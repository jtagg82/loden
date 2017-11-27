'                                 LODEN.BAS
'
'!!!!!!!: Make sure you set the path of the game in each .bas program.
'Run setup first to determine speed then Loden.
'Use mapedit to make your own levels.
'
'       This is my best game so far.  Make sure you view the help page
'before playing so you can use the game to it's full extent.
'
'Please send comments to razairelepepere@crosswinds.net.  I'd like to
'hear what you think of the game.

DECLARE SUB armor ()
DECLARE SUB battle (a, posa, posb)
DECLARE SUB clrmap ()
DECLARE SUB clrtxt (num)
DECLARE SUB credits ()
DECLARE SUB discitem ()
DECLARE SUB discweap ()
DECLARE SUB endcustom ()
DECLARE SUB endgame ()
DECLARE SUB errorhandle ()
DECLARE SUB frame ()
DECLARE SUB getlocation ()
DECLARE SUB help ()
DECLARE SUB intro ()
DECLARE SUB items ()
DECLARE SUB itemuse ()
DECLARE SUB loadchar ()
DECLARE SUB loadcustom ()
DECLARE SUB loadennemy ()
DECLARE SUB loaditems ()
DECLARE SUB loadlevel ()
DECLARE SUB loden ()
DECLARE SUB menu ()
DECLARE SUB move ()
DECLARE SUB newchar ()
DECLARE SUB pause ()
DECLARE SUB prntchr (x, y, c, h)
DECLARE SUB prntnum (x, y, c, w)
DECLARE SUB prntstr (x, y, c, w$)
DECLARE SUB savegame ()
DECLARE SUB showall ()
DECLARE SUB surrender ()
DECLARE SUB textfile (path$, c1, c2, c3)
DECLARE SUB textstr (text$, l, strt, c1, c2, c3)
DECLARE SUB title ()
DECLARE SUB usemana ()
DECLARE SUB weapons ()
DECLARE SUB weapuse ()
DECLARE FUNCTION die (lo, hi)

COMMON SHARED wnum(), wnam$(), wmindam(), wmaxdam(), wtype(), weap(), weap
COMMON SHARED inum(), inam$(), itype(), imin(), imax(), item(), item, idam
COMMON SHARED wx(), wy(), ix(), iy(), intk(), wnt(), mx(), my(), mnt(), mnthp()
COMMON SHARED aac(), anam$(), arm$
COMMON SHARED map(), map1(), map2(), map3(), map4(), map5()
COMMON SHARED cnam$, hpmax, hp, ac, str, dex, th, mana, lev, dlev, xp, keys, xpup
COMMON SHARED x, y, colhp, spd, stats, loaded, loca, mov, manashow, custom, goweap, goitem, goarm, golevup, menulook, goframe, loadlev, runx, runy, setupspd
COMMON SHARED mnam$(), mminhp(), mmaxhp(), mmindam(), mmaxdam(), mac(), mth(), mxp(), mtyp()
COMMON SHARED bnam$(), bminhp(), bmaxhp(), bmindam(), bmaxdam(), bac(), bth(), bxp(), btyp()

ON ERROR GOTO errorhandle

CHDIR "c:\desktop\loden"         '<------PATH

IF stats = 1 THEN frame
stats = 1
loca = 1

CLS : SCREEN 12

DIM SHARED map(40, 50), map1(40, 50), map2(40, 50), map3(40, 50), map4(40, 50), map5(40, 50)
DIM SHARED weap(6), item(15), aac(9), anam$(9)
DIM SHARED wnum(17), wnam$(17), wmindam(17), wmaxdam(17), wtype(17)
DIM SHARED inum(9), inam$(9), itype(9), imin(9), imax(9)
DIM SHARED mnam$(29), mminhp(29), mmaxhp(29), mmindam(29), mmaxdam(29), mac(29), mth(29), mxp(29), mtyp(29)
DIM SHARED bnam$(5), bminhp(5), bmaxhp(5), bmindam(5), bmaxdam(5), bac(5), bth(5), bxp(5), btyp(5)
DIM SHARED wx(10), wy(10), ix(20), iy(20), intk(20), wnt(10), mx(40), my(40), mnt(40), mnthp(40), text$(55)

setupspd = 1
OPEN "setup.dat" FOR INPUT AS #1
INPUT #1, spd
CLOSE #1
setupspd = 0

loaditems
loadennemy
loadlevel

title

DO
IF goframe = 1 THEN frame
IF goweap = 1 THEN PLAY "mso5l30cp30fp30ap30d": weapons
IF goitem = 1 THEN PLAY "mlo5l30cdefgab": items
IF goarm = 1 THEN PLAY "o2msdp15dc": armor
IF loadlev > 0 THEN PLAY "mso1l20cp20mlcdefgabms>cp20<cp20>c": loadlevel
move
LOOP

errorhandle:
errorhandle
RESUME NEXT

SUB armor STATIC

goarm = 0
f = die(1, lev + 1)
IF lev > 8 THEN f = die(1, 9)
text1$ = "You have found a "
text2$ = text1$ + anam$(f) + "!"
text4$ = " which has an AC value of "
text5$ = "You have on you at this moment "
text6$ = " giving you an AC value of "
textstr text2$, 42, 1, 15, 12, 4
clrtxt 1
text$ = text5$ + arm$ + text6$ + STR$(ac) + "."
textstr text$, 43, 1, 15, 10, 3
text$ = text1$ + anam$(f) + text4$ + STR$(aac(f)) + "."
textstr text$, 44, 1, 15, 10, 3
textstr "Put on new armor", 46, 5, 15, 2, 10
prntstr 46, 6, 15, "P"
textstr "Keep current armor", 47, 5, 15, 2, 10
prntstr 47, 6, 15, "K"

DO
a$ = LCASE$(INKEY$)
IF a$ = "k" THEN
map(x, y) = 0
clrtxt 6
GOTO endofthissb
END IF
IF a$ = "p" THEN
map(x, y) = 0
clrtxt 6
arm$ = anam$(f)
ac = aac(f)
goframe = 1: GOTO endofthissb
END IF
LOOP

endofthissb:
goframe = 1
END SUB

SUB battle (borm, posa, posb)

IF borm = 1 THEN PLAY "mso1cp20cp20l50cdefgab": GOTO boss
IF borm = 2 THEN PLAY "mso1l20cp20mlcdemsc": GOTO ennemy

ennemy:
f = die(1, lev * 3)
IF lev > 9 THEN f = die(1, 29)
mxpos = x + posa - 2
mypos = y + posb - 2
FOR a = 1 TO 40
IF mxpos = mx(a) AND mypos = my(a) THEN f = mnt(a): EXIT FOR
NEXT a
text1$ = "You have fallen upon a "
text2$ = text1$ + mnam$(f) + "!"
textstr text2$, 42, 1, 15, 12, 4
pause
clrtxt 1
mnam$ = mnam$(f)
mhp = die(mminhp(f), mmaxhp(f))
FOR a = 1 TO 40
IF mxpos = mx(a) AND mypos = my(a) THEN mhp = mnthp(a)
NEXT a
mhpmax = mhp
mth = mth(f)
mmindam = mmindam(f)
mmaxdam = mmaxdam(f)
mac = mac(f)
mxp = mxp(f)
mtyp = mtyp(f)
GOTO startbattle

boss:
text1$ = "You have fallen upon "
text2$ = text1$ + bnam$(dlev) + "!"
textstr text2$, 42, 1, 15, 12, 4
pause
clrtxt 1
mnam$ = bnam$(dlev)
mhp = die(bminhp(dlev), bmaxhp(dlev))
mhpmax = mhp
mth = bth(dlev)
mmindam = bmindam(dlev)
mmaxdam = bmaxdam(dlev)
mac = bac(dlev)
mxp = bxp(dlev)
mtyp = btyp(dlev)
GOTO startbattle

