<?

//$FROM = 'robot@physcon.ru';
$FROM = 'coms@physcon.ru';

include_once("../start.php");


$limit = 10;

$result = pg_query("SELECT * FROM mailtask WHERE taskstatus='0' ORDER BY taskid ASC LIMIT $limit");
while( $row = pg_fetch_array( $result ) ) {
  $errcode = 0;

  $result2 = pg_query("SELECT * FROM maildata WHERE mlid='$row[mlid]'");
  if( $ml = pg_fetch_array( $result2 ) ) {

    $SUBJECT = $ml[mlsubject];
    $FROM = $ml[mlfrom];
    $MESSAGE = $ml[mlbody];

    $USERID = $row[taskpin];

    $PIN = $USERPIN = $PASS = $PASSWORD = $TITLE = $TO = $EMAIL = $FNAME = $LNAME = $PAPERTITLE = $PAPERABSTRACT = "";

    if ( $row[tasktype] == 1 ) {
      $result3 = pg_query("SELECT * FROM userpin WHERE pin='$row[taskpin]' AND enabled=true");
      if( ! ( $userinfo = pg_fetch_array( $result3 ) ) ) {
        $errcode = 201;
      } else {
        $PIN = $USERPIN = $userinfo[pin];
        $PASS = $PASSWORD = $userinfo[pass];

        $FNAME = $userinfo[fname];
        $LNAME = $userinfo[lname];
        $TO = $EMAIL = $userinfo[email];

        $TITLE = $userinfo[title];
        $TITLE = $TITLES[$TITLE];

      }
    }

    if ( $row[tasktype] == 2 ) {
      $TO = $EMAIL = $row[taskemail];
    }

    $pattern = '/{\$(\w*)}/e';
    $MESSAGE = preg_replace( $pattern, "\$\\1", $MESSAGE );

    if ( strchr($TO, '@') == '' )
      $errcode = 203;

    if ( $errcode == 0 ) {
      if ( !mail($TO, $SUBJECT, $MESSAGE, "From: $FROM\r\nReply-To: $FROM") )
        $errcode = 204;
    }

  }

//  db_ml_setTaskStatus( $row[taskid], 1, $errcode );
  $result4 = pg_query("UPDATE mailtask SET taskstatus=1, taskerror=$errcode WHERE taskid=$row[taskid]");
  
}

?>