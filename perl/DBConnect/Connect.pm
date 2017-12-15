package DBConnect::Connect;

use strict;
use warnings;

use JSON;
use Data::Dumper;

sub errorResponse {
  my ($page, $comment) = @_;
  my $restData;
  my %result = (
    'error' => '404 Not Found',
    ($comment ?
     ('comment' => $comment) : ()
    )
  );
  Data::Dumper::Dumper \%result;
  $restData = to_json(\%result);
  $restData = $page->header(
    -content_type => 'application/json;charset=UTF-8',
    -status => '404 Not Found',
    -access_control_allow_origin => '*') . $restData;
  return $restData;
}

sub dbhandler {
  my $dsn = "DBI:mysql:database=wanderbase;host=localhost";
  my $dbh = DBI->connect($dsn, 'markus', 'markus', {'mysql_enable_utf8' => 1});
}
1;
