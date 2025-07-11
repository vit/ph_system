<?

include_once("start.php");

$PATH_INFO = getenv(PATH_INFO);
//preg_match('|(.*)/c(\d*)p(\d*)r(\d*)\.(.*)|', $PATH_INFO, $list);
preg_match('|/c(\d*)p(\d*)r(\d*)\.html|', $PATH_INFO, $list);

$context = (int)$list[1];
$papid = (int)$list[2];
$regpin = (int)$list[3];


$PAPID = 0;
$CONTEXT = 0;

$result = pg_query("SELECT * FROM paper WHERE context=$context AND papnum=$papid AND registrator=$regpin");
if( $row = pg_fetch_array($result) ) {
  $PAPID = $row['papnum'];
  $CONTEXT = $row['context'];
}







if( $PAPID && $CONTEXT ) {

  $result = pg_query("
SELECT p.*, t.shortstr || ' ' || u.fname || ' ' || u.lname AS registratorname, c.name AS registratorcountry, ct.title AS conttitle
FROM 
  (((paper AS p LEFT JOIN userpin AS u ON p.registrator=u.pin) 
  LEFT JOIN title AS t ON u.title=t.titleid)
  LEFT JOIN country AS c ON u.country=c.cid)
  INNER JOIN context AS ct ON p.context=ct.contid
WHERE p.context=$CONTEXT AND p.papnum=$PAPID
");

  if( $row = pg_fetch_array($result) ) {
    $PAPID = $row['papnum'];
    $papinfo = $row;
  }

}


if( $PAPID ) {

  $kw1 = array(); $kw2 = array();
  $result = pg_query("
SELECT pk.*, k.*
FROM pap_kw AS pk INNER JOIN keyword AS k 
    ON pk.context=$CONTEXT AND pk.papnum=$PAPID AND pk.keyword=k.kwid
ORDER BY k.name
");
  while( $row = pg_fetch_array($result) ) {
    if ($row[weight]==3)
      $kw1[] = $row[name];
    else if ($row[weight]==2)
      $kw2[] = $row[name];
  }
  $MAINKWD = join(", ", $kw1);
  $SECONDKWD = join(", ", $kw2);





  $AUTHORS = <<<AUTHORS
  <table width="99%" border=1>
  <tr>
    <th rowspan=2>PIN</th>
    <th>Title</th>
    <th>Last Name</th>
    <th>First Name</th>
    <th>Country</th>
  </tr>
  <tr>
    <th colspan=4>Organization</th>
  </tr>

AUTHORS;

  $result = pg_query("
SELECT a.*, u.*, t.shortstr AS usertitle, c.name AS countryname
FROM
  ((author AS a LEFT JOIN userpin AS u ON a.autpin=u.pin) 
  LEFT JOIN title AS t ON u.title=t.titleid)
  LEFT JOIN country AS c ON u.country=c.cid
WHERE a.context=$CONTEXT AND a.papnum=$PAPID
ORDER BY u.pin
");
  while( $row = pg_fetch_array($result) ) {

    $AUTHORS .= <<<AUTHORS
    <tr>
      <td rowspan=2 align=center>$row[pin]</td>
      <td>$row[usertitle]</td>
      <td>$row[lname]</td>
      <td>$row[fname]</td>
      <td>$row[countryname]</td>
    </tr>
    <tr>
      <td colspan=4>$row[affiliation]</td>
    </tr>
AUTHORS;


  }

  $AUTHORS .= <<<AUTHORS
  </table>
AUTHORS;

} else {
  header("HTTP/1.0 404 Not Found");
//  header("Status: 404 Not Found");
  exit(0);
}


$ctitle1 = htmlspecialchars($papinfo['title']);
$cabstract1 = nl2br( htmlspecialchars($papinfo['abstract']) );
$cauthors_s1 = htmlspecialchars($papinfo['authors']);
$cconttitle1 = htmlspecialchars($papinfo['conttitle']);


//  $PAPERINFO = <<<PAPERINFO
  $PAGEBODY = <<<PAPERINFO

<center><H2>Paper information (Paper_ID: $PAPID) </H2></center>

<table cellspacing=0 cellpadding=12 width="99%" border=0>
  <tr>
    <th width="1%" align=left>Conference:</th>
    <td> $cconttitle1 </td>
  </tr>
  <tr>
    <th width="1%" align=left>Paper_ID:</th>
    <td> $PAPID </td>
  </tr>
  <tr>
    <th width="1%" align=left>Title:</th>
    <td> $ctitle1 </td>
  </tr>
  <tr>
    <th width="1%" align=left>Authors (text):</th>
    <td> $cauthors_s1 </td>
  </tr>
  <tr>
    <th width="1%" align=left>Registrator:</th>
    <td> PIN: $papinfo[registrator], $papinfo[registratorname] (From: $papinfo[registratorcountry]) </td>
  </tr>
  <tr>
    <th width="1%" align=left valign=top>Authors:</th>
    <td>

$AUTHORS

    </td>
  </tr>
  <tr>
    <th width="1%" align=left valign=top>Main keywords:</th>
    <td> $MAINKWD </td>
  </tr>
  <tr>
    <th width="1%" align=left valign=top>Secondary keywords:</th>
    <td> $SECONDKWD </td>
  </tr>

</table>
<br>
<strong>ABSTRACT:</strong> <em>$cabstract1</em>
<p>


PAPERINFO;

include_once("finish1.php");

?>