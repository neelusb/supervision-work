import math


def bottom_up_merge_sort(a):
    """BEHAVIOUR: Run the bottom-up variant of the mergesort algorithm on the
    integer array a, returning a sorted version of the array as the result.

    PRECONDITION: array a contains len(a) integer values.

    POSTCONDITION: a new array is returned that contains the same integer
    values originally in a, but sorted in ascending order."""

    for i in range(math.ceil(math.log(len(a), 2))):
        a_s = [None for _ in range(len(a))]
        j = 0
        group_size = 2 ** i

        k1 = 0  # index for first subarray
        k2 = group_size  # index for second subarray
        k1_end = group_size  # the array index at which the first subarray ends
        k2_end = min(k2 + group_size, len(a))  # the array index at which the
        # second subarray ends

        for j in range(len(a)):
            array_to_add_from = None  # the subarray to add from
            if k1 == k1_end and k2 == k2_end:
                # if the ends of both subarrays have been reached, set the new
                # subarray boundaries
                k1_end = min(k2 + group_size, len(a))
                k2_end = min(k2 + 2 * group_size, len(a))
                k1 = k2
                k2 = k1_end

            if k1 == k1_end:
                array_to_add_from = 2
            elif k2 == k2_end:
                array_to_add_from = 1
            elif a[k1] < a[k2]:
                array_to_add_from = 1
            else:
                array_to_add_from = 2

            if array_to_add_from == 1:
                a_s[j] = a[k1]
                k1 += 1
            elif array_to_add_from == 2:
                a_s[j] = a[k2]
                k2 += 1

        a = a_s

    return a


x = [7, 3, -2, 11, 14, -8, 0, 77, 2, 63, 102, 2]
print(bottom_up_merge_sort(x))
