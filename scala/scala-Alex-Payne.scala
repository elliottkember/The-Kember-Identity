import java.security.MessageDigest
import scala.actors.Actor
import scala.actors.Actor._
import scala.util.Random
 
class DigestComparisonActor extends Actor {
  val md5 = MessageDigest.getInstance("MD5")
  val rand = new scala.util.Random()
  var byteArray = new Array[Byte](32)
 
  def printHex(digestBytes: Array[Byte]) {
    var hex = new StringBuffer()
 
    for (byte <- digestBytes) {
      val hexByte = byte & 0xFF
      if (hexByte < 0x10) hex.append("0")
      hex.append(Integer.toHexString(hexByte))
    }
 
    println(hex)
  }
 
  def act() {
    loop {
      rand.nextBytes(byteArray)
      md5.update(byteArray, 0, byteArray.length)
 
      val randomBytes = byteArray
      val digestBytes = md5.digest()
 
      if (randomBytes deepEquals digestBytes) {
        printHex(digestBytes)
        exit()
      }
    }
  }
}
 
object Kember {
  val cpus = 4 // edit for number of cores on your system
 
  def main(args: Array[String]) {
    for (cpu <- 1 to cpus) {
      val dca = new DigestComparisonActor
      dca.start()
    }
  }
}

