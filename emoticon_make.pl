#!/usr/bin/env perl 

use strict;
use warnings;
use Storable;
use utf8;

my %emoticon = (
        "화남" => '(╯°□°）╯︵ ┻━┻',
        "머리아픔" => 'ᕙ(⇀‸↼‶)ᕗ',
        "맥주" => '（ ^_^）o自自o（^_^ ）',
        "도망" => 'ε=ε=ε=┌(;*´Д`)ﾉ ', 
        "ping" => '( •_•)O*¯`·.¸.·´¯`°Q(•_• )',
        "pong" => '( •_•)O*¯`·.¸.·´¯`°Q(•_• )',
        "행복" => 'ヽ(´▽`)/',
        "좀비" => 'щ（ﾟДﾟщ）',
        "댄스" => '┏(-_-)┛ ┗(-_-)┓ ┗(-_-)┛ ┏(-_-)┓',
        "슬픔" => '(╥_╥)',
        "사랑" => '
        (¯`•.•´¯) (¯`•.•´¯)
        *`•.¸(¯`•.•´¯)¸.•´
       ¤ º° ¤`•.¸.•´ ¤ °º  perl-kr
        ',
        "발자국" => '
        ….oooO…………..
        …..(….)..…Oooo…
         ……)../…..(….)….
        …..(_/…….)../…..
        ……   ………(_/…….
        ',
        "hello" => '
        ║║ ╔ ║ ║ ╔╗ ║
        ╠╣ ╠ ║ ║ ║║ ║
        ║║ ╚ ╚ ╚ ╚╝ O
        ',
        "음악" => '
        : .ılı.——Volume——.ılı.
        : ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █
        : Min– – – – – - – -● Max   - DJ misskang
        ',
        "와우" => '
        ＿.人人人人人.＿
        ＞　WOW! 　＜
      ￣^Ｙ^Ｙ^^Ｙ^Ｙ^￣
      ',
        "폭격" => '
                             _
                            | \
                           _|  \______________________________________
                          - ______        ________________          \_`,
                        -(_______            -=    -=        PERL-KR    )
                                 `--------=============----------------`   
                                           -   -
                                          -   -
                               `   . .  -  -
                                .*` .* ;`*,`.,
                                 `, ,`.*.*. *
__________________________________*  * ` ^ *____________________________
        ',
        "일출" => '
                    ^^          @@@@@@@@@
       ^^       ^^            @@@@@@@@@@@@@@@
                            @@@@@@@@@@@@@@@@@@              ^^
                           @@@@@@@@@@@@@@@@@@@@
 ~~~~ ~~ ~~~~~ ~~~~~~~~ ~~ &&&&&&&&&&&&&&&&&&&& ~~~~~~~ ~~~~~~~~~~~ ~~~
 ~         ~~   ~  ~       ~~~~~~~~~~~~~~~~~~~~ ~       ~~     ~~ ~
   ~      ~~      ~~ ~~ ~~  ~~~~~~~~~~~~~ ~~~~  ~     ~~~    ~ ~~~  ~ ~~
   ~  ~~     ~         ~      ~~~~~~  ~~ ~~~       ~~ ~ ~~  ~~ ~
 ~  ~       ~ ~      ~           ~~ ~~~~~~  ~      ~~  ~             ~~
       ~             ~        ~      ~      ~~   ~             ~ 

        ',
        "생일" => '
           iiiiiiiiii
          |:H:a:p:p:y:|
        __|___________|__
       |^^^^^^^^^^^^^^^^^|
       |:B:i:r:t:h:d:a:y:|
       |                 |
       ~~~~~~~~~~~~~~~~~~~
        ',
        "크리스마스" => '
                   *             ,
                       _/^\_
                      <     >
     *                 /.-.\         *
              *        `/&\`                   *
                      ,@.*;@,
                     /_o.I %_\    *
        *           (`\'--:o(_@;
                   /`;--.,__ `\')             *
                  ;@`o % O,*`\'`&\ 
            *    (`\'--)_@ ;o %\'()\      *
                 /`;--._`\'\'--._O\'@;
                /&*,()~o`;-.,_ `""`)
     *          /`,@ ;+& () o*`;-\';\
               (`""--.,_0 +% @\' &()\
               /-.,_    ``\'\'--....-\'`)  *
          *    /@%;o`:;\'--,.__   __.\'\
              ;*,&(); @ % &^;~`"`o;@();         *
              /(); o^~; & ().o@*&`;&%O\
              `"="==""==,,,.,="=="==="`
           __.----.(\-\'\'#####---...___...-----._
         \'`         \)_`"""""`
                 .--\' \')
               o(  )_-\
                 `"""` `
            ',
    );

store \%emoticon, 'emoticons.dat';
