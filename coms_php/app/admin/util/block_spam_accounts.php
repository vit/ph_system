<?php

include_once("start.php");

// $result = pg_query("SELECT COUNT(*) FROM userpin;");
// if( $row = pg_fetch_array($result) ) {
//   $totalquantity = $row[0];
// }


// $result = pg_query("SELECT count(*) as cnt FROM userpin where email LIKE 'testing@example.com';");
$result = pg_query("SELECT count(*) as cnt FROM userpin where email LIKE '%testing@example.com%' or phone LIKE '%555-666-0606%';");

if( $row = pg_fetch_array($result) ) {

  $n = $row['cnt'];
  print($n);
  print("\n");
  // print(" ");
}

//  $result = pg_query("SELECT * FROM userpin ORDER BY pin;");
$result = pg_query("SELECT * FROM userpin where email LIKE '%testing@example.com%' or phone LIKE '%555-666-0606%' order by pin;");

while( $row = pg_fetch_array($result) ) {

  $pin1 = $row['pin'];
  // $email1 = htmlspecialchars($row['email']);
  // print($pin1);
  // print(" ");

  $r = pg_query("UPDATE userpin SET enabled=FALSE WHERE pin='$pin1'");

}

print("\n");

?>
