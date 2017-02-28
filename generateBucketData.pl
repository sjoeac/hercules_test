#!/usr/bin/perl

use LWP::Simple;
use JSON;
use Data::Dumper;
use Sys::Hostname;

my $tag_no = $ARGV[0] or die "Please add tag_no as argument\n";
my $url = 'http://10.1.25.16:8500/v1/catalog/services';
my $response = (get $url);
die "Error connecting to $url" unless defined $response;
$response = decode_json ($response);

if (! defined $response) {
    print "Service $service : INVALID SERVICE NAME \n";
    exit 1;
} 

my $filteredB1;
my $filtered;
foreach my $service (keys %{$response}) {
print $service . "\n";

my $url = ' http://10.1.25.16:8500/v1/health/service/' . $service;

my $response = (get $url);
die "Error connecting to $url" unless defined $response;
$response = decode_json ($response);

foreach my $key (@{$response}) {
    if (!defined $filteredB1->{$service}) {
        push @{$filteredB1->{$service}}, $key->{'Node'}->{"Node"} if (!defined $filteredB1->{$service});
        next;
    }

    push @{$filtered->{$service}}, $key->{'Node'}->{"Node"}
    }
}


print Dumper ($filtered);
print "____________________";
print Dumper ($filteredB1);

