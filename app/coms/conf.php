<?

$PARTID = 'conf';

include_once("start.php");

include_once("contstatus.php");

include_once("papfuncs.php");


// ----------------------------------------------

// Если скрипт вызван без "/" - добавить его и 
// переадресовать - как будто это подкаталог

$confpath = getenv('PATH_INFO');



// echo("-----------------");
// echo($confpath);
// echo("-----------------");

// phpinfo();
// exit();


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

// Разбор пути, выделение номера контекста 
// и имени документа или скрипта

$fpath = substr( $confpath, 1 );

$CURRENTCONT = 0;
$CURRENTCONTTITLE = "";
$CURRENTCONTSHORTTITLE = "";
$CURRENTCONTURL = "";
$CURRENTCONTEMAIL = "";
$CURRENTCONTSUBTITLE = "";
$confnum = 0;
//$docname = "";
$docname = 'index';
$scriptname = '';



$PAGEBODY = "";


if ( preg_match("/^(\d+)\/(.*)\.html$/", $fpath, $lst) ) {
  // Задан номер контекста и имя HTML-страницы
  $confnum = $lst[1];
  $docname = $lst[2];
} else if ( preg_match("/(.*)\.html$/", $fpath, $lst) ) {
  // Задано имя HTML-страницы без номера контекста
//  $docname = $lst[1];
} else if ( preg_match("/^(\d+)\/$/", $fpath, $lst) ) {
  // Задан номер контекста со слэшем (как подкаталог),
  // без имени документа. Требуется документ по умолчанию - "index"
  $confnum = $lst[1];
//  $docname = 'index';
} else if ( preg_match("/^(\d+)$/", $fpath, $lst) ) {
  // Задан номер контекста без слэша, надо переадресовать
//  $confnum = $lst[1];
  $url = $sername.$requri.'/';
  header("Location: http://$url");
  header("Content-type: text/html");
  exit(0);
} else if ( preg_match("/^(\d+)\/(.*)\.php$/", $fpath, $lst) ) {
  // Задан номер контекста и имя PHP-скрипта
  $confnum = $lst[1];
  $scriptname = $lst[2];
} else if ( $fpath=="" ) {
//  $docname = 'index';
}

// ----------------------------------------------

// Извлечение информации о текущем контексте

if( $confnum > 0 ) {
  $result = pg_query("SELECT * FROM context WHERE contid=$confnum");
  if( $row = pg_fetch_array($result) ) {
    $CURRENTCONT = $row['contid'];
    $CURRENTCONTTITLE = $row['title'];
    $CURRENTCONTSHORTTITLE = $row['shorttitle'];
//    $CURRENTCONTURL = $row['url'];
    $CURRENTCONTURL = $row['homepage'];
    $CURRENTCONTEMAIL = $row['email'];
    $CURRENTCONTSUBTITLE = "('$CURRENTCONTTITLE' is selected)";
    $REVIEWDEADLINE = $row['review_deadline'];
  }
	if( isset( $FILE_UPLOADED_LOG_EMAIL_PART[$CURRENTCONT] ) )
		$FILE_UPLOADED_LOG_EMAIL = $FILE_UPLOADED_LOG_EMAIL_PART[$CURRENTCONT];
	if( isset( $FROMEMAIL_PART[$CURRENTCONT] ) )
		$FROMEMAIL = $FROMEMAIL_PART[$CURRENTCONT];
}

// ----------------------------------------------

// Отображение заголовка раздела "Конференции"

//<center><span class=ptitle>$CURRENTCONTTITLE / My virtual office</span></center>
if($CURRENTCONT)
  $BODY0 = <<<ENDTEXT
<center><span class=ptitle>$CURRENTCONTSHORTTITLE / My virtual office</span></center>
<p>

ENDTEXT;
else {
}

/*
  $BODY0 = <<<ENDTEXT
<center><span class=ptitle>Conferences</span></center>

ENDTEXT;
*/

$PERMISSIONS = array();
$issubjman = "";
$iseditor = "";
$isreviewer = "";
$ispapreg = "";
$EDITORID = 0;

