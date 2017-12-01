#!/usr/bin/perl -w

use strict;

use CGI;
use DBI;
use DBD::mysql;
use Data::Dumper;
use POSIX qw(strftime);

print "Content-Type: text/html\n\n";

my $cgi = CGI->new();

#print $cgi->header('text/html');

# Find all the files available
#my @items;
#for my $filename (glob get_local_path('*')) {
#    my ($id) = $filename =~ m{([\d-]+)\.yaml$};
#    next unless defined $id;
#
#    push @items, $q->li(
#        $q->a({ href => absolute_url('/=/model/book/id/'.$id) }, $id),
#    );
#}
#
## List the items
#print $q->ul( @items );