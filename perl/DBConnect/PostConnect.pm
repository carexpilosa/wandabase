package DBConnect::PostConnect;

use strict;
use warnings;

use JSON;
use CGI;
use DBI;
use Data::Dumper;
use Encode;
use utf8;

use lib '/home/hugo/wanda/perl';

use DBConnect::Connect;
use DBConnect::DBWorker;
use Entities::Events;
use Entities::Members;
use Entities::Comments;
use Session::Token;

sub postDbQuery {
  my ($dbh, $type, $id, $page) = @_;

  my $data = $page->param( 'POSTDATA' );
  $data = decode_utf8($data);
 
  my $dataHash = from_json($data);
  my ($restData, $fieldHash, $tableName);
  if ($type eq 'logout' && $dataHash->{'token'}) {
    Entities::Members->logout($dataHash->{'token'});
    return $page->header(
      -content_type => 'application/json;charset=UTF-8',
      -access_control_allow_origin => '*',
      -access_control_allow_methods => 'GET,HEAD,OPTIONS,POST,PUT',
      -access_control_allow_headers => 'Mode, Token, Origin, X-Requested-With, Content-Type, Accept',
      -status => '200 OK'
    ) . encode_utf8(to_json({'Token' => 'leddig'}));
  } elsif ($type eq 'auth' && ! $id) {
    my $generator = Session::Token->new;
    my ($username, $password)
      = ($dataHash->{'username'}, $dataHash->{'password'});

    my $statement = <<EOT;
      SELECT username, password FROM members
        WHERE username=? AND password=?
EOT
    my $res = DBConnect::DBWorker->doGet($dbh, $statement, [$username, $password]);
    my $token;
    if ($res->[0]->{'username'} eq $username
        && $res->[0]->{'password'} eq $password
      ) {
      $token = $generator->get;
    }
    $statement = <<EOT;
      UPDATE `members`
        SET token=?, token_created=CURRENT_TIMESTAMP
          WHERE username=? AND password=?
EOT
    $res = DBConnect::DBWorker->do($dbh, $statement,
      [ $token, $username, $password ]);

    $restData = $page->header(
      -content_type => 'application/json;charset=UTF-8',
      -access_control_allow_origin => '*',
      -status => '200 OK'
    ) . encode_utf8(to_json({'Token' => $token}));
  } elsif ($id && $id eq 'new' && $type =~ /members|events|comments/) {
    return DBConnect::Connect::errorResponse($page, 'Login nicht (mehr?) aktiv')
      unless Entities::tokenIsValid($ENV{'HTTP_TOKEN'});
    $tableName = $type;
    my $entity;
    if ($type eq 'comments') {
      $entity = Entities::Comments->new();
      my $res = $entity->addComment($dbh, $page, $dataHash, $ENV{HTTP_TOKEN});
      $dataHash->{'success'} = $res;
      return $page->header(
        -content_type => 'application/json;charset=UTF-8',
        -access_control_allow_origin => '*',
        -status => '200 OK'
      ) . encode_utf8(to_json($dataHash));
    } elsif ($type eq 'members') {
      $entity = Entities::Members->new();
    } elsif ($type eq 'events') {
      $entity = Entities::Events->new();
    }

    $fieldHash = $entity->fieldHash();

    my @fieldNameArray = sort(keys (%{$fieldHash}));
    my @bindValues;
    map {
      my $ret = $fieldHash->{$_}->{'returnValue'}->($dataHash->{$_});
      push @bindValues, $ret;
    } @fieldNameArray;
    
    my $colnames = join ', ', @fieldNameArray;
    my $placeholder = join(', ', map { '?' } @fieldNameArray);
    my $statement = <<EOT;
      INSERT INTO $tableName (
        $colnames
      ) VALUES($placeholder)
EOT
    my $res = DBConnect::DBWorker->do($dbh, $statement, \@bindValues);
    $dataHash->{'success'} = $res;
    $restData = $page->header(
      -content_type => 'application/json;charset=UTF-8',
      -access_control_allow_origin => '*',
      -status => '200 OK'
    ) . encode_utf8(to_json($dataHash));
  } else {
    $restData = DBConnect::Connect::errorResponse($page);
  }
  return $restData;
}

1;