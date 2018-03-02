# Wrapper functions for fwrite to emulate write.csv and write.table
# Timo Voipio, Solita Oy
# 2018-03-02

library(data.table)
library(assertthat)

# Wrapper for data.table::fwrite, emulates write.csv
fwrite.write.csv <- function(x, file = "", quote = TRUE,
                             sep = ",", na = "NA",
                             dec = ".",
                             row.names = TRUE,
                             col.names = if (isTRUE(row.names)) NA else TRUE,
                             qmethod = c("double"),
                             showProgress = interactive(),
                             ...) {
  
  # Match quote method: match.arg enforces that it is "double" (like write.csv)
  qmethod.matched <- match.arg(qmethod)
  
  # write.csv enforces that the separator is ",", therefore so do we
  if (sep != ",") {
    warning("attempted to set 'sep' to '",
            sep,
            "' - using ',' as separator like in write.csv (use (fwrite.)write.table if you need to customize the separator)")
    sep <- ","
  }
  
  fwrite(x,
         file = file,
         quote = quote,
         sep = sep,
         na = na,
         row.names = row.names,
         col.names = col.names,
         qmethod = qmethod.matched,
         showProgress = showProgress,
         ...)
}

# Wrapper for data.table::fwrite, emulates write.table
write.table.wrap <- function(x, file = "", quote = TRUE,
                               sep = " ", na = "NA",
                               row.names = TRUE,
                               col.names = TRUE,
                               qmethod = c("escape", "double"),
                               showProgress = interactive(),
                               ...) {

  # Match quote method: match.arg enforces that it is either
  # "escape" (default) or "double" (like write.csv)
  qmethod.matched <- match.arg(qmethod)
  
  fwrite(x,
         file = file,
         quote = quote,
         sep = sep,
         na = na,
         row.names = row.names,
         col.names = col.names,
         qmethod = qmethod,
         showProgress = showProgress,
         ...)
}


