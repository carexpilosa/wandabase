#!/usr/bin/perl 

use strict;
use warnings;

use CGI;
use DB_File;
use Data::Dumper;
use JSON;

my $page  = new CGI;

# ------ Prüfen ob über den definierten Pfad auf den REST Service zugegriffen wurde ------
my $path_info = $ENV{ 'PATH_INFO' };

#$rest_data = $page->header('text/html');
#$rest_data .= "$path_info<br />\n";


$path_info =~ /^\/(.+)?\/(.*)$/;
my $type = $1;
my $id = $2;

my $html_data = $page->header(
  -content_type => 'text/html;charset=UTF-8',
  -access_control_allow_origin => '*')
  . <<EOT;
  <!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>Document</title>
</head>
<body>
  $0/$type/$id
</body>
</html>

EOT

print $html_data;
