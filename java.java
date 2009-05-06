//
//  kemberHash.java
//  kemberHash
//
//  Created by John Nye on 03/05/2009.
//  Copyright (c) 2009 John Nye. All rights reserved.
//
import java.util.*;
import java.security.*;

public class kemberHash {
    public static void main (String args[]) throws Exception{
		
		char[] alphabet =new char[] {'a','b','c','d','e','f','1','2','3','4','5','6','7','8','9','0'};
		int i = 0;
		int j = 0; 
		int pass = 0; 
		char[] preHash= new char[]{'a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a'};
		Random generator = new Random();
		int iterator = 0;
		String pre = new String();
		MessageDigest postHash = MessageDigest.getInstance("MD5");
		do{
			//generate a random string 
			for (i = 0; i <= 31; i++){
				j = 0;
				j = generator.nextInt(15);
				preHash[i] = alphabet[j];
			}
			pre = new String(preHash);
			
			postHash.update(pre.getBytes(),0,pre.length());
		
			if (pre.equals(postHash)){
				System.out.println("WHOOP");
				System.out.print(pre);
				pass = 1;
			}else{
			  iterator++;
			  if (iterator == 100000){
			    System.out.println(pre);
			    iterator = 0;
			  }
			}
		}while(pass != 1);

	}
}
