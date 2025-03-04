#lang racket
(require (lib "trace.ss"))
(require "etapa2.rkt")

; ignorați următoarele linii de cod...
(define show-defaults 999) ; câte exerciții la care s-au întors rezultate default să fie arătate detaliat
(define prepend #t) (define nopoints #f) (define name-ex '(testul testele trecut capitolul))
(define default-results `(#f 0 () your-code-here)) (define (default-result r) (set! default-results (cons r default-results))) (define : 'separator) (define punct 'string) (define puncte 'string) (define BONUS 'string) (define exerciții 'string)
(define total 0) (define all '()) (define n-ex 0) (define p-ex 0) (define n-exercs -1) (define default-returns '()) (define (ex n sep p . s) (set! n-ex n) (set! p-ex p) (set! all (cons (list n p) all))) (define exercițiul ex) (define (sunt n s) (set! n-exercs n)) (define s-a string-append)
(define (p . L) (map (λ (e) (display e) (when (> (string-length (format "~a" e)) 0) (display " "))) L) (newline)) (define (p-n-ex) (format "[~a]" (if nopoints (string-join (list (symbol->string (cadddr name-ex)) (number->string n-ex) "/" (number->string n-exercs))) n-ex)))
(define (epart ep% pfix full) (if (< (caddr ep%) 1) (s-a pfix (if full "" (s-a (symbol->string (car name-ex)) " ")) (if (and nopoints (not full)) "" (number->string n-ex)) (symbol->string (cadr ep%))) (if (and nopoints (not full)) "" (s-a pfix (if full "" (s-a (symbol->string (car name-ex)) " ")) (number->string n-ex)))))
(define (whengood ep%) (let [(pts (* p-ex (caddr ep%)))] (and (if prepend (printf "+~v: " pts) (printf "~a[OK] " (p-n-ex))) (if nopoints (p (epart ep% "" #f) "rezolvat") (p (epart ep% "" #f) "rezolvat: +" pts (if (= pts 1) 'punct 'puncte))) (set! total (+ total pts)))))
(define (whenbad ep% gvn expcd msg) (and (when (member gvn default-results) (set! default-returns (cons (epart ep% "" #t) default-returns))) (when (or (not (member gvn default-results)) (<= (length default-returns) show-defaults)) (bad-res ep% gvn expcd msg))))
(define (bad-res ep% gvn expcd msg) (p (if prepend "+0.0:" (format "~a[--]" (p-n-ex))) (epart ep% "la " #f) 'rezultatul gvn msg expcd))
(define (check-conds e gvn conds) (or (null? conds) (let ([r ((car conds) gvn)]) (if (eq? r #t) (check-conds e gvn (cdr conds)) (whenbad e gvn "" (or r "nu îndeplinește condiția"))))))
(define (check-part part per given main-test expected . conds) (let* ([e (list n-ex part per)] [p? (pair? (cdr main-test))] [p (if p? (car main-test) identity)] [t ((if p? cadr car) main-test)] [m ((if p? cddr cdr) main-test)]) (when (eq? #t (check-conds e given conds)) (if (t (p given) expected) (whengood e) (whenbad e (p given) expected m)))))
(define (check given main-test expected . conds) (apply check-part '- 1 given main-test expected conds))
(define the cons) (define is (cons equal? "diferă de cel așteptat")) (define in (cons member "nu se află printre variantele așteptate"))
(define same-set-as (cons (λ (x y) (apply equal? (map list->seteqv (list x y)))) "nu este aceeași mulțime cu"))
(define same-unique (cons (λ (x y) (and (apply = (map length (list x y))) ((car same-set-as) x y))) "nu sunt aceleași rezultate cu"))
(define (sumar) (when (and (not (null? default-returns)) (< show-defaults (length default-returns))) (p "... rezultatul implicit dat la" (cadr name-ex) (reverse default-returns))) (when (not nopoints) (p 'total: total 'puncte)))
(define (mark-helper) (printf "---~nEx  puncte    Total până aici~n") (foldr (λ (e-p t) (p (car e-p) ': (cadr e-p) "puncte. total 1 -" (car e-p) ': (+ t (cadr e-p))) (+ t (cadr e-p))) 0 all) (newline))

(define men-preferences-0
  '([adi  ana  bia cora]
    [bobo cora ana bia ]
    [cos  cora bia ana ]))
(define women-preferences-0
  '([ana  bobo adi cos ]
    [bia  adi  cos bobo]
    [cora bobo cos adi ]))

(define men-preferences-1
  '([abe  abi  eve  cath ivy  jan  dee  fay  bea  hope gay ]
    [bob  cath hope abi  dee  eve  fay  bea  jan  ivy  gay ]
    [col  hope eve  abi  dee  bea  fay  ivy  gay  cath jan ]
    [dan  ivy  fay  dee  gay  hope eve  jan  bea  cath abi ]
    [ed   jan  dee  bea  cath fay  eve  abi  ivy  hope gay ]
    [fred bea  abi  dee  gay  eve  ivy  cath jan  hope fay ]
    [gav  gay  eve  ivy  bea  cath abi  dee  hope jan  fay ]
    [hal  abi  eve  hope fay  ivy  cath jan  bea  gay  dee ]
    [ian  hope cath dee  gay  bea  abi  fay  ivy  jan  eve ]
    [jon  abi  fay  jan  gay  eve  bea  dee  cath ivy  hope]))
(define women-preferences-1
  '([abi  bob  fred jon  gav  ian  abe  dan  ed   col  hal ]
    [bea  bob  abe  col  fred gav  dan  ian  ed   jon  hal ]
    [cath fred bob  ed   gav  hal  col  ian  abe  dan  jon ]
    [dee  fred jon  col  abe  ian  hal  gav  dan  bob  ed  ]
    [eve  jon  hal  fred dan  abe  gav  col  ed   ian  bob ]
    [fay  bob  abe  ed   ian  jon  dan  fred gav  col  hal ]
    [gay  jon  gav  hal  fred bob  abe  col  ed   dan  ian ]
    [hope gav  jon  bob  abe  ian  dan  hal  ed   col  fred]
    [ivy  ian  col  hal  gav  fred bob  abe  ed   jon  dan ]
    [jan  ed   hal  gav  abe  bob  jon  col  ian  fred dan ]))

(define men-preferences-2
  '([abe  abi  eve  cath ivy  jan  dee  fay  bea  hope gay ]
    [bob  abi hope  cath dee  eve  fay  bea  jan  ivy  gay ]
    [col  hope eve  abi  dee  bea  fay  ivy  gay  cath jan ]
    [dan  ivy  bea  dee  gay  hope eve  jan  fay  cath abi ]
    [ed   jan  dee  bea  cath fay  eve  abi  ivy  hope gay ]
    [fred bea  abi  dee  gay  eve  ivy  cath jan  hope fay ]
    [gav  gay  eve  ivy  bea  cath abi  dee  hope jan  fay ]
    [hal  abi  eve  hope fay  ivy  cath jan  bea  gay  dee ]
    [ian  hope cath dee  gay  bea  abi  fay  ivy  jan  eve ]
    [jon  abi  fay  jan  gay  eve  bea  dee  cath ivy  hope]))
(define women-preferences-2
  '([abi  bob  fred jon  gav  ian  abe  dan  ed   col  hal ]
    [bea  bob  abe  col  fred gav  dan  ian  ed   jon  hal ]
    [cath fred bob  ed   gav  hal  col  ian  abe  dan  jon ]
    [dee  fred jon  col  abe  ian  hal  gav  dan  bob  ed  ]
    [eve  jon  hal  fred dan  abe  gav  col  ed   ian  bob ]
    [fay  bob  abe  ed   ian  jon  dan  fred gav  col  hal ]
    [gay  jon  gav  hal  fred bob  abe  col  ed   dan  ian ]
    [hope gav  jon  bob  abe  ian  dan  hal  ed   col  fred]
    [ivy  ian  col  hal  gav  fred bob  abe  ed   jon  dan ]
    [jan  ed   hal  gav  abe  bob  jon  col  ian  fred dan ]))


(sunt 9 exerciții)

(exercițiul 1 : 10 puncte)
(check-part 'a (/ 1 2) (get-men men-preferences-0) is '(adi bobo cos))
(check-part 'b (/ 1 2) (get-men men-preferences-1) is '(abe bob col dan ed fred gav hal ian jon))

(exercițiul 2 : 10 puncte)
(check-part 'a (/ 1 2) (get-women women-preferences-0) is '(ana bia cora))
(check-part 'b (/ 1 2) (get-women women-preferences-1) is '(abi bea cath dee eve fay gay hope ivy jan))

(exercițiul 3 : 10 puncte)
(check-part 'a (/ 1. 4) (get-pref-list women-preferences-0 'cora) is '(bobo cos adi))
(check-part 'b (/ 1. 4) (get-pref-list women-preferences-1 'bea) is '(bob abe col fred gav dan ian ed jon hal))
(check-part 'c (/ 1. 4) (get-pref-list men-preferences-1 'bob) is '(cath hope abi  dee  eve  fay  bea  jan  ivy  gay))
(check-part 'd (/ 1. 4) (get-pref-list men-preferences-2 'bob) is '(abi hope  cath dee  eve  fay  bea  jan  ivy  gay))

(exercițiul 4 : 10 puncte)
(check-part 'a (/ 1. 4) (preferable? '(ana bia cora) 'ana 'bia) is #t)
(check-part 'b (/ 1. 4) (preferable? '(bob abe col fred gav dan ian ed jon hal) 'dan 'gav) is #f)
(check-part 'c (/ 1. 4) (preferable? '(ana bia cora) 'cora 'ana) is #f)
(check-part 'd (/ 1. 4) (preferable? '(bob abe col fred gav dan ian ed jon hal) 'fred 'ian) is #t)

(exercițiul 5 : 15 puncte)
(check-part 'a (/ 1. 4) (find-first odd? '(1 2 3 4 5 6)) is 1)
(check-part 'b (/ 1. 4) (find-first even? '(1 3 5 11)) is #f)
(check-part 'c (/ 1. 4) (find-first null? '()) is #f)
(check-part 'd (/ 1. 4) (find-first list? '(1 2 3 4 5 (6) (7 8))) is '(6))

(exercițiul 6 : 10 puncte)
(check-part 'a (/ 1. 4) (get-partner '((ana . cos) (bia . adi) (cora . bobo)) 'cora) is 'bobo)
(check-part 'b (/ 1. 4) (get-partner '((ana . cos) (bia . adi) (cora . bobo)) 'adi) is #f)
(check-part 'c (/ 1. 4) (get-partner '((ana . cos) (bia . adi) (cora . bobo)) 'ema) is #f)
(check-part 'd (/ 1. 4) (get-partner '() 'ana) is #f)

(exercițiul 7 : 15 puncte)
(check-part 'a (/ 1. 4) (change-first odd? '(1 2 3 4 5 6) '()) is '(() 2 3 4 5 6))
(check-part 'b (/ 1. 4) (change-first even? '(1 3 5 11) 12) is '(1 3 5 11))
(check-part 'c (/ 1. 4) (change-first null? '() 1) is '())
(check-part 'd (/ 1. 4) (change-first list? '(1 2 3 4 5 (6) (7 8)) null?) is (list 1 2 3 4 5 null? '(7 8)))

(exercițiul 8 : 10 puncte)
(check-part 'a (/ 1 2) (update-engagements '((fay . dan) (dee . col) (eve . hal)) 'fay 'xav) is '((fay . xav) (dee . col) (eve . hal)))
(check-part 'b (/ 1 2) (update-engagements '((ana . cos) (bia . adi)) 'bia 'bobo) is '((ana . cos) (bia . bobo)))

(exercițiul 9 : 30 puncte)
(check-part 'a (/ 1 3)
            (map (λ (eng) (stable-match? eng men-preferences-0 women-preferences-0))
                 '( ((ana . adi) (bia . cos) (cora . bobo))
                   ((ana . cos) (bia . adi) (cora . bobo))))
            is '(#t #f))

(check-part 'b (/ 1 3)
          
            (map (λ (eng) (stable-match? eng men-preferences-1 women-preferences-1))
                 '(((fay . jon) (dee . col) (cath . abe) (gay . gav) (bea . fred) (jan . ed) (ivy . dan) (hope . ian) (eve . hal) (abi . bob))
                  ((fay . dan) (dee . col) (eve . hal) (gay . gav) (bea . fred) (jan . ed) (ivy . abe) (hope . ian) (cath . bob) (abi . jon))))
            is '(#f #t))
(check-part 'c (/ 1 3)
            (map (λ (eng) (stable-match? eng men-preferences-2 women-preferences-2))
                '(((abi . bob) (bea . fred) (cath . abe) (dee . col) (eve . hal) (fay . dan) (gay . gav) (hope . ian) (ivy . jon) (jan . ed))
                   ((abi . bob) (bea . fred) (cath . abe) (dee . col) (eve . hal) (fay . jon) (gay . gav) (hope . ian) (ivy . dan) (jan . ed))
                   ((abi . hal) (bea . fred) (cath . abe) (dee . col) (eve . bob) (fay . jon) (gay . gav) (hope . ian) (ivy . dan) (jan . ed))))
            is '(#f #t #f))

(sumar)
