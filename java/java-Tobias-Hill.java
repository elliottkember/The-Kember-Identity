import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Random;

public class KemberHash {

	static final char[] alphabet = new char[] { 'a', 'b', 'c', 'd', 'e', 'f',
			'1', '2', '3', '4', '5', '6', '7', '8', '9', '0' };
	static final Random generator = new Random(System.nanoTime());

	static final int retainToNextGeneration = 1;

	static final int mutateProbability = 90;

	static final int crossoverProbability = 50;

	static final int populationSize = 50;

	static final int printAfterThisManyGenerations = 200000;

	static MessageDigest postHash = null;
	{

		try {
			postHash = MessageDigest.getInstance("MD5");
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
	}

	private class Population {

		PreHash[] oldPopulation;
		PreHash[] newPopulation;

		Population() {

			oldPopulation = new PreHash[populationSize];
			newPopulation = new PreHash[populationSize];
			for (int i = 0; i < populationSize; i++) {
				oldPopulation[i] = new PreHash(alphabet);
				newPopulation[i] = new PreHash(alphabet);
			}
		}

		void newGeneration() {
			sort();
			for (int i = 0; i < populationSize; i++) {
				newPopulation[i].copy(oldPopulation[i]);
				if (i >= retainToNextGeneration)
					newPopulation[i].mutate();
			}
			for (int i = retainToNextGeneration; i < populationSize; i++) {
				newPopulation[i].crossover(oldPopulation[generator
						.nextInt(populationSize)]);
			}
			oldPopulation = newPopulation;
		}

		private void sort() {
			for (int i = 0; i < populationSize; i++) {
				oldPopulation[i].score();
			}
			PreHash temp;
			for (int i = 0; i < populationSize - 1; i++) {
				for (int j = i; j < populationSize; j++) {
					if (oldPopulation[i].score < oldPopulation[j].score) {
						temp = oldPopulation[i];
						oldPopulation[i] = oldPopulation[j];
						oldPopulation[j] = temp;
					}
				}
			}
		}

		PreHash topScore() {
			return oldPopulation[0];
		}
	}

	private class PreHash {

		char hashee[];
		int score;

		PreHash(char[] alphabet) {
			hashee = new char[32];
			score = 0;
			for (int i = 0; i <= 31; i++) {
				hashee[i] = alphabet[generator.nextInt(15)];
			}
		}

		void copy(PreHash preHash) {
			for (int i = 0; i <= 31; i++) {
				hashee[i] = preHash.hashee[i];
			}
		}

		@Override
		public String toString() {

			String pre = new String();
			for (int i = 0; i <= 31; i++) {
				pre = pre + hashee[i];
			}
			postHash.update(pre.getBytes(), 0, pre.getBytes().length);
			String postString = convertToHex(postHash.digest());

			return pre + "\n" + postString + ":" + score + "\n";
		}

		void mutate() {
			for (int i = 0; i <= 31; i++) {
				if (generator.nextInt(100) < mutateProbability)
					hashee[i] = alphabet[generator.nextInt(15)];
			}
		}

		void crossover(PreHash preHash) {
			if (generator.nextInt(100) < crossoverProbability) {
				int start = generator.nextInt(30);
				for (int i = start; i <= start + generator.nextInt(31 - start); i++) {
					hashee[i] = preHash.hashee[i];
				}
			}
		}

		private String convertToHex(byte[] data) {
			StringBuffer buf = new StringBuffer();
			for (int i = 0; i < data.length; i++) {
				int halfbyte = (data[i] >>> 4) & 0x0F;
				int two_halfs = 0;
				do {
					if ((0 <= halfbyte) && (halfbyte <= 9))
						buf.append((char) ('0' + halfbyte));
					else
						buf.append((char) ('a' + (halfbyte - 10)));
					halfbyte = data[i] & 0x0F;
				} while (two_halfs++ < 1);
			}
			return buf.toString();
		}

		void score() {
			score = 0;
			String pre = new String(hashee);

			postHash.update(pre.getBytes(), 0, pre.length());
			String postString = convertToHex(postHash.digest());

			for (int i = 0; i <= 31; i++) {
				if (hashee[i] == postString.charAt(i))
					score++;
			}
			if (score == 32) {
				System.out.println("Found it: " + pre);
				System.exit(0);
			}
		}
	}

	private void geneticAlgorithm() {
		Population population = new Population();

		int iterator = 0;

		do {

			population.newGeneration();

			iterator++;
			if (iterator == printAfterThisManyGenerations) {
				System.out.println(population.topScore());
				iterator = 0;
			}
		} while (true);
	}

	public static void main(String args[]) throws Exception {

		KemberHash kember = new KemberHash();
		kember.geneticAlgorithm();

	}
}
