<?

function paper_fileName( $context, $papid ) {
  return $GLOBALS['papersdir']."/c".$context."p".$papid;
}


function paper_getFileTime( $context, $papid ) {
  $filename = paper_fileName( $context, $papid );
  if ( file_exists( $filename ) )
    return date( "d.m.y", filemtime( $filename ) );
}

function paper_getFileTimeEx( $context, $papid ) {
  $filename = paper_fileName( $context, $papid );
  if ( file_exists( $filename ) )
    return date( "d.M.y H:i:s", filemtime( $filename ) );
}

function existspin($pin) {
  $rez = false;
  if( is_numeric($pin) ) {
    $result = pg_query("SELECT count(*) FROM userpin WHERE pin='$pin'");
    if ( $row = pg_fetch_array($result) )
      if ( $row[0] > 0 )
        $rez = true;
  }
  return $rez;
}

function getUserName($pin) {
  $rez = "";
  if( is_numeric($pin) ) {
    $result = pg_query("SELECT t.shortstr || ' ' || u.fname || ' ' || u.lname FROM userpin AS u LEFT JOIN title AS t ON u.title=t.titleid WHERE u.pin='$pin'");
    if ( $row = pg_fetch_array($result) )
      $rez = $row[0];
  }
  return $rez;
}



?>