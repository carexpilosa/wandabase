#!/usr/bin/perl 

use strict;
use warnings;

use CGI;
use DB_File;
use Data::Dumper;
use JSON;

my $page  = new CGI;

#print "Content-type: text/html \n\n";

my $rest_data; # = $page->header('application/json;charset=UTF-8');
#print $page->header('application/json');
# ------ Initialisierung des Datenzugriffs �ber DB_File ------
#my $file = "./books.data";
#my %data;
#my $db = tie %data, "DB_File", $file or die "err open $file: $!\n";

# ------ Pr�fen ob �ber den definierten Pfad auf den REST Service zugegriffen wurde ------
my $path_info = $ENV{ 'PATH_INFO' };

#$rest_data = $page->header('text/html');
#$rest_data .= "$path_info<br />\n";


$path_info =~ /^\/(.+)?\/(.*)$/;
my $type = $1;
my $id = $2;

#if( not $type eq 'bookdb' ){
#  exit;
#}

# ------ Zugriffsmethode ermitteln
my $request_method = $ENV{ 'REQUEST_METHOD' };
$rest_data .= "REQUEST_METHOD => $request_method\n";

if( $request_method eq 'GET' ) {
  $rest_data .= "GET";


  $rest_data = to_json({
    'ein' => 'test',
    'als' => 'hash',
    'meth' => 'GET'
  });
  $rest_data = $page->header(
    -content_type => 'application/json;charset=UTF-8',
    -access_control_allow_origin => '*') . $rest_data;
  #$rest_data = $page->header('application/json;charset=UTF-8') . "OK\n" . $rest_data;


  #if( not exists $data{ $id } ){
  #  $rest_data = $page->header('text/html', '404 Not found') . $rest_data;
  #} else {
  #  my %book = ( id => $id );
  #  ( $book{ title }, $book{ author } ) = split /;/, $data{ $id };
  #  $rest_data .= to_json( \%book );
  #  $rest_data =  $page->header('text/html') . "OK\n" . $rest_data;
  #}
} elsif ( $request_method eq 'POST' ) { # ----- Daten schreiben
    $rest_data = to_json({
      'ein' => 'testPOST',
      'als' => 'hashPOST',
      'meth' => 'POST',
      'postdata' => $page->param( 'POSTDATA' )
    });
    $rest_data = $page->header(
      -content_type => 'application/json;charset=UTF-8',
      -access_control_allow_origin => '*') . $rest_data;
    
    #$rest_data .= $page->param( 'POSTDATA' );
    #my $data = from_json( $page->param( 'POSTDATA' ) );
    #$rest_data .= Data::Dumper::Dumper $data;
#
#
    #my @bindValues;
    #map {
    #  #$rest_data .= $data->{$_} . "<br />\n";
    #  $rest_data .= "KEY => $_<br/>\n";
    #  my $ret;
    #  if ($_ eq 'is_admin') {
    #    $ret = $data->{$_} && $data->{$_} eq 'on' ? 1 : 0;
    #  } elsif($_ eq 'motto') {
    #    $ret = $data->{$_} || '';
    #  } elsif($_ eq 'date_of_membership') {
    #    $ret = strftime('%Y-%m-%d', localtime);
    #  } else {
    #    $ret = $data->{$_};
    #  }
    #  push @bindValues, $ret;
    #} keys %$data;
    #$rest_data .= Data::Dumper::Dumper \@bindValues;
    # Daten in den DB_File Hash schreiben
    #$data{ $book->{id} } = "$book->{title};$book->{author}";
    #$rest_data = $page->header('text/html') . "OK\n" . $rest_data;
} else {
  $rest_data = $page->header('text/html', '404 Not found') . $rest_data;
}
#$rest_data = $page->header('text/html') . "OK\n";
print $rest_data; # http Response ausgeben
