<?


// phpinfo();


$PARTID = 'contman';

include_once("start.php");

include_once("contstatus.php");

include_once("papfuncs.php");


// ----------------------------------------------

// ���� ������ ������ ��� "/" - �������� ��� � 
// �������������� - ��� ����� ��� ����������

$confpath = getenv('PATH_INFO');

$requri = getenv('REQUEST_URI');
$sername = getenv('SERVER_NAME');

if ( strlen($confpath) == 0 ) {
  $url = $sername.$requri.'/';
//  header("Status: 302 Moved Temporarily");
//  header("Status: 301 Moved Permanently");
  header("Location: http://$url");
  header("Content-type: text/html");
  print <<<TEXT
<html>
<body>
  <a href="http://$url">http://$url</a>
</body>
</html>
TEXT;
  exit(0);
}

// ----------------------------------------------

// ������ ����, ��������� ������ ��������� 
// � ����� ��������� ��� �������

$fpath = substr( $confpath, 1 );

$CURRENTCONT = 0;
$CURRENTCONTTITLE = "";
$CURRENTCONTSUBTITLE = "";
$CURRENTCONTMANAGER = 0;
$CURRENTCONTURL = "";
$confnum = 0;
//$docname = "";
$docname = 'index';
$scriptname = '';


if ( preg_match("/^(\d+)\/(.*)\.html$/", $fpath, $lst) ) {
  $confnum = $lst[1];
  $docname = $lst[2];
} else if ( preg_match("/(.*)\.html$/", $fpath, $lst) ) {
//  $docname = $lst[1];
} else if ( preg_match("/^(\d+)\/$/", $fpath, $lst) ) {
  $confnum = $lst[1];
//  $docname = 'index';
} else if ( preg_match("/^(\d+)$/", $fpath, $lst) ) {
//  $confnum = $lst[1];
  $url = $sername.$requri.'/';
  header("Location: http://$url");
  header("Content-type: text/html");
  exit(0);
} else if ( preg_match("/^(\d+)\/(.*)\.php$/", $fpath, $lst) ) {
  $confnum = $lst[1];
  $scriptname = $lst[2];
} else if ( $fpath=="" ) {
//  $docname = 'index';
}

// ----------------------------------------------

// ���������� ���������� � ������� ���������

if( $confnum > 0 ) {
  $result = pg_query("SELECT * FROM context WHERE contid=$confnum");
  if( $row = pg_fetch_array($result) ) {
    $CURRENTCONT = $row['contid'];
    $CURRENTCONTTITLE = $row['title'];
    $CURRENTCONTSUBTITLE = "('$CURRENTCONTTITLE' is selected)";
    $CURRENTCONTMANAGER = $row['manager'];
    $CURRENTCONTURL = $row['homepage'];
  }
}


if( $CURRENTCONT > 0 ) {
  // ������ ������ ��� (������)
  $SUBJECTS = array(0 => 'Uncertain');
  $result = pg_query("SELECT * FROM subject WHERE context='$CURRENTCONT' ORDER BY isinvited, title;");
  while( $row = pg_fetch_array($result) ) {
    $SUBJECTS[$row[subjid]] = $row[isinvited]=='t'?"INVITED: ".$row[title]:$row[title];
  }
}


// ��������� ���� ������������ �� ������� ��������
$iscurrentcontman = "";
if($USERPIN && $USERPIN==$CURRENTCONTMANAGER)
  $iscurrentcontman = 1;


// ----------------------------------------------

$BODY0 = <<<ENDTEXT
<center><span class=ptitle>Manager office $CURRENTCONTSUBTITLE</span></center>

ENDTEXT;

// �����: ��� ������ ���������� � ������������ 
// � �������� ����������� � �������

if( $iscurrentcontman ) {
  // ���� �������� ����� � ������������ 
  // ����� ����� ��������� �� - ������
  // ��������� �������� � �������

/*
  if ( $scriptname ) {
    include_once("contmandata/".$scriptname.".php");
  } else if ( $docname ) {
    include_once("contmandata/".$docname.".html");
  }
*/

  // �������� ����������� �������� ��� �������
  if ( $scriptname ) {
    $filename = "contmandata/".$scriptname.".php";
    if( file_exists($filename) ) {
      include_once($filename);
      include_once("finish1.php");
      exit(0);
    }
    else {
      $ERROR404 = true;
    }
  } else if ( $docname ) {
    $filename = "contmandata/".$docname.".html";
    if( file_exists($filename) )
      include_once($filename);
    else {
      $ERROR404 = true;
    }
  }




  include_once("contmandata/submenu.php");

  $BODY0 .= make_menu($SUBMENU, $PAGEID);

/*
  $BODY0 .= <<<ENDTEXT
<table wwidth=100% cellpadding=2 cellspacing=2>
<td><b>&rarr;</b></td>

ENDTEXT;

  foreach($SUBMENU as $item) {
    if($item['id'] == $PAGEID)
      $BODY0 .=  <<<ENDTEXT
<td style="border: solid #000000; border-width: 1px;"><b>&darr; <a href="{$item['url']}">{$item['title']}</a></b></td>

ENDTEXT;
    else
      $BODY0 .=  <<<ENDTEXT
<td><b>&#149; <a href="{$item['url']}">{$item['title']}</a></b></td>

ENDTEXT;
  }

  $BODY0 .= <<<ENDTEXT
</table>

ENDTEXT;
*/


} else if( $iscontman ) {
  // ���� �������� �� ����� ��� ������������ 
  // ����� ����� �� ���������� �����-�� ������ 
  // ���������� - ������ ������ ����������

  $PAGEBODY .= <<<PAGEBODY
<ul>

PAGEBODY;

  $result = pg_query("SELECT * FROM context WHERE manager='$USERPIN' ORDER BY contid DESC;");
  while( $row = pg_fetch_array($result) ) {

    $ctitle1 = htmlspecialchars($row['title']);
    $chomepage1 = htmlspecialchars($row['homepage']);
    $cdescr1 = nl2br( htmlspecialchars($row['description']) );

//Description: $cdescr1
//<br>

    $PAGEBODY .= <<<PAGEBODY
<li>
<a href="{$ROOT}contman/$row[contid]/"><b>$ctitle1</b></a><br>
Home page:  <a target=_blank href="$row[homepage]">$row[homepage]</a>
<p>
</li>

PAGEBODY;
  }

  $PAGEBODY .= <<<PAGEBODY
</ul>

PAGEBODY;

} else {
  // ������������ �� ��������������� ��� �� ����� �����
  // �� ���������� �����-���� ����������

  $PAGEBODY = <<<PAGEBODY
<p>

To manage the conference you have to have manager rights.

<br>

PAGEBODY;

}

// ----------------------------------------------

$PAGEBODY = <<<ENDTEXT
$BODY0
<p>
$PAGEBODY

ENDTEXT;


include_once("finish.php");

?>
