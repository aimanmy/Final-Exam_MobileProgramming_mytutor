<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$email = $_POST['user_email'];
$sqlloadsubscription = "SELECT tbl_subscriptions.subscription_id, tbl_subscriptions.subject_id, tbl_subscriptions.subscription_qty, tbl_subjects.subject_name, tbl_subjects.subject_price FROM tbl_subscriptions INNER JOIN tbl_subjects ON tbl_subscriptions.subject_id = tbl_subjects.subject_id WHERE tbl_subscriptions.user_email = '$email' AND tbl_subscriptions.subscription_status IS NULL";
$result = $conn->query($sqlloadsubscription);
$number_of_result = $result->num_rows;
if ($result->num_rows > 0) {
    //do something
    $total_payable = 0;
    $subscriptions["subscription"] = array();
    while ($rows = $result->fetch_assoc()) {
        
        $sublist = array();
        $sublist['subscription_id'] = $rows['subscription_id'];
        $sublist['subject_name'] = $rows['subject_name'];
        $subprice = $rows['subject_price'];
        $sublist['subject_price'] = number_format((float)$subprice, 2, '.', '');
        $sublist['subscription_qty'] = $rows['subscription_qty'];
        $sublist['subject_id'] = $rows['subject_id'];
        $price = $rows['subscription_qty'] * $subprice;
        $total_payable = $total_payable + $price;
        $sublist['pricetotal'] = number_format((float)$price, 2, '.', ''); 
        array_push($subscriptions["subscription"],$sublist);
    }
    $response = array('status' => 'success', 'data' => $subscriptions, 'total' => $total_payable);
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