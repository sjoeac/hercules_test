#!/usr/bin/perl

use strict;
use LWP::Simple;
use JSON;
use Data::Dumper;

my $tagno = $ARGV[0] or die "Please add <tagno> <bucket1|bucket2> <service> as arguments\n";
my $bucket = $ARGV[1] or die "Please add <tagno> <bucket1|bucket2> <service> as arguments\n";
my $service = $ARGV[2] or die "Please add <tagno> <bucket1|bucket2> <service>  as arguments\n";

my $path = $ENV{WORKSPACE} || "/tmp";
my $bucketFile;

if ($bucket =~ /bucket1/) {
$bucketFile = "$path/$bucket-" . $tagno .".json";
}
elsif ($bucket =~ /bucket2/) {
my ($bucketName)  = $bucket =~ /(bucket\d+)[_]*.*?/ig;
$bucketFile = "$path/$bucketName-" . $tagno .".json";
}

if (!(-e $bucketFile )) {
    print "ERROR: Bucket File $bucketFile does not exist\n";
    exit 1;
}

my $json;
{
  local $/; #Enable 'slurp' mode
  open my $fh, "<", $bucketFile;
  $json = <$fh>;
  close $fh;
}

my $data = decode_json($json);

if (! $data->{$service}) {
    print "ERROR: Service $service : No Minion available\n";
    exit 1;
}

if (($bucket=~/bucket1/) || ($bucket=~/bucket2$/)) {
    print join(",", @{$data->{$service}});
}
elsif ($bucket=~/bucket2_50/) {
    my @first_half;
    my $bno = scalar(@{$data->{$service}}) * 0.5;
    push @first_half ,shift @{$data->{$service}} for 1..$bno;
    if (scalar (@first_half) == 0 ) {
        print "Service $service : No minion available \n";
        exit 0;
    }
    print join(",", @first_half);

}
elsif ($bucket=~/bucket2_100/) {
    my @first_half;
    my $bno = scalar(@{$data->{$service}}) * 0.5;
    push @first_half ,shift @{$data->{$service}} for 1..$bno;
    print join(",", @{$data->{$service}});
}
else {
    print "ERROR: No Data\n";
    exit 1;
} 
