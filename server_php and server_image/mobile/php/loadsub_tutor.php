<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$sqlloadsubjects= "SELECT subject_name, tutor_id FROM tbl_subjects ORDER BY subject_id ASC";
$result = $conn->query($sqlloadsubjects);
$number_of_result = $result->num_rows;
if ($result->num_rows > 0) {
    $tutorsub["tutorsub"] = array();
    while ($row = $result->fetch_assoc()) {
        $tutorsublist = array();
        $tutorsublist['subject_name'] = $row['subject_name'];
        $tutorsublist['tutor_id'] = $row['tutor_id'];
        array_push($tutorsub["tutorsub"],$tutorsublist);
    }
    $response = array('status' => 'success', 'data' => $tutorsub);
    sendJsonResponse($response);
    }else{
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>