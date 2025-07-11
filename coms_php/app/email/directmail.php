<?php


// echo "!!!!! in directmail.php !!!!!";
// echo "!!!!! REVIEWDEADLINE=$REVIEWDEADLINE !!!!!";


//include_once("../start.php");


//function mail_send_now($mailname, $userinfo, $email) {
function mail_send_now($mailname, $topin, $toemail="", $args=array() ) {

  $SUBJECT = "User notification";
//    $SUBJECT = isset( $args['SUBJECT'] ) ? $args['SUBJECT'] : "User notification";

//  $FROM = "robot@physcon.ru";
//  $FROM = "coms@physcon.ru";

  $FROM = $GLOBALS['FROMEMAIL'];

  $RETURN = $GLOBALS['RETURNEMAIL'];

  if (is_array($args))
    extract( $args );



  $errcode = 0;



  $result = pg_query("SELECT * FROM userpin WHERE pin='$topin' AND enabled=true;");
  if ( ! ( $userinfo=pg_fetch_array($result) ) ) {
    $errcode = 201;
  } else {
    $CURRENTCONT = isset( $args['CURRENTCONT'] ) ? $args['CURRENTCONT'] : NULL;
    $MESSAGE = mail_get_template($mailname, $CURRENTCONT);

    if( !trim($MESSAGE) ) {
      $errcode = 205;
      return;
    }

    $TITLE = $userinfo['title'];
    $TITLE = $GLOBALS['TITLES'][$TITLE];

    $FNAME = $userinfo['fname'];
    $LNAME = $userinfo['lname'];
    $USERPIN = $PIN = $userinfo['pin'];
    $USERPASSWORD = $PASSWORD = $userinfo['pass'];

    $TO = $userinfo['email'];
    if( $toemail )
      $TO = $toemail;

//    $pattern = '/{\$(\w*)}/e';
//    $MESSAGE = preg_replace( $pattern, "\$\\1", $MESSAGE );

    $vals = array_merge(
      array(
        'SUBJECT' => $SUBJECT,
        'FROM' => $FROM,
        'RETURN' => $RETURN
      ),
      $args,
      array(
        'TITLE' => $TITLE,
        'FNAME' => $FNAME,
        'LNAME' => $LNAME,
        'USERPIN' => $USERPIN,
        'PIN' => $PIN,
        'USERPASSWORD' => $USERPASSWORD,
        'PASSWORD' => $PASSWORD,
        'TO' => $TO
      )
    );

    $pattern = '/{\$(\w*)}/';
    $MESSAGE = preg_replace_callback(
        $pattern,
        function ($matches) use($vals) {
          return $vals[$matches[1]];
        },
        $MESSAGE
    );


    if ( strchr($TO, '@') == '' )
      $errcode = 203;

    if ( $errcode == 0 ) {
//      if ( @mail($TO, $SUBJECT, $MESSAGE, "From: $FROM\r\nReply-To: $FROM") )
  		if ( @mail($TO, $SUBJECT, $MESSAGE, "From: $FROM\r\nReply-To: $FROM", "-f$RETURN") ) // last argument needs "trusted_users = root" in exim config
//  		if ( @mail($TO, $SUBJECT, $MESSAGE, "From: $FROM", "-f$RETURN") ) // last argument needs "trusted_users = root" in exim config
//  		if ( @mail($TO, $SUBJECT, $MESSAGE, "From: $FROM\r\nReply-To: $FROM") )
//  		if ( @mail($TO, $SUBJECT, $MESSAGE, "From: $FROM\r\nReply-To: $FROM", "-f$FROM") ) // last argument needs "trusted_users = root" in exim config
//  		if ( @mail($TO, $SUBJECT, $MESSAGE, "Reply-To: $FROM", "-f$FROM") ) // last argument needs "trusted_users = root" in exim config
        return true;
      else
        $errcode = 204;

    }

  }

}

function mail_get_template($mailname, $context=NULL) {

	if( ! is_null( $context ) ) {
		$context = (string)((int)$context);
		$templ_file = dirname(__FILE__)."/templ/part/".$context."/".$mailname.".eml";
		$filearr = @file( $templ_file );
		if ( $filearr )
			return join( "", $filearr );
	}


    $templ_file = dirname(__FILE__)."/templ/".$mailname.".eml";

    $filearr = @file( $templ_file );

    $MESSAGE = "";
    if ( $filearr )
      $MESSAGE = join( "", $filearr );
  return $MESSAGE;
}

?>
