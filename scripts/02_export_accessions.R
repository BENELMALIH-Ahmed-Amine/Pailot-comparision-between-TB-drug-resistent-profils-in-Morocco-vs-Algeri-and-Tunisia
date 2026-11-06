# Load library
library(here)

# Read the cleaned metadata file we generated in step 1
final_metadata <- read.csv(here("data_raw", "samples_metadata.csv"))

# Export only the sra_accession column to a text file
write.table(
  final_metadata$sra_accession, 
  file = here("data_raw", "accessions_to_download.txt"), 
  row.names = FALSE, 
  col.names = FALSE, 
  quote = FALSE
)

print("Accessions file exported successfully!")