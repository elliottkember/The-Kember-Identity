<?php
/**
* The Kember Identity Experiment
* Attempt to find md5(str) = str
* Adjusted George Hickmans script
*
* This Script is for calling via Cronjob
* It sends an email when a reversible hash was found.
*
* @author Max Berndt
* @version 1.0
* @date 07/May/2009
*/

/**
* Script Settings
* Set the rounds to look for hashes. 300000 rounds take about 25 sec on my server 
* and is optimal for me, because this is close to time out error.
*/
$timesToRun = 300000; // How many rounds to run 

/* Generate a random hash */
function random_gen($length) {
  $characters = '0123456789abcdef';
  $str = '';
  for($i=0;$i<$length;$i++) {
	$str .= substr($characters, (mt_rand() % (strlen($characters))), 1);
  }
  return $str;
}

/* Compare random hash with its md5 */
function cmpHashes($rounds) {
	$isReversible = false;
	$i=0; 
	while(($i < $rounds) && (!$isReversible)) {
		$i++;
		$str = random_gen(32);
		$output = hash('md5', $str);
		if($output == $str) {
			$isReversible = true;
			
			/* Email Settings */
			$to = "elliott.kember@gmail.com";
			$subject = "A reversible Hash was found!";
			$body = "The reversible Hash is: ".$str;

			/* Send email if revsersible hash was found */
			mail($to, $subject, $body, "From:Experiment@elliottkember.com<The Kember Identity>");
		}
	}
	return 'None of '.$rounds.' hashes were reversible!';
}

/* Run the comparisment function */
echo cmpHashes($timesToRun);
?>
