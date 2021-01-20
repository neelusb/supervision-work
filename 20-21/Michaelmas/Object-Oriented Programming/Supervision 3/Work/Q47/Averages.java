package Q47;

import java.util.Iterator;
import java.util.List;

public class Averages {
    private static double regularForLoop(List<Integer> l) {
        int sum = 0;
        for (int i = 0; i < l.size(); i++) {
            sum += l.get(i);
        }
        return ((double) sum) / l.size();
    }

    private static double forEachLoop(List<Integer> l) {
        int sum = 0;
        for (int i : l) {
            sum += i;
        }
        return ((double) sum) / l.size();
    }

    private static double iterator(List<Integer> l) {
        int sum = 0;
        Iterator<Integer> it = l.iterator();

        while (it.hasNext()) {
            sum += it.next();
        }
        return ((double) sum) / l.size();
    }

    public static void main(String[] args) {
        List<Integer> list = List.of(1, 2, 3, 4, 8, 9, 10, 12);
        double av1 = regularForLoop(list);
        double av2 = forEachLoop(list);
        double av3 = iterator(list);
        System.out.printf("%f, %f, %f", av1, av2, av3);
    }
}
