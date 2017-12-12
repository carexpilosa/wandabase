package Entities::Comments;

use strict;
use base qw(Entities);
use POSIX qw(strftime);
use DBConnect::Connect;

my @ISA = qw(Exporter Entities);
my @EXPORT = qw(addComment);

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
  my ($self, $page, $comment) = @_;
  use Encode;
  $comment = encode_utf8($comment);
  return
    DBConnect::Connect::errorResponse($page,
      "addComment \"$comment\" geht grad nicht...");
}

1;