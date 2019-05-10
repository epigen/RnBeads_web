## Install RnBeads

if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager", repos="http://cran.rstudio.com")
BiocManager::install(c("RnBeads", "RnBeads.hg19", "RnBeads.mm10", "RnBeads.hg38"),  dependencies = TRUE, quiet = TRUE)
# source("http://bioconductor.org/biocLite.R")
# biocLite(c("RnBeads", "RnBeads.hg19", "RnBeads.mm10"), dependencies = TRUE, quiet = TRUE)
suppressPackageStartupMessages(library(RnBeads))
txt <- c("\nHow to test if RnBeads is correctly installed?",
	"1. Check out our FAQ items on Ghostscript and ZIP by visiting:",
	"https://rnbeads.org/faq.html",
	"2. Check out the documentation:",
	'vignette("RnBeads")',
	"3. Start the RnBeads Data Juggler:",
	"rnb.run.dj()\n")
cat(paste0(txt, collapse = "\n"))
rm(txt)
