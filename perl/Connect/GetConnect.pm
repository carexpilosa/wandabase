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
  if ($type eq 'members' && $id eq 'all') {
    my $entity = $type eq 'members'
      ? Entities::Members->new()
      : Entities::Events->new();
    my $sortedFieldNamesForGet = $entity->sortedFieldNamesForGet();
    my $colnames = join (', ', @{$sortedFieldNamesForGet});

    $statement = <<EOT;
      SELECT $colnames
        FROM $type;
EOT
    my $query = $dbh->prepare($statement);
    $query->execute() or die $query->err_str;
    
    while (my $res = $query->fetchrow_hashref()) {
      $result{$res->{'id'}} = $res;
    }
    $restData = to_json(\%result);
    warn $restData;
    $restData = $page->header(
      -content_type => 'application/json;charset=UTF-8',
      -access_control_allow_origin => '*',
      -status => '200 OK') . $restData;
  } elsif ($type eq 'members' && $id =~ /^\d+$/) { #member called with id
    $restData = Connect::errorResponse($page,
      "/members/<id> => to bo implemented");
  } elsif ($type eq 'events' && $id eq 'all') {
    $statement = <<EOT;
      SELECT id, title, description, created, starttime, startlocation
        FROM events;
EOT
    my $query = $dbh->prepare($statement);
    $query->execute() or die $query->err_str;
  
    while (my ($id, $title, $description, $created, $starttime, $startlocation)
      = $query->fetchrow_array()) {
          $result{$id} = {
            id => $id,
            title => $title,
            description => $description,
            created => $created,
            starttime => $starttime, 
            startlocation => $startlocation
          };
    }
    $restData = to_json(\%result);
    $restData = $page->header(
      -content_type => 'application/json;charset=UTF-8',
      -access_control_allow_origin => '*',
      -status => '200 OK') . $restData;
  } elsif ($type eq 'events' && $id =~ /^\d+$/) { #events called with id
    $statement = <<EOT;
      SELECT id, title, description, created, starttime, startlocation
        FROM events
          WHERE id=$id;
EOT
    my $query = $dbh->prepare($statement);
    $query->execute() or die $query->err_str;

    while (my ($id, $title, $description, $created, $starttime, $startlocation)
      = $query->fetchrow_array()) {
          $result{$id} = {
            id => $id,
            title => $title,
            description => $description,
            created => $created,
            starttime => $starttime, 
            startlocation => $startlocation
          };
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