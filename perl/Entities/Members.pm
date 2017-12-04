package Entities::Members;

use  strict;
use base qw(Entities);
use POSIX qw(strftime);

my @ISA = ("Entities");

sub fieldHash {
  return {
    'id' => {
      'returnValue' => sub { shift },
      'postdata' => 0,
      'getdata' => 1,
      'getorder' => 100
    },
    'username' => {
      'returnValue' => sub { shift },
      'postdata' => 1,
      'getdata' => 1,
      'postorder' => 200,
      'getorder' => 200
    },
    'password' => {
      'returnValue' => sub { shift },
      'postdata' => 1,
      'getdata' => 1,
      'postorder' => 300,
      'getorder' => 300
    },          
    'gender' => {
      'returnValue' => sub { shift },
      'postdata' => 1,
      'getdata' => 1,
      'postorder' => 400,
      'getorder' => 400
    },
    'date_of_membership' => {
      'returnValue' => sub {
        my $value = shift;
        return $value ? $value : strftime('%Y-%m-%d %H:%M:%S', localtime);
      },
      'postdata' => 0,
      'getdata' => 1,
      'postorder' => 500,
      'getorder' => 500
    },
    'is_admin' => {
      'returnValue' => sub {
        my $value = shift;
        return $value && $value eq 'on' ? 1 : 0;
      },
      'postdata' => 1,
      'getdata' => 1,
      'postorder' => 600,
      'getorder' => 600
    },
    'motto' => {
      'returnValue' => sub { shift },
      'postdata' => 1,
      'getdata' => 1,
      'postorder' => 700,
      'getorder' => 700
    }
  };
}

1;