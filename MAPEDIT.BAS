'                               LODEN MAPEDIT
'
'  You can make your own maps with this program and then play them choosing
'play custom level.

DECLARE SUB clrtxt (num!)
DECLARE SUB prntchr (x, y, c, h)
DECLARE SUB prntstr (x, y, c, w$)

CLS : SCREEN 12: WIDTH 80, 60: a = 0

CHDIR "c:\desktop\loden"         '<------PATH

OPEN "list.ldn" FOR INPUT AS #1
DO
a = a + 1
INPUT #1, filenam$(a)
IF filenam$(a) = "" THEN GOTO nextpart
prntstr a + 5, 25, 15, filenam$(a)
LOOP UNTIL (EOF(1))
nextpart:
CLOSE
INPUT "Level name? (0=new)", file$
IF file$ = "0" THEN file$ = "level.dlt"
IF INSTR(1, file$, ".") THEN filename$ = file$ ELSE filename$ = file$ + ".cst"
OPEN filename$ FOR INPUT AS #1
DIM map(40, 50)
FOR a = 1 TO 40
FOR b = 1 TO 50
INPUT #1, map(a, b)
NEXT b, a
INPUT #1, bnam$, bminhp, bmaxhp, bmindam, bmaxdam, bac, bth, bxp, btyp
INPUT #1, xpos, ypos
CLOSE
CLS

ON ERROR GOTO openit

x = 3: y = 3

FOR a = 1 TO 40
FOR b = 1 TO 50
IF map(a, b) = 0 THEN prntchr a, b, 0, 0
IF map(a, b) = 1 THEN prntchr a, b, 8, 219
IF map(a, b) = 2 THEN prntchr a, b, 8, 177
IF map(a, b) = 4 THEN prntchr a, b, 6, 176
IF map(a, b) = 5 THEN prntchr a, b, 6, 177
IF map(a, b) = 6 THEN prntchr a, b, 7, 197
IF map(a, b) = 7 THEN prntchr a, b, 7, 127
IF map(a, b) = 8 THEN prntchr a, b, 4, 1
IF map(a, b) = 9 THEN prntchr a, b, 14, 20
IF map(a, b) = 15 THEN prntchr a, b, 2, 1
IF map(a, b) = 10 THEN prntchr a, b, 14, 234
IF map(a, b) = 100 THEN prntchr a, b, 12, 21
IF map(a, b) = 200 THEN prntchr a, b, 13, 21
NEXT b
NEXT a

prntstr 4, 52, 15, "0 - Nothing"
prntstr 5, 52, 7, "1 - Wall"
prntstr 6, 52, 7, "2 - Secret passage"
prntstr 7, 52, 6, "4 - Door"
prntstr 8, 52, 6, "5 - Locked door"
prntstr 9, 52, 7, "6 - Weapon"
prntstr 10, 52, 7, "7 - Item"
prntstr 11, 52, 4, "8 - Enemy"
prntstr 12, 52, 14, "9 - Key"
prntstr 13, 52, 14, "a - Armor"
prntstr 14, 52, 2, "b - Boss"
prntstr 15, 52, 12, "e - End level"
prntstr 16, 52, 13, "w - Start position"
prntstr 17, 52, 15, "s - Save level"
prntstr 18, 52, 15, "d - Delete level"
prntstr 19, 52, 15, "q - Exit editor"

move:
DO
a$ = INKEY$
IF a$ = CHR$(0) + "M" THEN x1 = x: y1 = y + 1: GOTO check
IF a$ = CHR$(0) + "K" THEN x1 = x: y1 = y - 1: GOTO check
IF a$ = CHR$(0) + "H" THEN x1 = x - 1: y1 = y: GOTO check
IF a$ = CHR$(0) + "P" THEN x1 = x + 1: y1 = y: GOTO check

prntchr x, y, 6, 8
IF a$ = "0" THEN map(x, y) = 0: GOTO start
IF a$ = "1" THEN map(x, y) = 1: GOTO start
IF a$ = "2" THEN map(x, y) = 2: GOTO start
IF a$ = "4" THEN map(x, y) = 4: GOTO start
IF a$ = "5" THEN map(x, y) = 5: GOTO start
IF a$ = "6" THEN map(x, y) = 6: GOTO start
IF a$ = "7" THEN map(x, y) = 7: GOTO start
IF a$ = "8" THEN map(x, y) = 8: GOTO start
IF a$ = "9" THEN map(x, y) = 9: GOTO start
IF a$ = LCASE$("b") THEN map(x, y) = 15: GOSUB bossedit
IF a$ = LCASE$("a") THEN map(x, y) = 10: GOTO start
IF a$ = LCASE$("w") THEN map(x, y) = 200: xpos = x: ypos = y: GOTO start
IF a$ = LCASE$("e") THEN map(x, y) = 100: GOTO start
IF a$ = LCASE$("s") THEN GOSUB save
IF a$ = LCASE$("d") THEN GOSUB delevel
IF a$ = LCASE$("q") THEN END

