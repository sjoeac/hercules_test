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
open my $fh, ">", "bucket1_" . $tag_no .".json";
print $fh encode_json($bucket1);
close $fh;
open my $fh, ">", "bucket2_" . $tag_no .".json";
print $fh encode_json($bucket2);
close $fh;

print "Bucket Files have been generated\n";
}

else {
print "ERROR: Bucket File not generated\n";
exit 1;

}
