library(here)

# 1. Read accessions
accessions <- read.table(here("data_raw", "accessions_to_download.txt"), header = FALSE)$V1

# If you wich to stop the download to continue later, define the accessions you need to skip
#skip_list <- accessions[1:x]
#cat(skip_list)

# Keep only the accessions that are NOT in the skip list
#accessions <- accessions[!accessions %in% skip_list]
#cat(accessions)

# 2. Define external drive path and directories
YourPath <- "YourPath"
sra_dir <- file.path(YourPath, "sra_raw")
fastq_dir <- file.path(YourPath, "fastq_files")

# Create directories safely
dir.create(sra_dir, showWarnings = FALSE, recursive = TRUE)
dir.create(fastq_dir, showWarnings = FALSE, recursive = TRUE)

# 3. Select all samples
test_batch <- accessions

# 4. Loop through the test batch
for (acc in test_batch) {
  cat("Processing:", acc, "\n")
  
  # 1- prefetch Downloads the .sra file, shQuote handels spaces in YourPath
  prefetch_cmd <- paste("prefetch", acc, "--output-directory", shQuote(sra_dir))
  system(prefetch_cmd)
  
  # Define where prefetch put the file
  sra_file_path <- file.path(sra_dir, acc, paste0(acc, ".sra"))
  
  # 2- fasterq-dump (Converts .sra to .fastq)
  dump_cmd <- paste("fasterq-dump", shQuote(sra_file_path), "--outdir", shQuote(fastq_dir), "--split-files -e 4")
  system(dump_cmd)
  
  # 3- Clean up the heavy .sra folder to save space
  unlink(file.path(sra_dir, acc), recursive = TRUE)
  
  # Log the download
  cat("Downloaded:", acc, "at", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n", 
      file = file.path(fastq_dir, "download_log.txt"), append = TRUE)
}
cat("Test batch complete!\n")