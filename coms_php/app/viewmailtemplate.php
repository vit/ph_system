<?php

include_once("start.php");


$CONTEXT = 0;
$MAILNAME = "";

if( $_REQUEST['contid'] ) {
  $CURRENTCONT = $CONTEXT = $_REQUEST['contid'];
}

if( $_REQUEST['mailname'] ) {
  $MAILNAME = $_REQUEST['mailname'];
}


if( $CONTEXT && $MAILNAME ) {

  include_once( "email/directmail.php" );
  $text = mail_get_template($MAILNAME);
  $text = nl2br($text);


  $PAGEBODY = <<<PAGEBODY
<center><b>Mail template</b></center>
$text

PAGEBODY;

}


include_once("finish1.php");

?>