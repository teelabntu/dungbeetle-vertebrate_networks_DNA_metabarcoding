# DNA Metabarcoding of dung beetle gut contents

Bioinformatics workflow and codes for processing raw reads of 12S and 16S rRNA marker genes obtained from the gut contents of 547 dung beetle individuals belonging to 15 dung beetle species.

Reads were obtained by:

1.  Standard PCR with tagged 12S (12SV05 forward: TTAGATACCCCACTATGC; 12SV05 reverse: TAGAACAGGCTCCTCTAG) and 16S (16Smam1forward: CGGTTGGGGTGACCTCGGA; 16Smam2 reverse: GCTGTTATCCCTAGGGTAACT) primer sets

2.  Next-generation sequencing on Illumina Novaseq platform using 150 bp paired end reads aiming for two Gb of data for each pooled product (performed by Axil Scientific Pte Ltd)

Raw reads from Illumina Novaseq sequencing are deposited on NCBI at Bioproject number PRJNA1147414 (<https://www.ncbi.nlm.nih.gov/bioproject/?term=PRJNA1147414>).

# Workflow:

## 1. Quality check

Quality of raw reads was assessed using FastQC (Andrews et al. 2012).

## 2. Demultiplexing

Raw reads (FASTQ files) of each PCR pool were demultiplexed using the demultiplexer Python script (<https://github.com/DominikBuchner/demultiplexer>).

Demultiplex template and primers are provided in the folder "2_Demultiplex".

## 3. APSCALE

Demultiplexed reads were processed using the APSCALE pipeline (Buchner et al. 2022), which comprised of:

-   Primer merging

-   Adapter removal

-   Quality filtering

-   Operational Taxonomical Units (OTU) clustering (sequence similarity threshold of 97%)

-   Denoising and filtering using the LULU algorithm.

The settings used in this pipeline are provided as "[APSCALE_Settings_12S.xlsx](https://github.com/teelabntu/dungbeetle-vertebrate_networks_DNA_metabarcoding/blob/master/3_APSCALE/APSCALE_Settings_12S.xlsx)" and "[APSCALE_Settings_16S.xlsx](https://github.com/teelabntu/dungbeetle-vertebrate_networks_DNA_metabarcoding/blob/master/3_APSCALE/APSCALE_Settings_16S.xlsx)".

This produced a matrix of replicates (rows) and OTUs (columns) for each primer set (i.e. 12S matrix and 16S matrix), with the number of reads as cell values.

## 4. Post-Bioinformatics Filtering

A series of post-bioinformatic filtering steps was applied to remove contamination and low-frequency artefacts (following Drake et al. 2022; code: [4_Post-Bioinformatics_filtering.R](https://github.com/teelabntu/dungbeetle-vertebrate_networks_DNA_metabarcoding/blob/master/4_Post-APSCALE/4_Post-Bioinformatics_filtering.R)):

-   Remove low-frequency artefacts

    Removed any read counts that were less than 10 reads.

-   Remove contamination within each PCR replicate

    Removed any OTUs within the replicate with read counts that were less than 1% of the total read count for each replicate

-   Remove contamination detected in blanks and negatives but avoid eliminating true detections

    Retained OTUs that were detected in at least five sample replicates.

## 5. Taxonomy Assignment using BLAST and filtering of BLAST results

*blastn* (using Web BLAST) was used to match all remaining OTUs against the NCBI *core_nt* database.

BLAST results were filtered using the following criteria (code: [5_BLAST_results_filtering.R](https://github.com/teelabntu/dungbeetle-vertebrate_networks_DNA_metabarcoding/blob/master/5_BLAST/5_BLAST_results_filtering.R)):

-   Retained vertebrate (Phylum Chordata) hits

-   Sequence length: At least 80 bp

-   e-value: Less than 1E-10

Taxonomy assignments with the following criteria were retained (code: [5_BLAST_results_filtering.R](https://github.com/teelabntu/dungbeetle-vertebrate_networks_DNA_metabarcoding/blob/master/5_BLAST/5_BLAST_results_filtering.R)):

-   Highest percentage identity,

-   Longest query cover

-   Lowest e-value

-   Highest number of BLAST matches

## 6. Data cleaning

OTUs that matched the same species were combined. Genus- or family-level classification was assigned to OTUs that had multiple species or genera matches with equal numbers of BLAST matches. OTU "replicates" (i.e. same species/genus/family) were combined and final matrices of individual beetles (rows) and assigned taxonomy (columns) were produced for 12S and 16S primer sets 

## References

Andrews, S., Krueger, F., Segonds-Pichon, A., Biggins, L., Krueger, C. & Wingett, S. (2012). FastQC: a quality control tool for high throughput sequence data.

Buchner, D., Macher, T.-H. & Leese, F. (2022). APSCALE: advanced pipeline for simple yet comprehensive analyses of DNA metabarcoding data. Bioinformatics, 38, 4817–4819. <https://doi.org/10.1093/bioinformatics/btac588>.

Drake, L.E., Cuff, J.P., Young, R.E., Marchbank, A., Chadwick, E.A. & Symondson, W.O.C. (2022). An assessment of minimum sequence copy thresholds for identifying and reducing the prevalence of artefacts in dietary metabarcoding data. Methods Ecol Evol, 13, 694–710. <https://doi.org/10.1111/2041-210X.13780>.
