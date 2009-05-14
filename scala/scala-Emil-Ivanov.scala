import java.util.Date
import scala.util.Random
import java.security.MessageDigest
import java.math.BigInteger

object Kih {
  def main(args: Array[String]) {
    val indicator = new ProgressIndicator(triesPerSecond =>
      println("Current speed is " + triesPerSecond / 1000 + "k tires/s")
    )
    val finder = new Finder(indicator)

    println("Searching...")
    println("Found: " + bytesAsString(finder.find))
  }

  def bytesAsString(bytes: Array[Byte]): String = new BigInteger(1, bytes).toString(16)
}

class Finder(private val pi: ProgressIndicator, private val step: Long) {
  private val md = MessageDigest.getInstance("MD5")

  def this(pi: ProgressIndicator) = this(pi, 5000000)

  def find: Array[Byte] = {
    var count = 0L
    var original = randomBytes
    while (original != hash(original)) {
      original = randomBytes

      count += 1

      if (count % step == 0) pi.progress(count)
    }

    original
  }

  private def hash(original: Array[Byte]): Array[Byte] = {
    md.reset()
    md.update(original)
    md.digest
  }

  private def randomBytes: Array[Byte] = {
    val rand = new Random
    val newHash = new Array[Byte](16)

    rand.nextBytes(newHash)

    newHash
  }
}

class ProgressIndicator(val notifyCallback: (Long) => Unit) {
  private val startTime: Long = new Date().getTime

  def progress(tries: Long) {
    notifyCallback(tries / time * 1000)
  }

  private def time: Long = {
    val now = new Date().getTime
    now - startTime 
  }
}