<?php

header("Pragma: no-cache");
header("Cache-Control: no-cache");



function addslashes_recursive($value) {
  if (is_array($value)) {
    foreach ($value as $index => $val) {
      $value[$index] = addslashes_recursive($val);
    }
    return $value;
  } else {
    //return addslashes($value);
    return pg_escape_string($value);
  }
}

$_GET = addslashes_recursive($_GET);
$_POST = addslashes_recursive($_POST);
$_COOKIE = addslashes_recursive($_COOKIE);
$_REQUEST = addslashes_recursive($_REQUEST);


//foreach ($_GET as $index => $val) {
//  $_GET[$index] = addslashes_recursive($val);
//}

/*
foreach (array('_COOKIE','_GET', '_POST', '_REQUEST') as $_SG) {
            foreach ($$_SG as $index => $value) {
                    $$_SG[$index] = smartQuotes($value);
            }
    }
*/

include_once("config.php");

include_once("templ_init.php");

include_once("version.php");

require_once("init1.php");
//require_once("init.php");


//$DBLINK = pg_pconnect ("host=$HN dbname=$DN user=$UL password=$UP");
//$result = pg_query("SET search_path = $SHEMA;");


$PAGEBODY = '';


$LOGONFORM = <<<LOGONFORM
<form style="margin: 0;" method=post action="">
<!-- nobr -->
PIN:
<input class=logoninput type=text name=log_pin size=6>
Password:
<input class=logoninput type=password name=log_pass size=6>
<input class=logonbutton type=submit name="login" value="login">
<!-- /nobr -->
</form>

LOGONFORM;

$LOGOUTFORM = <<<LOGOUTFORM
<form style="margin: 0;" method=post action="">
<input class=logonbutton type=submit name="logout" value="logout">
</form>

LOGOUTFORM;



$USERPIN = "";
$USERINFO = array();
$PIN = "";
$PASS = "";
$KEY = "";
$USERERROR = "";
$USERTITLE = "";

#if( isset($_REQUEST['cms_key']) ) {
#  $KEY = $_REQUEST['cms_key'];
if( isset($_COOKIE['cms_key']) ) {
  $KEY = $_COOKIE['cms_key'];
}

if( isset($_REQUEST['log_pin']) ) {
  $PIN = $_REQUEST['log_pin'];
  $PASS = $_REQUEST['log_pass'];

//print "KEY=$KEY";
//  if($KEY) {
//    $result = pg_query("DELETE FROM userkey WHERE key='$KEY';");
//    setcookie("cms_key", "", 0, "/");
//  }

//  $result = pg_query("SELECT * FROM userpin WHERE pin='$PIN' AND pass='$PASS';");
  $result = pg_query("SELECT getuserbypinpassword('$PIN', '$PASS');");
//print pg_last_error()."<br>\n";
  if( $row=pg_fetch_array($result) ) {
    if( $row[0]>0 ) {
//    $result = pg_query("SELECT createseanskey('{$row['pin']}');");
      $result = pg_query("SELECT createseanskey('{$row[0]}');");
      if( $row=pg_fetch_array($result) ) {

        if($KEY) {
          $result = pg_query("DELETE FROM userkey WHERE key='$KEY';");
          setcookie("cms_key", "", 0, "/", $COOKIEDOMAIN);
        }

        $KEY = $row[0];
        setcookie("cms_key", "$KEY", 0, "/", $COOKIEDOMAIN);
        $JUSTLOGGED = true;
      }
    } else {
      $USERERROR = "Error: wrong PIN or password";
    }
  }

}
// else if( isset($_REQUEST['cms_key']) ) {
//  $KEY = $_REQUEST['cms_key'];
//}


if( isset($_REQUEST['logout']) ) {
  $result = @pg_query("DELETE FROM userkey WHERE key='$KEY';");
  $PIN = "";
  $PASS = "";
  $KEY = "";
  setcookie("cms_key", "", 0, "/", $COOKIEDOMAIN);
}

if( $KEY ) {

  $result = pg_query("SELECT checkseanskey('$KEY')");
  if( $row=pg_fetch_array($result) ) {
    $USERPIN = $row[0];
  } 
  if (! $USERPIN ) {
    setcookie("cms_key", "", 0, "/", $COOKIEDOMAIN);
    $USERERROR = "User session is expired, sorry...";
  } else {

//    $result = pg_query("SELECT * FROM userpin WHERE pin='$USERPIN' AND enabled=true;");
    $result = pg_query("SELECT * FROM userpin WHERE pin='$USERPIN';");
    if( $row=pg_fetch_array($result) ) {
      $USERINFO = $row;
    } else {
      $USERPIN = "";
      setcookie("cms_key", "", 0, "/", $COOKIEDOMAIN);
      $USERERROR = "Your account is disabled now";
    }
  }

}







$iscontman = "";
//$issubjman = "";

//print "$CURRENTCONT|$USERPIN<br>";

$IS_MEMBER = false;
if( $USERPIN ) {
  $result = pg_query("SELECT COUNT(*) FROM context WHERE manager='$USERPIN'");
  if( $row = pg_fetch_array($result) ) {
    if( $row[0]>0 )
    $iscontman = 1;
  }
  $result = pg_query("SELECT * FROM ipacs_member WHERE userpin='$USERPIN'");
  $IS_MEMBER = ( $row = pg_fetch_array($result) );
}






include_once("mainmenu.php");





$TITLES = array();
$result = pg_query("SELECT * FROM title ORDER BY titleid;");
while( $row = pg_fetch_array($result) ) {
  $TITLES[$row['titleid']] = $row['shortstr'];
}


$EDITORSUBJDECISIONS = array(0 => 'Uncertain', 1 => 'Rejected', 2 => 'Accepted');
$FINALSUBJDECISIONS = $REVIEWERSUBJDECISIONS = $EDITORSUBJDECISIONS;

//$EDITORPAPERDECISIONS = array(0 => 'Uncertain', 1 => 'Rejected', 2 => 'Accepted as a regular paper', 3 => 'Accepted as a poster');
$EDITORPAPERDECISIONS = array(0 => 'Uncertain', 1 => 'Rejected', 2 => 'Accepted with minor corrections', 3 => 'Cannot be accepted in present form');
$REVIEWERPAPERDECISIONS = $EDITORPAPERDECISIONS;
//$FINALPAPERDECISIONS = array(0 => 'Uncertain', 1 => 'Rejected', 2 => 'Accepted as a regular paper', 3 => 'Accepted as a poster', 4 => 'Accepted as an invited paper');
//$FINALPAPERDECISIONS = array(0 => 'Uncertain', 1 => 'Rejected', 2 => 'Accepted with minor corrections', 3 => 'Cannot be accepted in present form');
//$FINALPAPERDECISIONS = array(0 => 'Uncertain', 1 => 'Rejected', 2 => 'Accepted with minor corrections', 3 => 'Cannot be accepted in present form', 4=> 'Accepted');
$FINALPAPERDECISIONS = array(0 => 'Uncertain', 1 => 'Rejected', 4=> 'Accepted', 2 => 'Accepted with minor corrections', 3 => 'Cannot be accepted in present form');


$SCORES = array(0 => 'Uncertain');
$result = pg_query("SELECT * FROM score ORDER BY scoreid DESC");
while( $row = pg_fetch_array($result) ) {
  $SCORES[$row['scoreid']] = $row['name'];
}


if($USERPIN) {
  $t0 = $USERINFO['title'];
//  $t = $TITLES[$t0-1];
  $t = $TITLES[$t0];
  $USERTITLE = "$t {$USERINFO['fname']} {$USERINFO['lname']}";
}


?>
