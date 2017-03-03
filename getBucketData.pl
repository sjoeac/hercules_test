#!/usr/bin/perl

use strict;
use LWP::Simple;
use JSON;
use Data::Dumper;

my $tagno = $ARGV[0] or die "Please add <tagno> <bucket1|bucket2> <service> as arguments\n";
my $bucket = $ARGV[1] or die "Please add <tagno> <bucket1|bucket2> <service> as arguments\n";
my $service = lc $ARGV[2] or die "Please add <tagno> <bucket1|bucket2> <service> as arguments\n";

my $path = $ENV{WORKSPACE} || "/tmp";
my $bucketFile = "$path/$bucket-" . $tagno .".json";
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

if (defined $data->{$service}) {
     print join(",", @{$data->{$service}})
}
else {
    print "ERROR: No Data\n";
    exit 1;
}
