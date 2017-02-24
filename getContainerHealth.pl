#!/usr/bin/perl

use LWP::Simple;
use JSON;
use Data::Dumper;

my $service = $ARGV[0] or die "Please add service as argument\n";
my $url = ' http://10.1.25.16:8500/v1/health/service/' . $service;

my $response = (get $url);
die "Error connecting to $url" unless defined $response;
$response = decode_json ($response);

my $filter;
foreach my $key (@{$response}) {
    foreach my $key2 (@{$key->{"Checks"}}) {
       next if ( $key2->{'Status'} =~/passing/g);
       $filter->{$key2->{'CheckID'}}->{$key2->{'Node'}} = $key2->{'Status'} 	
    }
}

if (defined ($filter)) {
    print "Service " . $service . " : FAILURES " . Dumper ($filter) . "\n";
    exit 1;
} else
{
    print "Service " . $service . " : Cluster Healthy" . "\n";
    exit 0;
}
