package Entities::Members;

use strict;
use warnings;

use base qw(Entities);
use POSIX qw(strftime);
use CGI;
use JSON;
use Encode;

use DBConnect::Connect;

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
    },
    'token' => {
      'returnValue' => sub { shift },
      'getdata' => 1,
      'getorder' => 800
    },
    'token_created' => {
      'returnValue' => sub { shift },
      'getdata' => 1,
      'getorder' => 900,
      'postorder' => 900,
      'postdata' => 1
    },
  };
}

sub getMemberByToken {
  my ($token) = @_;

  my $dbh = DBConnect::Connect::dbhandler();
  
  my $sortedFieldNamesForGet = Entities::Members->sortedFieldNamesForGet();
  my $colnames = join (', ', @{$sortedFieldNamesForGet});
  my $statement = "SELECT $colnames FROM members WHERE token=?";

  my $dbRes = DBConnect::DBWorker::doGet($dbh, $statement, [$token]);

  my %result = map { $_->{'id'} => $_ } @{$dbRes};

  return \%result;
}

sub getMemberByIdAsHash {
  
}

sub getAllMembersAsHash {
  my $dbh = DBConnect::Connect::dbhandler();

  my $sortedFieldNamesForGet = Entities::Members->sortedFieldNamesForGet();
  my $colnames = join (', ', @{$sortedFieldNamesForGet});
  my $statement = "SELECT $colnames FROM members";

  my $dbRes = DBConnect::DBWorker::doGet($dbh, $statement, []);

  my %result = map { $_->{'id'} => $_ } @{$dbRes};

  return \%result;
}

sub logout {
  my $token = shift;
  my $dbh = DBConnect::Connect::dbhandler();
  my $statement = <<EOT;
      UPDATE `members`
        SET token=NULL, token_created=NULL
          WHERE token=?
EOT

  my $dbRes = DBConnect::DBWorker::doPost($dbh, $statement, []);

  my $page = CGI->new();
  my $restData = $page->header(
    -content_type => 'application/json;charset=UTF-8',
    -access_control_allow_origin => '*',
    -status => '200 OK'
  ) . encode_utf8(to_json({'Token' => 'leddig'}));
}


1;