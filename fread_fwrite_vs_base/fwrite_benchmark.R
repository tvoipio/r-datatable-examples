# Benchmark reading and writing tabular data using base R and data.table

library(data.table)
library(microbenchmark)
library(assertthat)
#library(logging)
library(fasttime)
library(lubridate)
library(microbenchmark)

source("fwrite_wrappers.R")

in.dir <- "data"
# TODO: write script to ensure out.dir is on tmpfs or similar
out.dir <- file.path("data", "out")

in.file <- file.path(in.dir, "yellow_tripdata_2017_h1.csv")

out.filenames <- c(fwrite = "yellow_tripdata_2017_h1_fwrite.csv",
                   write.table = "yellow_tripdata_2017_h1_write_table.csv",
                   stats = "yellow_tripdata_2017_h1_stats.rds")

# Sample input data
# Inputs:
#  dt: data.table with data
#  seed: optional random seed for sampling
SampleData <- function(dt, sample.size = ceiling(0.01*nrow(dt)), seed) {
  
  assert_that(is.data.table(dt))
  
  if (!missing(seed)) {
    assert_that(is.numeric(seed))
    set.seed(seed)
  }
  
  sample.rows <- sample.int(nrow(dt), sample.size)
  
  data.sampled <- dt[sample.rows]
}


# Data processing; essentially, convert columns named in
# `cols.to.factor` into factor variables
ProcessData <- function(dt, cols.to.factor, cols.to.datetime, tz = "EST") {
  assert_that(is.data.table(dt))
  
  assert_that(is.character(cols.to.factor))
  assert_that(all(cols.to.factor %in% colnames(dt)))
  
  # Conversion to factors
  dt[, c(cols.to.factor) :=
       lapply(.SD, as.factor),
     .SDcols = cols.to.factor]
  
  # Conversion of datetimes to POSIXct
  dt[, c(cols.to.datetime) :=
       lapply(.SD, fastPOSIXct, tz = "UTC", required.components = 6L),
     .SDcols = cols.to.datetime]
  
  # fastPOSIXct always assumes that the times are in GMT/UTC,
  # so we force them into the correct tz
  dt[, c(cols.to.datetime) :=
       lapply(.SD, force_tz, tzone = "EST"),
     .SDcols = cols.to.datetime]
  
  invisible(dt)
}

# TODO: actual benchmark code here

