<?
include_once("config.php");

$PAGEBODY = '';

  $DBLINK = pg_pconnect ("host=$HN dbname=$DN user=$UL password=$UP");
  $result = pg_query("SET search_path = $SHEMA;");

$TITLES = array();
$result = pg_query("SELECT * FROM title ORDER BY titleid;");
while( $row = pg_fetch_array($result) ) {
  $TITLES[$row['titleid']] = $row['shortstr'];
}


include_once("mainmenu.php");


?>
