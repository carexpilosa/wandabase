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
use Entities::Comments;
use Session::Token;

sub postDbQuery {
  my ($dbh, $type, $id, $page) = @_;
  my $data = $page->param( 'POSTDATA' );
  #warn $data;
  $data = decode_utf8($data);
 
  my $dataHash = from_json($data);
  warn Dumper $dataHash;
  #warn 'user => '.$dataHash->{'username'}. ' <=> '. $dataHash->{'password'};
  my ($restData, $fieldHash, $tableName);
  if ($type eq 'auth' && ! $id) {
    my $generator = Session::Token->new;
    my ($username, $password)
      = ($dataHash->{'username'}, $dataHash->{'password'});

    my $statement = <<EOT;
      SELECT username, password FROM members
        WHERE username=? AND password=?
EOT

    my $query = $dbh->prepare($statement);
    $query->execute($username, $password) or die $query->err_str;

    my $res = $query->fetchrow_hashref();
    my $token;
    if ($res->{'username'} eq $username
        && $res->{'password'} eq $password
      ) {
      $token = $generator->get;
    }

    $statement
      = <<EOT;
      UPDATE `members`
        SET token=?, token_created=CURRENT_TIMESTAMP
          WHERE username=? AND password=?
EOT
    $query = $dbh->prepare($statement);
    $query->execute($token, $username, $password);

    $restData = $page->header(
      -content_type => 'application/json;charset=UTF-8',
      -access_control_allow_origin => '*',
      -status => '200 OK'
    ) . encode_utf8(to_json({'Token' => $token}));
  } elsif ($id eq 'new' && $type =~ /members|events|comments/) {
    $tableName = $type;

    my $entity;
    if ($type eq 'members') {
      $entity = Entities::Members->new();
    } elsif ($type eq 'events') {
      $entity = Entities::Events->new();
    } elsif ($type eq 'comments') {
      $entity = Entities::Comments->new();
    }

    $fieldHash = $entity->fieldHash();


    my @fieldNameArray = sort(keys (%{$fieldHash}));
    #warn Dumper \@fieldNameArray;
    my @bindValues;
    map {
      my $ret = $fieldHash->{$_}->{'returnValue'}->($dataHash->{$_});
      push @bindValues, $ret;
    } @fieldNameArray;
    #warn Dumper \@bindValues;
    
    my $colnames = join ', ', @fieldNameArray;
    my $placeholder = join(', ', map { '?' } @fieldNameArray);
    my $statement = <<EOT;
      INSERT INTO $tableName (
        $colnames
      ) VALUES($placeholder)
EOT
    warn $statement;
    my $sth = $dbh->prepare($statement);
    my $success = $sth->execute(@bindValues);

    $dataHash->{'success'} = $success;
    $restData = $page->header(
      -content_type => 'application/json;charset=UTF-8',
      -access_control_allow_origin => '*',
      -status => '200 OK'
    ) . encode_utf8(to_json($dataHash));
  } else {
    $restData = Connect::errorResponse($page);
  }
  return $restData;
}

1;