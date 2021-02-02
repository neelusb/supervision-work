def fibonacci(n):
    if n < 2:
        return 1
    return fibonacci(n - 1) + fibonacci(n - 2)

# For fibonacci(2), this program does:
# => fibonacci(1) = 1 recursive call
# => fibonacci(0) = 1 recursive call
# i.e. 2 recursive calls, 3 calls in total
#
# For fibonacci(3), this program does:
# => fibonacci(2) = 3 recursive calls
# => fibonacci(1) = 1 recursive call
# i.e. 4 recursive calls, 5 calls in total
#
# For fibonacci(4), it does:
# => fibonacci(3) = 5 recursive calls
# => fibonacci(2) = 3 recursive calls
# i.e. 8 recursive calls, 9 calls in total
#
# For fibonacci(5), it does:
# => fibonacci(4) = 9 recursive calls
# => fibonacci(3) = 5 recursive calls
# i.e. 14 recursive calls, 15 calls in total
#
# For fibonacci(6), it does:
# => fibonacci(5) = 15 recursive calls
# => fibonacci(4) = 9 recursive calls
# i.e. 24 recursive calls, 25 calls in total


# Let c(n) be the number of calls fibonacci(n) does. c(0) and c(1) = 1 as they
# don't recurse. For n > 2, c(n) = c(n-1) + c(n-2) + 1. This is a recurrence
# relation very similar to the fibonacci sequences, which is
# f(n) = f(n-1) + f(n-2), and we can write out the sequence or write a dynamic
# programming function to work this out and tell us the number of calls.

def fib_calls(n):
    if n < 2:
        result = 1
    else:
        c1 = 1
        c2 = 1
        c3 = None
        for i in range(1, n):
            c3 = c1 + c2 + 1
            c1 = c2
            c2 = c3
        result = c3
        return result


print(fib_calls(10))
print(fib_calls(20))
print(fib_calls(30))

# We can run this for n = 10, 20, and 30. We get that running fibonacci(10)
# makes 177 function calls, fibonacci(20) 21891 function calls, and
# fibonacci(30) 2692537 function calls.

# We can verify this by modifying our fibonacci() function to count the number
# of calls it makes.


def fibonacci_count(n, counter):
    counter += 1
    if n < 2:
        return 1, counter
    f1, counter = fibonacci_count(n - 1, counter)
    f2, counter = fibonacci_count(n - 2, counter)
    f = f1 + f2
    return f, counter


print(fibonacci_count(10, 0))
print(fibonacci_count(20, 0))
print(fibonacci_count(30, 0))

# And this matches what we were expecting.
