#!/usr/bin/perl 

use strict;
use warnings;

use CGI;
use DBI;
use DB_File;
use Data::Dumper;
use POSIX qw(strftime);
use JSON;

use Connect::PostConnect;
use Connect::GetConnect;

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
$dbh->{'mysql_enable_utf8'} = 1;
my $rest_data;

if( $request_method eq 'GET' ) {
  $rest_data = GetConnect::getDbQuery($dbh, $type, $id, $page);
} elsif ( $request_method eq 'POST') {
  $rest_data = PostConnect::postDbQuery($dbh, $type, $id, $page);
} else {
  $rest_data = to_json({'error' => "Wrong request method $request_method"});
  $rest_data = $page->header('text/html', '404 Not found') . $rest_data;
}
print $rest_data; # http Response ausgeben