LOOP
check:
IF map(x, y) = 0 THEN prntchr x, y, 0, 0
IF map(x, y) = 1 THEN prntchr x, y, 8, 219
IF map(x, y) = 2 THEN prntchr x, y, 8, 177
IF map(x, y) = 4 THEN prntchr x, y, 6, 176
IF map(x, y) = 5 THEN prntchr x, y, 6, 177
IF map(x, y) = 6 THEN prntchr x, y, 7, 197
IF map(x, y) = 7 THEN prntchr x, y, 7, 127
IF map(x, y) = 8 THEN prntchr x, y, 4, 1
IF map(x, y) = 9 THEN prntchr x, y, 14, 20
IF map(x, y) = 15 THEN prntchr x, y, 2, 1
IF map(x, y) = 10 THEN prntchr x, y, 14, 234
IF map(x, y) = 100 THEN prntchr x, y, 12, 21
IF map(x, y) = 200 THEN prntchr x, y, 13, 21
IF x1 = 2 OR x1 = 39 THEN GOTO move
IF y1 = 2 OR y1 = 49 THEN GOTO move
x = x1: y = y1
GOTO move

start:
IF map(x, y) = 0 THEN prntchr x, y, 0, 0
IF map(x, y) = 1 THEN prntchr x, y, 8, 219
IF map(x, y) = 2 THEN prntchr x, y, 8, 177
IF map(x, y) = 4 THEN prntchr x, y, 6, 176
IF map(x, y) = 5 THEN prntchr x, y, 6, 177
IF map(x, y) = 6 THEN prntchr x, y, 7, 197
IF map(x, y) = 8 THEN prntchr x, y, 4, 1
IF map(x, y) = 9 THEN prntchr x, y, 14, 20
IF map(x, y) = 15 THEN prntchr x, y, 2, 1
IF map(x, y) = 10 THEN prntchr x, y, 14, 234
IF map(x, y) = 100 THEN prntchr x, y, 12, 21
IF map(x, y) = 200 THEN prntchr x, y, 13, 21
GOTO move

save:
a = 0
LOCATE 41, 1
COLOR 15
PRINT ""
INPUT "File name: ", file$
IF INSTR(1, file$, ".") THEN GOTO ende

OPEN file$ FOR INPUT AS #1
CLOSE
GOTO ende

openit:
OPEN "list.ldn" FOR INPUT AS #1
DO
a = a + 1
INPUT #1, filenam$(a)
LOOP UNTIL EOF(1)
CLOSE
OPEN "list.ldn" FOR OUTPUT AS #1
FOR b = 1 TO a
PRINT #1, filenam$(b)
NEXT b
WRITE #1, file$
CLOSE
file$ = file$ + ".cst"

ende:
clrtxt 1
OPEN file$ FOR OUTPUT AS #1
FOR a = 1 TO 40
FOR b = 1 TO 50
PRINT #1, map(a, b),
NEXT b, a
WRITE #1, bnam$, bminhp, bmaxhp, bmindam, bmaxdam, bac, bth, bxp, btyp
WRITE #1, xpos, ypos
CLOSE
LOCATE 41, 1: COLOR 0: PRINT "                      "
GOTO start

delevel:
   a = 0
   OPEN "list.ldn" FOR INPUT AS #1
   DO
   a = a + 1
   INPUT #1, filename$(a)
   IF filename$(a) = "" THEN GOTO geton
   LOCATE a + 40, 30
   PRINT a; "-"; filename$(a)
   LOOP UNTIL (EOF(1))
geton:
   CLOSE
   LOCATE a + 41, 25
   INPUT "Which one do you want to delete?", dellevel
   IF dellevel = 0 THEN clrtxt 15: RETURN
   KILL filename$(dellevel) + ".cst"
   OPEN "list.ldn" FOR OUTPUT AS #1
   FOR b = 1 TO dellevel - 1
   PRINT #1, filename$(b)
   NEXT b
   FOR b = dellevel TO a - 1
   PRINT #1, filename$(b + 1)
   NEXT b
   CLOSE
   clrtxt 15
   RETURN

bossedit:
IF bossput = 1 THEN
prntstr 41, 1, 4, "You have already put a boss for this level!"
prntstr 42, 1, 4, "If you put a new one, don't forget to take away the old one!"
END IF
SLEEP
clrtxt 2
LOCATE 41, 1
COLOR 2
INPUT "Boss name: ", bnam$
INPUT "Boss minimum HP: ", bminhp
INPUT "Boss maximum HP: ", bmaxhp
INPUT "Boss AC: ", bac
INPUT "Boss To Hit %: ", bth
INPUT "Boss XP: ", bxp
INPUT "Boss minimum damage: ", bmindam
INPUT "Boss maximum damage: ", bmaxdam
btyp = 1
bossput = 1
clrtxt 8
RETURN

SUB clrtxt (num)

FOR a = 41 TO (41 + num)
prntstr a, 1, 0, "                                                                         "
NEXT a

END SUB

SUB prntchr (x, y, c, h) STATIC

COLOR c
LOCATE x, y
PRINT CHR$(h)

END SUB

SUB prntstr (x, y, c, w$) STATIC

LOCATE x, y
COLOR c
PRINT w$

END SUB

