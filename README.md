# DNA Metabarcoding of dung beetle gut contents

Bioinformatics workflow and codes for processing raw reads of 12S and 16S rRNA marker genes obtained from the gut contents of 547 dung beetle individuals belonging to 15 dung beetle species.

Reads were obtained by:

1.  Standard PCR with tagged 12S (12SV05 forward: TTAGATACCCCACTATGC; 12SV05 reverse: TAGAACAGGCTCCTCTAG) and 16S (16Smam1forward: CGGTTGGGGTGACCTCGGA; 16Smam2 reverse: GCTGTTATCCCTAGGGTAACT) primer sets

2.  Next-generation sequencing on Illumina Novaseq platform using 150 bp paired end reads aiming for two Gb of data for each pooled product (performed by Axil Scientific Pte Ltd)

Raw reads from Illumina Novaseq sequencing are deposited on NCBI at Bioproject number PRJNA885274.

# Workflow:

## 1. Quality check

Quality of raw reads was assessed using FastQC (Andrews et al. 2012).

## 2. Demultiplexing

Raw reads (FASTQ files) of each PCR pool were demultiplexed using the demultiplexer Python script (<https://github.com/DominikBuchner/demultiplexer>).

## 3. APSCALE

Demultiplexed reads were processed using the APSCALE pipeline (Buchner et al. 2022), which comprised of:

-   Primer merging

-   Adapter removal

-   Quality filtering

-   Operational Taxonomical Units (OTU) clustering (sequence similarity threshold of 97%)

-   Denoising and filtering using the LULU algorithm.

The settings used in this pipeline are provided as "[APSCALE_Settings_12S.xlsx](https://github.com/teelabntu/dungbeetle-vertebrate_networks_DNA_metabarcoding/blob/master/3_APSCALE/APSCALE_Settings_12S.xlsx)" and "[APSCALE_Settings_16S.xlsx](https://github.com/teelabntu/dungbeetle-vertebrate_networks_DNA_metabarcoding/blob/master/3_APSCALE/APSCALE_Settings_16S.xlsx)".

This produced a matrix of replicates (rows) and OTUs (columns) for each primer set (i.e. 12S matrix and 16S matrix), with the number of reads as cell values.

Output files: [12S_OTU_raw.csv](https://github.com/teelabntu/dungbeetle-vertebrate_networks_DNA_metabarcoding/blob/master/4_Post-APSCALE/12S_OTU_raw.csv); [16S_OTU_raw.csv](https://github.com/teelabntu/dungbeetle-vertebrate_networks_DNA_metabarcoding/blob/master/4_Post-APSCALE/16S_OTU_raw.csv)

## 4. Post-Bioinformatics Filtering

A series of post-bioinformatic filtering steps was applied to remove contamination and low-frequency artefacts (following Drake et al. 2022; code: [4_Post-Bioinformatics_filtering.R](https://github.com/teelabntu/dungbeetle-vertebrate_networks_DNA_metabarcoding/blob/master/4_Post-APSCALE/4_Post-Bioinformatics_filtering.R)):

-   Remove contamination detected by negative controls and blanks

    Within each OTU, the highest read count across the negative controls and blanks was determined and any read counts that were lower than this value were removed

-   Remove contamination within each PCR replicate

    Removed any OTUs within the replicate with read counts that were less than 1% of the total read count for each replicate

-   Remove low-frequency artefacts

    Removed any read counts that were less than 10 reads.

Output files: [12S_OTU_filtered.csv](https://github.com/teelabntu/dungbeetle-vertebrate_networks_DNA_metabarcoding/blob/master/4_Post-APSCALE/12S_OTU_filtered.csv); [16S_OTU_filtered.csv](https://github.com/teelabntu/dungbeetle-vertebrate_networks_DNA_metabarcoding/blob/master/4_Post-APSCALE/16S_OTU_filtered.csv)

Output files were processed in Microsoft Excel to remove OTUs that had 0 total reads post-filtering.

Outfile files: [12S_OTU_filtered2.csv](https://github.com/teelabntu/dungbeetle-vertebrate_networks_DNA_metabarcoding/blob/master/4_Post-APSCALE/12S_OTU_filtered2.csv); [16S_OTU_filtered2.csv](https://github.com/teelabntu/dungbeetle-vertebrate_networks_DNA_metabarcoding/blob/master/4_Post-APSCALE/16S_OTU_filtered2.csv)

## 5. Taxonomy Assignment using BLAST and filtering of BLAST results

*blastn* (using cmd line) was used to match all remaining OTUs against the NCBI *nt*-database.\
\
Example code:

`blastn -db nt -query 12S_OTU_seq_filtered_p1.fasta -out 12S_ESV_seq_filtered_results_p1.csv -outfmt "10 qseqid sseqid sscinames sskingdoms pident length mismatch qstart qend sstart send evalue bitscore score" -remote`

Output files: [12S_OTU_seq_filtered_results_all.csv](https://github.com/teelabntu/dungbeetle-vertebrate_networks_DNA_metabarcoding/blob/master/5_BLAST/12S_OTU_seq_filtered_results_all.csv); [16S_OTU_seq_filtered_results.csv](https://github.com/teelabntu/dungbeetle-vertebrate_networks_DNA_metabarcoding/blob/master/5_BLAST/16S_OTU_seq_filtered_results.csv)

BLAST results were filtered using the following criteria (code: [5_BLAST_results_filtering.R](https://github.com/teelabntu/dungbeetle-vertebrate_networks_DNA_metabarcoding/blob/master/5_BLAST/5_BLAST_results_filtering.R)):

-   Retained vertebrate (Phylum Chordata) hits

-   Sequence length: At least 80 bp

-   e-value: Less than 1E-10

Taxonomy assignments with the following criteria were retained (code: [5_BLAST_results_filtering.R](https://github.com/teelabntu/dungbeetle-vertebrate_networks_DNA_metabarcoding/blob/master/5_BLAST/5_BLAST_results_filtering.R)):

-   Highest percentage identity,

-   Longest query cover

-   Lowest e-value

-   Highest number of BLAST matches

Output files: [12S_OTU_all_blast_scores.csv](https://github.com/teelabntu/dungbeetle-vertebrate_networks_DNA_metabarcoding/blob/master/5_BLAST/12S_OTU_all_blast_scores.csv); [12S_OTU_assigned_taxonomy_tophit.csv](https://github.com/teelabntu/dungbeetle-vertebrate_networks_DNA_metabarcoding/blob/master/5_BLAST/12S_OTU_assigned_taxonomy_tophit.csv); [16S_OTU_all_blast_scores.csv](https://github.com/teelabntu/dungbeetle-vertebrate_networks_DNA_metabarcoding/blob/master/5_BLAST/16S_OTU_all_blast_scores.csv); [16S_OTU_assigned_taxonomy_tophit.csv](https://github.com/teelabntu/dungbeetle-vertebrate_networks_DNA_metabarcoding/blob/master/5_BLAST/16S_OTU_assigned_taxonomy_tophit.csv)

## 6. Data cleaning

OTUs that matched the same species were combined. Genus- or family-level classification was assigned to OTUs that had multiple species or genera matches with equal numbers of BLAST matches (see 12S_OTU_final_assignment.csv & 16S_OTU_final_assignment.csv). Read counts for each individual beetle were summed across its sample replicates (code: 6_Data_Cleaning.R)

Output files: [12S_OTU_matrix.csv](https://github.com/teelabntu/dungbeetle-vertebrate_networks_DNA_metabarcoding/blob/master/6_Data_Cleaning/12S_OTU_matrix.csv); [16S_OTU_matrix.csv](https://github.com/teelabntu/dungbeetle-vertebrate_networks_DNA_metabarcoding/blob/master/6_Data_Cleaning/16S_OTU_matrix.csv)

Output files were processed in Microsoft Excel to remove unmatched OTUs.

Output files: [12S_OTU_matrix2.csv](https://github.com/teelabntu/dungbeetle-vertebrate_networks_DNA_metabarcoding/blob/master/6_Data_Cleaning/12S_OTU_matrix2.csv); [16S_OTU_matrix2.csv](https://github.com/teelabntu/dungbeetle-vertebrate_networks_DNA_metabarcoding/blob/master/6_Data_Cleaning/16S_OTU_matrix2.csv)

OTU "replicates" (i.e. same species/genus/family) were combined and final matrices of individual beetles (rows) and assigned taxonomy (columns) were produced for 12S and 16S primer sets (code: 6_Data_Cleaning.R).

Output files: [12S_OTU_final_matrix.csv](https://github.com/teelabntu/dungbeetle-vertebrate_networks_DNA_metabarcoding/blob/master/6_Data_Cleaning/12S_OTU_final_matrix.csv); [16S_OTU_final_matrix.csv](https://github.com/teelabntu/dungbeetle-vertebrate_networks_DNA_metabarcoding/blob/master/6_Data_Cleaning/16S_OTU_final_matrix.csv)

## References

Andrews, S., Krueger, F., Segonds-Pichon, A., Biggins, L., Krueger, C. & Wingett, S. (2012). FastQC: a quality control tool for high throughput sequence data.

Buchner, D., Macher, T.-H. & Leese, F. (2022). APSCALE: advanced pipeline for simple yet comprehensive analyses of DNA metabarcoding data. Bioinformatics, 38, 4817–4819. <https://doi.org/10.1093/bioinformatics/btac588>.

Drake, L.E., Cuff, J.P., Young, R.E., Marchbank, A., Chadwick, E.A. & Symondson, W.O.C. (2022). An assessment of minimum sequence copy thresholds for identifying and reducing the prevalence of artefacts in dietary metabarcoding data. Methods Ecol Evol, 13, 694–710. <https://doi.org/10.1111/2041-210X.13780>.
