<?
//$PAGEID = 'papers';


/*
  $n = 0;
  $result = pg_query("
SELECT
  COUNT(p.*)
FROM 
  paper AS p
  WHERE p.context=$CURRENTCONT AND (p.finaldecision=$decision $decisioncond2)
");
  if( $row = pg_fetch_array($result) ) {
    $n = $row[0];
  }
*/


  $PAGEBODY .= <<<PAGEBODY
<br>
<center><span class=subtitle>Context: $CURRENTCONTTITLE</span></center>
<br>
<center><span class=subtitle>Report: Conscientious reviewers</span></center>
<p>

PAGEBODY;


$revarr = array();

  $result = pg_query("
    SELECT DISTINCT
      u.pin AS pin, u.pass AS password,
      u.fname AS fname, u.lname AS lname,
      u.email AS email,
      t.shortstr AS usertitle,
      c.name AS countryname
    FROM 
      ((review AS r LEFT JOIN userpin AS u ON r.revpin=u.pin)
      LEFT JOIN title AS t ON u.title=t.titleid)
      LEFT JOIN country AS c ON u.country=c.cid
    WHERE r.context=$CURRENTCONT AND (r.score>0 OR r.recommendation>0)
    ORDER BY u.lname
");

  while( $row = pg_fetch_array($result) ) {
    $fname = $row['fname'];
    $lname = $row['lname'];
    $usertitle = $row['usertitle'];
    $countryname = $row['countryname'];
    $revarr[] = "$fname $lname";
  }

  $revlist = join(",\n", $revarr);

  $PAGEBODY .= <<<PAGEBODY

$revlist

<br>
<p>

PAGEBODY;




?>