using System;
using System.Text;
using System.Security.Cryptography;

namespace HashIdentityString
{
    class Program
    {
        static void Main(string[] args)
        {
            int seed;

            if (args.Length != 1 ||  false == int.TryParse(args[0], out seed))
            {
                seed = 0;
            }

            Console.WriteLine("Initial seed: {0}", seed);

            while (true)
            {
                string testee = check(seed);
                seed++;

                if (seed%100000 == 0)
                {
                    Console.WriteLine("Current seed: {0}, '{1}'", seed, testee);
                }
            }
        }

        static string check(int seed)
        {
            string testee = getTestee(seed);

            byte[] tmpSource = ASCIIEncoding.ASCII.GetBytes(testee);
            byte[] tmpHash = new MD5CryptoServiceProvider().ComputeHash(tmpSource);
            string hashString = bytesToHex(tmpHash);

            if (hashString == testee)
            {
                Console.WriteLine("Match found for seed {0} = '{1}' => '{2}'", seed, testee, hashString);
                Console.ReadLine();
            }

            return testee;
        }

        static string getTestee(int seed)
        {
            string alphabet = "0123456789abcdef";

            Random r = new Random(seed);
            StringBuilder sb = new StringBuilder();

            int length = 32;

            for (int i = 0; i < length; i++)
            {
                int charNum = r.Next(alphabet.Length);
                sb.Append(alphabet[charNum]);
            }

            return sb.ToString();
        }

        static string bytesToHex(byte[] bytes)
        {
            StringBuilder sb = new StringBuilder();

            foreach (byte b in bytes)
            {
                sb.AppendFormat("{0:x2}", b);
            }

            return sb.ToString();
        }

    }
}