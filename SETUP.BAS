'                               LODEN SETUP
'
'press up to make the scrolling faster and down for slower.
'once you have found a good speed press Enter.
'Note: make it a little slower than you think is right.  It goes faster than
'you might think.  Test it a few times to get the correct speed.

DECLARE SUB check ()
DECLARE SUB textstr (text$, l!, strt!, c1!, c2!, c3!)
DECLARE SUB drawframe ()
DECLARE SUB setspeed ()

COMMON SHARED selspd, spd

CLS : SCREEN 12

CHDIR "c:\desktop\loden"         '<------PATH

FOR x = 1 TO 28
FOR y = 1 TO 80
LOCATE x, y: COLOR 5: PRINT CHR$(219)
NEXT y, x

CALL drawframe

LOCATE 12, 32: COLOR 4: PRINT "CHOOSE TEXT SPEED"
LOCATE 15, 37: COLOR 9: PRINT "Slow"
LOCATE 15, 37: COLOR 3: PRINT "S"
LOCATE 16, 36: COLOR 9: PRINT "Normal"
LOCATE 16, 36: COLOR 3: PRINT "N"
LOCATE 17, 37: COLOR 9: PRINT "Fast"
LOCATE 17, 37: COLOR 3: PRINT "F"

DO
a$ = LCASE$(INKEY$)
IF a$ = "s" THEN selspd = 1: EXIT DO
IF a$ = "n" THEN selspd = 2: EXIT DO
IF a$ = "f" THEN selspd = 3: EXIT DO
IF a$ = CHR$(27) THEN END
LOOP

CALL setspeed

CALL check

IF spd > 2 THEN addon = 1
IF spd <= 2 THEN addon = .25

DO
a$ = LCASE$(INKEY$)
IF a$ = CHR$(13) THEN GOTO endhere
IF a$ = CHR$(0) + "h" THEN spd = spd - addon: CALL check
IF a$ = CHR$(0) + "p" THEN spd = spd + addon: CALL check
LOOP

endhere:
OPEN "setup.dat" FOR OUTPUT AS #1
WRITE #1, spd
CLOSE #1
CALL drawframe
LOCATE 15, 25: COLOR 3: PRINT "To play, just run loden.bas!"
END

SUB check

CALL drawframe

LOCATE 12, 35: COLOR 4: PRINT "Is this OK?"
textstr "Text scrolling speed adjustment.", 15, 20, 15, 10, 2
FOR x = 1 TO (spd * 10000): NEXT x
textstr "                                   ", 15, 20, 15, 7, 0
COLOR 2
LOCATE 18, 39: COLOR 3: PRINT "Ok"
LOCATE 18, 35: COLOR 3: PRINT CHR$(25)
LOCATE 18, 44: COLOR 3: PRINT CHR$(24)

END SUB

SUB drawframe

FOR x = 10 TO 20
FOR y = 17 TO 62
LOCATE x, y: COLOR 0: PRINT CHR$(219)
NEXT y, x
FOR x = 11 TO 21
LOCATE x, 63: COLOR 8: PRINT CHR$(176)
NEXT x
FOR x = 18 TO 62
LOCATE 21, x: COLOR 8: PRINT CHR$(176)
NEXT x
LOCATE 10, 17: COLOR 10: PRINT CHR$(201)
FOR x = 18 TO 61
LOCATE 10, x: COLOR 10: PRINT CHR$(205)
NEXT x
LOCATE 10, 36: COLOR 2: PRINT " SETUP "
LOCATE 10, 62: COLOR 10: PRINT CHR$(187)
FOR x = 11 TO 19
LOCATE x, 17: COLOR 10: PRINT CHR$(186)
LOCATE x, 62: COLOR 10: PRINT CHR$(186)
NEXT x
LOCATE 20, 17: COLOR 10: PRINT CHR$(200)
FOR x = 18 TO 61
LOCATE 20, x: COLOR 10: PRINT CHR$(205)
NEXT x
LOCATE 20, 62: COLOR 10: PRINT CHR$(188)
END SUB

SUB setspeed

PLAY "t60p1"
0 TIMER ON
start = TIMER
FOR a = 1 TO 10000: NEXT a
PRINT ""
finish = TIMER - start
TIMER OFF
spd = CINT(1 / (finish + .0001)) / 2
IF spd > 100 THEN GOTO 0

IF selspd = 1 THEN spd = spd * 2
IF selspd = 2 THEN spd = spd
IF selspd = 3 THEN spd = spd / 2

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

