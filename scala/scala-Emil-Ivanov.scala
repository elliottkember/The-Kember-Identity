import scala.util.Random
import java.security.MessageDigest
import java.math.BigInteger

object Kih {
  val md = MessageDigest.getInstance("MD5")

  def main(args: Array[String]) {
    println("Searching...")
    println("Found: " + find)
  }

  def find(): String = {
    var original = randomBytes
    while (original != hash(original)) {
      original = randomBytes
    }

    bytesAsString(original)
  }

  def hash(original: Array[Byte]): Array[Byte] = {
    md.reset()
    md.update(original)
    md.digest
  }

  def randomBytes(): Array[Byte] = {
    val rand = new Random
    val newHash = new Array[Byte](16)

    rand.nextBytes(newHash)

    newHash
  }

  def bytesAsString(bytes: Array[Byte]): String = new BigInteger(1, bytes).toString(16)
}