startbattle:
FOR a = 41 TO 58
prntchr a, 40, 4, 219
NEXT a

GOSUB refresh

init:
prntstr 41, 25, 0, "                                   "
initroll = die(1, 20)
IF dex > 20 THEN initroll = initroll + (dex - 20)
minitroll = die(1, 20)
IF initroll < minitroll THEN init = 1: text1$ = " wins initiative!": text$ = cnam$ + text1$: textstr text$, 41, 25, 15, 7, 14: GOTO iattack
IF initroll > minitroll THEN init = 2: text1$ = " wins initiative!": text$ = mnam$ + text1$: textstr text$, 41, 25, 15, 7, 14: GOTO heattacks
IF initroll = minitroll THEN GOTO init

iattack:
textstr "Attack", 46, 10, 15, 2, 10
textstr "Use Item", 47, 10, 15, 2, 10
textstr "Use Mana", 48, 10, 15, 2, 10
textstr "Run away", 49, 10, 15, 2, 10
prntstr 46, 11, 15, "A"
prntstr 47, 15, 15, "I"
prntstr 48, 15, 15, "M"
prntstr 49, 11, 15, "R"
DO
a$ = LCASE$(INKEY$)
IF a$ = LCASE$("a") THEN GOTO iat
IF a$ = LCASE$("i") THEN GOTO iuseitem
IF a$ = LCASE$("m") THEN GOTO usemana
IF a$ = LCASE$("r") THEN GOTO runaway
LOOP

iat:
GOSUB refresh
throll = die(1, 100)
IF dex - 20 > 0 THEN throll = throll + (dex - 20)
IF throll <= th - mac THEN GOTO ihit:  ELSE GOTO imiss

iuseitem:
GOSUB refresh
textstr "You have:", 45, 2, 15, 14, 10
IF item > 9 THEN GOTO moreitems
FOR a = 1 TO item
prntnum 45 + a, 3, 3, a
textstr inam$(item(a)), 45 + a, 5, 7, 8, 15
NEXT a
GOTO inpub
moreitems:
FOR a = 1 TO 9
prntnum 45 + a, 3, 3, a
textstr inam$(item(a)), 45 + a, 5, 7, 8, 15
NEXT a
FOR a = 10 TO item
prntnum 45 + (a - 9), 22, 3, a
textstr inam$(item(a)), 45 + (a - 9), 25, 7, 8, 15
NEXT a
inpub:
LOCATE 58, 2: COLOR 7
INPUT "Which one(0=none)?", iitem
IF iitem = 0 THEN pse = 1: GOSUB refresh: GOTO iattack
IF iitem > item THEN GOTO inpub
GOSUB refresh
idam = die(imin(item(iitem)), imax(item(iitem)))
IF itype(item(iitem)) = 0 THEN
hp = hp + idam: IF hp > hpmax THEN hp = hpmax
text1$ = " drinks a "
text2$ = "and regains    HP!"
text$ = cnam$ + text1$ + inam$(item(iitem))
textstr text$, 46, 1, 15, 9, 1
textstr text2$, 47, 1, 15, 9, 1
prntnum 47, 13, 14, idam
pse = 1: GOSUB refresh
END IF
IF itype(item(iitem)) = 1 THEN
mhp = mhp - idam
text1$ = " hits and inflicts"
text3$ = "   points of damage with a "
text$ = cnam$ + text1$
textstr text$, 46, 1, 15, 12, 4
textstr text3$, 47, 1, 15, 12, 4
textstr inam$(item(iitem)) + "!", 48, 1, 15, 12, 4
prntnum 47, 1, 14, idam
IF mhp < 1 THEN GOTO iwin
pse = 1: GOSUB refresh
END IF
item(iitem) = 0
FOR a = iitem TO item
IF a = 15 THEN item(15) = 0: EXIT FOR
IF item(a) = 0 AND item(a + 1) > 0 THEN item(a) = item(a + 1)
   item(a + 1) = 0
NEXT a
item = item - 1
GOSUB refresh
IF init = 1 THEN GOTO heattacks
IF init = 2 THEN GOTO init

usemana:
GOSUB refresh
textstr "Kill enemy", 46, 10, 15, 2, 10
textstr "Regain HP", 47, 10, 15, 2, 10
prntstr 46, 11, 15, "K"
prntstr 47, 11, 15, "R"
DO
a$ = LCASE$(INKEY$)
IF mana = 0 THEN prntstr 41, 10, 4, "No Mana left!": GOSUB refresh: GOTO iattack
IF a$ = "r" THEN mana = mana - 1: hp = hpmax: GOSUB refresh: GOTO heattacks
IF a$ = "k" THEN mana = mana - 1: GOTO iwin
IF a$ = CHR$(27) THEN GOSUB refresh: GOTO iattack
LOOP

runaway:
FOR a = 1 TO 40
IF mxpos = mx(a) AND mypos = my(a) THEN EXIT FOR
IF mnt(a) = 0 THEN mnt(a) = f:  mx(a) = mxpos: my(a) = mypos: mnthp(a) = mhp: EXIT FOR
NEXT a
mthroll = die(1, 100)
IF mthroll <= mth - ac THEN GOTO runhit:  ELSE GOTO runmiss
runhit:
mdamroll = die(mmindam, mmaxdam)
hp = hp - mdamroll
text1$ = " hits and inflicts"
text3$ = "    points of damage!"
text$ = mnam$ + text1$
textstr text$, 46, 42, 15, 12, 4
textstr text3$, 47, 42, 15, 12, 4
prntnum 47, 43, 15, mdamroll
IF hp < 1 THEN GOTO hewins
GOTO runnow
runmiss:
text1$ = " attacks and misses!"
text$ = mnam$ + text1$
textstr text$, 46, 42, 15, 14, 6
runnow:
PLAY "mso1l40cdcdcdcdcdcdcdmlbagfedc"
clrtxt 17
textstr "COWARD!!!", 50, 30, 8, 4, 12
clrtxt 9
prntchr x, y, 0, 0
x = runx: y = runy: loca = 1: GOTO endbattle

ihit:
GOSUB refresh
damroll = die(wmindam(weap(6)), wmaxdam(weap(6)))
IF str - 20 > 0 THEN damroll = damroll + (str - 20)
IF mtyp = 0 AND wtype(6) = 1 THEN damroll = CINT(damroll / 2 + .01)
mhp = mhp - damroll
text1$ = " hits and inflicts"
text3$ = "   points of damage with a "
text$ = cnam$ + text1$
textstr text$, 46, 1, 15, 12, 4
textstr text3$, 47, 1, 15, 12, 4
textstr wnam$(weap(6)) + "!", 48, 1, 15, 12, 4
prntnum 47, 1, 15, damroll
IF mhp < 1 THEN GOTO iwin
pse = 1: GOSUB refresh
IF init = 1 THEN GOTO heattacks
IF init = 2 THEN GOTO init

imiss:
text1$ = " attacks and misses!"
text$ = cnam$ + text1$
textstr text$, 46, 1, 15, 14, 6
pse = 1: GOSUB refresh
IF init = 1 THEN GOTO heattacks
IF init = 2 THEN GOTO init

heattacks:
mthroll = die(1, 100)
IF mthroll <= mth - ac THEN GOTO hehits:  ELSE GOTO hemisses

