<?

  $CONNECTIONERROR = false;
  for($i=0; $i<10; $i++) {
    $DBLINK = @pg_pconnect ("host=$HN dbname=$DN user=$UL password=$UP");
    if ( $DBLINK )
      break;
/*
    $lasterr = @pg_last_error();
    $lasterr1 = "cannot connect to PostgreSQL...";
    $ff = @fopen("err.txt", "a");
    if($ff) {
      @fwrite($ff, date("Y-m-d H:i:s", time()) ."\n" );
      @fwrite($ff, "last_error: ". $lasterr ."\n");
      @fwrite($ff, "last_error1: ". $lasterr1 ."\n\n");
      @fclose($ff);
    }
*/
    sleep(1);
  }

  if ( ! $DBLINK )
    $CONNECTIONERROR = true;

  $result = @pg_query("SET search_path = $SHEMA;");

?>
