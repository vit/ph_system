<?
//$PAGEID = 'papers';

  $PAGEBODY .= <<<PAGEBODY
<br>
<center><span class=subtitle>Context: $CURRENTCONTTITLE</span></center>
<br>
<center><span class=subtitle>Report: Papers by registrator's countries</span></center>
<p>

PAGEBODY;






/*
  $result = pg_query("
SELECT p.*, r.score AS r_score, r.subject AS r_subject, r.ipccomments AS r_ipccomments, r.authcomments AS r_authcomments, r.recommendation AS r_recommendation,
  concatpaperauthors(p.context, p.papnum) AS authors,
  concatpaperkeywords(p.context, p.papnum, 3) AS keywords1,
  concatpaperkeywords(p.context, p.papnum, 2) AS keywords2,
  getfullnamewithpin(p.registrator) AS registratorname
FROM 
  review AS r 
    INNER JOIN paper AS p
      ON r.revpin=$USERPIN AND r.context=$CURRENTCONT AND r.papnum=p.papnum
ORDER BY p.papnum;
");
*/


  $result = pg_query("
SELECT
  p.*,
  c.name AS countrytitle,
  c.cid AS cid,
--  concatpaperauthors(p.context, p.papnum) AS authors,
  getfullnamewithpin(p.registrator) AS registratorname
FROM 
  (paper AS p LEFT JOIN userpin AS u ON p.registrator=u.pin)
    LEFT JOIN 
      country AS c ON u.country=c.cid
  WHERE p.context=$CURRENTCONT
ORDER BY c.cid, p.papnum
");


    $cellclass1 = "cell1";
    $cellclass2 = "cell2";
    $cellclass = $cellclass1;

    $ccountry0 = "";

    while( $row = pg_fetch_array($result) ) {
      $papid = $row['papnum'];
      $ctitle1 = htmlspecialchars($row[title]);
      $cauthors1 = $row['authors'];
      $ccountry1 = $row['countrytitle'];
      if( !$ccountry1 )
        $ccountry1 = "Uncertain";

      $registratorname = $row['registratorname'];

      if ( $ccountry0 != $ccountry1 ) {
        $PAGEBODY .= <<<PAGEBODY
<p>
 <b>$ccountry1</b>

PAGEBODY;
        $ccountry0 = $ccountry1;
      }

      $PAGEBODY .= <<<PAGEBODY
<div class=$cellclass>

 <b>&nbsp;&nbsp;ID:&nbsp;$papid</b>
<br>
 <b>Registrator:</b> $registratorname
<!-- br>
 <b>Country:</b> $ccountry1 -->
<br>
 <b>Title:</b> $ctitle1
<br>
 <b>Authors (text):</b> $cauthors1
<br>

</div>

PAGEBODY;

      $cellclass1 = $cellclass2;
      $cellclass2 = $cellclass;
      $cellclass = $cellclass1;
    }



    $PAGEBODY .= <<<PAGEBODY
<br>

PAGEBODY;











?>