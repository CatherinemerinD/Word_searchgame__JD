<!DOCTYPE html>
<html>
    <head>
        <title>WORD SEARCH</title>
        <link rel="stylesheet" href="css/reset.css" type="text/css">
        <link rel="stylesheet" href="css/main.css" type="text/css">
        <link rel="stylesheet" href="css/orientation_utils.css" type="text/css">
        <link rel='shortcut icon' type='image/x-icon' href='./favicon.ico' />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, minimal-ui" />
        <meta name="msapplication-tap-highlight" content="no"/>

        <script type="text/javascript" src="js/jquery-3.2.1.min.js"></script>
        <script type="text/javascript" src="js/easeljs-NEXT.min.js"></script>
        <script type="text/javascript" src="js/screenfull.min.js"></script>
        <script type="text/javascript" src="js/howler.min.js"></script>
        <script type="text/javascript" src="js/CLang.min.js"></script>
        <script type="text/javascript" src="js/main.js"></script>

    </head>
    <body ondragstart="return false;" ondrop="return false;" >
        <div style="position: fixed; background-color: transparent; top: 0px; left: 0px; width: 100%; height: 100%"></div>
        <script>
            $(document).ready(function () {
                var oMain = new CMain(
                        {
                            default_lang:"none",  //SET "none" TO SHOW LANGUAGE PANEL. SET ONE OF THESE VALUES TO START THE BOARD GAME WITH DEFAULT LANGUAGE:
                                                                                        //0 ENGLISH
                                                                                        //1 FRENCH
                                                                                        //2 GERMAN
                                                                                        //3 ITALIAN
                                                                                        //4 PORTUGUESE
                                                                                        //5 SPANISH
                                                                                        //EXAMPLE: default_lang:0 GAME SELECT ENGLISH
                                                  //WARNING: THIS PARAM DOESN'T TRANSLATE THE WHOLE GAME IN THE SELECTED LANGUAGE BUT JUST THE GRID WHERE USER SEARCHES WORDS
                            default_category:"none", //SET "none" TO SHOW THE CATEGORY PANEL. SET THE INDEX OF THE CATEGORY TO START THE GAME WITH DEFAULT CATEGORY.
                                                     //EXAMPLE: IF YOU HAVE 5 CATEGORIES IN lang FILE. IF YOU WANT TO START WITH THE SECOND ONE, SET default_category:2.
                            bonus_time: 1800, //BONUS TIME ADDED WHEN THE USER COMPLETE THE PUZZLE BETWEEN TIME IN SECONDS
                            audio_enable_on_startup:false, //ENABLE/DISABLE AUDIO WHEN GAME STARTS 
                            fullscreen: true,          //SET THIS TO FALSE IF YOU DON'T WANT TO SHOW FULLSCREEN BUTTON
                            check_orientation:false,     //SET TO FALSE IF YOU DON'T WANT TO SHOW ORIENTATION ALERT ON MOBILE DEVICES
                            num_levels_for_ads: 3 //NUMBER OF TURNS PLAYED BEFORE AD SHOWING //
                                    //////// THIS FEATURE  IS ACTIVATED ONLY WITH CTL ARCADE PLUGIN./////////////////////////// 
                                    /////////////////// YOU CAN GET IT AT: ///////////////////////////////////////////////////////// 
                                    // http://codecanyon.net/item/ctl-arcade-wordpress-plugin/13856421 ///////////
                        });

                $(oMain).on("start_session", function (evt) {
                    if (getParamValue('ctl-arcade') === "true") {
                        parent.__ctlArcadeStartSession();
                    }
                });


                $(oMain).on("end_session", function (evt) {
                    if (getParamValue('ctl-arcade') === "true") {
                        parent.__ctlArcadeEndSession();
                    }
                });


                $(oMain).on("start_level", function (evt, iLevel) {
                    if (getParamValue('ctl-arcade') === "true") {
                        parent.__ctlArcadeStartLevel({level: iLevel});
                    }
                });

                $(oMain).on("end_level", function (evt, iLevel) {
                    if (getParamValue('ctl-arcade') === "true") {
                        parent.__ctlArcadeEndLevel({level: iLevel});
                    }
                });

                $(oMain).on("save_score", function (evt, iScore) {
                    if (getParamValue('ctl-arcade') === "true") {
                        parent.__ctlArcadeSaveScore({score: iScore});
                    }
                });

                $(oMain).on("show_interlevel_ad", function (evt) {
                    if (getParamValue('ctl-arcade') === "true") {
                        parent.__ctlArcadeShowInterlevelAD();
                    }
                });

                $(oMain).on("share_event", function (evt, iScore) {
                    if (getParamValue('ctl-arcade') === "true") {
                        parent.__ctlArcadeShareEvent({img: TEXT_SHARE_IMAGE,
                            title: TEXT_SHARE_TITLE,
                            msg: TEXT_SHARE_MSG1 + iScore
                                    + TEXT_SHARE_MSG2,
                            msg_share: TEXT_SHARE_SHARE1
                                    + iScore + TEXT_SHARE_SHARE1});
                    }
                });

                if (isIOS()) {
                    setTimeout(function () {
                        sizeHandler();
                    }, 200);
                } else {
                    sizeHandler();
                }
            });

        </script>
        
        <div class="check-fonts">
            <p class="check-font-1">test 1</p>
        </div> 
        
        <canvas id="canvas" class='ani_hack' width="640" height="960"> </canvas>
        <div data-orientation="portrait" class="orientation-msg-container"><p class="orientation-msg-text">Please rotate your device</p></div>
        <div id="block_game" style="position: fixed; background-color: transparent; top: 0px; left: 0px; width: 100%; height: 100%; display:none"></div>

    </body>
</html>
