#!/usr/bin/perl -w

use strict;

use CGI;
use DBI;
use DBD::mysql;
use Data::Dumper;

print "Content-Type: text/html\n\n";

my $cgi = CGI->new();
my @val = $cgi->param();
map {
  print $_ . " => " . $cgi->param($_) . "<br />\n";
} @val;

my $dsn = "DBI:mysql:database=wanderbase;host=localhost";
my $dbh = DBI->connect($dsn, 'root', 'zM0dem');

#my $sth = $dbh->prepare('SELECT * FROM members')
#  or die "prepare statement failed: $dbh->errstr()";
#INSERT INTO members (id, username, password, gender, date_of_membership, is_admin)
#  VALUES(?, ?, ?, ?, ?, ?);
#id, username, password, gender, date_of_membership, is_admin
#$sth->execute();

#while (my $ref = $sth->fetchrow_arrayref()) {
#  map { print $_ . "<br />\n"} @{$ref};
#}
