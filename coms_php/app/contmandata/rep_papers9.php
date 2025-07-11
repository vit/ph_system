<?
//$PAGEID = 'papers';

  $PAGEBODY .= <<<PAGEBODY
<br>
<center><span class=subtitle>Context: $CURRENTCONTTITLE</span></center>
<br>
<center><span class=subtitle>Report: Number of papers from each country</span></center>
<p>

PAGEBODY;


  $result = pg_query("
SELECT
  count(p.*) as cnt,
  c.name AS countrytitle,
  c.cid AS cid
FROM 
  (paper AS p LEFT JOIN userpin AS u ON p.registrator=u.pin)
    LEFT JOIN 
      country AS c ON u.country=c.cid
  WHERE p.context=$CURRENTCONT
GROUP BY c.name, c.cid
ORDER BY c.name, c.cid
");

$n = 0;
    while( $row = pg_fetch_array($result) ) {
      $n++;
      $ccountry1 = $row['countrytitle'];
      $cnt = (int)$row['cnt'];
      if( !$ccountry1 )
        $ccountry1 = "Uncertain";
      $PAGEBODY .= <<<PAGEBODY
<br>&nbsp;{$n}. <b>$ccountry1</b> &mdash; $cnt

PAGEBODY;
        $ccountry0 = $ccountry1;
    }

    $PAGEBODY .= <<<PAGEBODY
<br>

PAGEBODY;





?>