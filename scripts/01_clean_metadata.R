# Load libraries
library(here)
library(dplyr)
library(stringr)

# 1. Read the three metadata files
morocco <- read.csv(here("data_raw", "morocco_metadata.csv"), colClasses = "character")
algeria <- read.csv(here("data_raw", "algeria_metadata.csv"), colClasses = "character")
tunisia <- read.csv(here("data_raw", "tunisia_metadata.csv"), colClasses = "character")

# 2. Combine all datasets
all_samples <- bind_rows(
  list(Morocco = morocco, Algeria = algeria, Tunisia = tunisia),
  .id = "country_source"
)

# 3. Filter, Deduplicate, and Clean
final_metadata <- all_samples %>%
  # Keep only M. tuberculosis
  filter(grepl("Mycobacterium tuberculosis", Organism, ignore.case = TRUE)) %>%
  
  # Remove the accidental Israel samples and 'uncalculated'
  filter(tolower(country_source) %in% c("morocco", "algeria", "tunisia")) %>%
  filter(geo_loc_name_country != "uncalculated") %>%
  
  # Deduplicate by BioSample
  distinct(BioSample, .keep_all = TRUE) %>%
  
  # Select and rename
  select(
    sample_id = BioSample,
    sra_accession = Run,
    bioproject = BioProject,
    country = country_source,
    collection_year = Collection_Date,
    notes = Library.Name
  ) %>%
  
  # Clean the dates
  mutate(
    collection_year = case_when(
      # If it starts with 4 digits (e.g., "2015-06-01"), extract just the first 4 digits
      grepl("^\\d{4}", collection_year) ~ str_extract(collection_year, "^\\d{4}"),
      # If it's text like "missing" or empty, set to NA (Not Available)
      collection_year %in% c("missing", "not applicable", "", "uncalculated") ~ NA_character_,
      # Otherwise, mark as unknown format
      TRUE ~ "Unknown_format"
    )
  )

# 4. Save the clean file
write.csv(final_metadata, here("data_raw", "samples_metadata.csv"), row.names = FALSE)

# 5. Check the results
print(paste("Total unique samples:", nrow(final_metadata)))
print(table(final_metadata$country))
print(table(final_metadata$collection_year, useNA = "ifany"))

