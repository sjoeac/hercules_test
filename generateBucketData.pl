#!/usr/bin/perl

use strict;
use LWP::Simple;
use JSON;
use Data::Dumper;
use Sys::Hostname;

my $tagno = $ARGV[0] or die "Please add <tagno> as argument\n";
my $path = $ENV{WORKSPACE} || "/tmp";
my $bucket1File = "$path/bucket1-" . $tagno .".json";
my $bucket2File = "$path/bucket2-" . $tagno .".json";

if ((-e $bucket1File ) && ( -e $bucket1File)) {
    print "Bucket Files already exists\n";
    print "Bucket1: $bucket1File...\n";
    print "Bucket2: $bucket2File...\n";
    exit 0;
}

my $url = 'http://10.1.25.16:8500/v1/catalog/services';
my $response = (get $url);
die "Error connecting to $url" unless defined $response;
$response = decode_json ($response);
my $bucket1;
my $bucket2;
foreach my $service (keys %{$response}) {
next unless $service !~ /haproxy/;
    my $url = ' http://10.1.25.16:8500/v1/health/service/' . $service;
    my $response = (get $url);
    die "Error connecting to $url" unless defined $response;
    $response = decode_json ($response);

    foreach my $key (@{$response}) {
        if (!defined $bucket1->{$service}) {
        push @{$bucket1->{$service}}, $key->{'Node'}->{"Node"} if (!defined $bucket1->{$service});
        next;
        }
        push @{$bucket2->{$service}}, $key->{'Node'}->{"Node"}
    }
}

if ((defined $bucket1) && (defined $bucket2) ) {
    open my $fh, ">", $bucket1File;
    print $fh encode_json($bucket1);
    close $fh;

    open my $fh, ">", $bucket2File;
    print $fh encode_json($bucket2);
    close $fh;
    print "Bucket Files have been generated\n";
    print "Bucket1: $bucket1File...\n";
    print "Bucket2: $bucket2File...\n";
    exit 0;
}
else {
    print "ERROR: Bucket File not generated\n";
    exit 1;
}
