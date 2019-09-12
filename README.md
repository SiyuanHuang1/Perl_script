# Perl_script
some scripts by Perl
### intersect
`intersect_of_seqname_in_multifiles.pl`中的脚本用来求多个文件（类似文件内容都是基因名）的交集，比如哪些基因在所有文件中都出现。

`intersect_of_record_in_multifiles.pl`有一些改进，能适用于多列文本，具体来说就是根据其中的某一列来找交集关系。脚本的最后还用到了**正则替换**。

`subtract.pl`处理多列文本，针对其中的某一列挑选出**该列存在于另一个单列文本**的行记录。
### mutation_file_to_ped
在转换的过程中，纯合变异记为`A\tA`，杂合变异记为`A\tT`，没有变异记为`T\tT`。
