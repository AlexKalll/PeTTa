# PeTTa Contributions — Pull Request Summary

## Overview

This document summarizes the contributions made to [PeTTa](https://github.com/trueagi-io/PeTTa), a probabilistic evaluation term rewriting system. Each PR is explained with the **problem**, the **fix**, and **before/after examples** in both technical and plain terms.

---

## PR #163 — Assertion Helpers (MERGED)

### Problem
The library had TODO comments for two missing assertion functions (`assertEqualToResult` and `assertAlphaEqualToResult`) that were never implemented, leaving test gaps.

### Fix
Added the two missing assertion helpers and activated the TODO tests that depend on them.

### Before
```metta
;TODO:
;!(assertEqualToResult (+ 1 2) 3)
;(= (adder) $x)
;!(assertAlphaEqualToResult (adder) ($y))
```
Using `assertEquals` directly required wrapping with `!(test ...)`.

### After
```metta
!(test (assertEqualToResult (+ 1 2) 3) True)
(= (adder) ($x))
!(test (assertAlphaEqualToResult (adder) ($y)) True)
```

**Plain English:** Added missing comparison tools that check whether the output of a function equals the expected value, including support for variable names.

---

## PR #173 — Type-Casting Support (OPEN)

### Problem
Once a value was assigned a type in PeTTa, it could not be changed or overridden. For example, declaring `(: x Number)` was permanent even if you wanted `(: x String)` later. Additionally, the type system prioritized inferred types (e.g., `42` is always `Number`) over user-declared types in the space.

### Fix
Added a `type-cast` function that removes the old type declaration from the space and adds a new one. Also reworked `get-type` to check user-declared types in the space before falling back to inference.

### Before
```metta
(: a A)
; get-type a -> A  (can't change it)
```

### After
```metta
(: type1 Type)
(type-cast A type1 &self)
(test (get-type A) type1)  ; ✅ now returns type1
```

**Plain English:** Added the ability to change (cast) the type of a value from one type to another, like relabeling a box after you change what's inside it.

---

## PR #183 — Safe car-atom/cdr-atom & Short-Circuit Operators (MERGED)

### Problem (car-atom/cdr-atom)
Calling `car-atom` or `cdr-atom` on an empty list `()` or a non-list value (like a symbol) would crash PeTTa or produce wrong results. This broke functions like `is-lambda` that check the first element of an expression.

### Problem (short-circuit)
The standard `and` and `or` operators evaluated **both** arguments even when the first one already determined the answer (e.g., `and` with `False` as the first argument would still evaluate the second one). This caused crashes when the second argument was invalid.

### Fix
1. Made `car-atom` return `()` on empty or non-list inputs
2. Made `cdr-atom` return `()` on empty or non-list inputs
3. Added `and-then` and `or-else` — short-circuit versions that stop evaluating once the result is known

### Before
```metta
(car-atom ())     -> CRASH
(cdr-atom ())     -> CRASH
(car-atom A)      -> CRASH
(and False (car-atom ()))  -> CRASH (evaluates both)
```

### After
```metta
(car-atom ())     -> ()
(cdr-atom ())     -> ()
(car-atom A)      -> ()
(and-then False (car-atom ()))  -> False (skips second arg)

(= (is-lambda $x)
   (and (== (get-metatype $x) Expression)
        (and-then (not (== () $x))
                  (== λ (car-atom $x)))))
; ✅ Works on all inputs
```

**Plain English:** Made two list operations safe to use on empty lists or plain values (they return an empty result instead of crashing). Also added smarter `and`/`or` versions that stop early when the answer is already clear — like checking if a key works before trying to open a door.

---

## PR #186 — Fix Atom Type & Empty Case (OPEN)

### Problem 1: Atom argument evaluated
When a function declared an `Atom` type for an argument, the argument was still being evaluated before being passed in. This meant `(foo (empty))` would try to evaluate `(empty)` first, which fails, instead of passing it as-is.

### Problem 2: Empty default never matched
In a `case` expression, the `Empty` default branch was only triggered when the key expression itself failed to evaluate. Since variables always succeed (wildcards match everything), `Empty` was dead code — it could never match an empty value.

### Fix
1. Treat `Atom` like `Expression` — pass arguments as data without evaluating
2. Add an explicit `== [empty]` check so `Empty` matches when the key value is `(empty)`

### Before
```metta
(: foo (-> Atom %Undefined%))
(= (foo $x)
   (case $x
     ((Empty Ok)
      ($_ Nok))))
(foo (empty))  -> Nok  (❌ should be Ok)
(foo 1)        -> Nok  (✅ correct)
```

### After
```metta
(: foo (-> Atom %Undefined%))
(= (foo $x)
   (case $x
     ((Empty Ok)
      ($_ Nok))))
(foo (empty))  -> Ok   (✅ correct)
(foo 1)        -> Nok  (✅ correct)
```

**Plain English:** Fixed two bugs: (1) Arguments marked as atomic values were being "unpacked" before the function received them, like opening a sealed envelope before handing it over; (2) The "otherwise" case in conditional matching never actually matched an empty value, making it useless.

---

## PR #194 — Date & Time Library (OPEN)

### Problem
PeTTa had no built-in way to work with dates and times — no function to get the current time, format dates, or extract weekday names.

### Fix
Added a small date & time library using Prolog FFI with three core functions: `now` (current timestamp), `format-date` (format timestamps), and `day-of-week` (weekday name). Date arithmetic is done directly with native `+` and `-` operators.

### Before
```metta
; No way to get current time
; No way to format dates
; No way to get weekday names
```

### After
```metta
!(import! &self ../lib/lib_datetime)

; Get current timestamp
(now)                            -> 1783508229.718

; Format a date
(format-date 1735689600 "%B")    -> January

; Get day of week
(day-of-week 1766188800)         -> Saturday

; Date arithmetic with native operators
(+ (now) 3600)                   -> now + 1 hour
(- 1736294400 1735689600)        -> 604800 (7 days in seconds)
```

**Plain English:** Added a clock and calendar to PeTTa — you can now get the current time, format dates in any style (like "January" or "2026-07-08"), and find out what day of the week a date falls on.

---

## Summary

| PR | Title | Status | Type |
|----|-------|--------|------|
| #163 | Result-based assertion helpers | ✅ Merged | Enhancement |
| #173 | Type-casting support | ❌ Open | Feature |
| #183 | Safe car-atom/cdr-atom & short-circuit operators | ✅ Merged | Bug fix + Enhancement |
| #186 | Fix Atom arg type and case Empty default | ❌ Open | Bug fix |
| #194 | Date & time library | ❌ Open | Feature |
