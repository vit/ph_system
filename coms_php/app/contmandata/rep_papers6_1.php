<?
//$PAGEID = 'papers';

$decision = $_REQUEST[decision];
$decisiontitle = $FINALPAPERDECISIONS[$decision];


$decisioncond2 = "";
if(!$decision>0) {
  $decision=0;
  $decisioncond2 = "OR p.finaldecision IS NULL";
}


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


  $PAGEBODY .= <<<PAGEBODY
<br>
<center><span class=subtitle>Context: $CURRENTCONTTITLE</span></center>
<br>
<center><span class=subtitle>Report: Papers with final decision <i>"$decisiontitle"</i>,<br>ordered by subject, title, authors (with ID and registrator)<br>Found $n papers</span></center>
<p>

PAGEBODY;









$cellclass1 = "cell1";
$cellclass2 = "cell2";
$cellclass = $cellclass1;

  $result = pg_query("
SELECT
  p.*,
  s.title AS subjecttitle,
  u.pin AS apin, u.fname AS afname, u.lname AS alname,
  c.name AS acountry,
  getfullnamewopin(p.registrator) AS registratorname,
  concatpaperauthorswopin(p.context, p.papnum) AS authors
FROM 
  (((paper AS p LEFT JOIN subject AS s ON p.finalsubject=s.subjid)
  LEFT JOIN author AS a ON p.papnum=a.papnum AND p.context=a.context)
  LEFT JOIN userpin AS u ON a.autpin=u.pin)
  LEFT JOIN country AS c ON u.country=c.cid

  WHERE p.context=$CURRENTCONT AND (p.finaldecision=$decision $decisioncond2)
ORDER BY s.title, p.title, p.papnum, u.lname
");

  $subj0="";
  $papid0="";
  $aut0="";
  $autarr = array();

  while( $row = pg_fetch_array($result) ) {
    $papid = $row['papnum'];
    $ctitle1 = htmlspecialchars($row[title]);
    $cauthors1 = $row['authors'];
    $ckeywords1 = $row['keywords1'];
    $ckeywords2 = $row['keywords2'];
    $registratorname = $row['registratorname'];

    $apin1 = $row['apin'];
    $afname1 = $row['afname'];
    $alname1 = $row['alname'];
    $acountry1 = $row['acountry'];

    $subject1 = (int)$row['subject'];
    $subject1_str = $SUBJECTS[$subject1];

    $cabstract1 = nl2br( htmlspecialchars($row[abstract]) );
    $registratorname = $row['registratorname'];
    $editorname = $row['editorname'];

    $ed_subject = (int)$row['ed_subject'];
    $ed_subject_str = $SUBJECTS[$ed_subject];

    $ed_score = (int)$row['ed_score'];
    $ed_score_str = $SCORES[$ed_score];

    $ed_decision = (int)$row['ed_recommendation'];
    $ed_decision_str = $EDITORPAPERDECISIONS[$ed_decision];


    $cipccomments = nl2br( htmlspecialchars($row[ed_ipccomments]) );
    $cauthcomments = nl2br( htmlspecialchars($row[ed_authcomments]) );

    $r_subject = (int)$row['r_subject'];
    $r_subject_str = $SUBJECTS[$r_subject];

    $r_score = (int)$row['r_score'];
    $r_score_str = $SCORES[$r_score];

    $r_decision = (int)$row['r_recommendation'];
    $r_decision_str = $REVIEWERPAPERDECISIONS[$r_decision];

    $rcipccomments = nl2br( htmlspecialchars($row[r_ipccomments]) );
    $rcauthcomments = nl2br( htmlspecialchars($row[r_authcomments]) );


    $fin_subject = (int)$row['finalsubject'];
    $fin_subject_str = $SUBJECTS[$fin_subject];

    $fin_decision = (int)$row['finaldecision'];
    $fin_decision_str = $FINALPAPERDECISIONS[$fin_decision];



if($papid0 != $papid) {
  $autstr = join(", ", $autarr);
  $PAGEBODY .= <<<PAGEBODY
$autstr
<p>


PAGEBODY;
  $autarr = array();
}

if($apin1)
  $autarr[] = makeauthname($afname1, $alname1, $acountry1);


if($subj0 != $fin_subject_str) {
  $subj0 = $fin_subject_str;
    $PAGEBODY .= <<<PAGEBODY

<p>
<center><b>$fin_subject_str</b></center>
<p>


PAGEBODY;
}

if($papid0 != $papid) {
  $papid0 = $papid;
  $PAGEBODY .= <<<PAGEBODY
ID: $papid
<br>
$ctitle1
<br>
Registrator: $registratorname
<br>

PAGEBODY;
//a: $cauthors1<br>

}

    $cellclass1 = $cellclass2;
    $cellclass2 = $cellclass;
    $cellclass = $cellclass1;

  }


  $autstr = join(", ", $autarr);
  $PAGEBODY .= <<<PAGEBODY
$autstr
<p>


PAGEBODY;


function makeauthname($afname1, $alname1, $acountry1) {
 return "<b>$afname1 $alname1</b> (<i>$acountry1</i>)";
}



?>