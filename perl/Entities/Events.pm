package Entities::Events;

use strict;
use base qw(Entities);
use POSIX qw(strftime);

my @ISA = qw(Entities);

sub fieldHash {
  return {
    'id' => {
      'returnValue' => sub { shift }, 
      'postdata' => 0,
      'getdata' => 1,
      'getorder' => 100
    },
    'title' => {
      'returnValue' => sub { shift },
      'postdata' => 1,
      'getdata' => 1,
      'getorder' => 200,
      'postorder' => 200
    },
    'description' => {
      'returnValue' => sub { shift },
      'postdata' => 1,
      'getdata' => 1,
      'getorder' => 300,
      'postorder' => 300
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
      'getorder' => 400,
      'postorder' => 400
    },
    'starttime' => {
      'returnValue' => sub { shift },
      'postdata' => 1,
      'getdata' => 1,
      'getorder' => 500,
      'postorder' => 500
    },
    'startlocation' => {
      'returnValue' => sub { shift },
      'postdata' => 1,
      'getdata' => 1,
      'getorder' => 600,
      'postorder' => 600
    }
  };
}

1;