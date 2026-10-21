# Load libraries
library(here)
library(dplyr)

# 1. Read the three metadata files
morocco <- read.csv(here("data_raw", "morocco_metadata.csv"), colClasses = "character")
algeria <- read.csv(here("data_raw", "algeria_metadata.csv"), colClasses = "character")
tunisia <- read.csv(here("data_raw", "tunisia_metadata.csv"), colClasses = "character")

# 2. Combine all datasets
all_samples <- bind_rows(morocco, algeria, tunisia)

# 3. Filter strictly by M. tuberculosis using grepl
all_samples_clean <- all_samples %>%
  filter(grepl("Mycobacterium tuberculosis", Organism, ignore.case = TRUE))

# 4. Deduplicate by BioSample to avoid skewing counts
all_samples_clean <- all_samples_clean %>%
  distinct(BioSample, .keep_all = TRUE)

# 5. Select and rename the columns to match your empty CSV structure
final_metadata <- all_samples_clean %>%
  select(
    sample_id = BioSample,       # Using BioSample as unique ID
    sra_accession = Run,
    bioproject = BioProject,
    country = geo_loc_name_country,
    collection_year = Collection_Date,
    notes = Library.Name
  )

# 6. Write the final CSV
write.csv(final_metadata, here("data_raw", "samples_metadata.csv"), row.names = FALSE)

# 7. Print a summary to check the result
print(paste("Total unique samples:", nrow(final_metadata)))
print(table(final_metadata$country))

