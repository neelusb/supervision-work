# Exercise 0

There are nC0 (n choose 0) subsequences of length 0 of a string of length n (just an empty string). There are nC1 subsequences of length 1 of a string of length n. For any integer 0 <= k <= n, there are nCk subsequences of length k of a string of length n.

The total number of subsequences of a string of length n is is therefore nC0 + nC1 + ... + nCn.

Therefore the total number of comparisons is (mC0 + mC1 + ... + mCm)(nC0 + nC1 + ... + nCn).