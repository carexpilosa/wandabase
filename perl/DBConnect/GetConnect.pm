package DBConnect::GetConnect;

use strict;
use warnings;

use JSON;
use CGI;
use DBI;
use Data::Dumper;
use POSIX qw(strftime);
use Encode;
use DBConnect::Connect;
use DBConnect::DBWorker;

sub getDbQuery {
  my ($dbh, $type, $id, $page) = @_;
  my ($restData, $statement);
  my $eventID = $page->param('event_id');
  my $result;
  warn "$type $id";
  if ($type =~ /^(members|events|comments)$/ && $id && $id eq 'all') {
    if ($type eq 'members') {
      $result = Entities::Members->getAllMembersAsHash();
    } elsif ($type eq 'events') {
      warn "AAAAAAAAAAAAa";
      $result = Entities::Events->getAllEventsAsHash();
    } elsif ($type eq 'comments') {
      $result = Entities::Comments->getAllCommentsAsHash();
    } else {
      die "wrong entity type $type";
    }
  } elsif ($type =~ /^(members|events|comments)$/ && $id && $id =~ /^\d+$/) {
    if ($type eq 'members') {
      $result = Entities::Members->getMemberByIdAsHash($id);
    } elsif ($type eq 'events') {
      $result = Entities::Events->getEventForId($id);
    } elsif ($type eq 'comments') {
      $result = Entities::Comments->getCommentForId();
    } else {
      die "wrong entity type $type";
    }
  } elsif ($type eq 'comments' && $eventID) {
    $result = Entities::Comments
      ->getCommentsOfMembersForEventIdAsHash($eventID);
  } else {
    return DBConnect::Connect::errorResponse($page);
  }
  return createRestDataFromResultHash($result, $page);
}

sub createRestDataFromResultHash {
  my ($result, $page) = @_;
  my $restData = Encode::encode_utf8(to_json($result));
  $restData = $page->header(
    -content_type => 'application/json;charset=UTF-8',
    -access_control_allow_origin => '*',
    -access_control_allow_methods => 'GET,HEAD,OPTIONS,POST,PUT',
    -access_control_allow_headers => 'Mode, Token, Origin, X-Requested-With, Content-Type, Accept',
    -content_type => 'application/json;charset=UTF-8',
    -status => '200 OK') . $restData;
  return $restData;
}

1;