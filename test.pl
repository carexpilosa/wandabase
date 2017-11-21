#!/usr/bin/perl -w

use strict;

use CGI;
use DBI;
use DBD::mysql;
use Data::Dumper;

print "Content-Type: text/html\n\n";

my $cgi = CGI->new();

my $dsn = "DBI:mysql:database=wanderbase;host=localhost";
my $dbh = DBI->connect($dsn, 'root', 'zM0dem');
my $statement = 'INSERT INTO members (
    username, password, gender, date_of_membership, is_admin, motto
  ) VALUES(?, ?, ?, ?, ?, ?)';
my $sth = $dbh->prepare($statement);
my @paramKeys = qw (username password gender date_of_membership is_admin motto);
my @bindValues = map {
  my $ret;
  if ($_ eq 'is_admin') {
    $ret = $cgi->param($_) eq 'on' ? 1 : 0
  } elsif($_ eq 'motto') {
    $ret = $cgi->param($_) || '';
  } else {
    $ret = $cgi->param($_);
  }
  $ret;
} @paramKeys;
print join("<br />\n", @bindValues);
$sth->execute(@bindValues);
