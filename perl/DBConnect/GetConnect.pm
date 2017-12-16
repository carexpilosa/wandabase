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
  if ($type =~ /^(members|events|comments)$/ && $id && $id eq 'all') {
    my $result;
    if ($type eq 'members') {
      $result = Entities::Members->getAllMembersAsHash();
    } elsif ($type eq 'events') {
      $result = Entities::Events->getAllEventsAsHash();
    } elsif ($type eq 'comments') {
      $result = Entities::Comments->getAllCommentsAsHash();
    } else {
      die "wrong entity type $type";
    }
    warn "xxx";
    warn Dumper $result;
  } elsif ($type =~ /^(members|events|comments)$/ && $id && $id =~ /^\d+$/) {
    if ($type eq 'members') {
      $result = Entities::Members->getMemberForId($id);
    } elsif ($type eq 'events') {
      $result = Entities::Events->getEventForId($id);
    } elsif ($type eq 'comments') {
      $result = Entities::Comments->getCommentForId();
    } else {
      die "wrong entity type $type";
    }
    warn Dumper $result;
  } elsif ($type eq 'comments' && $eventID) {
    $result = Entities::Comments
      ->getCommentsOfMembersForEventIdAsHash($eventID);
    warn "xxx";
    warn Dumper $result;
  #} elsif ($type =~ /^(members|events)$/) {
  #  my $entity = $type eq 'members'
  #      ? Entities::Members->new()
  #      : Entities::Events->new();
  #  my $sortedFieldNamesForGet = $entity->sortedFieldNamesForGet();
  #  my $colnames = join (', ', @{$sortedFieldNamesForGet});
  #  if ($id eq 'all') {
  #    $statement = "SELECT $colnames FROM $type";
  #  } elsif ($id =~ /^\d+$/) { #single entity called with id
  #    $statement = "SELECT $colnames FROM $type WHERE id=$id";
  #  } else {
  #    return DBConnect::Connect::errorResponse($page);
  #  }
  #  
  #  my $dbRes = DBConnect::DBWorker::doGet($dbh, $statement, []);
  #  my %result = map { $_->{'id'} => $_ } @{$dbRes};
  #} elsif ($type eq 'comments') {
  #  my $eventID = $page->param('event_id');
  #  my $statement = <<EOT;
  #    SELECT comments.id, comments.content, members.username, comments.created
  #      FROM comments, members
  #        WHERE comments.event_id = ?
  #          AND comments.member_id = members.id
#EOT
  #  my $dbRes = DBConnect::DBWorker::doGet($dbh, $statement, [$eventID]);
  #  my $result = [ map { $_->{'id'} => $_ } @{$dbRes} ];
  } else {
    warn "xxx";
    return DBConnect::Connect::errorResponse($page);
  }
  warn "xxx";
  warn Dumper $result;
  return createRestDataFromResultHash($result, $page);
}

sub createRestDataFromResultHash {
  my ($result, $page) = @_;
  warn "xxx";
  warn Dumper $result;
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