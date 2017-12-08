package GetConnect;

use strict;
use JSON;
use CGI;
use DBI;
use Data::Dumper;
use POSIX qw(strftime);
use Encode;
use Connect;

sub getDbQuery {
  my ($dbh, $type, $id, $page) = @_;
  my ($restData, $statement);
  my %result;

  if ($type =~ /^(members|events)$/) {
    my $entity = $type eq 'members'
        ? Entities::Members->new()
        : Entities::Events->new();
    my $sortedFieldNamesForGet = $entity->sortedFieldNamesForGet();
    my $colnames = join (', ', @{$sortedFieldNamesForGet});
    if ($id == 'all') {
      $statement = "SELECT $colnames FROM $type";
    } elsif ($id =~ /^\d+$/) { #single entity called with id
      $statement = "SELECT $colnames FROM $type WHERE id=$id";
    } else {
      $restData = Connect::errorResponse($page);
    }
    
    my $query = $dbh->prepare($statement);
    $query->execute() or die $query->err_str;

    while (my $res = $query->fetchrow_hashref()) {
      $result{$res->{'id'}} = $res;
    }
    $result{'gottoken'} = $ENV{'HTTP_TOKEN'} || 'nueschte';
      #if $ENV{'HTTP_TOKEN'};
    $restData = Encode::encode_utf8(to_json(\%result));
    $restData = $page->header(
      -content_type => 'application/json;charset=UTF-8',
      -access_control_allow_origin => '*',
      -access_control_allow_headers => 'Origin, X-Requested-With, Content-Type, Accept, Authorization',
      -status => '200 OK') . $restData;
    warn Dumper $restData;
  } else {
    $restData = Connect::errorResponse($page);
  }
  return $restData;  
}

1;