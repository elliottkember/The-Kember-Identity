//
//  ParallelKemberHash.java
//
//  Created by John Nye on 03/05/2009.
//  Copyright (c) 2009 John Nye. All rights reserved.
//
//  Updated by Trevor Blanarik on 5/7/2009
//  Requires Parallel Java Library http://www.cs.rit.edu/~ark/pj.shtml#download
//  to be in your classpath.
//

import edu.rit.pj.ParallelRegion;
import edu.rit.pj.ParallelTeam;
import java.util.*;
import java.security.*;

public class ParallelKemberHash {

    public static void main(String args[]) throws Exception {

        new ParallelTeam().execute(new ParallelRegion() {
            public void run() throws NoSuchAlgorithmException {
                char[] alphabet = new char[]{'a', 'b', 'c', 'd', 'e', 'f', '1',
                '2', '3', '4', '5', '6', '7', '8', '9', '0'};
                int i = 0;
                int j = 0;
                int pass = 0;
                char[] preHash = new char[]{'a', 'a', 'a', 'a', 'a', 'a', 'a',
                'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a',
                'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a',
                'a'};
                Random generator = new Random();
                int iterator = 0;
                String pre = new String();
                MessageDigest postHash = MessageDigest.getInstance("MD5");
                do {
                    //generate a random string
                    for (i = 0; i <= 31; i++) {
                        j = 0;
                        j = generator.nextInt(15);
                        preHash[i] = alphabet[j];
                    }
                    pre = new String(preHash);

                    postHash.update(pre.getBytes(), 0, pre.length());

                     byte messageDigest[] = postHash.digest();
                     StringBuffer hexString = new StringBuffer();
                     for (int m=0; m < messageDigest.length; m++) {
                     hexString.append(Integer.toHexString(0xFF
                             & messageDigest[m]));
                      }

                   if(pre.equals(hexString.toString())){
                        System.out.println("Found it!");
                        System.out.print(pre);
                        pass = 1;
                    } else {
                        iterator++;
                        if (iterator == 100000) {
                            System.out.println("previous version is: " + pre);
                            System.out.println("md5 version is: "
                                    + hexString.toString());
                            iterator = 0;
                        }
                    }
                } while (pass != 1);
            }

        });

    }
}
