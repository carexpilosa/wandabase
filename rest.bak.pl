#!/usr/bin/perl 

use strict;
use warnings;

use CGI;
use DB_File;
use JSON;

my $page  = new CGI;
my $rest_data = $page->header('application/json');

# ------ Initialisierung des Datenzugriffs über DB_File ------
my $file = "./books.data";
my %data;
my $db = tie %data, "DB_File", $file or die "err open $file: $!\n";

# ------ Prüfen ob über den definierten Pfad auf den REST Service zugegriffen wurde ------
my $path_info = $ENV{ 'PATH_INFO' };
warn "====> $path_info";
$path_info =~ /^\/(.+)?\/(.*)$/;
my $type = $1;
my $id = $2;
if( not $type eq 'bookdb' ){
  exit;
}

# ------ Zugriffsmethode ermitteln
my $request_method = $ENV{ 'REQUEST_METHOD' };

if( $request_method eq 'GET' ){ # ------ Daten holen

  # ??? keine Daten zur ID in DB_File gefunden ???
  # ja: der Restservice liefer den Fehler 404
  if( not exists $data{ $id } ){
      $rest_data =  $page->header('text/html', '404 Not found');
  }
  # nein: Daten sind da und werden aus DB_File geholt
  else{
    my %book = ( id => $id );

    # Daten sind in DB_File im Semikolon separierten Format gespeicht 
    # und werden hier in einen Hash umgewandelt
    ( $book{ title }, $book{ author } ) = split /;/, $data{ $id };
    $rest_data .= to_json( \%book );
  }

}
elsif ( $request_method eq 'POST' ) { # ----- Daten schreiben

    # Json Daten aus dem POST Request holen und auf einen Hash abbilden
    my $book = from_json( $page->param( 'POSTDATA' ) );

    # Daten in den DB_File Hash schreiben
    $data{ $book->{id} } = "$book->{title};$book->{author}";
    $rest_data =  $page->header('text/html') . "OK\n";
}

print $rest_data; # http Response ausgeben
