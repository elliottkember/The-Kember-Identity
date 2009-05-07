#include <iostream>
#include <string>        // string
#include <ctime>        // time()
#include <cstdlib>        // srand() and rand()
#include "md5.h"
#include "md5wrapper.h"

char input[256];
const char* cmpInput;
std::string encInput;
md5wrapper* encrypt;
int i;
unsigned long tries;

int number;
char newInput[32];

char rndInput[16];

int _tmain(int argc, _TCHAR* argv[])
{
   encrypt = new md5wrapper();

   std::cout << "Enter a string (up to 256 characters) to get started. \n> ";
   fgets(input, sizeof input, stdin);

   number = -1;

   // blah, there's probably a better way to do this
   rndInput[0] = '0';
   rndInput[1] = '1';
   rndInput[2] = '2';
   rndInput[3] = '3';
   rndInput[4] = '4';
   rndInput[5] = '5';
   rndInput[6] = '6';
   rndInput[7] = '7';
   rndInput[8] = '8';
   rndInput[9] = '9';
   rndInput[10] = 'a';
   rndInput[11] = 'b';
   rndInput[12] = 'c';
   rndInput[13] = 'd';
   rndInput[14] = 'e';
   rndInput[15] = 'f';

   srand(time(0));

   if (input != NULL)
   {
       while (1)
       {
           tries++;
           encInput = encrypt->getHashFromString(input);
           std::cout << "In: " << input << " Out: " << encInput << "\n";
           cmpInput = encInput.c_str();

           // comparison
           for (i = 0; i < 32; i++) { if (cmpInput[i] != input[i]) { break; } }

           if (i >= 32)
           {
               std::cout << "Holy shit! We found it! \n" << "And it only took " << tries << " tries!";
               fgets(input, sizeof input, stdin);
           }

           // compile a new string from the other strings to help randomness
           if (number++ == 32)
           {
               memcpy(input, newInput, 32 * sizeof(char));
               number = -1;
           }
           else
           {
               int pick = rand() % 16;
               newInput[number] = rndInput[pick];
               strcpy(input, cmpInput);
           }
       }
   }

   return 0;
}

