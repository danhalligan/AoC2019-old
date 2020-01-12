fuel <- function(mass) floor(mass/3) - 2

x <- read.table("q1_mass.txt")[, 1]
sum(fuel(x))


fuel <- function(mass) {
    x <- floor(mass/3) - 2
    ifelse(x > 0, x, 0)
}

s <- rep(0, length(x))
y <- x
while(any(y != 0)) {
    y <- fuel(y)
    s <- s + y
    print(y[1])
}
sum(s)



