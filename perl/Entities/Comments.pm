package Entities::Comments;

use strict;
use warnings;

use POSIX qw(strftime);
use DBConnect::Connect;
use Data::Dumper;

use base qw(Entities);

my @ISA = qw(Entities);

sub fieldHash {
  return {
    'id' => {
      'returnValue' => sub { shift }, 
      'postdata' => 0,
      'getdata' => 1,
      'getorder' => 100
    },
    'content' => {
      'returnValue' => sub { shift },
      'postdata' => 1,
      'getdata' => 1,
      'getorder' => 200,
      'postorder' => 200
    },
    'created' => {
      'returnValue' => sub {
        my $value = shift;
        if ($value) {
          return $value;
        } else {
          return strftime('%Y-%m-%d %H:%M:%S', localtime);
        }
      },
      'postdata' => 1,
      'getdata' => 1,
      'getorder' => 300,
      'postorder' => 300
    },
    'member_id' => {
      'returnValue' => sub { shift },
      'postdata' => 1,
      'getdata' => 1,
      'getorder' => 400,
      'postorder' => 400
    },
    'event_id' => {
      'returnValue' => sub { shift },
      'postdata' => 1,
      'getdata' => 1,
      'getorder' => 500,
      'postorder' => 500
    },
  };
}

sub getCommentById {}
sub getAnswers {}
sub getPredecessor {}

sub addComment {
  my ($self, $dbh, $page, $dataHash) = @_;
  my ( $content, $eventID, $token )
    = ( $dataHash->{'content'}, $dataHash->{'event_id'}, $ENV{HTTP_TOKEN});
  my $res = {};
  my $mem = $self->getMemberForValidToken($token);

  if ($mem->{'id'}) {
    my $statement = <<EOT;
      INSERT into comments (content, created, member_id, event_id)
        VALUES (?, ?, ?, ?)
EOT
    my $fieldHash = fieldHash();
    my @bindValues = (
      $content,
      $fieldHash->{'created'}->{'returnValue'}(),
      $mem->{'id'},
      $eventID
    );
    $res = DBConnect::DBWorker->do($dbh, $statement, \@bindValues);
  } else {
    $res = DBConnect::Connect::errorResponse($page,
      "addComment geht grad nicht...");
  }
  return $res;
}

sub getAllCommentsAsHash {
  my $dbh = DBConnect::Connect::dbhandler();

  my $sortedFieldNamesForGet = Entities::Comments->sortedFieldNamesForGet();
  my $colnames = join (', ', @{$sortedFieldNamesForGet});
  my $statement = "SELECT $colnames FROM comments";

  my $dbRes = DBConnect::DBWorker->doGet($dbh, $statement, []);

  my %result = map { $_->{'id'} => $_ } @{$dbRes};

  return \%result;
}

sub getCommentsOfMembersForEventIdAsHash {
  my ($pkg, $id) = @_;
  my $dbh = DBConnect::Connect::dbhandler();

  my $statement = <<EOT;
  SELECT comments.id, comments.content, members.username, comments.created
        FROM comments, members
          WHERE comments.event_id = ?
            AND comments.member_id = members.id
EOT
  my $dbRes = DBConnect::DBWorker->doGet($dbh, $statement, [$id]);
  my %result = map { $_->{'id'} => $_ } @{$dbRes};
  return \%result;
}

1;  