hehits:
mdamroll = die(mmindam, mmaxdam)
hp = hp - mdamroll
text1$ = " hits and inflicts"
text3$ = "    points of damage!"
text$ = mnam$ + text1$
textstr text$, 46, 42, 15, 12, 4
textstr text3$, 47, 42, 15, 12, 4
prntnum 47, 43, 15, mdamroll
IF hp < 1 THEN GOTO hewins
pse = 1: GOSUB refresh
IF init = 2 THEN GOTO iattack
IF init = 1 THEN GOTO init

hemisses:
text1$ = " attacks and misses!"
text$ = mnam$ + text1$
textstr text$, 46, 42, 15, 14, 6
pse = 1: GOSUB refresh
IF init = 2 THEN GOTO iattack
IF init = 1 THEN GOTO init

refresh:
IF pse = 1 THEN pause
pse = 0
IF hp = hpmax THEN colhp = 15 ELSE colhp = 7
IF hp < (hpmax / 4) THEN colhp = 4
IF mhp = mhpmax THEN colmhp = 15 ELSE colmhp = 7
IF mhp < (mhpmax / 4) THEN colmhp = 4
prntstr 45, 1, 0, "                                       "
prntstr 46, 1, 0, "                                       "
prntstr 47, 1, 0, "                                       "
prntstr 48, 1, 0, "                                       "
prntstr 49, 1, 0, "                                       "
prntstr 50, 1, 0, "                                       "
prntstr 51, 1, 0, "                                       "
prntstr 52, 1, 0, "                                       "
prntstr 53, 1, 0, "                                       "
prntstr 54, 1, 0, "                                       "
prntstr 55, 1, 0, "                                       "
prntstr 56, 1, 0, "                                       "
prntstr 57, 1, 0, "                                       "
prntstr 58, 1, 0, "                                       "
prntstr 45, 41, 0, "                                       "
prntstr 46, 41, 0, "                                       "
prntstr 47, 41, 0, "                                       "
prntstr 48, 41, 0, "                                       "
prntstr 58, 41, 0, "                                       "
prntstr 42, 15, 2, cnam$
prntstr 42, 55, 4, mnam$
prntstr 44, 5, 5, "HP -"
prntnum 44, 9, colhp, hp
prntstr 44, 50, 5, "HP -"
prntnum 44, 54, colmhp, mhp
RETURN

iwin:
PLAY "o1l40mlcdefgabp20msl30bl10b"
map(x + posa - 2, y + posb - 2) = 0
FOR a = 1 TO 40
IF mx(a) = mxpos AND my(a) = mypos THEN mnt(a) = 0
NEXT a
IF borm = 1 AND dlev = 5 THEN endgame
clrtxt 17
textstr "You have overcome your enemy and gained " + STR$(mxp) + " experience points!", 42, 1, 8, 7, 15
xp = xp + mxp
IF xp >= xpup THEN GOSUB passlev
clrtxt 2
IF borm = 1 THEN manashow = 1: showall
loca = 1
GOTO endbattle

hewins:
clrtxt 17
textstr "You fought on with all your might.  However, the loss of blood got the", 41, 1, 15, 8, 4
textstr "better of you and finally died at the hands of a " + mnam$(f) + ".", 42, 1, 15, 8, 4
PLAY "t160mno1l4cl5cl16cl4cl5e-l16dl5dl16cl5cl16<bl4>c"
credits
SYSTEM

passlev:
lev = lev + 1
xpup = xpup * 2
str = str + die(1, 2)
dex = dex + die(1, 2)
th = th + 5
hpmax = hpmax + die(1, 8)
hp = hpmax
textstr "You have gained an experience level!", 43, 1, 6, 14, 15
PLAY "o2l5cl20egb>c"
clrtxt 2
IF xp >= xpup THEN GOTO passlev
RETURN

endbattle:
goframe = 1
END SUB

SUB clrmap

FOR a = 2 TO 39
FOR b = 2 TO 49
prntchr a, b, 0, 0
NEXT b, a

END SUB

SUB clrtxt (num) STATIC

prntchr x, y, 6, 8
FOR a = 1 TO (spd * 10000): NEXT a
FOR a = 41 TO (41 + num)
prntstr a, 1, 0, "                                                                             "
NEXT a

END SUB

SUB credits

CLS
textstr "          Programming .................................. Joseph Tagg", 10, 1, 8, 9, 1
textstr "          Special thanks to ....................... Fabrice Bernhard", 11, 1, 8, 10, 2
textstr "          E-mail ...................Joseph Tagg: jim.tagg@wanadoo.fr", 13, 1, 8, 11, 3
textstr "                 .......Fabrice Bernhard: werner.bernhard@wanadoo.fr", 14, 1, 8, 12, 4
textstr "          Visit the Fantasy page at http://perso.wanadoo.fr/bernhard", 16, 1, 8, 13, 5

END SUB

FUNCTION die (lo, hi)

RANDOMIZE TIMER
die = INT(RND * (hi - lo + 1)) + lo

END FUNCTION

SUB discitem

clrtxt 17

textstr "You have:", 42, 2, 15, 14, 10
FOR a = 1 TO item
prntnum 42 + a, 3, 3, a
textstr inam$(item(a)), 42 + a, 5, 7, 8, 15
NEXT a
inpui:
LOCATE 58, 2: COLOR 7
INPUT "Which one(0=none)?", dwitem
IF dwitem > item THEN GOTO inpui
IF dwitem = 0 THEN clrtxt 17: GOTO enddi
item(dwitem) = 0
FOR a = dwitem TO item
IF a = 15 THEN item(15) = 0: EXIT FOR
IF item(a) = 0 AND item(a + 1) > 0 THEN item(a) = item(a + 1): item(a + 1) = 0
NEXT a
item = item - 1
clrtxt 17

enddi:
END SUB

SUB discweap STATIC

clrtxt 17

prntstr 41, 2, 4, "Remember to reselect weapon!"
textstr "You have:", 42, 2, 15, 14, 10
FOR a = 1 TO weap
prntnum 42 + a, 3, 3, a
textstr wnam$(weap(a)), 42 + a, 5, 7, 8, 15
NEXT a
inpuw:
LOCATE 50, 2: COLOR 7
INPUT "Which one(0=none)?", dwweap
IF dwweap > weap THEN GOTO inpuw
IF dwweap = 0 THEN clrtxt 17: GOTO enddw
weap(dwweap) = 0
FOR a = dwweap TO weap
IF a = 5 THEN weap(5) = 0: EXIT FOR
IF weap(a) = 0 AND weap(a + 1) > 0 THEN weap(a) = weap(a + 1): weap(a + 1) = 0
NEXT a
weap = weap - 1
weap(6) = 0
prntstr 17, 61, 0, "                 "
clrtxt 17

enddw:
END SUB

SUB endcustom

textstr "Congratulations!  You have achieved this level.", 5, 5, 8, 7, 15
textstr "Make some more using mapedit and play them.", 6, 5, 8, 7, 15

credits: SYSTEM

END SUB

SUB endgame

CLS
textfile "endgame.ldn", 8, 7, 15
   
credits
SYSTEM

END SUB

SUB errorhandle

SELECT CASE ERR

CASE 53
IF setupspd = 0 THEN
prntstr 2, 1, 4, "The file you just refered to doesn't exist!  Please try another one."
pause
CLS
title
END IF

IF setupspd = 1 THEN
CLS
prntstr 2, 1, 4, "Please run setup before playing."
SYSTEM
END IF

CASE 64
prntstr 2, 1, 4, "You cannot include any of the following characters in the filename."
prntstr 3, 1, 4, "They are: \ / : * ? '' < > |"
pause
CLS
title

END SELECT

END SUB

SUB frame

goframe = 0

