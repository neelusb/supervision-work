package Q51;

import java.util.*;

public class StudentMarks {
    private Map<String, Integer> marks;

    StudentMarks(Map<String, Integer> marks) {
        this.marks = marks;
    }

    public List<String> students() {
        List<String> list = new ArrayList<>(this.marks.keySet());
        Collections.sort(list);
        return list;
    }

    public List<String> top(int p) {
        LinkedHashMap<String, Integer> sortedMarks = new LinkedHashMap<>();
        this.marks.entrySet().stream().sorted(Map.Entry.comparingByValue()).forEachOrdered(x -> sortedMarks.put(x.getKey(), x.getValue()));
        List<String> list = new ArrayList<>(sortedMarks.keySet());
        Collections.reverse(list);
        return list.subList(0, (p * list.size() / 100));
    }

    public double median() {
        List<Integer> list = new ArrayList<>(this.marks.values());
        Collections.sort(list);
        if (list.size() % 2 == 1) return list.get(list.size() / 2);
        return (list.get(list.size() / 2) + list.get(list.size() / 2 - 1)) / 2;
    }

    public static void main(String[] args) {
        HashMap<String, Integer> students = new HashMap<>();

        students.put("A", 45);
        students.put("B", 35);
        students.put("C", 100);
        students.put("D", 80);
        students.put("E", 40);
        students.put("F", 75);
        students.put("G", 90);
        students.put("H", 95);
        students.put("I", 20);
        students.put("J", 35);
        students.put("K", 100);

        StudentMarks marks = new StudentMarks(students);

        List<String> allStudents = marks.students();
        List<String> top20Percent = marks.top(20);
        List<String> top50Percent = marks.top(50);
        double median = marks.median();

        System.out.println(allStudents);
        System.out.println(top20Percent);
        System.out.println(top50Percent);
        System.out.printf("Median: %f", median);
    }
}
