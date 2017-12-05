package GetConnect;

use strict;
use JSON;
use CGI;
use DBI;
use Data::Dumper;
use POSIX qw(strftime);
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

    $restData = to_json(\%result);
    $restData = $page->header(
      -content_type => 'application/json;charset=UTF-8',
      -access_control_allow_origin => '*',
      -status => '200 OK') . $restData;
  } else {
    $restData = Connect::errorResponse($page);
  }
  return $restData;  
}

1;