samtools_version = 1.2
samtools = src/samtools-$(samtools_version)/samtools

gvcftools_version = 0.16
gvcftools = src/gvcftools-$(gvcftools_version)/bin

programs = src $(samtools) $(gvcftools)

references = $(reference_dir) reference/grch37.p13.fa.fai reference/hg19.fa.fai


all: $(programs)

src:
	mkdir -p src

$(samtools):
	cd src; wget -c https://github.com/samtools/samtools/releases/download/$(samtools_version)/samtools-$(samtools_version).tar.bz2
	cd src; bzip2 -dc samtools-$(samtools_version).tar.bz2| tar xvf -
	cd src/samtools-$(samtools_version); make

$(gvcftools):
	cd src; wget -c https://sites.google.com/site/gvcftools/home/download/gvcftools-$(gvcftools_version).tar.gz
	cd src; tar -xzf gvcftools-$(gvcftools_version).tar.gz
	cd src/gvcftools-$(gvcftools_version); make

install: bin bin/samtools bin/gvcftools

bin:
	mkdir -p bin

bin/samtools:
	cd src/samtools-$(samtools_version); make prefix=../../ install

bin/gvcftools:
	ln -s $(PWD)/src/gvcftools-$(gvcftools_version)/bin/* bin

reference: $(references)

reference_dir:
	mkdir -p reference

reference/grch37.p13.fa:
	cd reference; wget -r ftp://ftp.ncbi.nlm.nih.gov/genbank/genomes/Eukaryotes/vertebrates_mammals/Homo_sapiens/GRCh37.p13/Primary_Assembly/assembled_chromosomes/FASTA/
	cd reference; for x in {1..22} X Y; do gzip -dc chr${x}.fa.gz >> GRCh37.p13.fa; done

reference/hg19.fa:
	cd reference; wget -r http://hgdownload.cse.ucsc.edu/goldenPath/hg19/bigZips/chromFa.tar.gz -O hg19.tar.gz
	cd reference; tar xvzf hg19.tar.gz

# TODO: DRY
reference/grch37.p13.fa.fai: bin/samtools reference/grch37.p13.fa
	bin/samtools faidx reference/grch37.p13.fa

# TODO: DRY
reference/hg19.fa.fai: bin/samtools reference/hg19.fa
	bin/samtools faidx reference/hg19.fa
