#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use Encode;

`mkdir /tmp/vector`;
our $dlpath = "/tmp/vector/";
our $host = "http://www.vector.co.jp";
#my  $url = "/vpack/filearea/winnt/hardware/av";
while(<STDIN>){
  my $url;
  chomp;
  $url = $1 if(/https?:\/\/[^\/]+(\/.*)$/);
  $url = $_ unless(/https?:\/\/[^\/]+(\/.*)$/);
  sub dlpage{
    my $path = shift;
    my $name = shift;
    my $source = decode("sjis", `wget -O - '$host$path' 2>/dev/null`);
    if($source=~/<a\s+href="(http:\/\/ftp.vector.co.jp[^"]+)"/i){
      my $dlurl = $1;
      print "wget -P $dlpath '$dlurl'\n";
      `wget -P $dlpath '$dlurl'`;
    }
  }
  sub detailpage{
    my $path = shift;
    my $name = shift;
    $path =~ s/\/soft/\/soft\/dl/g;
    my $source=decode("sjis", `wget -O - '$host$path' 2>/dev/null`);
    if($source=~/<a\s+href="(\/download\/[^"]+)"/i){
      &dlpage($1, $name);
    }
  }

  my $source = decode("sjis", `wget -O - '$host$url' 2>/dev/null`);
  while($source =~ /<A\s+HREF="(\/soft[^"]+)"\s*>([^<]+)<\/A>/gi){
    &detailpage($1, $2);
  }
}
