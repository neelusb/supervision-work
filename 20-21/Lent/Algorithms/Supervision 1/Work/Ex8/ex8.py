def binary_insert_sort(a):
    """BEHAVIOUR: Run the binary insertsort algorithm on array a, sorting it in
    place.

    PRECONDITION: array a contains len(a) integer values

    POSTCONDITION: array a contains the same integer values as before, but now
    they are sorted in ascending order."""

    for k in range(1, len(a)):

        # ASSERT: the array positions before a[k] are already sorted

        # Use binary partitioning of a[0:k] to figure out where to insert a[k]
        # within the sorted region

        # BEGIN BINARY PARTITIONING PORTION

        lower_i = 0
        upper_i = k
        i = 0

        while lower_i != upper_i:  # while lower and upper bounds are not equal
            i = int((lower_i + upper_i) / 2)
            if a[i] < a[k]:
                lower_i = i + 1  # a[k] goes to the right
            else:
                upper_i = i  # a[k] goes to the left

        # END BINARY PARTITIONING PORTION

        # ASSERT: the place of a[k] is i, i.e. between a[i-1] and a[i]

        # Put a[k] in position i, i.e. right shift by one every other item in
        # a[i:k], unless it is already there

        if i != k:
            tmp = a[k]
            for tmp_j in range(i - 1, k - 1):
                j = i + k - 2 - tmp_j
                a[j + 1] = a[j]
            a[i] = tmp


x = [7, 3, -2, 11, 14, -8, 0, 77, 2, 63, 102, 2]
binary_insert_sort(x)
print(x)
