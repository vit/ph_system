<?php
include_once("../start.php");
include_once("mail_func.php");


echo "in sendmail.php\n";


$FROM0 = $GLOBALS['FROMEMAIL'];

	$RETURN = $GLOBALS['RETURNEMAIL'];

$limit = 10;

$result = pg_query("SELECT * FROM mlqueue WHERE status='1' ORDER BY qid ASC LIMIT $limit");
while( $row = pg_fetch_array( $result ) ) {
  $errcode = 0;
  $data = mail_prepare($row['qid']);

  if( $data ) {
    $SUBJECT = $data['subject'];
    $FROM = $data['ffrom'];
    $TO = $data['tto'];
    $BODY = $data['body'];
    if( !$FROM )
      $FROM = $FROM0;
    if ( strchr($FROM, '@') == '' )
      $errcode = 202;
    if ( strchr($TO, '@') == '' )
	$errcode = 203;
	if ( $errcode == 0 ) {
	$subj = "=?utf-8?B?". base64_encode( $SUBJECT ) ."?=";
//	$subj = $SUBJECT;
		if	( !mail(
					$TO,
					$subj,
//					$SUBJECT,
					$BODY,
//					"From: $FROM\r\nReply-To: $FROM"
					"Content-type: text/plain; charset=utf-8\r\n".
					"Content-Transfer-Encoding: 8bit\r\n".
//					"Subject: {$subj}". // this caused 'duplicate headers' error in gmail
//					"From: {$FROM}".
					"From: $FROM\r\nReply-To: $FROM".
//					"Reply-To: $FROM".
					"",
					"-f$RETURN"
				) 
			)
        	$errcode = 204;
	}
  }
  else
    $errcode = 201;

  $result2 = pg_query("UPDATE mlqueue SET status=2, error=$errcode WHERE qid=$row[qid]");
}

/*
		$subj = "=?utf-8?B?". base64_encode( $this->SUBJECT ) ."?=";
		return @mail($this->TO, $subj, $this->BODY,
			"Content-type: text/html; charset=utf-8\r\n".
			"Content-Transfer-Encoding: 8bit\r\n".
			"Subject: {$subj}\r\n".
			"From: {$this->FROM}".
//			"\r\n".
//			"Reply-To: {$this->FROM}".
//			"\r\n".
//			"To: {$this->TO}".
			""
		);
*/

?>
