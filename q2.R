

run_prog <- function(p) {
    run_opcode <- function(x) {
        if (!(x[1] %in% c(1, 2, 99))) {
            stop("Error!")
        } else if (x[1] == 1) {
            p[x[4]+1] <<- p[x[2]+1] + p[x[3]+1] # add numbers and store
        } else if (x[1] == 2) {
            p[x[4]+1] <<- p[x[2]+1] * p[x[3]+1] # multiply numbers and store
        }
    }
    i <- 1
    while (i < length(p)) {
        if (p[i] == 99) break()
        o <- run_opcode(p[i:c(i+3)])
        i <- i + 4
    }
    return(p)
}

p <- c(1,9,10,3,2,3,11,0,99,30,40,50)
run_prog(p)

run_prog(c(1,0,0,0,99))
run_prog(c(2,3,0,3,99))
run_prog(c(2,4,4,5,99,0))
run_prog(c(1,1,1,4,99,5,6,0,99))

p <- as.numeric(strsplit(readLines("q2.txt"), ",")[[1]])
p[2] <- 12
p[3] <- 2
run_prog(p)[1]

sp <- as.numeric(strsplit(readLines("q2.txt"), ",")[[1]])
for (i in 0:99) {
    for (j in 0:99) {
        p <- sp
        p[2] <- i
        p[3] <- j
        if (run_prog(p)[1] == 19690720) {
            print(100 * i + j)
        }
    }
}





