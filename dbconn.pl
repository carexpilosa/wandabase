#!/usr/bin/perl 

use strict;
use warnings;

use CGI;
use DBI;
use DB_File;
use Data::Dumper;
use POSIX qw(strftime);
use JSON;

use PostConnect;

my $page  = new CGI;

# ------ Prüfen ob über den definierten Pfad auf den REST Service zugegriffen wurde ------
my $path_info = $ENV{ 'PATH_INFO' };
my ($type, $id);
if ($path_info =~ /^\/(.+)?\/(.*)$/) {
  $type = $1;
  $id = $2;
}

my $request_method = $ENV{ 'REQUEST_METHOD' };

my $dsn = "DBI:mysql:database=wanderbase;host=localhost";
my $dbh = DBI->connect($dsn, 'markus', 'markus');
my $rest_data = '';

if( $request_method eq 'GET' ) {
  if ($type eq 'members' && $id eq 'all') {
    
    my $statement = <<EOT;
      SELECT id, username, password, gender, date_of_membership, is_admin, motto
        FROM members;
EOT
    my $query = $dbh->prepare($statement);
    $query->execute() or die $query->err_str;
    my %result;
    while (my ($id, $username, $password, $gender, $date_of_membership, $is_admin, $motto) =
      $query->fetchrow_array()) {
         $result{$id} = {
          id => $id,
          username => $username,
          password => $password,
          gender => $gender, 
          date_of_membership => $date_of_membership, 
          is_admin => $is_admin, 
          motto => $motto
        }
    }
    $rest_data = to_json(\%result);
  } else {
    $rest_data = to_json({
      'ein' => 'test',
      'als' => 'hash',
      'meth' => 'GET'
    });
  }
  
  $rest_data = $page->header(
    -content_type => 'application/json;charset=UTF-8',
    -access_control_allow_origin => '*') . $rest_data;
} elsif ( $request_method eq 'POST') {
    $rest_data = PostConnect::postDbQuery($dbh, $type, $id, $page);
    warn $rest_data;
} else {
  $rest_data = $page->header('text/html', '404 Not found') . $rest_data;
}
print $rest_data; # http Response ausgeben