SCREEN 12: WIDTH 80, 60
FOR a = 1 TO 40
prntchr a, 1, 4, 219
prntchr a, 50, 4, 219
prntchr a, 80, 4, 219
NEXT a
FOR a = 1 TO 80
prntchr 1, a, 4, 219
prntchr 40, a, 4, 219
NEXT a
FOR a = 50 TO 80
prntchr 16, a, 4, 219
NEXT a

prntstr 18, 61, 0, "                  "
prntstr 19, 61, 0, "                  "
IF hp = hpmax THEN colhp = 15 ELSE colhp = 7
IF hp < (hpmax / 4) THEN colhp = 4
prntstr 3, 60, 4, cnam$
prntstr 5, 52, 13, "Hit Points -    /"
prntnum 5, 64, colhp, hp
prntnum 5, 69, 15, hpmax
prntstr 6, 52, 13, "Armor Class -"
prntnum 6, 65, 15, ac
prntstr 7, 52, 13, "Strength -"
prntnum 7, 62, 15, str
prntstr 8, 52, 13, "Dexterity -"
prntnum 8, 63, 15, dex
prntstr 9, 52, 13, "% hit -"
prntnum 9, 59, 15, th
prntstr 9, 62, 15, "%"
prntstr 10, 52, 13, "Mana -"
prntnum 10, 58, 15, mana
prntstr 12, 52, 13, "XP -         /"
prntnum 12, 58, 15, xp
prntnum 12, 66, 15, xpup
prntstr 13, 52, 13, "Level -"
prntnum 13, 59, 15, lev
prntstr 14, 52, 13, "Dungeon level -"
prntnum 14, 67, 15, dlev
prntstr 18, 52, 13, "Weapon -"
prntstr 18, 61, 15, LEFT$(wnam$(weap(6)), 10)
prntnum 18, 71, 15, wmindam(weap(6))
prntstr 18, 75, 15, "-"
prntnum 18, 76, 15, wmaxdam(weap(6))
prntstr 19, 52, 13, "Armor -"
prntstr 19, 59, 15, arm$
prntstr 21, 52, 13, "Keys -"
prntnum 21, 58, 15, keys

END SUB

SUB help

CLS
textfile "help.ldn", 8, 7, 15
CLS
prntchr 2, 5, 14, 20
prntstr 2, 7, 14, "key"
prntchr 4, 5, 7, 197
prntstr 4, 7, 7, "weapon"
prntchr 6, 5, 7, 127
prntstr 6, 7, 7, "item"
prntchr 8, 5, 14, 234
prntstr 8, 7, 14, "armor"
prntchr 10, 5, 4, 1
prntstr 10, 7, 4, "enemy"
prntchr 12, 5, 2, 1
prntstr 12, 7, 2, "boss"
prntchr 14, 5, 12, 21
prntstr 14, 7, 12, "end of level"
prntchr 16, 5, 13, 21
prntstr 16, 7, 13, "start of level"
prntchr 18, 5, 6, 176
prntstr 18, 7, 6, "door"
prntchr 20, 5, 6, 177
prntstr 20, 7, 6, "locked door"
pause
CLS

END SUB

SUB intro

CLS
textfile "intro.ldn", 8, 7, 15
CLS
title

END SUB

SUB items STATIC

goitem = 0
f = die(1, lev + 1)
IF lev > 8 THEN f = die(1, 9)
FOR a = 1 TO 20
IF x = ix(a) AND y = iy(a) THEN f = intk(a)
NEXT a
text1$ = "You have found a "
text2$ = text1$ + inam$(f) + "!"
textstr text2$, 42, 1, 15, 12, 4
FOR a = 1 TO 15
IF item(a) = 0 THEN item(a) = inum(f): map(x, y) = 0: item = item + 1: intk(a) = 0: clrtxt 1: goframe = 1: GOTO stopitrightnow
NEXT a
GOTO inoroom

inoroom:
textstr "No room left!!!", 43, 2, 15, 14, 6
clrtxt 2
FOR a = 1 TO 20
IF x = ix(a) AND y = iy(a) THEN EXIT FOR
IF intk(a) = 0 THEN intk(a) = inum(f):  ix(a) = x: iy(a) = y:  GOTO stopitrightnow
NEXT a

stopitrightnow:
END SUB

SUB itemuse

textstr "You have:", 42, 2, 15, 14, 10
FOR a = 1 TO item
prntnum 42 + a, 3, 3, a
textstr inam$(item(a)), 42 + a, 5, 7, 8, 15
NEXT a
inpuc:
LOCATE 58, 2: COLOR 7
INPUT "Which one(0=none)?", iitem
IF iitem = 0 THEN GOTO nosel
IF iitem > item THEN GOTO inpuc
idam = die(imin(item(iitem)), imax(item(iitem)))
IF itype(item(iitem)) = 0 THEN
hp = hp + idam: IF hp > hpmax THEN hp = hpmax
clrtxt 17
text1$ = " drinks a "
text2$ = "and regains    HP!"
text$ = cnam$ + text1$ + inam$(item(iitem))
textstr text$, 46, 1, 15, 9, 1
textstr text2$, 47, 1, 15, 9, 1
prntnum 47, 13, 14, idam
END IF
IF itype(item(iitem)) = 1 THEN
textstr "You cannot use that now!", 44, 1, 8, 6, 14
GOTO nosel
END IF
item(iitem) = 0
FOR a = iitem TO item
IF a = 15 THEN item(15) = 0: EXIT FOR
IF item(a) = 0 AND item(a + 1) > 0 THEN item(a) = item(a + 1)
   item(a + 1) = 0
NEXT a
item = item - 1

nosel:
clrtxt 17
END SUB

SUB loadchar

CLS
COLOR 6
INPUT "Character name:", filenam$
filename$ = LEFT$(filenam$, 8) + ".lsv"
OPEN filename$ FOR INPUT AS #1
INPUT #1, cnam$, hpmax, hp, ac, str, dex, th, mana, lev, dlev, xp, keys, xpup
INPUT #1, armo, arm$, x, y
FOR a = 1 TO 15
INPUT #1, item(a)
NEXT a
INPUT #1, item
FOR a = 1 TO 6
INPUT #1, weap(a)
NEXT a
INPUT #1, weap
FOR a = 1 TO 10
INPUT #1, wx(a), wy(a), wnt(a)
NEXT a
FOR a = 1 TO 20
INPUT #1, ix(a), iy(a), intk(a)
NEXT a
FOR a = 1 TO 40
INPUT #1, mx(a), my(a), mnt(a), mnthp(a)
NEXT a
FOR a = 1 TO 40
FOR b = 1 TO 50
INPUT #1, map(a, b)
NEXT b, a
INPUT #1, bnam$, bminhp, bmaxhp, bmindam, bmaxdam, bac, bth, bxp, btyp
CLOSE #1

showall
goframe = 1

endloadchar:
END SUB

SUB loadcustom

CLS
OPEN "list.ldn" FOR INPUT AS #1
a = 0
DO
a = a + 1
INPUT #1, filenam$
prntstr a + 5, 25, 15, filenam$
LOOP UNTIL EOF(1)
CLOSE
INPUT "Which one(0=none)? ", file$
CLS
filename$ = file$ + ".cst"
OPEN filename$ FOR INPUT AS #1
prntstr 1, 1, 15, "Loading custom level"
prntstr 1, 21, 8, "........................................"
FOR a = 1 TO 40
FOR b = 1 TO 50
prntstr 1, a + 20, 15, "."
INPUT #1, map(a, b)
NEXT b, a
INPUT #1, bnam$(1), bminhp(1), bmaxhp(1), bmindam(1), bmaxdam(1), bac(1), bth(1), bxp(1), btyp(1)
INPUT #1, xpos, ypos
CLOSE #1
CLS
COLOR 6: INPUT "Character name:", cnam$
cnam$ = UCASE$(LEFT$(cnam$, 15))
IF LEN(cnam$) = 0 THEN newchar
hpmax = die(20, 30)
hp = hpmax
ac = 0
str = die(15, 18)
dex = die(12, 15)
lev = 1
dlev = 1
th = CINT((str * dex) / 6 + lev)
mana = 20
xp = 0
xpup = 100
keys = 0
arm$ = "Nothing"
x = xpos
y = ypos
custom = 1

