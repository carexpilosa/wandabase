package PostConnect;

use strict;
use JSON;
use CGI;
use DBI;
use Data::Dumper;
use Encode;
use POSIX qw(strftime);

use Connect;

sub postDbQuery {
  my ($dbh, $type, $id, $page) = @_;
  my $data = $page->param( 'POSTDATA' );
  $data = from_json($data);
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

    my $statement = <<'EOT';
      INSERT INTO members (
        username, password, gender, date_of_membership, is_admin, motto
      ) VALUES(?, ?, ?, ?, ?, ?)
EOT
    my $sth = $dbh->prepare($statement);
    my $success = $sth->execute(@bindValues);

    $data->{'success'} = $success;

    $rest_data = $page->header(
      -content_type => 'application/json;charset=UTF-8',
      -access_control_allow_origin => '*',
      -status => '200 OK'
    ) . to_json($data);
  } elsif ($type eq 'events' && $id eq 'new') {
    $rest_data = Connect::errorResponse($page, "/events/new => to bo implemented");
    my @bindValues = (
      $data->{'headline'},
      $data->{'description'},
      strftime('%Y-%m-%d %H:%M:%S', localtime),
      $data->{'starttime'},
      $data->{'startlocation'},
    );

    my $statement = <<'EOT';
      INSERT INTO events (
        headline,
        description,
        created,
        starttime,
        startlocation
      ) VALUES (?, ?, ?, ?, ?)
EOT
    my $sth = $dbh->prepare($statement);
    my $success = $sth->execute(@bindValues);
    
    $rest_data = $page->header(
      -content_type => 'application/json;charset=UTF-8',
      -access_control_allow_origin => '*',
      -status => '200 OK'
    ) . to_json($data);
  } else {
    $rest_data = Connect::errorResponse($page);
  }
  return $rest_data;
}

1;