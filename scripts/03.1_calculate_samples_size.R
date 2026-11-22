library(here)

# 1. Read the accessions
accessions <- read.table(here("data_raw", "accessions_to_download.txt"), header = FALSE)$V1

# 2. Initialize a variable to hold the total bytes
total_bytes <- 0

# 3. Loop through all accessions to fetch sizes
for (acc in accessions) {
  cat("Querying:", acc, "\n")
  
  api_url <- paste0("https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=sra&id=", 
                    acc, "&rettype=runinfo&retmode=text")
  
  # Use read.csv for NCBI, and add Sys.sleep to prevent rate-limiting
  Sys.sleep(0.4) # NCBI allows max 3 requests per second
  ena_data <- tryCatch(
    read.csv(api_url, stringsAsFactors = FALSE),
    error = function(e) data.frame() 
  )
  
  # Check if we actually got rows AND the size_MB column exists
  if (nrow(ena_data) > 0 && "size_MB" %in% colnames(ena_data)) {
    
    # Check if the value is not NA or empty
    if (!is.na(ena_data$size_MB[1]) && ena_data$size_MB[1] != "") {
      sizes <- as.numeric(ena_data$size_MB) * (1024^2)
      total_bytes <- total_bytes + sum(sizes, na.rm = TRUE)
    } else {
      cat("WARNING: Size is NA/empty for", acc, "\n")
    }
    
  } else {
    # This will catch cases where NCBI throws an error or returns an invalid format
    cat("WARNING: Could not fetch size for", acc, "(NCBI API issue or invalid accession)\n")
  }
}


# 4. Convert to GB (using binary 1024^3 for accurate storage calculation)
total_gb <- total_bytes / (1024^3)

# 5. Print the result
cat("\n----------------------------------------\n")
cat("Total bytes:", total_bytes, "\n")
cat("Total estimated download size:", round(total_gb, 2), "GB\n")
cat("----------------------------------------\n")