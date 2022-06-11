<?php
if(!isset($_POST)){
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$name = $_POST['name'];
$email = $_POST['email'];
$base64image = $_POST['image'];
$phone = $_POST['phone'];
$address = $_POST['address'];
$password = sha1($_POST['password']);


$sqlinsert = "INSERT INTO tbl_customer (user_email, user_name, user_phone, user_address, user_password) VALUES ('$email', '$name', '$phone', '$address', '$password')";

if($conn->query($sqlinsert) === true){
    $response = array('status' => 'success', 'data' => null);
    $filename = mysqli_insert_id($conn);
    $decoded_string = base64_decode($base64image);
    $path = '../../../assets/user_image/' . $filename. '.jpg';
    $is_written = file_put_contents($path, $decoded_string);
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