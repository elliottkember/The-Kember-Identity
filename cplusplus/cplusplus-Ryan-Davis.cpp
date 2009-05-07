#include <iostream>
#include "md5wrapper.h"    // Get @ http://www.md5hashing.com/c++/

int main( int argc, char** argv )
{
  // Create MD5 Wrapper Object
  md5wrapper md5;
    // Generate A Seed Hash
  std::string hash1 = md5.getHashFromString("KemberIdentity");
  std::string hash2 = md5.getHashFromString( hash1 );

  // Run through hash's until they match
  for( ;; ){
      // Is This The Kember Identity?
      if( 0 == hash1.compare( hash2 ) ){
          std::cout << "I've Found It!" << "\r\n";
          std::cout << "The Kember Identity Is " << hash1 << "\r\n";
          return 0;
      }

      // Next Time, Compare This Hash To This Hash's Hash
      hash1.assign( hash2 );
      hash2 = md5.getHashFromString( hash1 );           }

  return 0;
}

