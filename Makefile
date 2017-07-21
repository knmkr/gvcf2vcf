samtools_version = 1.5
samtools = src/samtools-$(samtools_version)/samtools

gvcftools_version = 0.17.0
gvcftools = src/gvcftools-$(gvcftools_version)/bin

programs = src $(samtools) $(gvcftools)
references = $(reference_dir) reference/GRCh37.p13.fa.fai


all: $(programs) $(references) bin bin/samtools bin/gvcftools

src:
	mkdir -p src

$(samtools):
	cd src; wget -c https://github.com/samtools/samtools/releases/download/$(samtools_version)/samtools-$(samtools_version).tar.bz2
	cd src; bzip2 -dc samtools-$(samtools_version).tar.bz2| tar xvf -
	cd src/samtools-$(samtools_version); make

$(gvcftools):
	cd src; wget -c https://github.com/sequencing/gvcftools/releases/download/v$(gvcftools_version)/gvcftools-$(gvcftools_version).tar.gz
	cd src; tar -xzf gvcftools-$(gvcftools_version).tar.gz
	cd src/gvcftools-$(gvcftools_version); make

bin:
	mkdir -p bin

bin/samtools:
	cd src/samtools-$(samtools_version); make prefix=../../ install

bin/gvcftools:
	ln -s $(PWD)/src/gvcftools-$(gvcftools_version)/bin/* bin

reference: $(references)

reference_dir:
	mkdir -p reference

reference/GRCh37.p13.fa:
	cd reference; wget -r ftp://ftp.ncbi.nlm.nih.gov/genomes/archive/old_genbank/Eukaryotes/vertebrates_mammals/Homo_sapiens/GRCh37.p13/Primary_Assembly/assembled_chromosomes/FASTA/
	cd reference; for x in {1..22} X Y; do gzip -dc chr${x}.fa.gz >> GRCh37.p13.fa; done

reference/GRCh37.p13.fa.fai: bin/samtools reference/GRCh37.p13.fa
	bin/samtools faidx reference/GRCh37.p13.fa
