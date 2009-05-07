package com.altuscorp.tests;

import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.util.Date;

public class CalcHash implements Runnable {
       public CalcHash(BigInteger start, BigInteger stop, String threadId) throws Exception {
               if (start.compareTo(stop) == 1) {
                       throw new Exception("Start value must be less than stop value");
               }
               this.start = start;
               this.stop = stop;
               this.count = start;
               this.threadId = threadId;
       }
       private BigInteger start;
       private BigInteger stop;
       private BigInteger count;
       private Long startTime;
       private Long endTime;
       private String threadId;
       static final byte[] HEX_CHAR_TABLE = {
               (byte)'0', (byte)'1', (byte)'2', (byte)'3',
               (byte)'4', (byte)'5', (byte)'6', (byte)'7',
               (byte)'8', (byte)'9', (byte)'a', (byte)'b',
               (byte)'c', (byte)'d', (byte)'e', (byte)'f'
       };

       public static String getHexString(byte[] raw) throws UnsupportedEncodingException {
               byte[] hex = new byte[2 * raw.length];
               int index = 0;

               for (byte b : raw) {
                       int v = b & 0xFF;
                       hex[index++] = HEX_CHAR_TABLE[v >>> 4];
                       hex[index++] = HEX_CHAR_TABLE[v & 0xF];
               }
               return new String(hex, "ASCII");
       }
       public void run() {
               Thread.currentThread().setName("CalcThread"+this.threadId);
               this.startTime = System.currentTimeMillis();
               System.out.println(Thread.currentThread().getName() + " Start Value: " + this.start + "\tStop Value: " + this.stop
                               + "\n" +Thread.currentThread().getName() + " Total nums to be calculated: " + this.stop.subtract(this.start) +
                               "\n"+Thread.currentThread().getName() + " Beginning processing at: " + new Date(this.startTime));
               try {
                       int pass = 0;
                       MessageDigest hash = MessageDigest.getInstance("MD5");
                       do{
                               hash.update(count.byteValue());
                               byte[] md = hash.digest();
                               if (count.toString(16).equals(getHexString(md))) {
                                       this.endTime = System.currentTimeMillis();
                                       System.out.println(Thread.currentThread().getName() + " WHOOP!");
                                       System.out.println(count + " == " + count.toString(16) + " == (hash)" + getHexString(md));
                                       pass = 1;
                               } else if (count.toString(16).length() > 32) {
                                       this.endTime = System.currentTimeMillis();
                                       System.out.println(Thread.currentThread().getName() + " String not found in group");
                               } else if (this.count.compareTo(this.stop) == 1) {
                                       this.endTime = System.currentTimeMillis();
                                       System.out.println(Thread.currentThread().getName() + " String not found in group");
                                       pass = 1;
                               } else {
                                       //System.out.println(count + " == " + count.toString(16) + " != (hash)" + getHexString(md));
                                       count = count.add(BigInteger.ONE);
                               }
                       }while(pass != 1);
                       System.out.println(Thread.currentThread().getName() + " Processing Finished at: " + new Date(this.endTime) + "\tTotal processing time: " + (this.endTime-this.startTime)+"ms");
               } catch (Exception e) {
                       System.err.println("Exception caught while processing thread: " + Thread.currentThread().getName());
                       e.printStackTrace();
               }
       }
}

