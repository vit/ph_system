<?
//$PAGEID = 'papers';

  $PAGEBODY .= <<<PAGEBODY
<br>
<center><span class=subtitle>Context: $CURRENTCONTTITLE</span></center>
<br>
<center><span class=subtitle>Report: Files with mtime</span></center>
<p>

PAGEBODY;



$cellclass1 = "cell1";
$cellclass2 = "cell2";
$cellclass = $cellclass1;

$PAGEBODY .= <<<PAGEBODY
<center>

<table align=center wwidth=100% border=1>
<tr class=$cellclass2 aalign=left>
<th width=1 rowspan=1>ID</th>
<th>Title</th>
<th>Registrator</th>
<th>File</th>
<th>File mtime</th>
</tr>

PAGEBODY;

  $result = pg_query("
SELECT
  p.*,
--  concatpaperauthors(p.context, p.papnum) AS authorswithpin,
--  concatpaperkeywords(p.context, p.papnum, 3) AS keywords1,
--  concatpaperkeywords(p.context, p.papnum, 2) AS keywords2,
--  r.revpin AS revpin, r.score AS r_score, r.subject AS r_subject, r.ipccomments AS r_ipccomments, r.authcomments AS r_authcomments, r.recommendation AS r_recommendation,
  getfullnamewithpin(p.registrator) AS registratorname
FROM 
  paper AS p
  WHERE p.context=$CURRENTCONT
ORDER BY p.papnum
");

$revcnt = 0;
$papid0 = 0;

  while( $row = pg_fetch_array($result) ) {
    $papid = $row['papnum'];
    $ctitle1 = htmlspecialchars($row[title]);
//    $cauthors1 = $row['authors'];
//    $cauthors2 = $row['authorswithpin'];
//    $ckeywords1 = $row['keywords1'];
//    $ckeywords2 = $row['keywords2'];

//    $subject1 = (int)$row['subject'];
//    $subject1_str = $SUBJECTS[$subject1];

//    $cabstract1 = nl2br( htmlspecialchars($row[abstract]) );
    $registratorname = $row['registratorname'];
//    $editorname = $row['editorname'];

//    $ed_subject = (int)$row['ed_subject'];
//    $ed_subject_str = $SUBJECTS[$ed_subject];

//    $ed_score = (int)$row['ed_score'];
//    $ed_score_str = $SCORES[$ed_score];

//    $ed_decision = (int)$row['ed_recommendation'];
//    $ed_decision_str = $EDITORPAPERDECISIONS[$ed_decision];


//    $cipccomments = nl2br( htmlspecialchars($row[ed_ipccomments]) );
//    $cauthcomments = nl2br( htmlspecialchars($row[ed_authcomments]) );

//    $r_subject = (int)$row['r_subject'];
//    $r_subject_str = $SUBJECTS[$r_subject];

//    $r_score = (int)$row['r_score'];
//    $r_score_str = $SCORES[$r_score];

//    $r_decision = (int)$row['r_recommendation'];
//    $r_decision_str = $REVIEWERPAPERDECISIONS[$r_decision];

//    $rcipccomments = nl2br( htmlspecialchars($row[r_ipccomments]) );
//    $rcauthcomments = nl2br( htmlspecialchars($row[r_authcomments]) );


//    $fin_subject = (int)$row['finalsubject'];
//    $fin_subject_str = $SUBJECTS[$fin_subject];

    $fin_decision = (int)$row['finaldecision'];
    $fin_decision_str = $FINALPAPERDECISIONS[$fin_decision];


    $filename = $papersdir."/c".$CURRENTCONT."p".$row[papnum];
    $ftime = '';
    if ( file_exists($filename) ) {
      $filetext = "Yes";
      $ftime = date ("Y-m-d H:i:s.", filemtime($filename) );
    } else
      $filetext = "No";

    $PAGEBODY .= <<<PAGEBODY
<tr class=$cellclass>
<td align=center rowspan=1>
  <a href="{$ROOT}paperinfo/c{$CURRENTCONT}p{$papid}r{$row[registrator]}.html" title="Paper information"
    onClick="window.open('{$ROOT}paperinfo/c{$CURRENTCONT}p{$papid}r{$row[registrator]}.html', '', 'location=no, menubar=no, toolbar=no, statusbar=no, scrollbars=yes, width=620, height=550, resizable=yes'); return false;"
  >[&nbsp;$papid&nbsp;]</a>
</td>
<td>$ctitle1</td>
<td align=center>$registratorname</td>
<td align=center>
  $filetext
</td>
<td align=center>
  $ftime
</td>
</tr>

PAGEBODY;

    $cellclass1 = $cellclass2;
    $cellclass2 = $cellclass;
    $cellclass = $cellclass1;

  }


$PAGEBODY .= <<<PAGEBODY
</table>

PAGEBODY;





$PAGEBODY .= <<<PAGEBODY
<br>
</center>

PAGEBODY;


?>