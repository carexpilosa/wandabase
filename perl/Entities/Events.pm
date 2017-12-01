package Entities::Events;

use strict;
use base qw(Entities);
use POSIX qw(strftime);

my @ISA = qw(Entities);

sub fieldArray {
  return (
    'headline' => {
      'returnValue' => sub {
        return shift;
      }
    },
    'description' => {
      'returnValue' => sub {
        return shift;
      }
    },
    'created' => {
      'returnValue' => sub {
        my $value = shift;
        if ($value) {
          return $value;
        } else {
          return strftime('%Y-%m-%d %H:%M:%S', localtime);
        }
      }
    },
    'starttime' => {
      'returnValue' => sub {
        return shift;
      }
    },
    'startlocation' => {
      'returnValue' => sub {
        return shift;
      }
    }
  );
}

1;