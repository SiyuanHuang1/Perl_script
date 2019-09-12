#!/usr/bin/perl
use warnings;
use strict;

if ($#ARGV != 2) {
	print "\nusage:perl this.pl samples.txt max_occurence min_occurence\n\n";
	print "作用：寻找出现了一定次数的突变记录\n";
	exit;
}

my @files = ();

my $sample_list = $ARGV[0];
open SPEC, $sample_list or die "$sample_list : No such file\n";
while (<SPEC>) {
	chomp $_;
	push @files, $_;
}
close SPEC;

my %mutation = ();
my %annotation = ();
my %fname = ();
for (my $i = 0; $i <= $#files; $i++) {
	open SPEC, $files[$i] or die "$files[$i] : No such file\n";
	while (<SPEC>) {
		chomp $_;
		s/^ //;
		s/ $//;
		my @data = (split("\t", $_));
		if (exists $mutation{$data[0]}) {
			$mutation{$data[0]} += 1;
			$fname{$data[0]} .= ";$files[$i]";
		} else {
			$mutation{$data[0]} = 1;
			$fname{$data[0]} = "$files[$i]";
			$annotation{$data[0]} = "$data[1]\t$data[2]\t$data[3]\t$data[4]\t$data[5]\t$data[6]\t$data[7]\t$data[8]";
		}
	}
	close SPEC;
}
for (my $i = $ARGV[1]; $i >= $ARGV[2]; $i--) {
  my @mutations = grep {$mutation{$_}==$i} keys %mutation;
  @mutations = sort @mutations;
  foreach my $imutation (@mutations) {
 	my $imutation_nospace = $imutation =~ s/\s+//gr;
	my $imutation_nospace_nokuohao = $imutation_nospace =~ s/\(.*\)//gr;
	print "$imutation_nospace_nokuohao\t$i\t$annotation{$imutation}\t$fname{$imutation}\n";
  }
}	
