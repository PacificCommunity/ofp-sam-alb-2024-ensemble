## This Rcode calculates the ref points and 95% CIs from the ensemble models for
## Steven's TFAR work

rm(list=ls())

library(ggplot2)
library(dplyr)
library(reshape2)
library(gridExtra)
library(tidyr)
library(diags4MFCL)
library(FLR4MFCL)
library(diags4MFCL)
library(magrittr)
library(data.table)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

## read in the results from the simulations
NZ.troll.threshold <- -120
results <- read.csv(file = "../Diagnostics/Results/results_2024-08-07.csv")
bad.mods <- results %>% filter(LF.NZ.troll.Samp.14.16 >= NZ.troll.threshold |
                                 negvals != 0)
results %<>% filter(LF.NZ.troll.Samp.14.16 < NZ.troll.threshold & negvals == 0)

model_main_folder <-  "C:/StockAssessment/Albacore/2024/ensemble_models/Simulations/diag-north.WCPO.idx/"

# Check length is correct and make some names from the folder names
model_set <- c(as.character(seq(1, 100, 1)))
rep_list <- list()

for (model in model_set){
  cat("Processing model data for: ", model, "\n")
  rep_no <- "09"
  rep <- read.MFCLRep(paste(model_main_folder, model, "/plot-",rep_no,
                            ".par.rep", sep=""))
  rep_list[[model]] <- rep
}

year <- "2022"
load(file = "fishery_map.Rdata")

reffunc <- function(rep_list){
  refpts <- data.frame()
  for(model in model_set){
    rep <- rep_list[[model]]
    areas <- as.numeric(dimnames(adultBiomass(rep))$area)
    fisheries <- fishery_map[fishery_map$region %in% areas, "fishery"]
    # MSY by year (individual values are per quarter)
    msy <- MSY(rep)*4
    # fmultiplier at FMSY
    fmult <- Fmult(rep)
    # FMSY - F at MSY
    fmsy <- FMSY(rep)
    # Frecent / FMSY
    # Use aggregate F / FMSY (NDB)
    #frecent_fmsy <- c(yearMeans(seasonMeans(AggregateF(rep)[,ac(2015:2018)]))) / fmsy
    frecent_fmsy <- 1/fmult
    # SBMSY
    sbmsy <- BMSY(rep) # Adult biomass at MSY
    # Total biomass at MSY is not read in
    # SB0 - equilibrium unexploited SB
    sb0 <- c(eq_biomass(rep))[1]  # Equilibrium adult biomass at effort = 0
    # SBMSY/SB0
    sbmsy_sb0 <- sbmsy / sb0
    # SBF=0 (average 2009-2018), i.e. latest
    sbf0 <- c(SBF0(rep, lag_nyears = 1, mean_nyears = 10)[,c(year)])
    # SBMSY/SBF=0
    sbmsy_sbf0 <- sbmsy / sbf0
    # SBlatest/SB0 (SBlatest is just adultbiomass)
    sblatest <- c(SBlatest(rep)[,year])
    sblatest_sb0 <- sblatest / sb0
    # SBlatest / SBF=0
    sblatest_sbf0 <- c(SBSBF0latest(rep)[,c(year)])
    # SBlatest / SBMSY
    sblatest_sbmsy <- sblatest / sbmsy
    
    # SBrecent / SBF=0
    sbrecent_sbf0 <- c(SBSBF0recent(rep)[,c(year)])
    # SBrecent / SBMSY
    sbrecent_sbmsy <- c(SBrecent(rep)[,year]) / sbmsy
    
    outtemp <- data.frame(model=model, msy=msy, fmult=fmult,
                          fmsy=fmsy, frecent_fmsy = frecent_fmsy, sbmsy=sbmsy,
                          sb0=sb0, sbmsy_sb0 = sbmsy_sb0, sbf0=sbf0,
                          sbmsy_sbf0=sbmsy_sbf0, sblatest_sb0=sblatest_sb0,
                          sblatest_sbf0=sblatest_sbf0,
                          sblatest_sbmsy=sblatest_sbmsy,
                          sbrecent_sbf0 = sbrecent_sbf0,
                          sbrecent_sbmsy=sbrecent_sbmsy)
    
    refpts <- rbind(refpts, outtemp)
  }
  return(refpts)
}

refptsall <- reffunc(rep_list)

## combine refpts with and without estimation error
final.df <- refptsall %>% select(model, SBrec.SBF0 = sbrecent_sbf0,
                                 SBrec.SBmsy = sbrecent_sbmsy,
                                 Frec.Fmsy = frecent_fmsy) %>%
  mutate(model = as.integer(model)) %>%
  left_join(results %>% filter(CPUE == "north.WCPO") %>%
              select(model = Model, SBrec.SBF0.new = Sbrecent.SBF0, SD.depletion,
                     SBrec.SBmsy.new = SB.SBmsy, SD.SBmsy, Frec.Fmsy.new = Frecent.Fmsy,
                     CV.fmsy) %>% mutate(SD.fmsy = CV.fmsy * Frec.Fmsy.new) %>%
              mutate(SBrec.SBF0.new.min = SBrec.SBF0.new - 2 * SD.depletion,
                     SBrec.SBF0.new.max = SBrec.SBF0.new + 2 * SD.depletion,
                     SBrec.SBmsy.new.min = SBrec.SBmsy.new - 2 * SD.SBmsy,
                     SBrec.SBmsy.new.max = SBrec.SBmsy.new + 2 * SD.SBmsy,
                     Frec.Fmsy.new.min = Frec.Fmsy.new - 2 * SD.fmsy,
                     Frec.Fmsy.new.max = Frec.Fmsy.new + 2 * SD.fmsy) %>%
              select(model, SBrec.SBF0.new, SBrec.SBF0.new.min, SBrec.SBF0.new.max,
                     SBrec.SBmsy.new, SBrec.SBmsy.new.min, SBrec.SBmsy.new.max,
                     Frec.Fmsy.new, Frec.Fmsy.new.min, Frec.Fmsy.new.max))

write.csv(final.df, file = "../ALB.2024.model.ensemble.outcomes.csv",
          row.names = F)
