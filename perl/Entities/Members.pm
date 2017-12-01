package Entities::Members;

use  strict;
use base qw(Entities);
use POSIX qw(strftime);

my @ISA = ("Entities");

sub fieldArray {
  return (
    'username' => {
      'returnValue' => sub {
        return shift;
      }
    },
    'password' => {
      'returnValue' => sub {
        return shift;
      }
    },          
    'gender' => {
      'returnValue' => sub {
        return shift;
      }
    },
    'date_of_membership' => {
      'returnValue' => sub {
        my $value = shift;
        return $value ? $value : strftime('%Y-%m-%d %H:%M:%S', localtime);
      }
    },
    'is_admin' => {
      'returnValue' => sub {
        my $value = shift;
        return $value && $value eq 'on' ? 1 : 0;
      }
    },
    'motto' => {
      'returnValue' => sub {
        return shift;
      }
    }
  );
}

1;