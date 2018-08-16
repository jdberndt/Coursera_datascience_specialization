## makeCacheMatrix and cacheSolve work together to calculate the identity matrix of a square input matrix
## if the same value of "x" is inputed, the functions return a cached solution "m" rather than recalculating "m"

## makeCacheMatrix takes an input matrix "x" and passes a list of four functions as well as 
## two variables to the parent environment

makeCacheMatrix <- function(x = matrix()) {
                m <- NULL
                set <- function(y) {
                        x <<- y
                        m <<- NULL
                }
                get <- function() x
                setINV <- function(solve) m <<- solve
                getINV <- function() m
                list(set = set, get = get,
                     setINV = setINV,
                     getINV = getINV)
}


## cacheSolve takes the input list from makeCacheMatrix 
## it  determines whether the inverse of the matrix "x" has been solved already
## if not then it solves the inverse and stores it in the value "m"
## it returns the newly calculated or cached value of "m"

cacheSolve <- function(x, makeCacheMatrix, ...) {
        m <- x$getINV()
        if(!is.null(m)) {
                message("getting cached data")
                return(m)
        }
        data <- x$get()
        m <- solve(data, ...)
        x$setINV(m)
        m
        ## Returns a matrix that is the inverse of 'x'
}