if( $CURRENTCONT > 0 ) {
  // Чтение списка разрешений
  $result = pg_query("
SELECT p.*, p1.* 
FROM permission AS p INNER JOIN cont_perm AS p1 ON p.permid=p1.permission AND p1.context=$CURRENTCONT 
ORDER BY p.name;
");
  while( $row = pg_fetch_array($result) ) {
    $PERMISSIONS[$row['name']] = $row['value']=='t'?true:false;
  }

  // Чтение списка тем (секций)
  $SUBJECTS = array(0 => 'Uncertain');
  $result = pg_query("SELECT * FROM subject WHERE context='$CURRENTCONT' ORDER BY isinvited, title;");
  while( $row = pg_fetch_array($result) ) {
    $SUBJECTS[$row['subjid']] = $row['isinvited']=='t'?"INVITED: ".$row['title']:$row['title'];
  }


  // Является ли пользователь менеджером каких-либо тем в данном контексте?
  if( $USERPIN ) {
    $result = pg_query("SELECT COUNT(*) FROM subject WHERE context='$CURRENTCONT' AND manager='$USERPIN'");
    if( $row = pg_fetch_array($result) ) {
      if( $row[0]>0 )
        $issubjman = 1;
    }
  }

  // Является ли пользователь регистратором каких-либо статей в данном контексте?
  if( $USERPIN ) {
    $result = pg_query("SELECT COUNT(*) FROM paper WHERE context='$CURRENTCONT' AND registrator='$USERPIN'");
    if( $row = pg_fetch_array($result) ) {
      if( $row[0]>0 )
        $ispapreg = 1;
    }
  }

  // Является ли пользователь едитором в данном контексте?
  if( $USERPIN ) {
    $result = pg_query("SELECT editorid FROM editor WHERE userpin='$USERPIN' AND context=$CURRENTCONT");
    if( $row = pg_fetch_array($result) ) {
      $EDITORID = $row[0];
      $iseditor = 1;
    }
  }

  // Является ли пользователь ревьювером в данном контексте?
  if( $USERPIN ) {
    $result = pg_query("
SELECT COUNT(*)
FROM 
  subjectreview AS sr 
   INNER JOIN 
    subject AS s ON sr.subjid=s.subjid AND sr.revpin='$USERPIN' AND s.context=$CURRENTCONT
");
    if( $row = pg_fetch_array($result) ) {
      if( $row[0] > 0 )
        $isreviewer = 1;
    }
    $result = pg_query("SELECT COUNT(*) FROM review WHERE revpin='$USERPIN' AND context=$CURRENTCONT");
    if( $row = pg_fetch_array($result) ) {
      if( $row[0] > 0 )
        $isreviewer = 1;
    }
  }





  // Открытие запрошенной страницы или скрипта
  if ( $scriptname ) {
    $filename = "confdata/".$scriptname.".php";
    $filename2 = "contmandata/".$scriptname.".php";
    if( file_exists($filename) ) {
      include_once($filename);
      include_once("finish1.php");
      exit(0);
    }
    // Allows to editors view manager's reports
    else if( file_exists($filename2) && strpos($scriptname, "rep_")===0 && $iseditor ) {
      include_once($filename2);
      include_once("finish1.php");
      exit(0);
    }
    else {
      $ERROR404 = true;
    }

  } else if ( $docname ) {
    $filename = "confdata/".$docname.".html";
    if( file_exists($filename) )
      include_once($filename);
    else {
      $ERROR404 = true;
    }
  }

  // Чтение и отображение меню пользователя в текущей конференции
  include_once("confdata/submenu.php");

  $BODY0 .= make_menu($SUBMENU, $PAGEID);

} else {

  // Контекст не задан, пользователь должен выбрать его из списка

  $BODY0 = <<<ENDTEXT

ENDTEXT;

  $PAGEBODY .= <<<ENDTEXT
<center><span class=ptitle>Conferences</span></center>
<p>

ENDTEXT;

  $PAGEBODY .= <<<PAGEBODY
<ul>

PAGEBODY;

  $result = pg_query("SELECT * FROM context WHERE status>100 and cont_type=1 ORDER BY contid DESC;");
  while( $row = pg_fetch_array($result) ) {

    $ctitle1 = htmlspecialchars($row['title']);
    $chomepage1 = htmlspecialchars($row['homepage']);
    $cdescr1 = nl2br( htmlspecialchars($row['description']) );

    $PAGEBODY .= <<<PAGEBODY
<li>
<!-- a href="{$ROOT}conf/$row[contid]/"><b>$ctitle1</b></a> ({$CONTSTATUS[$row['status']]})<br -->
<b>$ctitle1 / <a href="{$ROOT}conf/$row[contid]/">My virtual office</a></b><br />
Home page (not for submission, info only): <a target=_blank href="$row[homepage]">$row[homepage]</a>
<br>
$cdescr1
<p>
</li>
PAGEBODY;
  }

  $PAGEBODY .= <<<PAGEBODY
</ul>

PAGEBODY;


  $PAGEBODY .= <<<ENDTEXT
<center><span class=ptitle>Archives</span></center>
<p>

ENDTEXT;

  $PAGEBODY .= <<<PAGEBODY
<ul>

PAGEBODY;

  $result = pg_query("SELECT * FROM context WHERE status>100 and cont_type=2 ORDER BY contid DESC;");
  while( $row = pg_fetch_array($result) ) {

    $ctitle1 = htmlspecialchars($row['title']);
    $chomepage1 = htmlspecialchars($row['homepage']);
    $cdescr1 = nl2br( htmlspecialchars($row['description']) );

    $PAGEBODY .= <<<PAGEBODY
<li>
<!-- a href="{$ROOT}conf/$row[contid]/"><b>$ctitle1</b></a> ({$CONTSTATUS[$row['status']]})<br -->
<b>$ctitle1 / <a href="{$ROOT}conf/$row[contid]/">My virtual office</a></b><br />
Home page (not for submission, info only): <a target=_blank href="$row[homepage]">$row[homepage]</a>
<br>
$cdescr1
<p>
</li>
PAGEBODY;
  }

  $PAGEBODY .= <<<PAGEBODY
</ul>

PAGEBODY;


}


// Окончательное формирование страницы для отображения
$PAGEBODY = <<<ENDTEXT
$BODY0
$PAGEBODY
ENDTEXT;


include_once("finish.php");

?>
