package PostConnect;

use strict;
use JSON;
use CGI;
use DBI;
use Data::Dumper;
use Encode;
use POSIX qw(strftime);

use Connect;

sub postDbQuery {
  my ($dbh, $type, $id, $page) = @_;
  my $data = $page->param( 'POSTDATA' );
  $data = from_json($data);
  my ($rest_data, %fieldArray, $tableName);
  if ($id eq 'new') {
    $tableName = $type;
    %fieldArray = _getFieldArray($tableName);
    
    my @fieldNameArray = sort(keys (%fieldArray));
    my @bindValues;
    map {
      my $ret = $fieldArray{$_}->{'returnValue'}->($data->{$_});
      push @bindValues, $ret;
    } @fieldNameArray;

    my $colnames = join ',', @fieldNameArray;
    my $placeholder = join(',', map { '?' } @fieldNameArray);

    my $statement = <<EOT;
      INSERT INTO $tableName (
        $colnames
      ) VALUES($placeholder)
EOT
    my $sth = $dbh->prepare($statement);
    my $success = $sth->execute(@bindValues);

    $data->{'success'} = $success;

    $rest_data = $page->header(
      -content_type => 'application/json;charset=UTF-8',
      -access_control_allow_origin => '*',
      -status => '200 OK'
    ) . to_json($data);
  } else {
    $rest_data = Connect::errorResponse($page);
  }
  return $rest_data;
}

sub _getFieldArray {
  my $tableName = shift;
  if ($tableName eq 'members') {
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
  } elsif ($tableName eq 'events') {
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
}

1;