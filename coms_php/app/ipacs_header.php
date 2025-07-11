
<?php function render_login() { ?>
<?

global $USERPIN, $JUSTLOGGED, $USERTITLE, $USERERROR, $MEMBERTEXT, $IS_MEMBER, $LOGONFORM, $LOGOUTFORM, $USERERROR;

if( $USERPIN ) {

  if( isset($JUSTLOGGED) )
    $USERERROR = "Welcome $USERTITLE!<br>You are logged in.";

  $MEMBERTEXT = "";
  if( $IS_MEMBER ) {
  	$MEMBERTEXT = ", IPACS member";
  }

  print <<<ENDTEXT
<div class=userwelcome style="color: white; background-color: transparent;">
Welcome <span class=username style="color: white; background-color: transparent;">$USERTITLE</span><span class=name style="color: white; background-color: transparent;">$MEMBERTEXT</span>, PIN: <span class=name style="color: white; background-color: transparent;">$USERPIN</span>
</div>

<form style="margin: 0; color: white; background-color: transparent;" method=post action="">
<input class=logonbutton type=submit name="logout" value="logout" style="color: white; border-color: white; background-color: transparent;">
</form>

ENDTEXT;

} else {
?>

<form style="margin: 0; color: white; background-color: transparent;" method=post action="">
PIN:
<input class=logoninput type=text name=log_pin size=6 style="color: white; border-color: white; background-color: transparent;">
Password:
<input class=logoninput type=password name=log_pass size=6 style="color: white; border-color: white; background-color: transparent;">
<input class=logonbutton type=submit name="login" value="login" style="color: white; border-color: white; background-color: transparent;">
</form>

<?php
  if ( $USERERROR ) {
  }
}
?>
<?php } ?>










<?php function render_top_menu_block() { ?>
    <?php
        $IPACS_DOMAIN_NAME = $_SERVER["IPACS_DOMAIN_NAME"];
        $COMS_DOMAIN_NAME = $_SERVER["COMS_DOMAIN_NAME"];
        $CAP_DOMAIN_NAME = $_SERVER["CAP_DOMAIN_NAME"];
        $LIB_DOMAIN_NAME = $_SERVER["LIB_DOMAIN_NAME"];
        $CONF_DOMAIN_NAME = $_SERVER["CONF_DOMAIN_NAME"];
        $ALBUM_DOMAIN_NAME = $_SERVER["ALBUM_DOMAIN_NAME"];

        $ipacs_menu = [
            ['id' => "ipacs", 'name' => "IPACS Home", 'url' => "http://$IPACS_DOMAIN_NAME"],
            ['id' => "coms", 'name' => "CoMS", 'url' => "http://$COMS_DOMAIN_NAME"],
            ['id' => "cap", 'name' => "CAP Journal", 'url' => "http://$CAP_DOMAIN_NAME"],
            ['id' => "lib", 'name' => "Library", 'url' => "http://$LIB_DOMAIN_NAME"],
            ['id' => "conferences", 'name' => "Conferences", 'url' => "http://$CONF_DOMAIN_NAME"],
            ['id' => "album", 'name' => "Album", 'url' => "http://$ALBUM_DOMAIN_NAME"]
        ];
    ?>

    <div class="" style="background-color: #fff;">
        <nav class="" style="">
            <div style="display: flex; justify-content: space-between; margin-right: auto; margin-left: auto; align-items: center;">
                <div style="display: flex; align-items: center;">
                    <ul style="margin: 10px; padding-left: 0;">
                        <?php foreach($ipacs_menu as $elm) { ?>
                            <?php
                                $bg_style = 'coms' == $elm['id'] ? "background-color: #357edd;" : "";
                                $text_style = 'coms' == $elm['id'] ? "color: rgba(255, 255, 255, .9);" : "color: rgba(0, 0, 0, .9);";
                        
                            ?>
                            <li style="margin: 0px; padding: 10px; display: inline-block; font-weight: 400; font-size: 1.25rem; <?= $bg_style ?>">
                                <a href="<?= $elm['url'] ?>" 
                                    style="text-decoration: none; font-size: 1.25rem; background-color: transparent; <?= $text_style ?>"><?= $elm['name'] ?>
                                </a>
                            </li>
                        <?php } ?>
                    </ul>
                </div>
            </div>
        </nav>
    </div>
<?php } ?>


<?php function render_title_block() { ?>
    <div class="" style="background-color: #357edd;">
        <nav class="" style="padding-left: 2rem; padding-right: 2rem; padding-top: 1rem; padding-bottom: 1rem; background-color: #357edd;">
            <div style="display: flex; justify-content: space-between; margin-right: auto; margin-left: auto; align-items: center; background-color: #357edd;">
                <a href="/" style="font-size: 1.5rem; text-decoration: none; font-weight: 200; display: inline-block; color: rgba(255, 255, 255, .9); background-color: transparent;">
                    Conference Management System (CoMS)
                </a>
                <span style="background-color: transparent;">
                    <?php render_login(); ?>
                </span>
            </div>
        </nav>
    </div>
<?php } ?>





<header style="margin-bottom: 1rem;">
    <?php render_top_menu_block(); ?>
    <?php render_title_block(); ?>
</header>
