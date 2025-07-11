<?

$PAGEBODY .= <<<PAGEBODY
<font size="+2"><b>CoMS Admin</b></font>

PAGEBODY;


$menuarr = array();
$menuarr[] = array('id'=> 'main', 'href'=> "$root", 'title'=> "Main");

$menuarr[] = array('id'=> 'countries', 'href'=> "{$root}countries.html", 'title'=> "Countries");
$menuarr[] = array('id'=> 'users', 'href'=> "{$root}users.html", 'title'=> "Users");
$menuarr[] = array('id'=> 'mailcenter', 'href'=> "{$root}mailcenter.html", 'title'=> "Mail center");

//$menuarr[] = array(id=> editors, href=> "{$root}conf/editors.html", title=> "Editors");
//$menuarr[] = array(id=> contexts, href=> "{$root}conf/contexts.html", title=> "Contexts");
$menuarr[] = array('id'=> 'allkeywords', 'href'=> "{$root}allkeywords.html", 'title'=> "All keywords");
$menuarr[] = array('id'=> 'allpermissions', 'href'=> "{$root}allpermissions.html", 'title'=> "All permissions");
$menuarr[] = array('id'=> 'contexts', 'href'=> "{$root}contexts.html", 'title' => "Contexts");



$PAGEBODY .= <<<PAGEBODY
<table border=1 bgcolor="#cccccc" wwidth=100% cellpadding=2>
PAGEBODY;

foreach($menuarr as $row) {
  if($row['id']==$pageid) $bgcolor = "#eeeeee"; else $bgcolor = "#cccccc";
  $PAGEBODY .= <<<PAGEBODY
<td wwidth=80 align=center bgcolor="$bgcolor"><a href="$row[href]">$row[title]</a></td>
PAGEBODY;
}

$PAGEBODY .= <<<PAGEBODY
<!-- td align=center bgcolor="#ffffcc"><a href="pg/" target=_blank>>>> pgSQL</a></td>
<td align=center bgcolor="#ffffcc"><a href="http://cms.physcon.ru/admin/" target=_blank>>>> CMS</a></td -->
</table>
PAGEBODY;


?>