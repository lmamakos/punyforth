marker: -tests

exception: EFAC
exception: ETEST

: factorial ( n -- n! | throws:EFAC )
       dup 0< if
           drop EFAC throw
       then
       dup 0= if
           drop 1
       else
           dup 1= if
               drop 1
           else
               dup 1- factorial *
           then
       then ;

: factorial2 ( n -- n! )
    1 2 rot
    begin
        2dup <=
    while
        -rot tuck
        * swap
        1+ rot
    repeat
    2drop ;

: factorial3 ( n -- n! )
    case
        0 of 1 endof
    1 of 1 endof
    dup 1- factorial3 *
    endcase ;

5 array: test_numbers

struct
  cell field: .width
  cell field: .height
constant: Rect

: new-rect Rect create: allot ;
: area ( rect -- area ) dup .width @ swap .height @ * ;
new-rect r1

variable: test_var1
variable: test_var2

defer: deferred-word
: use-deferred 2 3 deferred-word ;

: test:core-arithmetic
   12 3 min 3 =assert
   -3 7 min -3 =assert
   -3 -7 min -7 =assert
   132 33 max 132 =assert
   -33 77 max 77 =assert
   -389 -27 max -27 =assert
   0 1- -1 =assert
   -10 1+ -9 =assert
   -10 4 < assert
   -10 -4 < assert
   324 12 > assert
   -24 -212 > assert
   24 -2 > assert
   1 1- 0= assert
   -1 1+ 0= assert
   15 0<> assert
   0 0<> invert assert
   -3 0< TRUE =assert 3 0< FALSE =assert
   3 0> TRUE =assert -3 0> FALSE =assert
   -12 2 / 6 + 0 =assert
   1 2 tuck 2 =assert 1 =assert 2 =assert
   -123 abs 123 =assert 32 abs 32 =assert 0 abs 0 =assert
   -42 abs 42 abs =assert
   -12 -3 * 36 =assert -3 4 * -12 =assert 2 -4 * -8 =assert
   -12 -3 + -15 =assert -3 4 + 1 =assert 2 -4 + -2 =assert
   -12 -3 - -9 =assert -3 4 - -7 =assert 2 -4 - 6 =assert
   12 -6 / -2 =assert -36 6 / -6 =assert -4 -2 / 2 =assert 
   0 1 lshift 0 =assert
   1 1 lshift 2 =assert
   3 4 lshift 48 =assert
   3 0 lshift 3 =assert
   0 1 rshift 0 =assert
   2 1 rshift 1 =assert
   128 3 rshift 16 =assert
   4 4 >= assert 5 4 >= assert -4 -10 >= assert 4 5 >= invert assert
   6 6 <= assert 3 9 <= assert -9 -5 <= assert 10 2 <= invert assert
   12 3 /mod 4 =assert 0 =assert 12 4 / 3 =assert
   13 5 /mod 2 =assert 3 =assert 14 6 % 2 =assert ;

: test:core-branch
   TRUE if TRUE assert else FALSE assert then
   FALSE if FALSE assert else TRUE assert then
   2 TRUE if dup * then 4 =assert
   2 FALSE if dup * then 2 =assert ;

: test:core-bounds
    10000 5 bounds 10000 =assert 10005 =assert ;

: test:core-?dup
   42 0 ?dup 0 =assert 42 =assert
   42 12 ?dup 12 =assert 12 =assert 42 =assert ;

424242 constant: SENTINEL

: test:core-doloop
   SENTINEL 10000 5 bounds do i loop
   10004 =assert 10003 =assert 10002 =assert 10001 =assert 10000 =assert
   SENTINEL =assert
   0 11 1 do i + loop 55 =assert
   0 11 1 do i + 1 +loop 55 =assert
   0 50 0 do i + 5 +loop 225 =assert
   SENTINEL 15 0 do i 5 +loop 10 =assert 5 =assert 0 =assert SENTINEL =assert
   SENTINEL 3 0 do i 2 +loop 2 =assert 0 =assert SENTINEL =assert
   SENTINEL 1 0 do i 2 +loop 0 =assert SENTINEL =assert
   SENTINEL -5 0 do i -2 +loop -4 =assert -2 =assert 0 =assert SENTINEL =assert
   SENTINEL -1 0 do i -1 +loop -1 =assert 0 =assert SENTINEL =assert
   SENTINEL 0 0 do i -1 +loop 0 =assert SENTINEL =assert
   0 8 2 do 9 3 do i j + + loop loop 360 =assert ;

: doloop-exit 10 0 do i 5 = if i unloop exit then loop ;
: test:core-unloop
   doloop-exit 5 =assert ;

