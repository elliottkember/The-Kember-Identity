var kemberIdentity = function(kemberEl){

	var randomGenerate = function(len){
		var chars = '0123456789abcdef';
		var str = '';
		for (var i=0, clen=chars.length; i<len; i++) {
			var r = Math.floor(Math.random() * clen);
			str += chars.substring(r, r+1);
		}
		return str;
	};
	
	var i = 0;
	// using setInterval because `while` loop hangs the browser. Bad...
//	while (true){
	var interval = setInterval(function(){
		var str = randomGenerate(32);
		i++;
		if (i == 1000){
			kemberDiv.innerHTML += str + '<br>';
			i = 0;
		}
		var output = hex_md5(str);
		if (output == str){
			kemberDiv.innerHTML += '<strong>' + str + ' is a reversible md5 hash!</strong>';
			clearInterval(interval);
//		break;
		}
	}, 1);
//	}

};