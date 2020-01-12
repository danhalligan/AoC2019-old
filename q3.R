library(stringr)

logmove <- function(moves) {
    h <- character()
    i <- j <- 0
    for (m in moves) {
        d <- str_sub(m, end = 1)
        l <- as.numeric(str_sub(m, start = 2))

        if (d == "R") {
            h <- c(h, paste(i, (j + 1):(j + l)))
            j <- j + l
        } else if (d == "L") {
            h <- c(h, paste(i, (j - 1):(j - l)))
            j <- j - l
        } else if (d == "U") {
            h <- c(h, paste((i + 1):(i + l), j))
            i <- i + l
        } else if (d == "D") {
            h <- c(h, paste((i - 1):(i - l), j))
            i <- i - l
        }
    }
    h
}

x <- readLines("q3.txt")
x <- strsplit(x, ",")
h1 <- logmove(x[[1]])
h2 <- logmove(x[[2]])
cross <- h1[which(h1 %in% h2)]
cross <- sapply(strsplit(cross, " "), as.numeric)
min(colSums(abs(cross)))


x <- readLines("q3.txt")
x <- strsplit(x, ",")
h1 <- logmove(x[[1]])
h2 <- logmove(x[[2]])
candidates <- h1[which(h1 %in% h2)]
min(match(candidates, h1) + match(candidates, h2))


moves <- c("R8", "U5", "L5", "D3")
moves2 <- c("U7", "R6", "D4", "L4")

moves <- c("R75","D30","R83","U83","L12","D49","R71","U7","L72")
moves2 <-c("U62","R66","U55","R34","D71","R55","D58","R83")

moves <- c("R98","U47","R26","D63","R33","U87","L62","D20","R33","U53","R51",
moves2 <- c("U98","R91","D20","R16","D67","R40","U7","R15","U6","R7")