: test:core-logic
   1 0 or 1 =assert 0 1 or 1 =assert
   1 1 or 1 =assert 0 0 or 0 =assert
   1 0 and 0 =assert 0 1 and 0 =assert
   1 1 and 1 =assert 0 0 and 0 =assert
   1 0 xor 1 =assert 0 1 xor 1 =assert
   1 1 xor 0 =assert 0 0 xor 0 =assert
   10 2 < 3 1 > or if 1 else 0 then 1 =assert
   3 10 < 3 11 > and if 1 else 0 then 0 =assert
   -98 45 < 33 11 > and if 1 else 0 then 1 =assert ;

: test:core-between
   1 2 3 between? assert
   1 1 1 between? assert
   1 1 2 between? assert
   1 2 2 between? assert
   3 2 4 between? invert assert
   1 3 2 between? invert assert ;

: test:core-factorial
   9 factorial 362880 =assert
   8 factorial 8 factorial2 =assert
   9 factorial 9 factorial3 =assert ;

: test:core-hex
   str: "aBcDeF" hex>int 11259375 =assert
   str: "AbCdEf" hex>int 11259375 =assert
   str: "12345678" hex>int 305419896 =assert
   str: "a1" hex>int 161 =assert
   str: "123abc" hex>int 1194684 =assert
   { str: "" hex>int } catch ECONVERT =assert
   { str: "123g4" hex>int } catch ECONVERT =assert
   { str: "12G4" hex>int } catch ECONVERT =assert
   hex: a0f 2575 =assert ;

: test:core-case   
   1 case
       1 of 10 endof
       2 of 20 endof
       3 of 30 endof
   endcase 10 =assert
   2 case
       1 of 10 endof
       2 of 20 endof
       3 of 30 endof
   endcase 20 =assert
   3 case
       1 of 10 endof
       2 of 20 endof
       3 of 30 endof
   endcase 30 =assert
   1 case
       1 of 2 endof
       2 of 3 endof
   endcase 2 =assert ;

