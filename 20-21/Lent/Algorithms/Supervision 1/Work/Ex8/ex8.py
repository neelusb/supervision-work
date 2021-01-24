def binary_insert_sort(a):
    for k in range(1, len(a)):

        # BEGIN BINARY PARTITIONING PORTION

        lower_i = 0
        upper_i = k
        i = 0

        while lower_i != upper_i: # while lower and upper bounds are not the same
            i = int((lower_i + upper_i) / 2)
            if a[i] < a[k]:
                lower_i = i + 1 # a[k] goes to the right
            else:
                upper_i = i # a[k] goes to the left
        
        # END BINARY PARTITIONING PORTION

        if i != k:
            tmp = a[k]
            for tmp_j in range(i - 1, k - 1):
                j = i + k - 2 - tmp_j
                a[j + 1] = a[j]
            a[i] = tmp
    
    return a


x = [7,3,-2,11,14,-8,0,77,2,63,102, 2]
# x = [3,2,1,4]

print(binary_insert_sort(x))        