<?

$contid = $_REQUEST['contid'];


$root1 = $root."conf/";
if( $contid ) {

  $result = pg_query("SELECT * FROM context WHERE contid=$contid");
  if( $row = pg_fetch_array($result) ) {
    $ctitle = $row['title'];
  }


$PAGEBODY .= <<<PAGEBODY
<font size="+2"><b>Selected context: $contid - $ctitle</b></font>

PAGEBODY;


  $menuarr = array();
  $menuarr[] = array('id'=> 'main', 'href'=> "$root1?contid=$contid", 'title'=> "Main");

  $menuarr[] = array('id'=> 'keywords', 'href'=> "{$root1}keywords.html?contid=$contid", 'title'=> "Keywords");
  $menuarr[] = array('id'=> 'permissions', 'href'=> "{$root1}permissions.html?contid=$contid", 'title'=> "Permissions");
  $menuarr[] = array('id'=> 'editors', 'href'=> "{$root1}editors.html?contid=$contid", 'title'=> "Editors");
  $menuarr[] = array('id'=> 'papers', 'href'=> "{$root1}papers.html?contid=$contid", 'title'=> "Papers");



  $PAGEBODY .= <<<PAGEBODY
<table border=1 bgcolor="#cccccc" wwidth=100% cellpadding=2>
PAGEBODY;

  foreach($menuarr as $row) {
    if($row['id']==$subpageid) $bgcolor = "#eeeeee"; else $bgcolor = "#cccccc";
    $PAGEBODY .= <<<PAGEBODY
<td wwidth=80 align=center bgcolor="$bgcolor"><a href="$row[href]">$row[title]</a></td>
PAGEBODY;
  }

  $PAGEBODY .= <<<PAGEBODY
</table>
PAGEBODY;

}

?>