: test:core-defer
   ['] deferred-word is: +
   use-deferred 5 =assert
   ['] deferred-word is: *
   use-deferred 6 =assert ;

: negative-factorial -1 factorial ;
: nested-throw1 dup 1= if drop 10 throw then 2 = if 20 throw then 42 ;
: nested-throw2
       ['] nested-throw1 catch dup 10 = if
          drop 30 throw
       else
          throw
       then ;
: 1nested-throw2 1 nested-throw2 ;
: 2nested-throw2 2 nested-throw2 ;
: 3nested-throw2 3 nested-throw2 ;

: simple-throw 123 throw ;
: throw-if-42 42 = if ETEST throw then ;

: test:core-catch
   sp@ test_var1 !
   ['] negative-factorial catch EFAC =assert
   ['] 1nested-throw2 catch 30 =assert
   ['] 2nested-throw2 catch 20 =assert
   ['] 3nested-throw2 catch drop 42 =assert
   3 nested-throw2 42 =assert
   ['] simple-throw catch 123 =assert
   24 ['] throw-if-42 catch 0= assert
   42 ['] throw-if-42 catch ETEST =assert drop ( 42 )
   sp@ test_var2 !
   test_var1 @ test_var2 @ =assert ;

: test:core-rdepth
   rdepth
   1 >r 2 >r 3 >r
   dup 3 + rdepth =assert
   r> drop r> drop
   dup 1 + rdepth =assert
   r> drop
   rdepth =assert ;

: test:core-alloc
   freemem 16 allot freemem - 16 =assert ;

: test:core-str
   str: "" strlen 0 =assert
   str: "1" strlen 1 =assert
   str: "12" strlen 2 =assert
   str: "1234567" strlen 7 =assert
   str: '""""' strlen 4 =assert
   str: 'anystring' 
   str: ''
   str-starts? TRUE =assert
   str: ''
   str: ''
   str-starts? TRUE =assert
   str: 'abc'
   str: 'bc'
   str-starts? FALSE =assert
   str: 'abc'
   str: 'ab'
   str-starts? TRUE =assert
   str: 'aabbc'
   str: 'aabbc'
   str-starts? TRUE =assert
   str: 'aabbc'
   str: 'aabbcc'
   str-starts? FALSE =assert
   str: 'abcxxxx' 
   str: 'abc' 
   str-in? TRUE =assert   
   str: 'xxabcyy' 
   str: 'abc' 
   str-in? TRUE =assert   
   str: 'xxabzyy' 
   str: 'abc'
   str-in? FALSE =assert
   str: 'anystring' 
   str: '' 
   str-in? assert   
   str: 'xxx'
   str: 'xxx' 
   str-in? assert   
   str: 'abcdef'
   str: 'def' 
   str-in? assert   
   str: 'abcdef'
   str: 'efg' 
   str-in? FALSE =assert 
   str: "" str: "" =str assert
   str: "1" str: "12" =str invert assert
   str: "" str: "12" =str invert assert
   str: "1" str: "2" =str invert assert
   str: "12" str: "13" =str invert assert
   str: "abcd" str: "abcde" =str invert assert
   str: "abcdef" str: "abcdeF" =str invert assert ;
       
: test:eval-whitespace
   32 whitespace? assert
   10 whitespace? assert
   13 whitespace? assert
   9 whitespace? assert
   65 whitespace? invert assert ;

: test:core-multi-line-str
str: 
"
A\n
B
"  
   dup strlen 3 = assert
   dup c@ 65 = assert
   dup 1+ c@ 10 = assert
   dup 2 + c@ 66 = assert
   drop ;

: test:core-str-escape
   str: 'a\nb' 1 + c@ 10 =assert 
   str: '\rb' c@ 13 =assert 
   str: '\\' c@ 92 =assert 
   str: '\\\\' strlen 2 =assert 
   str: '\t' c@ 9 =assert 
   str: "\"" c@ 34 =assert 
   str: "\'" c@ 39 =assert 
   str: 'abc\r\nd' strlen 6 =assert ;

: test:core-untilloop
   2 10 begin 1- swap 2 * swap dup 0= until drop 2048 =assert ;

: test:core-quotation
   10 { } execute 10 =assert
   6 { dup + } execute 12 =assert
   3 4 { 1+ swap 2 * swap } execute 5 =assert 6 =assert
   0 5 { 0 do i + loop } execute 10 =assert
   -7 { dup 0< if -1 * then } execute 7 =assert
   57 { dup 0< if -1 * then } execute 57 =assert
   12 { 1+ { 1+ } execute } execute 14 =assert   
   10 { 1+ { 1+ { 1+ } execute } execute } execute 13 =assert ;

: test:core-combinators
   1 2 4 { + } dip 4 =assert 3 =assert
   1 2 4 { + } keep 4 =assert 6 =assert 1 =assert
   str: "john" str: ".doe" { 1+ c@ } { 2 + c@ } bi* =assert
   str: "john" str: ".doe" { strlen } bi@ =assert
   str: "john.doe" { strlen } { 1+ c@ 103 - } bi =assert ;

: test:core-array   
   5 0 do i i test_numbers ! loop
   5 0 do i test_numbers @ i =assert loop ;

create: seq1 1 , 2 , 3 ,
create: seq2 4 c, 5 c,
: test:core-create
    seq1 0 cells + @ 1 =assert
    seq1 1 cells + @ 2 =assert
    seq1 2 cells + @ 3 =assert
    seq2 0 + c@ 4 =assert
    seq2 1 + c@ 5 =assert ;

3 buffer: buf1
: test:core-buffer
   1 buf1 0 + c!
   2 buf1 1 + c!
   3 buf1 2 + c!
   buf1 0 + c@ 1 =assert
   buf1 1 + c@ 2 =assert
   buf1 2 + c@ 3 =assert ;

: test:core-struct
   3 r1 .width ! 5 r1 .height !
   r1 area 15 =assert ;

: test:core-var
   12 test_var1 ! test_var1 @ 12 =assert
   3 test_var1 +! test_var1 @ 15 =assert ;

: to-override 42 ;
: to-override override to-override 3 + ;
: test:core-override
    to-override 45 =assert ;

: test:>str
    here dup 1234567     >str str: '1234567'     =str assert
    here dup 1234        >str str: '1234'        =str assert
    here dup -123        >str str: '-123'        =str assert
    here dup -87654321   >str str: '-87654321'   =str assert
    here dup 1           >str str: '1'           =str assert
    here dup -1          >str str: '-1'          =str assert
    here dup 2147483647  >str str: '2147483647'  =str assert
    here dup -2147483647 >str str: '-2147483647' =str assert
    here dup 0           >str str: '0'           =str assert ;

str: "123"    constant: s1
str: "abcdef" constant: s2
: test:cmove
    s1 s2 0 cmove s2 str: "abcdef" =str assert
    s1 s2 1 cmove s2 str: "1bcdef" =str assert
    s1 s2 3 cmove s2 str: "123def" =str assert ;

variable: dp-before-mark dp dp-before-mark !
marker: -test-mark
: word-after-marker 1 2 3 ; 237 allot

: test:core-marker
   -test-mark
   dp dp-before-mark @ =assert ;

: test:r@
   123 >r r@ 123 =assert r> drop
   -34 >r r@ -34 =assert r> drop ;

depth 0= assert
test
depth 0= assert

-tests
