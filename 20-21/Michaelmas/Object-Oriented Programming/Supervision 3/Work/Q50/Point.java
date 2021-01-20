package Q50;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Point implements Comparable<Point> {
  private final double x;
  private final double y;
  private final double z;

  public Point(double x, double y, double z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  public Point() {
    this.x = 0.0;
    this.y = 0.0;
    this.z = 0.0;
  }

  public double getX() {
    return this.x;
  }

  public double getY() {
    return this.y;
  }

  public double getZ() {
    return this.z;
  }

  public int compareTo(Point p) {
    if (this.z > p.z) return 1;
    if (this.z < p.z) return -1;
    if (this.y > p.y) return 1;
    if (this.y < p.y) return -1;
    if (this.x > p.x) return 1;
    if (this.x < p.x) return -1;
    return 0;
  }

  public String toString() {
    return String.format("Point(%f, %f, %f)", this.x, this.y, this.z);
  }

  public static void main(String[] args) {
    Point p1 = new Point(1, 2, 3);
    Point p2 = new Point(1, 2, 4);
    Point p3 = new Point(1, 3, 3);
    Point p4 = new Point(2, 2, 3);
    Point p5 = new Point();
    List<Point> list = new ArrayList<>(List.of(p1, p2, p3, p4, p5));
    System.out.println(list);
    Collections.sort(list);
    System.out.println(list);
  }
}
