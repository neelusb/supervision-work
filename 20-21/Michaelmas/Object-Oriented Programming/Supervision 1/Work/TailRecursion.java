public class TailRecursion {
    public static long recursiveFactorial (int n) {
        if (n == 0) {
            return 1;
        }
        return n * recursiveFactorial(n - 1);
    }

    public static long tailRecursiveFactorial(int n, long acc) {
        if (n == 0) {
            return acc;
        }
        return tailRecursiveFactorial(n - 1, n * acc);
    }

    public static long compare(int n) {
        long recursiveStartTime = System.nanoTime();
        long recursiveTwentyFact = recursiveFactorial(n);
        long recursiveEndTime = System.nanoTime();
        long recursiveTime = recursiveEndTime - recursiveStartTime;

        long tailRecursiveStartTime = System.nanoTime();
        long tailRecursiveTwentyFact = tailRecursiveFactorial(n, 1);
        long tailRecursiveEndTime = System.nanoTime();
        long tailRecursiveTime = tailRecursiveEndTime - tailRecursiveStartTime;

        return recursiveTime - tailRecursiveTime;
    }

    public static void main(String[] args) {
        for (int i = 0; i < 50; i++) {
            System.out.printf("%d!: %d difference", i, compare(i));
            System.out.println();
        }
    }
}