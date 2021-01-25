def merge_sort(a):
    """BEHAVIOUR: Run the mergesort algorithm on the integer array a,
    returning a sorted version of the array as the result.

    PRECONDITION: array a contains len(a) integer values.

    POSTCONDITION: a new array is returned that contains the same integer
    values originally in a, but sorted in ascending order."""

    if len(a) < 2:
        # ASSERT: a is already sorted, so return it as is
        return a

    # Split array a into two smaller arrays a1 and a2
    # and sort these recursively
    h = int(len(a) / 2)
    a1 = merge_sort(a[0:h])
    a2 = merge_sort(a[h:])

    # Form a new array a3 by merging a1 and a2
    a3 = [None for _ in range(len(a))]
    i1 = 0  # index into a1
    i2 = 0  # index into a2
    i3 = 0  # index into a3
    while i1 < len(a1) or i2 < len(a2):
        # ASSERT: i3 < len(a3)
        if i1 == len(a1):
            array_to_add_from = 2
        elif i2 == len(a2):
            array_to_add_from = 1
        else:
            array_to_add_from = 1 if a1[i1] < a2[i2] else 2
            a3[i3] = min(a1[i1], a2[i2])  # updates i1 or i2 too

        if array_to_add_from == 1:
            a3[i3] = a1[i1]
            i1 += 1
        elif array_to_add_from == 2:
            a3[i3] = a2[i2]
            i2 += 1

        i3 += 1

    # ASSERT: i3 == len(a3)
    return a3


x = [7, 3, -2, 11, 14, -8, 0, 77, 2, 63, 102, 2]
print(merge_sort(x))
