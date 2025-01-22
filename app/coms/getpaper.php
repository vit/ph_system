<?

include_once("start.php");


$PATH_INFO = getenv(PATH_INFO);
preg_match('|/c(\d*)p(\d*)r(\d*)\.(.*)|', $PATH_INFO, $list);

$context = $list[1];
$papid = $list[2];
$regpin = $list[3];
$fileext = $list[4];
$filename = $papersdir."/c".$context."p".$papid;


$PAPID = 0;
$CONTEXT = 0;
$filet = "";

$result = pg_query("SELECT * FROM paper WHERE context=$context AND papnum=$papid AND registrator=$regpin");
if( $row = pg_fetch_array($result) ) {
  $PAPID = $row['papnum'];
  $CONTEXT = $row['context'];
  $filet = $row['filetype'];
}

if ( $filet && file_exists( $filename ) ) {
  header("Content-type: ".$filet);
  @readfile( $filename );
} else {

  header("HTTP/1.0 404 Not Found");

}

exit(0);

?>