valid <- function(x) {
    x <- as.numeric(strsplit(as.character(x), "")[[1]])
    all(sort(x) == x) && any(x[-1] == x[-length(x)])
}

valid(111111)
valid(223450)
valid(123789)

s <- 0
for (i in 246540:787419) s <- s + valid(i)



valid <- function(x) {
    x <- as.numeric(strsplit(as.character(x), "")[[1]])
    all(sort(x) == x) && any(rle(x)$lengths == 2)
}
valid(112233)
valid(123444)
valid(111122)

s <- 0
for (i in 246540:787419) s <- s + valid(i)
