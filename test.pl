#!/usr/bin/perl -w

use strict;

use CGI;
use DBI;
use DBD::mysql;
use Data::Dumper;

print "Content-Type: text/html\n\n";

my $cgi = CGI->new();
my @val = $cgi->param();

my $dsn = "DBI:mysql:database=wanderbase;host=localhost";
my $dbh = DBI->connect($dsn, 'root', 'zM0dem');
my $statement = 'INSERT INTO members (id, username, password, gender, date_of_membership, is_admin)'
  . ' VALUES(?, ?, ?, ?, ?, ?)';
my $sth = $dbh->prepare($statement);
my @paramKeys = qw (id username password gender date_of_membership is_admin);
my @bindValues = map {
  $cgi->param($_) || '0';
} @paramKeys;
print join(',', @bindValues);
$sth->execute(@bindValues);
