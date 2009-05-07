using System;
using System.Security.Cryptography;

namespace KemberIdentity
{
    class Program
    {
        static void Main()
        {
            Int32 longestMatchLength = 0;
            Byte[] longestMatchOriginal = new Byte[16];
            Byte[] longestMatchHash = new Byte[16];

            Byte[] original = new Byte[16];
            Byte[] hash;

            MD5 md5 = MD5.Create();
            Random random = new Random();

            while (true)
            {
                for (Int32 i = 0; i < 16; i++)
                {
                    original[i] = (Byte)random.Next(0, 255);
                }

                hash = md5.ComputeHash(original);

                for (Int32 i = 0; i < 16; i++)
                {
                    if (original[i] != hash[i])
                        break;

                    if (i + 1 > longestMatchLength)
                    {
                        longestMatchLength = i + 1;

                        System.Console.WriteLine("Longest match: {0} bytes", longestMatchLength);
                        System.Console.WriteLine("    Original: {0}", BitConverter.ToString(original));
                        System.Console.WriteLine("    Hash:     {0}", BitConverter.ToString(hash));
                        System.Console.WriteLine();

                        if (longestMatchLength == 16)
                        {
                            System.Console.WriteLine("*** EXECUTION COMPLETE!");
                            System.Console.WriteLine("*** Write down the number, then press any key to quit.");
                            System.Console.ReadKey();
                            return;
                        }
                    }
                }
            }
        }
    }
}


