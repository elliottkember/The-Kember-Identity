/// <summary>
/// A Kember Identity Hash script in C#
/// by Jaco Pretorius
/// </summary>

using System;
using System.Security.Cryptography;
using System.Text;

namespace KemberIdentity
{
    class Program
    {
        static void Main()
        {
            var hexadecimal = new[] { 'a', 'b', 'c', 'd', 'e', 'f', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0' };
            var hash = new byte[32];

            var md5 = MD5.Create();
            var random = new Random();

            var finished = false;
            while (!finished)
            {
                // Fill the hash with a random hexadecmial string
                for (int i = 0; i < 32; i++)
                {
                    hash[i] = (byte) hexadecimal[random.Next(0, hexadecimal.Length)];
                }

                var before = Encoding.ASCII.GetString(hash);
                var after = Encoding.ASCII.GetString(md5.ComputeHash(hash));

                finished = before == after;
            }

            Console.WriteLine("The Kember Identity Hash is {0}", Encoding.ASCII.GetString(hash));
        }
    }
}
