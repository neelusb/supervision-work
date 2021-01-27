# Unfortunately this implementation requires a list of distinct integers
# (symbols) appearing in the array in order to the functio (e.g. for array
# [1, 2, 3, 2, 1, 3, 2] we need to also pass in [1, 2, 3]) but I couldn't work
# out how to implement this in linear time without this, as any other sorting
# algorithm used to sort these distinct symbols would be at least O(nlgn).

def counting_sort(a, a_symbols):
    """BEHAVIOUR: Run the counting sort algorithm on array a with the list of
    symbols in order a_symbols, returning the sorted array

    PRECONDITION: array a contains len(a) integer values and array a_symbols
    contains every distinct value in a, in order.

    POSTCONDITION: the returned array contains the same integer values as array
    a, but they are sorted in ascending order."""

    # ASSERT: array a contains len(a) integer values

    # Count the number of occurrences of each value

    counter = {}

    for i in a:
        if i not in counter:
            counter[i] = 0
        counter[i] += 1

    # Create the next index lookup table with the initial index of each integer

    # ASSERT: a_symbols contains the same elements as the keys of counter

    next = {}
    total_so_far = 0

    for i in a_symbols:
        next[i] = total_so_far
        total_so_far += counter[i]

    # ASSERT: next has the same keys as counter

    # Sort a, putting each integer in the next place for it to go as directed
    # by the next index lookup table, and then update this table by
    # incrementing the next index of the integer by 1.

    a_sorted = [None for _ in range(len(a))]

    for i in a:
        a_sorted[next[i]] = i
        next[i] += 1

    return a_sorted


x = [3, 3, 1, 3, 2, 1, 3, 4, 1, 2, 2, 2, 3, 1, 3, 1, 4, 1, 4, 1, 1]
x_symbols = [1, 2, 3, 4]
x_sorted = counting_sort(x, x_symbols)
print(x_sorted)
