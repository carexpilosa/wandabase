#!/usr/bin/perl 

use strict;
use warnings;

use CGI;
use DB_File;
use Data::Dumper;
use JSON;

my $page  = new CGI;
my $rest_data; # = $page->header('application/json;charset=UTF-8');

# ------ Initialisierung des Datenzugriffs über DB_File ------
my $file = "./books.data";
my %data;
my $db = tie %data, "DB_File", $file or die "err open $file: $!\n";

# ------ Prüfen ob über den definierten Pfad auf den REST Service zugegriffen wurde ------
my $path_info = $ENV{ 'PATH_INFO' };

#$rest_data = $page->header('text/html');
$rest_data .= "$path_info<br />\n";


$path_info =~ /^\/(.+)?\/(.*)$/;
my $type = $1;
my $id = $2;

if( not $type eq 'bookdb' ){
  exit;
}

# ------ Zugriffsmethode ermitteln
my $request_method = $ENV{ 'REQUEST_METHOD' };
$rest_data .= "REQUEST_METHOD => $request_method\n";

if( $request_method eq 'GET' ) {
  $rest_data .= "GET";
  if( not exists $data{ $id } ){
    $rest_data = $page->header('text/html', '404 Not found') . $rest_data;
  } else {
    my %book = ( id => $id );
    ( $book{ title }, $book{ author } ) = split /;/, $data{ $id };
    $rest_data .= to_json( \%book );
    $rest_data =  $page->header('text/html') . "OK\n" . $rest_data;
  }
} elsif ( $request_method eq 'POST' ) { # ----- Daten schreiben
    my $book = from_json( $page->param( 'POSTDATA' ) );

    # Daten in den DB_File Hash schreiben
    $data{ $book->{id} } = "$book->{title};$book->{author}";
    $rest_data =  $page->header('text/html') . "OK\n" . $rest_data;
} else {
  $rest_data = $page->header('text/html', '404 Not found') . $rest_data;
}

print $rest_data; # http Response ausgeben
