package Q52;

public class Car2 extends Car implements Comparable<Car> {

    Car2(String manufacturer, int age) {
        super(manufacturer, age);
    }

    @Override
    public int compareTo(Car c) {
        if (this.getManufacturer().compareToIgnoreCase(c.getManufacturer()) < 0) return 1;
        if (this.getManufacturer().compareToIgnoreCase(c.getManufacturer()) > 0) return -1;
        if (this.getAge() > c.getAge()) return 1;
        if (this.getAge() < c.getAge()) return -1;
        return 0;
    }
}
