#!/bin/bash
 E='echo -e';
 e='echo -en';
#
 i=0; CLEAR; CIVIS;NULL=/dev/null
 trap "R;exit" 2
 ESC=$( $e "\e")
 TPUT(){ $e "\e[${1};${2}H" ;}
 CLEAR(){ $e "\ec";}
 CIVIS(){ $e "\e[?25l";}
 R(){ CLEAR ;stty sane;CLEAR;};                 # в этом варианте фон прозрачный
#
 ARROW(){ IFS= read -s -n1 key 2>/dev/null >&2
           if [[ $key = $ESC ]];then
              read -s -n1 key 2>/dev/null >&2;
              if [[ $key = \[ ]]; then
                 read -s -n1 key 2>/dev/null >&2;
                 if [[ $key = A ]]; then echo up;fi
                 if [[ $key = B ]];then echo dn;fi
              fi
           fi
           if [[ "$key" == "$($e \\x0A)" ]];then echo enter;fi;}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 ma="\e[47;30m│\e[0m                                                                                \e[47;30m│\e[0m"
 mb="\033[0m\033[47;30m┌────────────────────────────────────────────────────────────────────────────────┐\033[0m"
 mc="\e[47;30m├\e[0m\e[1;30m────────────────────────────────────────────────────────────────────────────────\e[0m\e[47;30m┤\e[0m"
 md="\e[47;30m├\e[0m\e[2m─ Up \xE2\x86\x91 \xE2\x86\x93 Down Select Enter ─────────────────────────────────────────────────────\e[0m\e[47;30m┤\e[0m"
 me="\033[0m\033[47;30m└────────────────────────────────────────────────────────────────────────────────┘\033[0m"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 na="\e[2m\xE2\x94\x82                                                                                \xE2\x94\x82\e[0m"
 nb="\e[0m\e[2m┌────────────────────────────────────────────────────────────────────────────────┐\e[0m"
 nc="\e[2m├────────────────────────────────────────────────────────────────────────────────┤\e[0m"
 nd="\033[2m├─ Up \xE2\x86\x91 \xE2\x86\x93 Down Select Enter ─────────────────────────────────────────────────────┤\e[0m"
 ne="\033[0m\033[2m└────────────────────────────────────────────────────────────────────────────────┘\033[0m"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# source "sEncfsctl.sh"
 UNMARK(){ $e "\e[0m";}
 MARK(){ $e "\e[30;47m";}
#
 HEAD()
{
 for (( a=2; a<=25; a++ ))
          do
              TPUT $a 1;$E "$ma"
          done
TPUT  1 1;$E "$mb"
TPUT  3 3;$E "\e[1;36m *** encfsctl ***\e[0m";
TPUT  4 3;$E "\e[2m Aдминистративный инструмент для работы с файловыми системами EncFS\e[0m";
TPUT  5 1;$E "$mc"
TPUT 12 1;$E "$mc"
TPUT 13 3;$E "\e[36m Commands\e[0m                                                           \e[2m Команды\e[0m";
TPUT 20 1;$E "$mc"
TPUT 22 1;$E "$md"
}
 FOOT(){ MARK;TPUT 25 1;$E "$me";UNMARK;}
#
  M0(){ TPUT  6 3; $e " Установка                                                          \e[32m Install \e[0m";}
  M1(){ TPUT  7 3; $e " Kраткий обзор                                                     \e[32m Synopsis \e[0m";}
  M2(){ TPUT  8 3; $e " Описание                                                       \e[32m Description \e[0m";}
  M3(){ TPUT  9 3; $e " Автор                                                               \e[32m Author \e[0m";}
  M4(){ TPUT 10 3; $e " Смотрите также                                                    \e[32m See Also \e[0m";}
  M5(){ TPUT 11 3; $e " Отказ от ответственности                                        \e[32m Disclaimer \e[0m";}
#
  M6(){ TPUT 14 3; $e " Показать основную информацию о файловой системе                       \e[32m info \e[0m";}
  M7(){ TPUT 15 3; $e " Позволяет изменить пароль зашифрованной файловой системы            \e[32m passwd \e[0m";}
  M8(){ TPUT 16 3; $e " Рекурсивный поиск по всему объему и отображение всех файлов      \e[32m showcruft \e[0m";}
  M9(){ TPUT 17 3; $e " Позволяет указать закодированное имя в командной строке             \e[32m decode \e[0m";}
 M10(){ TPUT 18 3; $e " Позволяет указать имя файла в командной строке                      \e[32m encode \e[0m";}
 M11(){ TPUT 19 3; $e " Декодирует и выдает содержимое зашифрованного файла                    \e[32m cat \e[0m";}
#
 M12(){ TPUT 21 3; $e "                                                                        \e[32m Git \e[0m";}
#
 M13(){ TPUT 23 3; $e " Exit                                                                        ";}
LM=13
   MENU(){ for each in $(seq 0 $LM);do M${each};done;}
    POS(){ if [[ $cur == up ]];then ((i--));fi
           if [[ $cur == dn ]];then ((i++));fi
           if [[ $i -lt 0   ]];then i=$LM;fi
           if [[ $i -gt $LM ]];then i=0;fi;}
REFRESH(){ after=$((i+1)); before=$((i-1))
           if [[ $before -lt 0  ]];then before=$LM;fi
           if [[ $after -gt $LM ]];then after=0;fi
           if [[ $j -lt $i      ]];then UNMARK;M$before;else UNMARK;M$after;fi
           if [[ $after -eq 0 ]] || [ $before -eq $LM ];then
           UNMARK; M$before; M$after;fi;j=$i;UNMARK;M$before;M$after;}
   INIT(){ R;HEAD;FOOT;MENU;}
     SC(){ REFRESH;MARK;$S;$b;cur=`ARROW`;}
# Функция возвращения в меню
     ES(){ MARK;$e " ENTER = main menu ";$b;read;INIT;};INIT
  while [[ "$O" != " " ]]; do case $i in
  0) S=M0;SC; if [[ $cur == enter ]];then R;echo -e "
 Предустановлена
