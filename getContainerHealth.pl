#!/usr/bin/perl

use strict;
use LWP::Simple;
use JSON;
use Data::Dumper;

my $service  = lc $ARGV[0] or die "Please add <service> <servers|exit> <bucket1|2> <tagno> as arguments\n";
my $flag     = lc $ARGV[1] or die "Please add <service> <servers|exit> <bucket1|2> <tagno> as arguments\n";
my $bucketno = lc $ARGV[2] or die "Please add <service> <servers|exit> <bucket1|2> <tagno> as arguments\n";
my $tagno    = lc $ARGV[3] or die "Please add <service> <servers|exit> <bucket1|2> <tagno> as arguments\n";

my $getBucketData = ` ./getBucketData.pl $tagno $bucketno $service `;
if ($getBucketData =~ /No minion available/) {
    print $getBucketData;
    exit 0;
}

my $url = ' http://10.1.25.16:8500/v1/health/service/' . $service;
my $response = (get $url);
die "Error connecting to $url" unless defined $response;
$response = decode_json ($response);

if (scalar(@$response) == 0) {
    print "ERROR Service $service : INVALID SERVICE NAME \n";
    exit 1;
} 

my @failed_hosts;
my @exit_hosts;
my $filter;

foreach my $key (@{$response}) {
    if (scalar(@{$key->{"Checks"}}) == 1) {
        print "ERROR Service $service : Missing http url app check \n";
        exit 1;
    }
    foreach my $key2 (@{$key->{"Checks"}}) {
        next if (( $key2->{'Status'} =~/passing/g) || ($key2->{'Name'} =~/Serf Health Status/g)) ;
        if ($getBucketData =~/$key2->{'Node'}/) {
            $filter->{$key2->{'CheckID'}}->{$key2->{'Node'}} = $key2->{'Status'};	
            push @exit_hosts, $key2->{'Node'}  if ($key2->{'Output'} =~ /404/);
            push @failed_hosts, $key2->{'Node'};
        }
    }
}

if (!defined $filter) {
    print "Service " . $service . " : Cluster Healthy" . "\n";
    exit 0;
}
if ((defined $filter) && ($flag =~/servers/i)) {
    print join (",",sort @failed_hosts);
}
if ((defined $filter) && ($flag =~/exit/i)) {
    print join (",",sort @exit_hosts);
}
if ((defined $filter) && ($flag =~/debug/i)) {
    print "Service " . $service . " : FAILURES " . Dumper ($filter) . "\n";
    exit 1;
} 