CLS
goframe = 1

END SUB

SUB loadennemy

prntstr 4, 1, 15, "Loading ennemies"
prntstr 4, 17, 8, "............................."
OPEN "monsters.dat" FOR INPUT AS #1
FOR a = 1 TO 29
prntstr 4, a + 16, 15, "."
INPUT #1, mnam$(a), mminhp(a), mmaxhp(a), mmindam(a), mmaxdam(a), mac(a), mth(a), mxp(a), mtyp(a)
NEXT a
CLOSE #1

END SUB

SUB loaditems

prntstr 1, 1, 15, "Loading weapons"
prntstr 1, 16, 8, "................."
OPEN "items.dat" FOR INPUT AS #1
FOR a = 0 TO 16
prntstr 1, a + 16, 15, "."
INPUT #1, wnum(a), wnam$(a), wmindam(a), wmaxdam(a), wtype(a)
NEXT a
prntstr 2, 1, 15, "Loading items"
prntstr 2, 14, 8, "........."
FOR a = 1 TO 9
prntstr 2, a + 13, 15, "."
INPUT #1, inum(a), inam$(a), itype(a), imin(a), imax(a)
NEXT a
prntstr 3, 1, 15, "Loading armor"
prntstr 3, 14, 8, "........."
FOR a = 1 TO 9
prntstr 3, a + 13, 15, "."
INPUT #1, anam$(a), aac(a)
NEXT a
CLOSE #1

END SUB

SUB loadlevel

IF loadlev = 0 THEN GOTO endlevload
IF custom = 1 THEN endcustom

keys = 0
IF loadlev = 1 THEN loadlev = 0: GOTO lev1
IF loadlev = 2 THEN loadlev = 0: dlev = dlev + 1: GOTO lev2
IF loadlev = 3 THEN loadlev = 0: dlev = dlev + 1: GOTO lev3
IF loadlev = 4 THEN loadlev = 0: dlev = dlev + 1: GOTO lev4
IF loadlev = 5 THEN loadlev = 0: dlev = dlev + 1: GOTO lev5

lev1:
prntstr 42, 1, 15, "Loading level 1"
prntstr 42, 16, 8, "........................................"
OPEN "level1.lev" FOR INPUT AS #1
FOR a = 1 TO 40
FOR b = 1 TO 50
prntstr 42, a + 15, 15, "."
INPUT #1, map1(a, b)
NEXT b, a
INPUT #1, bnam$(1), bminhp(1), bmaxhp(1), bmindam(1), bmaxdam(1), bac(1), bth(1), bxp(1), btyp(1)
CLOSE #1
FOR a = 1 TO 40
FOR b = 1 TO 50
map(a, b) = map1(a, b)
NEXT b, a
bnam$ = bnam$(1)
bminhp = bminhp(1)
bmaxhp = bmaxhp(1)
bth = bth(1)
bmindam = bmindam(1)
bmaxdam = bmaxdam(1)
bac = bac(1)
bxp = bxp(1)
btyp = btyp(1)
mov = 1: loca = 1: goframe = 1
clrtxt 1
GOTO endlevload

lev2:
clrmap
prntstr 42, 1, 15, "Loading level 2"
prntstr 42, 16, 8, "........................................"
OPEN "level2.lev" FOR INPUT AS #1
FOR a = 1 TO 40
FOR b = 1 TO 50
prntstr 42, a + 15, 15, "."
INPUT #1, map2(a, b)
NEXT b, a
INPUT #1, bnam$(2), bminhp(2), bmaxhp(2), bmindam(2), bmaxdam(2), bac(2), bth(2), bxp(2), btyp(2)
CLOSE #1
FOR a = 1 TO 40
FOR b = 1 TO 50
map(a, b) = map2(a, b)
NEXT b, a
bnam$ = bnam$(2)
bminhp = bminhp(2)
bmaxhp = bmaxhp(2)
bth = bth(2)
bmindam = bmindam(2)
bmaxdam = bmaxdam(2)
bac = bac(2)
bxp = bxp(2)
btyp = btyp(2)
mov = 1: loca = 1: goframe = 1
clrtxt 1
GOTO endlevload

lev3:
clrmap
prntstr 42, 1, 15, "Loading level 3"
prntstr 42, 16, 8, "........................................"
OPEN "level3.lev" FOR INPUT AS #1
FOR a = 1 TO 40
FOR b = 1 TO 50
prntstr 42, a + 15, 15, "."
INPUT #1, map3(a, b)
NEXT b, a
INPUT #1, bnam$(3), bminhp(3), bmaxhp(3), bmindam(3), bmaxdam(3), bac(3), bth(3), bxp(3), btyp(3)
CLOSE #1
FOR a = 1 TO 40
FOR b = 1 TO 50
map(a, b) = map3(a, b)
NEXT b, a
bnam$ = bnam$(3)
bminhp = bminhp(3)
bmaxhp = bmaxhp(3)
bth = bth(3)
bmindam = bmindam(3)
bmaxdam = bmaxdam(3)
bac = bac(3)
bxp = bxp(3)
btyp = btyp(3)
mov = 1: loca = 1: goframe = 1
clrtxt 1
GOTO endlevload

lev4:
clrmap
prntstr 42, 1, 15, "Loading level 4"
prntstr 42, 16, 8, "........................................"
OPEN "level4.lev" FOR INPUT AS #1
FOR a = 1 TO 40
FOR b = 1 TO 50
prntstr 42, a + 15, 15, "."
INPUT #1, map4(a, b)
NEXT b, a
INPUT #1, bnam$(4), bminhp(4), bmaxhp(4), bmindam(4), bmaxdam(4), bac(4), bth(4), bxp(4), btyp(4)
CLOSE #1
FOR a = 1 TO 40
FOR b = 1 TO 50
map(a, b) = map4(a, b)
NEXT b, a
bnam$ = bnam$(4)
bminhp = bminhp(4)
bmaxhp = bmaxhp(4)
bth = bth(4)
bmindam = bmindam(4)
bmaxdam = bmaxdam(4)
bac = bac(4)
bxp = bxp(4)
btyp = btyp(4)
mov = 1: loca = 1: goframe = 1
clrtxt 1
GOTO endlevload

lev5:
clrmap
prntstr 42, 1, 15, "Loading level 5"
prntstr 42, 16, 8, "........................................"
OPEN "level5.lev" FOR INPUT AS #1
FOR a = 1 TO 40
FOR b = 1 TO 50
prntstr 42, a + 15, 15, "."
INPUT #1, map5(a, b)
NEXT b, a
INPUT #1, bnam$(5), bminhp(5), bmaxhp(5), bmindam(5), bmaxdam(5), bac(5), bth(5), bxp(5), btyp(5)
CLOSE #1
FOR a = 1 TO 40
FOR b = 1 TO 50
map(a, b) = map5(a, b)
NEXT b, a
bnam$ = bnam$(5)
bminhp = bminhp(5)
bmaxhp = bmaxhp(5)
bth = bth(5)
bmindam = bmindam(5)
bmaxdam = bmaxdam(5)
bac = bac(5)
bxp = bxp(5)
btyp = btyp(5)
mov = 1: loca = 1: goframe = 1
clrtxt 1
GOTO endlevload