";ES;fi;;
  1) S=M1;SC; if [[ $cur == enter ]];then R;echo -e "\e[32m
 encfsctl [command command_args]
 encfsctl [info] rootdir
 encfsctl passwd rootdir
 encfsctl showcruft rootdir
 encfsctl decode [--extpass=prog] rootdir [encoded name ...]
 encfsctl encode [--extpass=prog] rootdir [plaintext name ...]
 encfsctl cat [--extpass=prog] [--reverse] rootdir <(cipher|plain) filename>
\e[0m";ES;fi;;
  2) S=M2;SC; if [[ $cur == enter ]];then R;echo -e "
 encfsctl — это административный инструмент для работы с файловыми системами EncFS.
 Он может изменять введенный пользователем пароль, отображать основную информацию
 о зашифрованном томе и выполнять другие связанные операции.
";ES;fi;;
  3) S=M3;SC; if [[ $cur == enter ]];then R;echo -e "
 EncFS был написан Валиентом Гофом:\e[32m vgough@pobox.com\e[0m
";ES;fi;;
  4) S=M4;SC; if [[ $cur == enter ]];then R;echo -e "
\e[32m encfs\e[0m
";ES;fi;;
  5) S=M5;SC; if [[ $cur == enter ]];then R;echo -e "
 Эта библиотека распространяется в надежде, что она будет полезна, но БЕЗ КАКИХ
 ЛИБО ГАРАНТИЙ даже без подразумеваемой гарантии КОММЕРЧЕСКОЙ ПРИГОДНОСТИ или
 ПРИГОДНОСТИ ДЛЯ ОПРЕДЕЛЕННОЙ ЦЕЛИ. Пожалуйста, обратитесь к файлу 'COPYING',
 распространяемому вместе с encfs, для полной информации.
";ES;fi;;
  6) S=M6;SC; if [[ $cur == enter ]];then R;echo -e "
 Показать основную информацию о файловой системе:\e[32m encfsctl info ~/.crypt\e[0m
 Принимает единственный аргумент, rootdir, который является корневым каталогом
 зашифрованной файловой системы. Файловая система не требует монтирования.
 Info также является командой по умолчанию, если в командной строке указан
 только корневой каталог.
\e[32m \e[0m";ES;fi;;
  7) S=M7;SC; if [[ $cur == enter ]];then R;echo -e "
 Позволяет изменить пароль зашифрованной файловой системы:
\e[32m encfsctl passwd путь_к_зашифрованной_папке\e[0m
 Пользователю будет предложено ввести существующий пароль и новый пароль.
";ES;fi;;
  8) S=M8;SC; if [[ $cur == enter ]];then R;echo -e "
 Рекурсивный поиск по всему объему и отображение всех файлов, которые не поддаются
 декодированию (только проверяет кодировку имени файла, не блокируя заголовки MAC).
 Это может быть полезно для очистки, если вы использовали функции, создающие файлы,
 не поддающиеся декодированию с помощью первичного ключа.
";ES;fi;;
  9) S=M9;SC; if [[ $cur == enter ]];then R;echo -e "
 Позволяет указать закодированное имя в командной строке и отображает
 декодированную версию. Это в основном полезно для отладки, так как отладочные
 сообщения всегда отображают зашифрованные имена файлов (во избежание утечки
 конфиденциальных данных через каналы отладки). Таким образом, эта команда
 предоставляет способ декодирования имен файлов.
 Опцию --extpass можно использовать для указания программы, которая возвращает
 пароль, как и в случае с encfs. Если в командной строке не указаны имена,
 то список имен файлов будет прочитан из стандартного ввода и декодирован.
";ES;fi;;
 10) S=M10;SC;if [[ $cur == enter ]];then R;echo -e "
 Позволяет указать имя файла в командной строке и отображает его закодированную
 версию. Это полезно, если, например. вы делаете резервную копию зашифрованного
 каталога и хотите исключить некоторые файлы.
 Опцию --extpass можно использовать для указания программы, которая возвращает
 пароль, как и в случае с encfs. Если в командной строке не указаны имена,
 то список имен файлов будет прочитан из стандартного ввода и закодирован.
";ES;fi;;
 11) S=M11;SC;if [[ $cur == enter ]];then R;echo -e "
 cat Декодирует и выдает содержимое зашифрованного файла. Имя файла может быть
 указано в простой или зашифрованной форме. С --reverse вместо этого содержимое
 файла будет зашифровано.
";ES;fi;;
#
 12) S=M12;SC;if [[ $cur == enter ]];then R;echo -e "
 Di 12 Jul 2022 16:42:14 CEST
 Описание утилиты.
 Asciinema:  \e[36m \e[0m
 Github:     \e[36m \e[0m
 Gitlab:     \e[36m \e[0m
 Sourceforge:\e[36m \e[0m
 Notabug:    \e[36m \e[0m
 Bitbucket:  \e[36m \e[0m
 Framagit:   \e[36m \e[0m
 GFogs:      \e[36m \e[0m
 Codeberg:   \e[36m \e[0m
 Gitea       \e[36m \e[0m
 ~~~ File ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 Phacility:  \e[36m \e[0m
 Archive:    \e[36m \e[0m
 Discord:    \e[36m \e[0m
 Mewe:       \e[36m \e[0m
 ~~~ Post ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 Bastyon:\e[36m \e[0m
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 Peergos:\e[36m \e[0m
";ES;fi;;
 13) S=M13;SC;if [[ $cur == enter ]];then R;clear;ls -l;exit 0;fi;;
 esac;POS;done
