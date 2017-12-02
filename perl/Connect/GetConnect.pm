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
    $statement = <<'EOT';
      SELECT id, username, password, gender, date_of_membership, is_admin, motto
        FROM members;
EOT
    my $query = $dbh->prepare($statement);
    $query->execute() or die $query->err_str;
    
    while (my ($id, $username, $password, $gender, $date_of_membership, $is_admin, $motto) =
      $query->fetchrow_array()) {
        $result{$id} = {
          id => $id,
          username => $username,
          password => $password,
          gender => $gender, 
          date_of_membership => $date_of_membership, 
          is_admin => $is_admin, 
          motto => $motto
        };
    }
    $restData = to_json(\%result);
    $restData = $page->header(
      -content_type => 'application/json;charset=UTF-8',
      -access_control_allow_origin => '*',
      -status => '200 OK') . $restData;
  } elsif ($type eq 'member' && $id) { #member called with username
    $restData = Connect::errorResponse($page,
      "/member/<username> => to bo implemented");
  } elsif ($type eq 'events' && $id eq 'all') {
    $statement = <<'EOT';
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
  } else {
    $restData = Connect::errorResponse($page);
  }
  return $restData;  
}

1;