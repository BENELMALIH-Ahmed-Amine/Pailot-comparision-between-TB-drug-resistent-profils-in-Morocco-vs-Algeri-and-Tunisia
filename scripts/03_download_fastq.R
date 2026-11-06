library(here)
library(dplyr)

options(timeout = 600)


# 1. Read the accession list
accessions <- read.table(here("data_raw", "accessions_to_download.txt"), header = FALSE)$V1

# 2. Create the output directory (if it doesn't exist)
dir.create(here("data_raw", "fastq_files"), showWarnings = FALSE)

# 3. Select first 3 samples (a test batch)
test_batch <- head(accessions, 3)

# 4. Loop through the test batch
for (acc in test_batch) {
  cat("Processing:", acc, "\n")
  
  # Query the ENA API for the fastq link
  api_url <- paste0("https://www.ebi.ac.uk/ena/portal/api/filereport?accession=", 
                    acc, "&result=read_run&fields=fastq_ftp")
  
  # Read the API response
  ena_data <- read.delim(api_url, stringsAsFactors = FALSE)
  
  if (nrow(ena_data) == 0 || ena_data$fastq_ftp == "") {
    cat("WARNING: No FASTQ link found for", acc, "\n")
    next
  }
  
  # ENA returns paired-end links separated by a semicolon (e.g., "link_1;link_2")
  links <- strsplit(ena_data$fastq_ftp, ";")[[1]]
  
  # Download each file
  for (i in seq_along(links)) {
    # Add https:// prefix if missing
    url <- links[i]
    if (!startsWith(url, "http")) {
      url <- paste0("https://", url)
    }
    
    # Define the local filename
    dest_file <- here("data_raw", "fastq_files", paste0(acc, "_", i, ".fastq.gz"))
    
    # Download with wget method (-c resumes the download)
    download.file(url, dest_file, method = "wget", extra = "-c -q")
    
    # Store the timing in a text log file 
    cat("Downloaded:", basename(dest_file), "at", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n", 
        file = here("data_raw", "download_log.txt"), append = TRUE)
  }
}
cat("Test batch complete!\n")