<?php

include_once("start.php");
header('Content-Type: text/plain; charset=utf-8');

if(
	! (
		$_SERVER['PHP_AUTH_USER'] == 'alf' &&
		$_SERVER['PHP_AUTH_PW'] == '22maya'
	)
) {
	header('Status: 401 Authorization Required');
	header('WWW-Authenticate: Basic realm="Restricted access"');
	print "Access denied";
	#print_r( $_SERVER );
	return;
}




//$accept = isset( $_REQUEST['accept'] ) ? (bool)$_REQUEST['accept'] : false; 

function to_csv($s) {
//  $s = '"'. $s;
  $s = str_replace('"', '""', $s);
  $s = '"'. $s .'"';
  return $s;
}

//if($result = pg_query("SELECT * FROM ipacs_member")) {
//if($result = pg_query("SELECT * from userpin limit 10")) {
//if($result = pg_query("SELECT * from title")) {
//if($result = pg_query("SELECT * FROM (ipacs_member as m inner join userpin as u on m.userpin=u.pin) left join title as t on u.title=t.titleid")) {
if($result = pg_query("SELECT u.pin, t.shortstr as title, u.fname, u.lname, c.name as country, u.email, m.addtime as since FROM ((ipacs_member as m inner join userpin as u on m.userpin=u.pin) left join country as c on u.country=c.cid) left join title as t on u.title=t.titleid order by since")) {
//  print pg_num_rows($result) . "\n";
  while( $row = pg_fetch_assoc($result) ) {
//    print_r($row);
    $resarr = array();
    foreach($row as $e) {
      $resarr[] = to_csv($e);
    }
    print join(',', $resarr) ."\n";
  }
}



?>
