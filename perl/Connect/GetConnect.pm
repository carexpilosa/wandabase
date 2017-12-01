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
  my $rest_data;
  my $statement = <<EOT;
      SELECT id, username, password, gender, date_of_membership, is_admin, motto
        FROM members;
EOT
  my %result;
  if ($type eq 'members' && $id eq 'all') {  
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
        }
    }
    $rest_data = to_json(\%result);
    $rest_data = $page->header(
      -content_type => 'application/json;charset=UTF-8',
      -access_control_allow_origin => '*',
      -status => '200 OK') . $rest_data;
  } elsif ($type eq 'member' && $id) { #member called with username
    $rest_data = Connect::errorResponse($page,
      "/member/<username> => to bo implemented");
  } else {
    $rest_data = Connect::errorResponse($page);
  }
  return $rest_data;  
}

1;