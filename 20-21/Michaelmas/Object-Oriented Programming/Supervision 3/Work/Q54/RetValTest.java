package Q54;

class EmptySentenceException extends Exception {}
class NoCamEmailFoundException extends Exception {}

public class RetValTest {
    public static String extractCamEmail(String sentence) throws EmptySentenceException, NoCamEmailFoundException {
        if (sentence == null || sentence.length() == 0) throw new EmptySentenceException();

        String tokens[] = sentence.split(" "); // split into tokens
        for (int i = 0; i < tokens.length; i++) {
            if (tokens[i].endsWith("@cam.ac.uk")) {
                return tokens[i];
            }
        }

        throw new NoCamEmailFoundException();
    }

    public static void main(String[] args) {
        try {
            String ret = RetValTest.extractCamEmail("My email is rkh23@cam.ac.uk");
//            String ret = RetValTest.extractCamEmail("jkfdjkhdsfjkhdsf");
//            String ret = RetValTest.extractCamEmail("");
            System.out.println("Success: " + ret);
        } catch (EmptySentenceException e) {
            System.out.println("Supplied string empty");
        } catch (NoCamEmailFoundException e) {
            System.out.println("No @cam address in supplied string");
        }
    }
}
