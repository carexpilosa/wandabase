#!/usr/bin/perl

use strict;
use warnings;

use CGI;
use DBI;
use DB_File;
use Data::Dumper;
use POSIX qw(strftime);
use JSON;

use DBConnect::PostConnect;
use DBConnect::GetConnect;
use Entities;

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

my $dsn = "DBI:mysql:database=wanderbase;host=localhost";
my $dbh = DBI->connect($dsn, 'markus', 'markus', {'mysql_enable_utf8' => 1});
my $restData;

if( $request_method eq 'GET' ) {
  $restData = DBConnect::GetConnect::getDbQuery($dbh, $type, $id, $page);
} elsif ( $request_method eq 'POST') {
  $restData = DBConnect::PostConnect::postDbQuery($dbh, $type, $id, $page);
} elsif ( $request_method eq 'OPTIONS') {
  $restData = $page->header(
    -content_type => 'application/json;charset=UTF-8',
    -access_control_allow_origin => '*',
    -access_control_allow_methods => 'GET,HEAD,OPTIONS,POST,PUT',
    -access_control_allow_headers => 'Mode, Token, Origin, X-Requested-With, Content-Type, Accept',
    -status => '200 OK'
  );
} else {
  $restData = to_json({'error' => "Wrong request method $request_method"});
  $restData = $page->header('text/html', '404 Not found') . $restData;
}
print $restData; # http Response ausgeben

