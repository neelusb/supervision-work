package Q55;

class InvalidIterationsException extends Exception {}
class NegativeNumberException extends Exception {}

public class SquareRoot {
    static double newtonRaphson(double num, double guess, int i) throws InvalidIterationsException, NegativeNumberException {
        if (i < 0) throw new InvalidIterationsException();
        if (num < 0) throw new NegativeNumberException();
        if (i == 0) return Math.abs(guess);
        double newGuess = guess - (guess * guess - num) / (guess * 2);
        return newtonRaphson(num, newGuess, i - 1);
    }

    static void printSqrt(double num, int i) {
        try {
            System.out.println(newtonRaphson(num, num / 2, i));
        } catch (InvalidIterationsException e) {
            System.out.println("Number of iterations must be non-negative.");
        } catch (NegativeNumberException e) {
            System.out.println("Number to compute the square root of must be non-negative.");
        }
    }

    public static void main(String[] args) {
        printSqrt(120, 3);
        printSqrt(120, 10);
        printSqrt(23.22, 2);
        printSqrt(23.22, 10);
        printSqrt(23.22, -4);
        printSqrt(-5, 10);
    }
}
