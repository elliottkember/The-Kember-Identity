// MD5 identity solver, by Stephen McCarthy.
// All code below this point is public domain.

var hexChars = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0', 'a', 'b', 'c', 'd', 'e', 'f'];

function generateRandomHash() {
  var buffer = [];
  for (var i = 0; i < 32; i++) {
    buffer.push(hexChars[Math.floor(Math.random() * 16)]);
  }
return buffer.join('');
}

var numAttempts = 0;

function findIdentityHash() {
  var found = false;

  for (var i = 0; i < 1000; i++) {
    var hash = generateRandomHash();
    if (hex_md5(hash) == hash) {
      document.body.innerHTML = 'You found it! md5(' + hash + ') = ' + hex_md5(hash);
      found = true;
      alert('You found it! ' + hash);
      break;
    }
    numAttempts++;
  }

  if(!found) {
    document.body.innerHTML = numAttempts + ' attempts made so far.'
   
    // We must yeild control back to the browser every now and then, otherwise it freezes.
    // Recursively calling this function via setTimout gets the job done.
    window.setTimeout(findIdentityHash, 0);
  }
}

