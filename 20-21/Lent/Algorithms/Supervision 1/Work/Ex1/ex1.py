def insert_sort(a):
    """BEHAVIOUR: Run the insertsort algorithm on list a, sorting it in place.

    PRECONDITION: list a contains len(a) integer values.

    POSTCONDITION: returns the same integer values as in array a, but now they are sorted in ascending order.
    """

    for i in range(1, len(a)):
        # ASSERT: the first i positions are already sorted

        # Insert a[i] where it belongs within a[0:i]
        j = i - 1
        current = a[i]

        while j >= 0 and a[j] > current:
            j = j - 1
        
        a[j + 2:i + 1] = a[j + 1:i]
        a[j + 1] = current

    return a


print(insert_sort([3,7,6,4,8,9,2]))
