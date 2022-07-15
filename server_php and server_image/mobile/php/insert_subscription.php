<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");
$subid = $_POST['subid'];
$useremail = $_POST['email'];
$subscriptionqty = "1";
$subscriptiontotal = 0;

$sqlcheckqty = "SELECT * FROM tbl_subjects where subject_id = '$subid'";
$resultqty = $conn->query($sqlcheckqty);
$num_of_qty = $resultqty->num_rows;
if ($num_of_qty>1){
    $response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
	return;
}

$sqlinsert = "SELECT * FROM tbl_subscriptions WHERE user_email = '$useremail' AND subject_id = '$subid' AND subscription_status IS NULL";
$result = $conn->query($sqlinsert);
$number_of_result = $result->num_rows;

if ($number_of_result > 0) {
    while($row = $result->fetch_assoc()) {
	    $subscriptionqty = $row['subscription_qty'];
	}
	$subscriptionqty = $subscriptionqty + 1;
	$updatesubscription = "UPDATE `tbl_subscriptions` SET `subscription_qty`= '$subscriptionqty' WHERE user_email = '$useremail' AND subject_id = '$subid' AND subscription_status IS NULL";
	$conn->query($updatesubscription);
} 
else 
{
    $addsubscription = "INSERT INTO `tbl_subscriptions`(`user_email`, `subject_id`, `subscription_qty`) VALUES ('$useremail','$subid','$subscriptionqty')";
    if ($conn->query($addsubscription) === TRUE) {

	}else{
	    $response = array('status' => 'failed', 'data' => null);
		sendJsonResponse($response);
		return;
    }
}

$sqlgetqty = "SELECT * FROM tbl_subscriptions WHERE user_email = '$useremail' AND subscription_status IS NULL";
$result = $conn->query($sqlgetqty);
$number_of_result = $result->num_rows;
$subscriptiontotal = 0;
while($row = $result->fetch_assoc()) {
    $subscriptiontotal = $row['subscription_qty'] + $subscriptiontotal;
}
$mysubscription = array();
$mysubscription['subscriptiontotal'] =$subscriptiontotal;
$response = array('status' => 'success', 'data' => $mysubscription);
sendJsonResponse($response);

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}


?>