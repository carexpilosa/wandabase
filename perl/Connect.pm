package Connect;

use strict;
use JSON;
use Data::Dumper;

sub errorResponse {
  my ($page, $comment) = @_;
  my $restData;
  my %result = (
    'error' => '404 Not Found'
  );
  $result{comment} = $comment if $comment;
  Data::Dumper::Dumper \%result;
  $restData = to_json(\%result);
  $restData = $page->header(
    -content_type => 'application/json;charset=UTF-8',
    -status => '404 Not Found',
    -access_control_allow_origin => '*') . $restData;
  return $restData;
}

1;