endlevload:
IF dlev > 1 THEN savegame
goframe = 1
END SUB

SUB loden

  FOR a = 10 TO 15
  prntchr a, 25, 2, 18
  prntchr a, 35, 2, 18
  prntchr a, 40, 2, 18
  prntchr a, 45, 2, 18
  prntchr a, 48, 2, 18
  NEXT a

  FOR a = 25 TO 28
  prntchr 15, a, 2, 18
  prntchr 15, a + 15, 2, 18
  prntchr 10, a + 15, 2, 18
  NEXT a

  FOR a = 31 TO 32
  prntchr 15, a, 2, 18
  prntchr 10, a, 2, 18
  prntchr 10, a + 5, 2, 18
  prntchr 15, a + 5, 2, 18
  prntchr 12, a + 10, 2, 18
  NEXT a

  FOR a = 11 TO 14
  prntchr a, 30, 2, 18
  prntchr a, 33, 2, 18
  prntchr a, 38, 2, 18
  NEXT a

  FOR a = 11 TO 12
  prntchr a, 46, 2, 18
  prntchr a + 1, 47, 2, 18
  NEXT a

END SUB

SUB menu

textstr "Select Weapon", 42, 30, 15, 8, 7
prntstr 42, 31, 15, "S"
textstr "Discard Weapon", 43, 30, 15, 8, 7
prntstr 43, 31, 15, "D"
textstr "Use Item", 44, 30, 15, 8, 7
prntstr 44, 31, 15, "U"
textstr "Discard Item", 45, 30, 15, 8, 7
prntstr 45, 39, 15, "I"
textstr "Use Mana", 46, 30, 15, 8, 7
prntstr 46, 35, 15, "M"
textstr "Save Game", 47, 30, 15, 8, 7
prntstr 47, 36, 15, "G"
textstr "Quit game", 48, 30, 15, 8, 7
prntstr 48, 31, 15, "Q"
textstr "Surrender", 49, 30, 15, 8, 7
prntstr 49, 33, 15, "r"

DO
a$ = LCASE$(INKEY$)
IF a$ = "s" THEN clrtxt 8:  weapuse: menulook = 1: goframe = 1: GOTO stopend
IF a$ = "d" THEN clrtxt 8:  discweap: menulook = 1: goframe = 1: GOTO stopend
IF a$ = "u" THEN clrtxt 8:  itemuse: menulook = 1: goframe = 1: GOTO stopend
IF a$ = "i" THEN clrtxt 8:  discitem: menulook = 1: GOTO stopend
IF a$ = "m" THEN clrtxt 8:  usemana: menulook = 1: goframe = 1: GOTO stopend
IF a$ = "g" THEN clrtxt 8:  savegame: menulook = 1: GOTO stopend
IF a$ = "q" THEN clrtxt 8: credits: SYSTEM
IF a$ = "r" THEN clrtxt 8: surrender: credits: SYSTEM
IF a$ = CHR$(27) THEN clrtxt 10: goframe = 1: GOTO stopend
LOOP

stopend:
END SUB

SUB move

IF loca = 1 THEN loca = 0: GOTO getlocation

up:
prntchr x, y, 6, 8
DO
a$ = LCASE$(INKEY$)
IF a$ = CHR$(0) + "m" THEN x1 = x: y1 = y + 1: GOTO check
IF a$ = CHR$(0) + "k" THEN x1 = x: y1 = y - 1: GOTO check
IF a$ = CHR$(0) + "h" THEN x1 = x - 1: y1 = y: GOTO check
IF a$ = CHR$(0) + "p" THEN x1 = x + 1: y1 = y: GOTO check
IF a$ = "p" THEN pause
IF a$ = "m" THEN menu
IF menulook = 1 THEN GOTO stopithere
LOOP

check:
prntchr x, y, 0, 0
IF map(x1, y1) = -1 THEN GOTO getlocation
IF map(x1, y1) = -5 THEN GOTO lkdoor
runx = x
runy = y
x = x1
y = y1
IF map(x, y) = -2 THEN map(x, y) = -3
GOTO getlocation


lkdoor:
IF keys > 0 THEN map(x1, y1) = -4 ELSE GOTO getlocation
PLAY "l40o1fc"
keys = keys - 1
x = x1
y = y1
loca = 1: frame

getlocation:
PLAY "t120o4"
prntchr x, y, 6, 8
FOR a = 1 TO 3
FOR b = 1 TO 3
IF map(x - 2 + a, y - 2 + b) = 0 THEN prntchr x - 2 + a, y - 2 + b, 0, 0
IF ABS(map(x - 2 + a, y - 2 + b)) = 1 THEN map(x - 2 + a, y - 2 + b) = -1: prntchr x - 2 + a, y - 2 + b, 8, 219
IF ABS(map(x - 2 + a, y - 2 + b)) = 2 THEN map(x - 2 + a, y - 2 + b) = -2: prntchr x - 2 + a, y - 2 + b, 8, 219
IF ABS(map(x - 2 + a, y - 2 + b)) = 3 THEN map(x - 2 + a, y - 2 + b) = -3: prntchr x - 2 + a, y - 2 + b, 8, 177
IF ABS(map(x - 2 + a, y - 2 + b)) = 4 THEN map(x - 2 + a, y - 2 + b) = -4: prntchr x - 2 + a, y - 2 + b, 6, 176
IF ABS(map(x - 2 + a, y - 2 + b)) = 5 THEN map(x - 2 + a, y - 2 + b) = -5: prntchr x - 2 + a, y - 2 + b, 6, 177
IF ABS(map(x - 2 + a, y - 2 + b)) = 6 THEN map(x - 2 + a, y - 2 + b) = -6: prntchr x - 2 + a, y - 2 + b, 7, 197
IF ABS(map(x - 2 + a, y - 2 + b)) = 7 THEN map(x - 2 + a, y - 2 + b) = -7: prntchr x - 2 + a, y - 2 + b, 7, 127
IF ABS(map(x - 2 + a, y - 2 + b)) = 8 THEN prntchr x - 2 + a, y - 2 + b, 7, 1
IF ABS(map(x - 2 + a, y - 2 + b)) = 9 THEN map(x - 2 + a, y - 2 + b) = -9: prntchr x - 2 + a, y - 2 + b, 14, 20
IF ABS(map(x - 2 + a, y - 2 + b)) = 10 THEN map(x - 2 + a, y - 2 + b) = -10: prntchr x - 2 + a, y - 2 + b, 14, 234
IF ABS(map(x - 2 + a, y - 2 + b)) = 15 THEN prntchr x - 2 + a, y - 2 + b, 2, 1
IF ABS(map(x - 2 + a, y - 2 + b)) = 100 THEN map(x - 2 + a, y - 2 + b) = -100: prntchr x - 2 + a, y - 2 + b, 12, 21
IF ABS(map(x - 2 + a, y - 2 + b)) = 200 THEN map(x - 2 + a, y - 2 + b) = -200: prntchr x - 2 + a, y - 2 + b, 13, 21
NEXT b, a
prntchr x, y, 6, 8

FOR a = 1 TO 3
FOR b = 1 TO 3
IF ABS(map(x - 2 + a, y - 2 + b)) = 8 THEN battle 2, a, b: GOTO stopithere
IF ABS(map(x - 2 + a, y - 2 + b)) = 15 THEN battle 1, a, b: GOTO stopithere
NEXT b, a
IF mov = 1 THEN mov = 0: GOTO up
IF map(x, y) = -6 THEN goweap = 1: GOTO stopithere
IF map(x, y) = -7 THEN goitem = 1: GOTO stopithere
IF map(x, y) = -9 THEN PLAY "mlo5l30cl5f": keys = keys + 1: map(x, y) = 0: goframe = 1: GOTO stopithere
IF map(x, y) = -10 THEN goarm = 1: GOTO stopithere
IF map(x, y) = -100 THEN loadlev = dlev + 1: GOTO stopithere
GOTO up

