# Exercise 7

We want to find the permutation of [1, 2, 3, 4, 5, 6, 7] that causes the most fails. Let this be a b c d e f g.

We have the first element a, followed by 5 others that we want to fail, and finally the last one to succeed, so the last element is 1, the smallest. So far our required permutation is a b c d e f 1. (g = 1)

The sorter swaps a and 1, so the sorted array is 1 b c d e f a.

Now the subarray to be sorted is b c d e f a. We want the lowest to be at the end again to get the maximum number of failed comparisons, i.e. b c d e f 2. (a = 2)

The sorter swaps b and 2, so the sorted array is 1 2 c d e f b.

Now the subarray to be sorted is c d e f b. We want the last element to be the lowest again, so we get c d e f 3. (b = 3)

The sorter swaps c and 3, so the sorted array is 1 2 3 d e f c.

Now the subarray to be sorted is d e f c. Again, the lowest element is at the end, i.e. d e f 4. (c = 4).

The sorter swaps d and 4. The sorted array is now 1 2 3 4 e f d.

We repeat this process to get d = 5, e = 6 and f = 7. Therefore the total permutation is 2 3 4 5 6 7 1.