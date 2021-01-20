package Q53;

import Q50.Point;

import java.io.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;

class Pair implements Comparable<Pair> {
    private int x;
    private int y;

    Pair(int x, int y) {
        this.x = x;
        this.y = y;
    }

    public int getX() {
        return this.x;
    }

    public int getY() {
        return this.y;
    }

    public int compareTo(Pair p) {
        if (this.x > p.x) return 1;
        if (this.x < p.x) return -1;
        if (this.y > p.y) return 1;
        if (this.y < p.y) return -1;
        return 0;
    }

    public String toString() {
        return String.format("(%d, %d)", this.x, this.y);
    }
}

public class SortNumbers {
    public static void main(String[] args) {
        try (BufferedReader br =
                     new BufferedReader(new FileReader("Q53/numbers.txt"))) {
            String line = br.readLine();

            List<Pair> list = new ArrayList<>();

            while (line != null) {
                line = line.replaceAll(" ", "");
                if (line == "") continue;

                String[] numbers = line.split(",");
                int num1 = Integer.parseInt(numbers[0]);
                int num2 = Integer.parseInt(numbers[1]);
                Pair pair = new Pair(num1, num2);
                list.add(pair);

                line = br.readLine();
            }

            List<Pair> sortedList = list.stream().sorted().collect(Collectors.toList());

            for (Pair pair : sortedList) {
                System.out.printf("%d, %d\n", pair.getX(), pair.getY());
            }


        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}
