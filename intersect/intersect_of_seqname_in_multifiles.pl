#! /usr/bin/perl
use warnings;
use strict;

if ($#ARGV != 2) {
  print "perl this_script.pl files.txt max_occurence min_occurence\n";
  exit;
}

my @files = ();

my $spec = $ARGV[0];
open SPEC, $spec or die "$spec : No such file\n";
while (<SPEC>) {
  chomp $_;
  push @files, $_;
}
close SPEC;

my %seq = ();
my %seq_fname = ();
for (my $i = 0; $i <= $#files; $i++) {
  open SPEC, $files[$i] or die "$files[$i] : No such file\n";
  while (<SPEC>) {
    chomp $_;
    s/[\s]+/ /g;
    s/^ //;
    s/ $//;
    my @data = split / /, $_;
    if (exists $seq{$data[0]}) {
      $seq{$data[0]} += 1;
	  $seq_fname{$data[0]} .= ";$files[$i]";
    } else {
      $seq{$data[0]} = 1;
	  $seq_fname{$data[0]} = "$files[$i]";
    }
  }
  close SPEC;
}

for (my $i = $ARGV[1]; $i >= $ARGV[2]; $i--) {
  my @seqs = grep {$seq{$_}==$i} keys %seq;
  @seqs = sort @seqs;
  foreach my $iseq (@seqs) {
	print "$i\t$iseq\t$seq_fname{$iseq}\n";
  }
}

#####################################
#								 	#
#			Author: hsy			  	#
#			Date: 2019.9.12		  	#
#								  	#
#####################################