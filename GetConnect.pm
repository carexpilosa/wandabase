package PostConnect;

use strict;
use JSON;
use CGI;
use DBI;
use Data::Dumper;
use POSIX qw(strftime);

sub getDbQuery {
  my ($dbh, $type, $id, $page) = @_;
  my $data = from_json($page->param( 'POSTDATA' ));
  my $rest_data;
  my $statement = <<EOT;
      SELECT id, username, password, gender, date_of_membership, is_admin, motto
        FROM members;
EOT
  
  if ($type eq 'members' && $id eq 'all') {  
    my $query = $dbh->prepare($statement);
    $query->execute() or die $query->err_str;
    my %result;
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
  } else {
    $rest_data = to_json({
      'ein' => 'test',
      'als' => 'hash',
      'meth' => 'GET'
    });
  }
  
  $rest_data = $page->header(
    -content_type => 'application/json;charset=UTF-8',
    -access_control_allow_origin => '*') . $rest_data;
  return $rest_data;
}

1;