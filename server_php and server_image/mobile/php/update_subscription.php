<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");
$subscriptionid = addslashes($_POST['subscriptionid']);
$op = addslashes($_POST['operation']);

if ($op =="+"){
    $updatecart = "UPDATE `tbl_subscriptions` SET `subscription_qty`= (subscription_qty+1) WHERE subscription_id = '$subscriptionid'";    
}

if ($op =="-"){
    $updatecart = "UPDATE `tbl_subscriptions` SET `subscription_qty`= if(subscription_qty>1,(subscription_qty-1),subscription_qty) WHERE subscription_id = '$subscriptionid'";    
}

if ($conn->query($updatecart)){
    $response = array('status' => 'success', 'data' => null);    
}else{
    $response = array('status' => 'failed', 'data' => null);
}

sendJsonResponse($response);

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>