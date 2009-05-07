mport scala.util.Random
import scala.collection.mutable
import java.security.MessageDigest

object Kih {
  val alphabet = List('a', 'b', 'c', 'd', 'e', 'f', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9')
  val md = MessageDigest.getInstance("MD5")

  def main(args: Array[String]) {
    println("Searching...")
    println("Found: " + find)
  }

  def find(): String = {
    var original: Array[Byte] = randomBytes
    while (original != hash(original)) {
      original = randomBytes
    }
    original.map(_.toChar).mkString
  }

  def hash(original: Array[Byte]): Array[Byte] = {
    md.update(original)
    md.digest
  }

  def randomBytes = {
    val rand = new Random
    val newHash = new mutable.ArrayBuffer[Byte]

    for (i <- 1 to 32) {
      newHash += alphabet(rand nextInt alphabet.length).toByte
    }

    newHash toArray
  }
}
