using System;
using System.Text;
using System.Security.Cryptography;


namespace kemberHash
{
    class Program
    {
        static void Main(string[] args)
        {
            
            bool isReversible=false ;
            int i = 0;
            while(!isReversible) {
                string str = random_gen(32);
                i++;
                  if (i == 10000) {
                        Console.WriteLine(str);
                         i = 0;
                       }
                string output = getMD5Hash(str);

               
                if(output == str) {
                    isReversible = true;
                        Console.WriteLine("Hurrah " + str + " is a reversible md5 hash. Profit!");
                    }
            }

        }

        static string random_gen(int length)
        {
            string c = "0123456789abcdef";
            string str = "";
            Random r = new Random();
            for(int i = 0; i<length ;i++)
            {
                str += c.Substring(r.Next(c.Length -1), 1);
            }
            return str;
        }

        static string getMD5Hash(string strToHash)
        {

            MD5CryptoServiceProvider md5Obj = new MD5CryptoServiceProvider();
            byte[] bytesToHash = System.Text.Encoding.ASCII.GetBytes(strToHash);
            bytesToHash = md5Obj.ComputeHash(bytesToHash);
            string strResult = "";
            foreach (byte b in bytesToHash)
            {
                strResult += b.ToString("x2");
            }
            return strResult;
        }

    }
}
