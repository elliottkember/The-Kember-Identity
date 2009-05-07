//
//  ThreadedKember.java
//  ThreadedKember
//
//  Created by James Raybould on 06/05/2009
//  Copyright (c) 2009 James Raybould. All rights reserved.
//
import java.util.*;
import java.security.*;

public class ThreadedKember
{

       public static void main(String[] args) {
               new ThreadedKember();
       }

       public ThreadedKember(){
               // Find how many processors we have to play with
               int getNumberOfProcessors = Runtime.getRuntime().availableProcessors();
               System.out.println("Starting run to find KemberHash using "+ getNumberOfProcessors+" threads");

               // Start as many threads as there are processors
               for (int i = 1; i<=getNumberOfProcessors ; i++) {
                       Thread t = new Thread(new kemberHash());
                       t.start();
               }

       }

}

//
//  kemberHash.java
//  kemberHash
//
//  Created by John Nye on 03/05/2009.
//      Edited by James Raybould on 06/05/2009 - Added support for multi-threading
//  Copyright (c) 2009 John Nye. All rights reserved.
//

class kemberHash implements Runnable {

       // Static random because we only need one of these
       static Random generator = new Random();
       // Static running so we can stop all threads at once
       static boolean running = true;

       public void run(){

               char[] alphabet = new char[] {'a','b','c','d','e','f','1','2','3','4','5','6','7','8','9','0'};
               int i = 0;
               char[] preHash = new char[]{'a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a'};
               int iterator = 0;
               String pre = new String();

               // Placed in a try catch because we can no longer just throw an exception
               MessageDigest postHash;
               try{
                       postHash = MessageDigest.getInstance("MD5");
               }catch (Exception e) {
                       // quits
                       System.out.println("Setup has failed, please try again");
                       e.printStackTrace();
                       return;
               }

               while(running){
                       //generate a random string
                       for (i = 0; i <= 31; i++){
                               preHash[i] = alphabet[generator.nextInt(15)];
                       }

                       pre = new String(preHash);

                       postHash.update(pre.getBytes(),0,pre.length());

                       if (pre.equals(postHash)){
                               System.out.println("WHOOP");
                               System.out.print(pre);
                               running = false;
                       }else{
                               iterator++;
                               if (iterator == 100000){
                                       System.out.println(pre);
                                       iterator = 0;
                               }

                       }

               }

       }

}

