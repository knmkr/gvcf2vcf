# gvcf2vcf

Makefile for gVCF to VCF converter

Build

```
$ make
```

Usage

```
$ gzip -dc gvcf.gz| ./bin/break_blocks --region-file ./reference/reference.region.bed --ref ./reference/reference.fa
```

- [gvcftools](https://sites.google.com/site/gvcftools/)
- [samtools](http://www.htslib.org/doc/samtools.html)