stopithere:
END SUB

SUB newchar

inputchrnam:
CLS
COLOR 6
INPUT "Character name:", cnam$
IF INSTR(cnam$, "\") OR INSTR(cnam$, "/") OR INSTR(cnam$, ":") OR INSTR(cnam$, "*") OR INSTR(cnam$, "?") OR INSTR(cnam$, "''") OR INSTR(cnam$, "<") OR INSTR(cnam$, ">") OR INSTR(cnam$, "|") THEN
prntstr 2, 1, 4, "You cannot use the following characters in the name:"
prntstr 3, 1, 4, "\ / : * '' < >"
pause
GOTO inputchrnam
ELSE GOTO goodname
END IF
goodname:
cnam$ = UCASE$(LEFT$(cnam$, 15))
IF LEN(cnam$) = 0 THEN newchar
hpmax = die(20, 30)
hp = hpmax
ac = 0
str = die(15, 16)
dex = die(14, 15)
lev = 1
dlev = 1
th = 35
mana = 5
xp = 0
xpup = 100
keys = 0
arm$ = "Nothing"
x = 3
y = 3

loadlev = 1
goframe = 1

END SUB

SUB pause STATIC

strt:
prntstr 55, 2, 12, "Press any key"
FOR a = 15 TO 19
prntchr 55, a, 12, 46
FOR b = 1 TO (spd * 700): NEXT b
IF INKEY$ <> "" THEN GOTO prntblk
NEXT a
FOR a = 15 TO 19
prntchr 55, a, 0, 46
FOR b = 1 TO (spd * 700): NEXT b
IF INKEY$ <> "" THEN GOTO prntblk
NEXT a
GOTO strt

prntblk:
prntstr 55, 2, 0, "Press any key....."

END SUB

SUB prntchr (x, y, c, h) STATIC

LOCATE x, y
COLOR c
PRINT CHR$(h)

END SUB

SUB prntnum (x, y, c, w) STATIC

LOCATE x, y
COLOR c
PRINT w

END SUB

SUB prntstr (x, y, c, w$) STATIC

LOCATE x, y
COLOR c
PRINT w$

END SUB

SUB savegame

filename$ = LEFT$(cnam$, 8) + ".lsv"
OPEN filename$ FOR OUTPUT AS #1
WRITE #1, cnam$, hpmax, hp, ac, str, dex, th, mana, lev, dlev, xp, keys, xpup
WRITE #1, armo, arm$, x, y
FOR a = 1 TO 15
WRITE #1, item(a)
NEXT a
WRITE #1, item
FOR a = 1 TO 6
WRITE #1, weap(a)
NEXT a
WRITE #1, weap
FOR a = 1 TO 10
WRITE #1, wx(a), wy(a), wnt(a)
NEXT a
FOR a = 1 TO 20
WRITE #1, ix(a), iy(a), intk(a)
NEXT a
FOR a = 1 TO 40
WRITE #1, mx(a), my(a), mnt(a), mnthp(a)
NEXT a
FOR a = 1 TO 40
FOR b = 1 TO 50
WRITE #1, map(a, b)
NEXT b, a
WRITE #1, bnam$, bminhp, bmaxhp, bmindam, bmaxdam, bac, bth, bxp, btyp
CLOSE #1

textstr "Game saved!", 48, 35, 8, 7, 15
clrtxt 8

END SUB

SUB showall

IF manashow = 1 THEN manashow = 0: GOTO convcoord

showthemap:
FOR a = 2 TO 39
FOR b = 2 TO 49
IF map(a, b) = 0 THEN prntchr a, b, 0, 0
IF map(a, b) = -1 THEN prntchr a, b, 8, 219
IF map(a, b) = -2 THEN prntchr a, b, 8, 219
IF map(a, b) = -3 THEN prntchr a, b, 8, 177
IF map(a, b) = -4 THEN prntchr a, b, 6, 176
IF map(a, b) = -5 THEN prntchr a, b, 6, 177
IF map(a, b) = -6 THEN prntchr a, b, 7, 0
IF map(a, b) = -7 THEN prntchr a, b, 7, 0
IF map(a, b) = -8 THEN prntchr a, b, 7, 0
IF map(a, b) = -9 THEN prntchr a, b, 14, 0
IF map(a, b) = -10 THEN prntchr a, b, 14, 0
IF map(a, b) = -100 THEN prntchr a, b, 12, 21
IF map(a, b) = -200 THEN prntchr a, b, 13, 21
IF map(a, b) = -15 THEN prntchr a, b, 2, 1
NEXT b, a
GOTO endofthissub

convcoord:
FOR a = 1 TO 40
FOR b = 1 TO 50
map(a, b) = -ABS(map(a, b))
NEXT b, a
GOTO showthemap

endofthissub:
END SUB

SUB surrender

CLS
textstr "You take out a white tissue and start waving it as you go ahead.", 1, 1, 8, 7, 15
PLAY "t120mso1l20cp20mlcdemsc"
SLEEP 1
textstr "Eventually, you something spots you and takes you to Amrelgna.", 3, 1, 8, 7, 15
PLAY "mso1cp20cp20l50cdefgab"
SLEEP 1
textstr "  'Well!  What have we here?'", 5, 1, 8, 7, 15
SLEEP 1
textstr "  'This is what the sage of Nerra sends to take the Loden from me?", 7, 1, 8, 7, 15
PLAY "o1l20cdefgab"
SLEEP 1
textstr "  'I will personnaly see to your torture.  Bring him to the dungeons'", 9, 1, 8, 7, 15
textstr "and prepare the tools.'", 11, 1, 8, 7, 15
SLEEP 3
CLS
textstr "  'I see you are afraid.  Am I wrong?...  No need to answer.'", 1, 1, 8, 7, 15
SLEEP 1
textstr "  'Bring me a dull knife!  I fear his fingers are twitching too much.", 3, 1, 8, 7, 15
SLEEP 1
PLAY "o6mll64bagfedc<bagfedc<bagfedcp10msl20cfp20o1mll64l20fgl4fl50edc"
PLAY "o6mll64bagfedc<bagfedc<bagfedcp10msl20cfp20o1mll64fgl4fl64edc"
SLEEP 1
textstr "  'Well! Now that two of your fingers are gone, let's try an eye!", 5, 1, 8, 7, 15
textstr "Give me a spoon.", 7, 1, 8, 7, 15
SLEEP 1
FOR a = 450 TO 400 STEP -10
SOUND a, a / 500
NEXT a
FOR a = 400 TO 750 STEP 30
SOUND a, a / 500
NEXT a
PLAY "o1mll64fgl4fl64edc"
SLEEP 1
textstr "  'That hurts doesn't it?  How well do you see with one eye?", 9, 1, 8, 7, 15
SLEEP 2
CLS
textstr "  'I have a bargain to make with you: either you suffer and die,", 1, 1, 8, 7, 15
textstr "or I kill you right this moment and I turn you into one of my faithful", 3, 1, 8, 7, 15
textstr "undead.  Is it a deal?", 5, 1, 8, 7, 15
inputchoice:
LOCATE 7, 1
INPUT "Turn me into an undead [1], proceed with torture [2].", choice
IF choice = 1 THEN GOTO undead
IF choice = 2 THEN GOTO suffer
IF choice <> 1 OR choice <> 2 THEN GOTO inputchoice

undead:
CLS
textstr "  'You have made a good choice.  See you once you are risen.", 1, 1, 8, 7, 15
SLEEP 1
PLAY "o6mll64bagfedc<bagfedc<bagfedcp10msl20cf"
PLAY "t160mno1l4cl5cl16cl4cl5e-l16dl5dl16cl5cl16<bl4>c"
SLEEP 1
textstr "  'There.  Now let us proceed with resurrection.", 3, 1, 8, 7, 15
SLEEP 1
PLAY "o6l64mlee-dd-de-ee-dd-dee-dd-ee-dd-ee-dd-ee-dd-ee-dd-c<bb-aa-gg-fee-dd-ccd-de-efg-ga-ab-b>cd-de-efg-ga-ab-bb-aa-gg-fee-dd-ee-dd-ee-dd-ee-dd-c"
PLAY "t160mno1l4c<l16b>l5cl16cl5dl16dl5e-l4cl16cl5cl4c"
textstr "  'Good...good...Now witness my power!", 5, 1, 8, 7, 15
SLEEP 1
GOTO endofgame

suffer:
CLS
textstr "  'As you wish.  Proceed to cutting off his limbs.", 1, 1, 8, 7, 15
SLEEP 1
PLAY "o1l64mscdcdcdcdcdcdcdcdcp30dededededededededep30cdcdcdcdcdcdcdcdcp30dededededededededep30"
PLAY "o1mll64fgl4fl64edc"
PLAY "o1l64mscdcdcdcdcdcdcdcdcp30dededededededededep30cdcdcdcdcdcdcdcdcp30dededededededededep30"
PLAY "o1mll64fgl4fl64edc"
PLAY "o1l64mscdcdcdcdcdcdcdcdcp30dededededededededep30cdcdcdcdcdcdcdcdcp30dededededededededep30"
PLAY "o1mll64fgl4fl64edc"
PLAY "o1l64mscdcdcdcdcdcdcdcdcp30dededededededededep30cdcdcdcdcdcdcdcdcp30dededededededededep30"
PLAY "o1mll64fgl4fl64edc"
textstr "  'Now that only your body and head are left, let us separate them.", 3, 1, 8, 7, 15
SLEEP 1
PLAY "o1l64cdedefefgfgagabp20bagagfgfefededcp20cdedefefgfgagabp20bagagfgfefededcp10l20fc"
PLAY "t160mno1l4cl5cl16cl4cl5e-l16dl5dl16cl5cl16<bl4>c"
SLEEP 1

endofgame:
CLS
textstr "Amrelgna, with his faithful undead raid the village of Nerra.", 1, 1, 8, 7, 15
PLAY "l40mlo1bagfedc<bagfel50dcdcdcdcdcdcdcdp20"
PLAY "l40mlo1bagfedc<bagfel50dcdcdcdcdcdcdcdp20"
PLAY "l40mlo1bagfedc<bagfel50dcdcdcdcdcdcdcd"
SLEEP 1

END SUB

SUB textfile (path$, c1, c2, c3) STATIC

OPEN path$ FOR INPUT AS #1
startit:
l = 0
FOR a = 1 TO 50
  IF l > 49 THEN pause: CLS : GOTO startit
  IF EOF(1) THEN GOTO endsub
  INPUT #1, text$(a)
    l = l + 2
    FOR i = 1 TO LEN(text$(a)) + 4
      IF INKEY$ <> "" THEN GOTO endsub
      FOR c = 1 TO 4
        IF c = 1 THEN COLOR c1
        IF c > 1 THEN COLOR c2
        IF c > 3 THEN COLOR c3
        IF i > c THEN LOCATE l, i - c: PRINT MID$(text$(a), i - c, 1)
          FOR b = 1 TO (spd * 100): NEXT b
      NEXT c
    NEXT i
NEXT a

endsub:
pause
CLOSE #1
END SUB

SUB textstr (text$, l, strt, c1, c2, c3) STATIC

    FOR i = 1 TO LEN(text$) + 4
      FOR c = 1 TO 4
        IF c = 1 THEN COLOR c1
        IF c > 1 THEN COLOR c2
        IF c > 3 THEN COLOR c3
        IF i > c THEN LOCATE l, i - c + strt: PRINT MID$(text$, i - c, 1)
          FOR b = 1 TO (spd * 30): NEXT b
      NEXT c
    NEXT i

END SUB

SUB title

toptitle:
SCREEN 12: WIDTH 80, 60

loden

prntstr 22, 30, 2, "by Joseph Tagg"
prntstr 30, 30, 15, "S"
textstr "tart a new game", 30, 30, 15, 12, 4
prntstr 32, 30, 15, "L"
textstr "oad a saved game", 32, 30, 15, 10, 2
prntstr 34, 30, 15, "P"
textstr "lay a custom level", 34, 30, 15, 6, 14
prntstr 36, 30, 15, "V"
textstr "iew introduction", 36, 30, 3, 9, 1
prntstr 38, 30, 15, "H"
textstr "elp", 38, 30, 8, 4, 12
prntstr 40, 30, 15, "Q"
textstr "uit game", 40, 30, 15, 13, 5

DO
a$ = LCASE$(INKEY$)
IF a$ = "s" THEN newchar: GOTO bottom
IF a$ = "l" THEN loadchar: GOTO bottom
IF a$ = "p" THEN loadcustom: GOTO bottom
IF a$ = "v" THEN intro
IF a$ = "h" THEN help: GOTO toptitle
IF a$ = "q" THEN credits: SYSTEM
LOOP

bottom:
END SUB

SUB usemana

textstr "Discover whole Level", 45, 30, 15, 8, 7
prntstr 45, 31, 15, "D"
textstr "Regain lost Hit Points", 46, 30, 15, 8, 7
prntstr 46, 31, 15, "R"

DO
a$ = LCASE$(INKEY$)
IF a$ = "d" THEN clrtxt 6: mana = mana - 1: manashow = 1: showall: GOTO stopmana
IF a$ = "r" THEN clrtxt 6: mana = mana - 1: hp = hpmax: GOTO stopmana
LOOP

stopmana:
END SUB

SUB weapons STATIC

goweap = 0

f = die(1, lev * 2)
IF lev > 8 THEN f = die(1, 16)
FOR a = 1 TO 10
IF x = wx(a) AND y = wy(a) THEN f = wnt(a)
NEXT a
text1$ = "You have found a "
text2$ = text1$ + wnam$(f) + "!" + "(" + STR$(wmindam(f)) + "-" + STR$(wmaxdam(f)) + ")"
textstr text2$, 42, 1, 15, 12, 4
FOR a = 1 TO 5
IF weap(a) = 0 THEN weap(a) = wnum(f): weap = weap + 1: map(x, y) = 0: wnt(a) = 0: clrtxt 1: goframe = 1: GOTO stopnow
NEXT a
GOTO wnoroom

wnoroom:
textstr "No room left!!!", 43, 2, 15, 14, 6
clrtxt 2
FOR a = 1 TO 10
IF x = wx(a) AND y = wy(a) THEN EXIT FOR
IF wnt(a) = 0 THEN wnt(a) = wnum(f):  wx(a) = x: wy(a) = y:  GOTO stopnow
NEXT a

stopnow:
END SUB

SUB weapuse STATIC

textstr "You have:", 42, 2, 15, 14, 10
FOR a = 1 TO weap
prntnum 42 + a, 3, 3, a
textstr wnam$(weap(a)), 42 + a, 5, 7, 8, 15
NEXT a
inpu:
LOCATE 50, 2: COLOR 7
INPUT "Which one(0=fist)?", wweap
IF wweap > weap THEN GOTO inpu
weap(6) = weap(wweap)

clrtxt 17

END SUB

