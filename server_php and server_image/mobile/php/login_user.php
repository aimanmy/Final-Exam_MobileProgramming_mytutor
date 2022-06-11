<?php
if(!isset($_POST)){
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);
$sqllogin = "SELECT * FROM tbl_customer WHERE user_email = '$email' AND user_password = '$password'";
$result = $conn->query($sqllogin);
$numrow = $result->num_rows;


if($numrow > 0){
    while($row = $result->fetch_assoc()) {
        $user['id'] = $row['user_id'];
        $user['email'] = $row['user_email'];
        $user['name'] = $row['user_name'];
        $user['phone'] = $row['user_phone'];
        $user['password'] = $row['user_password'];
        $user['address'] = $row['user_address'];
        $user['regdate'] = $row['user_datereg'];
    }
    $response = array('status' => 'success', 'data' => $user);
    sendJsonResponse($response);
    }else{
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}


function sendJsonResponse($sentArray){
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>