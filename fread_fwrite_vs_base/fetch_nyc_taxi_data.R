# Fetch NYC taxi data from AWS S3 to subdirectory data/
# Timo Voipio, Solita Oy, 2018-03-02

library(curl)
library(assertthat)
library(logging)

basicConfig()

out.dir <- "data"

common.path <- "https://s3.amazonaws.com/nyc-tlc/trip+data/"
filenames <- sprintf("yellow_tripdata_2017-%02d.csv", 1:6)

assert_that(dir.exists(out.dir))

res <- vapply(filenames,
              function(x) {
                loginfo("Starting to download %s", x)
                curl.res <-
                  curl_download(paste0(common.path, x),
                                file.path(out.dir, x),
                                quiet = !interactive())
                loginfo("Downloaded to %s", file.path(out.dir, x))
                return(curl.res)
                },
              "")

loginfo("Done!")
