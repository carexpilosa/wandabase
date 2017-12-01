package PostConnect;

use strict;
use warnings;
use JSON;
use CGI;
use DBI;
use Data::Dumper;
use Encode;

use lib '/home/hugo/wanda/perl';

use Connect;
use Entities::Events;
use Entities::Members;

sub postDbQuery {
  my ($dbh, $type, $id, $page) = @_;
  my $data = $page->param( 'POSTDATA' );
  $data = from_json($data);
  my ($rest_data, %fieldArray, $tableName);
  if ($id eq 'new' && $type =~ /members|events/) {
    $tableName = $type;
    my $entity;
    $entity = $type eq 'members'
      ? Entities::Members->new()
      : Entities::Events->new();
    %fieldArray = $entity->fieldArray();
    
    my @fieldNameArray = sort(keys (%fieldArray));
    my @bindValues;
    map {
      my $ret = $fieldArray{$_}->{'returnValue'}->($data->{$_});
      push @bindValues, $ret;
    } @fieldNameArray;
    
    my $colnames = join ', ', @fieldNameArray;
    my $placeholder = join(', ', map { '?' } @fieldNameArray);
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

1;