public class LowestCommon {
  public static int lowestCommon(long a, long b) {
    int lowestCommon = -1;
    for (int i = 0; i < 64; i++) {
      if ((a & 1L) == (b & 1L)) {
        lowestCommon = i;
        break;
      }
      a = a >>> 1;
      b = b >>> 1;
    }
    return lowestCommon;
  }

  public static void main(String[] args) {
    System.out.println(lowestCommon(14, 25)); // expecting 3
    System.out.println(lowestCommon(0, 1)); // expecting 1
    System.out.println(lowestCommon(0, -1)); // expecting -1
  }
}
