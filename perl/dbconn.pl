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

my $path_info = $ENV{ 'PATH_INFO' };
my ($type, $id);
if ($path_info =~ /^\/(.+)?\/(.*)$/) {
  $type = $1;
  $id = $2;
} elsif ($path_info =~ /^\/([^\/]+)$/) {
  $type = $1;
}
my $request_method = $ENV{ 'REQUEST_METHOD' };
warn $ENV{HTTP_REFERER};

my $dsn = "DBI:mysql:database=wanderbase;host=localhost";
my $dbh = DBI->connect($dsn, 'markus', 'markus', {'mysql_enable_utf8' => 1});
my $restData;

warn "=========== $type => $id ; $request_method";
 
if( $request_method eq 'GET' ) {
  $restData = GetConnect::getDbQuery($dbh, $type, $id, $page);
} elsif ( $request_method eq 'POST') {
  $restData = PostConnect::postDbQuery($dbh, $type, $id, $page);
} elsif ( $request_method eq 'OPTIONS') {
  warn "===============";
  $restData = $page->header(
    -content_type => 'application/json;charset=UTF-8',
    -access_control_allow_origin => '*',
    -access_control_allow_methods => 'GET,HEAD,OPTIONS,POST,PUT',
    -access_control_allow_headers => 'Origin, X-Requested-With, Content-Type, Accept, Authorization',
    -status => '200 OK'
  );
} else {
  $restData = to_json({'error' => "Wrong request method $request_method"});
  $restData = $page->header('text/html', '404 Not found') . $restData;
}
print $restData; # http Response ausgeben
