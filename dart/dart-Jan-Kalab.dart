import 'package:crypto/crypto.dart' show MD5, CryptoUtils;
import 'dart:math' show Random;

void main() {
	Random r = new Random();
	while (true) {
		List<int> inhash = new List<int>.generate(16, (int index) => r.nextInt(255));
		MD5 md5 = new MD5();
		md5.add(inhash);
		List<int> outhash = md5.close();
		print(CryptoUtils.bytesToHex(outhash));
		if (inhash == outhash) break;
	}
}
