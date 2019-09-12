#!/usr/bin/perl
use warnings;
use strict;

if ($#ARGV != 1) {
  print "perl subtract.pl A.txt B.txt\n";
  exit;
}

my @seq = ();
my %annotation = ();
my $a = $ARGV[0];
open A, $a or die "$a : No such file\n";
while (<A>) {
  chomp $_;
  my @one_line = (split("\t",$_));
  push @seq, $one_line[0];
  $annotation{$one_line[0]} = "$one_line[1]\t$one_line[2]\t$one_line[3]\t$one_line[4]\t$one_line[5]\t$one_line[6]\t$one_line[7]\t$one_line[8]";
}
close A;

my %ex = ();
my $b = $ARGV[1];
open B, $b or die "$b : No such file\n";
while (<B>) {
  chomp $_;
  $ex{$_} = 1;
}
close B;

@seq = grep {!exists($ex{$_})} @seq;
foreach my $iseq (@seq) {
	print "$iseq\t$annotation{$iseq}\n";
}