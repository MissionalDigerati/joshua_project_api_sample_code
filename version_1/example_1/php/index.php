<?php
$domain = "http://jpapi.codingstudio.org";
$api_key = YOUR_API_KEY;
$url = $domain . "/v1/people_groups/daily_unreached.json?api_key=" . $api_key;
/**
 * open connection
 *
 * @author Johnathan Pulos
 */
$ch = curl_init();
/**
 * Setup cURL
 *
 * @author Johnathan Pulos
 */
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_TIMEOUT, 60);
curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'GET');
/**
 * execute request
 *
 * @author Johnathan Pulos
 */
$result = curl_exec($ch) or die(curl_error($ch));
/**
 * close connection
 *
 * @author Johnathan Pulos
 */
curl_close($ch);
/**
 * decode the response JSON
 *
 * @author Johnathan Pulos
 */
$decoded_json = json_decode($result, true);
if (!is_array($decoded_json)) {
	echo "Unable to retrieve the JSON.";
	exit;
}
/**
 * Assign the first object to a variable
 *
 * @author Johnathan Pulos
 */
$unreached = $decoded_json[0];
/**
 * Handle the null value
 *
 * @author Johnathan Pulos
 */
if ($unreached['PCEvangelical'] == null) {
	$unreached['PCEvangelical'] = 0;
}
/**
 * Start the rendering
 *
 * @author Johnathan Pulos
 */
?>
<!DOCTYPE html>
<html>
	<head>
		<title>Joshua Project | Sample Code (Javascript)</title>
		<link rel="stylesheet" type="text/css" href="css/styles.css">
	</head>
	<body>
		<p>
			This Sample Code is designed to demonstrate how to retrieve the Daily Unreached from the <a href="" class="domain-link">Joshua Project API</a> using PHP.
		</p>
		<div id="jp_widget">
	        <div class="upgotd upgotd-title">
	        	<a href="http://www.joshuaproject.net/upgotdfeed.php" class="upgotd-link">Unreached of the Day</a>
	        </div>
	        <div class="upgotd-image">
	        	<a href="<?php echo $unreached['PeopleGroupURL']; ?>" class="upgotd-link pg-link" id="people-group-image">
	        		<img src="<?php echo $unreached['PeopleGroupPhotoURL']; ?>" height="160" width="128" alt="Unreached of the Day Photo">
	        	</a>
	        </div>
	        <div class="upgotd upgotd-pray">Please pray for the ...</div>
	        <div class="upgotd upgotd-people">
	        	<a href="<?php echo $unreached['PeopleGroupURL']; ?>" class="upgotd-link pg-link pg-name"><?php echo $unreached['PeopNameInCountry']; ?></a> of <a href="<?php echo $unreached['CountryURL']; ?>" class="upgotd-link country-link country-name"><?php echo $unreached['Country']; ?></a>
	        </div>
	        <table align="center" class="upgotd-table" cellpadding="0" cellspacing="0">
	            <tbody><tr>
	                <td width="65">Population:</td>
	                <td width="135" class="pg-population"><?php echo number_format($unreached['Population']); ?></td>
	            </tr>
	            <tr>
	                <td>Language:</td>
	                <td class="pg-language"><?php echo $unreached['PrimaryLanguageName']; ?></td>
	            </tr>
	            <tr>
	                <td>Religion:</td>
	                <td class="pg-religion"><?php echo $unreached['PrimaryReligion']; ?></td>
	            </tr>
	            <tr>
	                <td>Evangelical:</td>
	                <td class="pg-evangelical"><?php echo number_format($unreached['PCEvangelical'], 2); ?>%</td>
	            </tr>
	            <tr>
	                <td>Status:</td>
	                <td>
	                	<a href="http://www.joshuaproject.net/definitions.php?term=25" class="upgotd-link pg-scale-text">
	                		<?php echo $unreached['JPScaleText']; ?>
	                	</a> (
	                	<a href="http://www.joshuaproject.net/global-progress-scale.php" class="upgotd-link pg-scale">
	                		<?php echo $unreached['JPScale']; ?>
	                	</a>
	                	<a href="http://www.joshuaproject.net/global-progress-scale.php" class="upgotd-link" id="progress-scale-image">
	                		<img src="<?php echo $unreached['JPScaleImageURL']; ?>" alt="Progress Scale">
	                	</a>)
	                </td>
	            </tr>
	        </tbody></table>
	        <div class="upgotd upgotd-footer">Add this daily global vision feature to <br><a href="/upgotdfeed.php" class="upgotd-link"><b>your website</b></a> or get it <a href="http://www.unreachedoftheday.org/unreached-email.php" class="upgotd-link"><b>by email</b></a>.</div>
		</div>
	</body>
</html>