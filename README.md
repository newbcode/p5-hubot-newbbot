# p5-hubot-newbbot #

![p5-hubot](https://github.com/aanoaa/p5-hubot)
Hubot IRC 기반의 스크립트 모음
git hubot을 aanoaa님이 perl로 porting 해주신것을 기반으로 만들어진 hubot scripts입니다.

## Installation ##

- [CPAN](http://search.cpan.org)

        $ cpanm Hubot
        $ hubot --help

- [github](https://github.com)

        $ git clone git://github.com/aanoaa/p5-hubot.git
        $ cd p5-hubot/
        $ grep -Prho '^use +[^(?:Hubot)]([^ ;]+)' lib/ | perl -e 'while(<>) { $h{(split / /)[1]}++ } print keys %h' | cpanm
        $ perl -Ilib bin/hubot

## Configuration ##

Checkout each documentation what you will use for.
and describe each script name to `hubot-scripts.json`


