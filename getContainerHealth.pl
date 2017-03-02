#!/usr/bin/perl

use LWP::Simple;
use JSON;
use Data::Dumper;

my $service = lc $ARGV[0] or die "Please add service <list|all> as argument\n";
my $list = lc $ARGV[1] or die "Please add service <list|all> as argument\n";
my $url = ' http://10.1.25.16:8500/v1/health/service/' . $service;

my $response = (get $url);
die "Error connecting to $url" unless defined $response;
$response = decode_json ($response);

if (scalar(@$response) == 0) {
    print "Service $service : INVALID SERVICE NAME \n";
    exit 1;
} 

my @failed_hosts;
my $filter;
foreach my $key (@{$response}) {
    foreach my $key2 (@{$key->{"Checks"}}) {
       next if ( $key2->{'Status'} =~/passing/g);
       $filter->{$key2->{'CheckID'}}->{$key2->{'Node'}} = $key2->{'Status'} ;	
       push @failed_hosts, $key2->{'Node'}
    }
}

if ($list =~/list/) {
    print join (",",@failed_hosts);
    exit 1;
}
elsif (defined ($filter)) {
    print "Service " . $service . " : FAILURES " . Dumper ($filter) . "\n";
    exit 1;
} 
else
{
    print "Service " . $service . " : Cluster Healthy" . "\n";
    exit 0;
}
