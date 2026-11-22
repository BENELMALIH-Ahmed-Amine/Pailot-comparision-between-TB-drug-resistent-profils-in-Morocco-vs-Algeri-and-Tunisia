# Maghreb TB Resistance 2026

## Project Goal
A pilot genomic survey of drug-resistance mutations in *Mycobacterium tuberculosis* from Morocco and the Maghreb (Algeria, Tunisia).


## Status
- [x] Step 1: Data acquisition (Metadata cleaned and finalized)
- [x] Step 2: Downloading raw sequencing data
        - [x] Tested - 3 samples.
        - [x] Calculate total samples size.
        + N.B.: You can use ncbi or ena based on your localisation
- [ ] Step 3: Variant calling & annotation
- [ ] Step 4: Lineage assignment
- [ ] Step 5: Presence/absence tables
- [ ] Step 6: Comparative analysis (Morocco vs. Algeria+Tunisia)
- [ ] Step 7: Machine learning proof-of-concept
- [ ] Step 8: Final report


## Folder Structure
- `data_raw/` — downloaded sequences (never modified)
- `data_processed/` — intermediate files
- `scripts/` — R and Bash code
- `results/` — tables and figures
- `docs/` — notes and manuscript


## Log
|     Action    |           Notes            |
|---------------|----------------------------|
| Project setup | Created folders and README |
|---------------|----------------------------|
| Metadata extracted | Downloaded SRA metadata for Morocco, Algeria, Tunisia |
|---------------|----------------------------|
| Metadata cleaning | 384 unique samples retained (Morocco: 145, Algeria: 105, Tunisia: 134). |
|---------------|----------------------------|
| Test Download | Downloaded 3 test samples using SRA Toolkit to verify pipeline. |


## Important Decisions & Caveats
- *Excluded Libya and Mauritania:* No public *M. tuberculosis* genomic data found on NCBI SRA.
- *Sample Size:* This is a pilot study. The sample size (384) is too small for definitive population frequencies. Results will be reported as presence/absence and descriptive comparisons.
- *Data Security:* Raw data will not be pushed to any public repository (GitHub) to respect data size limits and privacy.

