public class Kember {
    public static void main(String[] args) throws Exception {
        java.util.Random generator = new java.util.Random(System.currentTimeMillis());
        java.security.MessageDigest digest = java.security.MessageDigest.getInstance("MD5");
        while (true) {
            String test = Long.toHexString(Math.abs((long) (generator.nextDouble() * (2L^33L))));
            if (test.equals(digest.digest(test.getBytes()))) {
                System.out.println("WINNER WINNER CHICKEN DINNER: " + test);
                break;
            }
        }
    }    
}
