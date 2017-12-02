package PostConnect;

use strict;
use warnings;
use JSON;
use CGI;
use DBI;
use Data::Dumper;
use Encode;
use utf8;

use lib '/home/hugo/wanda/perl';

use Connect;
use Entities::Events;
use Entities::Members;

sub postDbQuery {
  my ($dbh, $type, $id, $page) = @_;
  my $data = $page->param( 'POSTDATA' );
  my $dataHash = from_json($data);
  my ($restData, %fieldHash, $tableName);
  if ($id eq 'new' && $type =~ /members|events/) {
    $tableName = $type;
    my $entity;
    $entity = $type eq 'members'
      ? Entities::Members->new()
      : Entities::Events->new();
    %fieldHash = $entity->fieldHash();
    
    my @fieldNameArray = sort(keys (%fieldHash));
    my @bindValues;
    map {
      my $ret = $fieldHash{$_}->{'returnValue'}->($dataHash->{$_});
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

    $dataHash->{'success'} = $success;

    $restData = $page->header(
      -content_type => 'application/json;charset=UTF-8',
      -access_control_allow_origin => '*',
      -status => '200 OK'
    ) . to_json($dataHash);
  } else {
    $restData = Connect::errorResponse($page);
  }
  return $restData;
}

1;