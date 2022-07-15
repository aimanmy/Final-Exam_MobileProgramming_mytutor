<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$email = $_POST['user_email'];
$subscriptionid = $_POST['subscription_id'];

$sqldelete = "DELETE FROM tbl_subscriptions WHERE subscription_id ='$subscriptionid'";
if ($conn->query($sqldelete) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>