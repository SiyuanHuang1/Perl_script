#! /usr/bin/perl
use warnings;
use strict;

if ($#ARGV != 3) {
    print "perl this_script.pl lib_file case_list_file control_list_file out_file's_name\n";
    exit;
}

#接收前三个参数
my $lib = $ARGV[0];
my $case_file_list = $ARGV[1];
my $control_file_list = $ARGV[2];

#数组用来保存样本文件名、变异类型
my @array_allmutation = ();
my @array_allfile = ();

#哈希用来标记样本是否为case或control
my %case_or_control = ();

#文件句柄
open my $fh1, "<", "$lib";
open my $fh2, "<", "$case_file_list";
open my $fh3, "<", "$control_file_list";

#读取三个参数文件
while (<$fh1>) {
	chomp $_;
    push @array_allmutation, $_;
}
close $fh1;

while (<$fh2>) {
    chomp $_;
    my @oneline = (split(/\./, $_));
    push @array_allfile, $oneline[0];
    $case_or_control{$oneline[0]} = 2;
}
close $fh2;

while (<$fh3>) {
    chomp $_;
    my @oneline = (split(/\./, $_));
    push @array_allfile, $oneline[0];
    $case_or_control{$oneline[0]} = 1;
}
close $fh3;

#第四个参数定义输出文件名
my $outfile_name = $ARGV[3];
open my $outfh, ">>", "$outfile_name";

#两个循环，外层循环是所有样本文件，内层是所有变异类型
for (my $i=0; $i <= $#array_allfile; $i++) {
    my $sample_ID = $array_allfile[$i];
    my $outline = "$sample_ID\t$sample_ID\t0\t0\t1\t$case_or_control{$sample_ID}";
    my %one_file_mutation = ();
    
    #外层循环每一次都需要读取文件内容，出现的变异会记录在哈希表里面
    open my $one_file_fh, "<", "$sample_ID.txt" or die "Can't open file '$sample_ID.txt'! $!";
    while (<$one_file_fh>) {
        chomp $_;
        my @oneline = (split(/\t/,$_));
        if ($oneline[1] eq "Het") {
            $one_file_mutation{$oneline[0]} = 1;
        }
        if ($oneline[1] eq "Hom" || $oneline[1] eq "Hemi") {
            $one_file_mutation{$oneline[0]} = 2;
        }
    }
    close $one_file_fh;
    
    #内层循环检测库文件中的变异是否出现在上文的哈希表里面
    for (my $j=0; $j <= $#array_allmutation; $j++) {
        if (exists $one_file_mutation{$array_allmutation[$j]}) {
            if ($one_file_mutation{$array_allmutation[$j]} == 1) {
                $outline .= "\tA\tT";
            }
            if ($one_file_mutation{$array_allmutation[$j]} == 2) {
                $outline .= "\tA\tA";
            }
        } else {
            $outline .= "\tT\tT";
        }
    }
    print $outfh "$outline\n";
}
close $outfh;
