x <- strsplit(readLines("8.txt")[1], "")[[1]]
x <- as.numeric(x)

arr <- array(x, dim = c(25, 6, 100))
layer <- which.min(apply(arr, 3, function(v) sum(v == 0)))
layer <- arr[, , layer]
sum(layer == 1) * sum(layer == 2)

layers <- asplit(arr, 3)
out <- t(Reduce(function(a, b) ifelse(a == 2, b, a), layers))
view <- function(v) paste(ifelse(v, "█", " "), collapse = "")
cat(paste(apply(out, 1, view), collapse = "\n"), "\n")
