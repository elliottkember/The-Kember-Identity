<?php
/**
 * Attempt to find md5(str) = str
 *
 * @author Gargoyle
 */

// Initialise some counters 'cos everyone loves stats.
$hashCount = 1;
$hashTotalCount = 0;
$startTime = microtime(true);

// Create our first hash test.
$hashOne = md5(time());
$hashTwo = md5($hashOne);

// Remember the original hash for a very crude looping check
$originalHash = $hashOne;

// Loop!
while($hashOne != $hashTwo) {

    // This is the very crude loop check.
    if ($hashTwo == $originalHash) {
        echo "\n\n ** I have collided with my orignal hash! **\n\n";
        break;
    }

    // No match, so move the new hash to hashOne and re-compute a new second hash.
    $hashOne = $hashTwo;
    $hashTwo = md5($hashOne);

    // Everyone loves stats!
    $hashCount++;
    if ($hashCount == 1000000) {
        // Add to the total and reset the intermediate counter.
        // This stops us from having to do modulus on stupidly large numbers!        
        $hashTotalCount += $hashCount;
        $hashCount = 0;

        // Get the current rate of hashes per second.
        $timeNow = microtime(true);
        $timeDifference = $timeNow - $startTime;
        $hashesPerSecond = $hashTotalCount / $timeDifference;

        // Show some stats.
        $str = "I have compared " . number_format($hashTotalCount, 0, null, ',')
            . " hashes (".number_format($hashesPerSecond, 2)." hashes / sec)";
        echo "\r" . str_pad($str, 80, " ", STR_PAD_RIGHT);
    }
}

echo "Found one!!! It's " . $hashOne . "\n";
