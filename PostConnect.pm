package PostConnect;

use JSON;
use CGI;
use DBI;

sub postDbQuery {
  my ($dbh, $id, $type) = @_;
  warn "-----------------";
  my $page  = new CGI;
  my $data = from_json($page->param( 'POSTDATA' ));
  my $rest_data;
  if ($type eq 'members' && $id eq 'new') {
    $data->{'date_of_membership'} = strftime('%Y-%m-%d', localtime);
    my @bindValues;
    map {
      my $ret;
      if ($_ eq 'is_admin') {
        $ret = $data->{$_} && $data->{$_} eq 'on' ? 1 : 0;
      } elsif($_ eq 'motto') {
        $ret = $data->{$_} || '';
      } elsif($_ eq 'date_of_membership') {
        $ret = strftime('%Y-%m-%d', localtime);
      } else {
        $ret = $data->{$_};
      }
      push @bindValues, $ret;
    } ('username', 'password', 'gender', 'date_of_membership', 'is_admin', 'motto');


    my $statement = 'INSERT INTO members (
        username, password, gender, date_of_membership, is_admin, motto
      ) VALUES(?, ?, ?, ?, ?, ?)';
    warn "############# $statement";
    my $sth = $dbh->prepare($statement);
    my $success = $sth->execute(@bindValues);

    $data->{'success'} = $success;

    $rest_data = $page->header(
      -content_type => 'application/json;charset=UTF-8',
      -access_control_allow_origin => '*'
    ) . to_json($data);
  }
  return $rest_data;
}

1;