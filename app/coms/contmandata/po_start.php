<?
$PAGEID = 'postoffice';

  $PAGEBODY .= <<<PAGEBODY
<center><span class=subtitle>Post office</span></center>

PAGEBODY;

//  include_once("contmandata/po_menu.php");
  include_once("po_menu.php");

  $PAGEBODY .= make_menu($PO_SUBMENU, $SUBPAGEID);

?>