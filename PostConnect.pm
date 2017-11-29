package PostConnect;

use JSON;
use CGI;
use DBI;

sub helloPost {
  my ($id, $type) = @_;
  my $page  = new CGI;
  if ($type eq 'members' && $id eq 'all') {
    my $dsn = "DBI:mysql:database=wanderbase;host=localhost";
    my $dbh = DBI->connect($dsn, 'markus', 'markus');
    my $statement = <<EOT;
      SELECT id, username, password, gender, date_of_membership, is_admin, motto
        FROM members;
EOT
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