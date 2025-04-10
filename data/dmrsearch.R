  
  required_packages <- c("dplyr")
  missing_packages <- function(packages) {
    for (pkg in packages) {
      if (!require(pkg, character.only = TRUE)) {
        install.packages(pkg, dependencies = TRUE)
        library(pkg, character.only = TRUE)
      }
    }
  }
  
  missing_packages(required_packages)
  
  library(dplyr)
  
  file_list <- list.files(path = "../differential_methylation_data/", pattern = "diffMethTable_site_", full.names = TRUE)
  cmp <- gsub("diffMethTable_site_|\\.csv", "", basename(file_list))
  
  dmr_search <- function(n) {
    
      rnb.cpg <- read.csv(file = file_list[n])
      rnb.cpg <- rnb.cpg[, c("cgid", "Chromosome", "Start", "mean.diff", "diffmeth.p.adj.fdr")]
      rnb.cpg$Chromosome <- gsub("chr", "", rnb.cpg$Chromosome)
      colnames(rnb.cpg)[1:5] <- c("CPG", "CHR", "POS", "DIFF", "FDR")
      rnb.cpg <- rnb.cpg %>% 
        mutate(ORG = 0, EMP = 0, FWER = 0, SDMP = 0) %>% 
        dplyr::select(CPG, CHR, POS, ORG, EMP, FDR, FWER, SDMP, DIFF)
      
      write.csv(rnb.cpg, file = paste0('../dimmer/dimmer_project.csv'), 
                quote = FALSE, row.names = FALSE)

      new_dir <- "./DMR/"
      
      if (!dir.exists(new_dir)) {
        dir.create(new_dir, showWarnings = TRUE, recursive = FALSE)
      } else {
        message("Directory already exists.")
      }
      
      # Configuration file for dimmer with default parameters set
      # If needed, please modify the DMR search parameters mentioned below
      # Save changes to this file before proceeding
      
      config <- "
  
  #Choose an output directory:
  output_path: ./DMR/
  
  #If an existing project is loaded, DiMmer will directly start the DMR search.
  
  #Select an existing DiMmer project file:
  dimmer_project_path: ./dimmer_project.csv
  
  ##################### General settings ###############################
  
  #Choose how many threads should be used for parallelization:
  #Only positive integers are accepted.
  threads: 4
  
  ##################### DMR search settings ############################
  
  #Select whether the program should execute the DMR search. 
  #If false, DiMmer will terminate after the CpG permutations.
  #Accepted values: {0: false, 1: true} 
  dmr_search: 1
  
  #Select if the program should pause before the DMR search. 
  #Some of the following variables might need information from the previous results to be set properly.
  #If the pause option is set, the program will pause and let you inspect the interim results. 
  #Then you have the option to refine the variables from the next section by hand via console inputs. 
  #Accepted values: {0: false, 1: true} 
  pause: 0
  
  #Set the maximum distance between CpGs in an island:
  #Only positive integers are accepted.
  max_cpg_dist: 1000
  
  #Set the window size for the DMR search:
  #Only positive integers are accepted.
  w_size: 5
  
  #Set the number of exceptions (number of not significantly diff. methylated CpGs allowed in the window):
  #Only non-negative integers are accepted.
  n_exceptions: 2
  
  #Set the p-value cutoff (CpGs with a lower value are will be considered as significantly diff. methylated):
  #Only decimal numbers between 0 and 1 are accepted.
  p_value_cutoff: 0.05
  
  #Set the minimum mean methylation difference:
  #If T-test is selected, the minimum mean methylation difference is an additional criterium for a CpG to count as significantly diff. methylated.
  #Only decimal numbers between 0 and 1 are accepted.
  min_diff: 0.0
  
  #Select, which p-value type should be used to check the significance of the CpGs.
  #Accepted values: {1: empirical, 2: original, 3: FWER, 4: FDR, 5: minP}
  p_value_type: original
  
  #Set the number of permutations to calculate the statistical significance of the DMRs:
  #Only positive integers are accepted.
  n_permutations_dmr: 100
  
  #Set the number of random regions used to get a distribution for the p-value calculation:
  #Only positive integers are accepted.
  n_random_regions: 10000
  
  ##################### Output settings ################################
  
  #-------------------- CpG statistics ---------------------------
  
  #Select whether the result plots of the permutation tests should be saved.
  #Accepted values: {0: false, 1: true}
  save_permu_plots: 1
  
  #Accepted values: {0: false, 1: true}
  save_beta: 1
  
  #-------------------- DMR search -------------------------------
  
  #Select whether the result plots of the DMR search should be saved.
  #Accepted values: {0: false, 1: true} 
  save_search_plots: 0
  
  #Select whether the result plots of the DMR permutations should be saved (one plot for every DMR size)
  #Accepted values: {0: false, 1: true} 
  save_dmr_permu_plots: 0
  
  #Select whether the result tables of the DMR search should be saved.
  #Accepted values: {0: false, 1: true} 
  save_search_tables: 1
  "
      
      # Write the content to a .config file
      writeLines(config, con = "dimmer.config")
      command <- "java -jar dimmer.jar dimmer.config"    
      system(command)
  }
  
  
  
  for(n in 1:length(file_list)) {
    dmr_search(n)
  }
  
  
  
