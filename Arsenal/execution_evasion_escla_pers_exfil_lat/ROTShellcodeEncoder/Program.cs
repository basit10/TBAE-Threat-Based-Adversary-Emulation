using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp2
{
    class Program
    {
        static void Main(string[] args)
        {
 
            byte[] buf = new byte[] {};

            if (args.Length == 0)
            {
                System.Console.WriteLine("Numeric argument for the number of rotations.");
                return;
            }

            int rotNo = int.Parse(args[0]);

            // Encode the payload with rotation
            byte[] encoded = new byte[buf.Length];
            for (int i = 0; i < buf.Length; i++)
            {
                encoded[i] = (byte)(((uint)buf[i] + rotNo) & 0xFF);
            }

            StringBuilder hex = new StringBuilder(encoded.Length * 2);
            int totalCount = encoded.Length;
            for (int count = 0; count < totalCount; count++)
            {
                byte b = encoded[count];

                if ((count + 1) == totalCount) // Dont append comma for last item
                {
                    hex.AppendFormat("0x{0:x2}", b);
                }
                else
                {
                    hex.AppendFormat("0x{0:x2}, ", b);
                }
            }

            Console.WriteLine($"ROT{rotNo} payload:");
            Console.WriteLine($"byte[] buf = new byte[{buf.Length}] {{ {hex} }};");

            //// Decode the ROTxx payload (make sure to change rotations)
            // for (int i = 0; i < buf.Length; i++)
            // {
            //    buf[i] = (byte)(((uint)buf[i] - 37) & 0xFF);
            //}

        }
    }
}