# Contributing to PeTTa

This document catalogs potential contribution opportunities identified through a systematic codebase review. Each item is tagged with **effort** and **impact** to help you choose.

---

## Quick Reference

| Area | Best For |
|------|----------|
| String manipulation library | Beginners (pure MeTTa) |
| Test coverage gaps | Beginners |
| Bug fixes | Beginners to intermediate |
| Error handling improvements | Intermediate |
| Documentation | All levels |
| Performance / infrastructure | Advanced |
| Core language features | Advanced |

---

## 🟢 Easy (Pure MeTTa, No Prolog Needed)

### 1. String manipulation library

**Files to create:** `lib/lib_string.metta`, `examples/test_string.metta`

PeTTa has zero string operations exposed to MeTTa. SWI-Prolog has extensive string built-ins that just need wrapping:

```metta
(= (str-length $s) (str_length $s))
(= (str-split $s $sep) (str_split $s $sep))
(= (str-join $parts $sep) (str_join $parts $sep))
(= (str-contains $s $sub) (str_contains $s $sub))
(= (str-replace $s $old $new) (str_replace $s $old $new))
(= (str-to-upper $s) (str_to_upper $s))
(= (str-to-lower $s) (str_to_lower $s))
(= (str-trim $s) (str_trim $s))
(= (str-starts-with $s $prefix) (str_starts_with $s $prefix))
(= (str-ends-with $s $suffix) (str_ends_with $s $suffix))
(= (str-substring $s $start $len) (str_substring $s $start $len))
(= (str->int $s) (str_to_int $s))
(= (int->str $n) (int_to_str $n))
```

**Effort:** Low. Pure FFI wrappers.
**Impact:** High (fills a major gap).
**Files:** `lib/lib_string.pl` + `lib/lib_string.metta` + `examples/test_string.metta`.

---

### 2. Math extensions library

**Files to modify/create:** `lib/lib_math.metta`, `examples/test_math.metta`

SWI-Prolog has `gcd`, `lcm`, `factorial`, `pi`, `e`, permutation, and combination built-ins that are not exposed:

```metta
(= (gcd $a $b) (gcd $a $b))
(= (lcm $a $b) (lcm $a $b))
(= (factorial $n) (factorial $n))
(= (random-choice $list) (random_choice $list))
(= (random-shuffle $list) (random_shuffle $list))
(= (random-seed $seed) (set_random_seed $seed))
```

**Effort:** Low.
**Impact:** Medium.
**Note:** `random-choice` (pick random element from list) and `random-shuffle` are commonly needed.

---

### 3. Add tests for libraries without coverage

**Files:** `examples/test_combinatorics.metta`, `examples/test_vector.metta`, `examples/test_datastructures.metta`

Four libraries have zero example/test coverage:

| Library | Functions | Example to create |
|---------|-----------|-------------------|
| `lib_combinatorics.metta` | `range`, `choose2`, `chooseK`, `takeK` | `test_combinatorics.metta` |
| `lib_vector.metta` | `dot`, `cosine`, `norm`, `random-normal-vector` | `test_vector.metta` |
| `lib_datastructures.metta` | Queue ops, unique-atom space | `test_datastructures.metta` |
| `lib_mm2.metta` | MM2 calculus | `test_mm2.metta` |

**Effort:** Low-Medium. You need to understand the intended behavior.
**Impact:** Medium (improves quality, helps reviewers merge).

---

### 4. Fix `docs/constraint.md` documentation mismatch

**Files:** `docs/constraint.md` references `constraint_example.metta` and `constraint_test.metta` which do not exist.

**Fix:** Create the missing example files based on the CLP(FD) constraint documentation. The doc mentions `cp-solve` and `cp-enumerate` predicates.

**Effort:** Low.
**Impact:** Low (closes a documentation gap).

---

### 5. File I/O library

**Files to create:** `lib/lib_file.metta`, `lib/lib_file.pl`, `examples/test_file.metta`

SWI-Prolog has extensive file operations that are not exposed:

```metta
(= (file-read $path) (file_read $path))
(= (file-write $path $content) (file_write $path $content))
(= (file-append $path $content) (file_append $path $content))
(= (file-exists? $path) (file_exists $path))
(= (file-delete $path) (file_delete $path))
(= (file-list $dir) (file_list $dir))
(= (file-mkdir $path) (file_mkdir $path))
```

**Effort:** Low (same pattern as datetime library).
**Impact:** Medium.

---

## 🟡 Medium (Some Prolog Knowledge)

### 6. Better test infrastructure

**Files:** `test.sh`, `.github/workflows/ci.yml`

Current issues:
- **No per-test timeout.** A hanging test locks CI for hours. Add `timeout 30` to each test run.
- **First failure stops all tests.** Change to run all tests, report failures at the end ("X/Y passed").
- **No test count summary.** Print "12/15 passed, 3 failed" at the end.
- **Only 3 Python tests.** Expand `python/tests/test_petta.py` to cover error cases, imports, edge cases.

**Effort:** Medium.
**Impact:** High (makes CI reliable).

---

### 7. Error handling improvements

**Files:** `src/main.pl`, `src/translator.pl`, `src/metta.pl`

Current issues:
- `catch(Goal, _, fail)` in `translator.pl:57` and `metta.pl:282` silently swallows errors. A function call that fails should report *why*, not just return no result.
- `main.pl` has no top-level exception handler. A file-not-found error dumps raw Prolog stack trace.
- Error messages lack file/line context.

**Fix:** Replace `_, fail` with proper error reporting. Add a top-level `catch` in `main.pl`.

**Effort:** Medium (requires understanding the translator flow).
**Impact:** High (better developer experience).

---

### 8. JSON support

**Files to create:** `lib/lib_json.metta`, `lib/lib_json.pl`

SWI-Prolog has `library(http/json)` with `json_read`/`json_write`. Wrapping these would let MeTTa programs parse and generate JSON:

```metta
(= (json-parse $string) (json_parse $string))
(= (json-stringify $term) (json_stringify $term))
(= (json-read-file $path) (json_read_file $path))
(= (json-write-file $path $term) (json_write_file $path $term))
```

**Effort:** Medium (JSON ↔ MeTTa term conversion needs design).
**Impact:** High (enables API integration, data pipelines).

---

### 9. Regex support

**Files to create:** `lib/lib_regex.metta`, `lib/lib_regex.pl`

SWI-Prolog has `library(pcre)` already imported in `filereader.pl` but not exposed to MeTTa:

```metta
(= (regex-match $pattern $string) (regex_match $pattern $string))
(= (regex-replace $pattern $string $replacement) (regex_replace $pattern $string $replacement))
(= (regex-split $pattern $string) (regex_split $pattern $string))
```

**Effort:** Medium.
**Impact:** Medium.

---

### 10. Random utility extensions

**Files to modify:** `lib/lib_math.metta` or a new `lib/lib_random.metta`

Current random functions (`random-int`, `random-float`) expose SWI-Prolog `random/1` and `random_between/3`. Missing:

```metta
(= (random-shuffle $list) (random_shuffle $list))
(= (random-sample $list $k) (random_sample $list $k))
(= (random-uuid) (random_uuid))
```

**Effort:** Low-Medium.
**Impact:** Medium.

---

### 11. Fix `NARS`/`PLN` code duplication

**Files:** `lib/lib_nars.metta`, `lib/lib_pln.metta`

The derivation engines (`NARS.Derive` and `PLN.Derive`) and query loops (`NARS.Query` and `PLN.Query`) are structurally identical — differing only in which truth functions they call. They also share duplicate stamp/priority/sort helpers.

**Fix:** Factor out a common `Derive` engine parameterized by truth rules, and move shared helpers (`StampDisjoint`, `StampConcat`, `BestCandidate`, `PriorityRank`, `PriorityRankNeg`, `LimitSize`, `ConfidenceRank`) into a shared library.

**Effort:** High (requires understanding both NARS and PLN semantics).
**Impact:** Medium (reduces ~200 lines of duplication, prevents drift).

---

### 12. Data structure library expansion

**Files to modify/create:** `lib/lib_datastructures.metta`, `examples/test_datastructures.metta`

Current data structures are minimal (just a queue). Missing commonly-needed structures:

| Structure | Missing? | Notes |
|-----------|----------|-------|
| Hash map (key-value) | Yes | SWI-Prolog has `dict`, `pairs` |
| Stack (LIFO) | Yes | Can use list as stack |
| Set operations | Partial | `list_to_set`, `exclude-item` exist |
| Priority queue | Partial | `BestCandidate` pattern in PLN |
| Binary search tree | Yes | SWI-Prolog has `library(assoc)` |

**Effort:** Medium.
**Impact:** Medium.

---

### 13. UUID support

**Files to modify:** `lib/lib_random.metta` or `lib/lib_meta.metta`

SWI-Prolog imports `library(uuid)` in `metta.pl:8` but never exposes it. `uuid/1` generates UUIDs.

```metta
(= (uuid) (uuid))
```

One line, trivially useful for generating unique identifiers.

**Effort:** Trivial.
**Impact:** Low-Medium.

---

## 🔴 Larger (Core Language / Infrastructure)

### 14. Path traversal security fix

**Files:** `src/metta.pl` lines 282-294

The `importer_helper` constructs file paths by raw string concatenation without validation. A malicious `.metta` file could `import!` arbitrary files:

```
!(import! &self "../../etc/passwd")
```

**Fix:** Use `absolute_file_name/3` with `access(read)` to validate paths before importing.

**Effort:** Low (but security-sensitive).
**Impact:** High.

---

### 15. Recursion depth limit / timeout guard

**Files:** `src/translator.pl`, `src/main.pl`

PeTTa has no guard against infinite recursion or infinite loops. An infinite `(= (f) (f))` hangs 100% CPU until stack overflow (8GB limit).

**Fix:** Add a configurable recursion depth limit or CPU timeout in the `reduce` loop.

**Effort:** Medium-High (needs translator-level changes).
**Impact:** High.

---

### 16. Proper REPL with history

**Files:** `examples/repl.metta` → `src/repl.pl`

Current REPL has no history, no completion, no multi-line, no error recovery. SWI-Prolog has `readline`/`editline` integration that could be leveraged.

**Effort:** Medium-High.
**Impact:** Medium (developer experience).

---

### 17. Profiling / benchmarking harness

**Files to create:** `bench/` directory

No performance benchmarks exist. Adding a simple benchmarking harness would help:
- Track performance regressions across versions
- Compare optimization strategies
- Identify bottlenecks

**Effort:** Medium.
**Impact:** Medium (infrastructure).

---

### 18. CHANGELOG

**File to create:** `CHANGELOG.md`

No changelog exists. Start one based on git history and PR descriptions.

**Effort:** Low (but ongoing).
**Impact:** Medium (helps users track changes).

---

### 19. Project metadata fixes

**Files:** `setup.py`, `MANIFEST.in`

- `setup.py` has placeholder `author="Your Name"`, `author_email`, `url`
- `MANIFEST.in` only includes `src/`, missing `lib/`, `python/`, `docs/`

**Effort:** Trivial.
**Impact:** Medium (fixes packaging).

---

### 20. .gitignore bug

**Status:** Fixed above. `*.md` was ignoring ALL markdown files including README.md.

---

## 🟠 Senior-Level (Architecture, Infrastructure, Production Readiness)

### 21. Error reporting overhaul — stop swallowing failures

**Files:** `src/translator.pl`, `src/metta.pl`, `src/main.pl`

**The problem:** 5+ places use `catch(Goal, _, fail)` which converts runtime exceptions into silent "no result":
- `translator.pl:57` — all function calls
- `metta.pl:282` — all imports
- `spaces.pl:49,61` — match operations

A type error, division by zero, or missing file produces zero output. The user has no way to know what failed or why.

**The fix:** 
1. Replace `_, fail` with a handler that constructs a structured error term like `['Error', Type, Message]`
2. Add a top-level `catch` in `main.pl` that pretty-prints exceptions instead of dumping raw Prolog stack traces
3. Make `import!` return the error instead of silently returning `false`

**Effort:** Medium. Requires tracing the error propagation path.
**Impact:** **Critical** for usability. Without this, every other feature is hard to debug.

---

### 22. Memory leak audit — stop unbounded growth

**Files:** `src/translator.pl`, `src/metta.pl`, `src/spaces.pl`

**The problem:** The system never reclaims state:
- Every `|->` (lambda) creates a permanent named predicate (`translator.pl:253`) — never cleaned up
- Every `fun/1` registration is permanent (`metta.pl:304`)
- `translated_from/2` grows forever (`spaces.pl:18`)
- `nb_setval` entries are never deleted

In a long-running session (server, REPL, chess game), memory grows linearly with activity.

**The fix:** 
1. Track lambda predicates and clean them up when their scope ends
2. Add `forget-fun!` MeTTa primitive
3. Add space-level garbage collection (`clear-space!` or `gc-space!`)
4. Add a `(gc)` function that runs Prolog's `garbage_collect`

**Effort:** Medium-High (requires understanding lifecycle of every dynamic predicate).
**Impact:** High. Without this, PeTTa cannot run as a long-lived server.

---

### 23. Clean up the translator — break up translate_expr

**Files:** `src/translator.pl` (lines 96-333)

**The problem:** `translate_expr` is a single 237-line predicate with ~30 branches in a `;`-chain. Each branch handles one language construct. Reviewing changes to it is nearly impossible — you can't tell which inputs exercise which branch.

**The fix:** Factor each language construct into its own predicate:
```prolog
translate_if(Args, GsH, Goals, Out) :- ...
translate_case(Args, GsH, Goals, Out) :- ...
translate_let(Args, GsH, Goals, Out) :- ...
translate_superpose(Args, GsH, Goals, Out) :- ...
% etc.
```
Then `translate_expr` becomes a dispatch table:
```prolog
translate_expr([H|T], Goals, Out) :-
    translate_head(H, Arm),
    call(Arm, T, GsH, Goals, Out).
```

**Effort:** High. Requires understanding every branch. Tests must cover every construct.
**Impact:** **Critical** for long-term maintainability. Without this, the translator will become impossible to modify.

---

### 24. Thread safety audit

**Files:** `python/petta.py`, `src/metta.pl`, `src/translator.pl`, `src/spaces.pl`

**The problem:** Every `add-atom` call `assertz`s a Prolog fact globally. Concurrent calls from Python threads will interleave mutations. The translator's `nb_setval` for function metadata is not atomic.

**The fix:**
1. Add `thread_local` declarations for space predicates
2. Protect read-modify-write patterns (like `nb_getval` + `nb_setval`) with `with_mutex`
3. In Python, each `PeTTa` instance should use a separate Prolog engine (`janus-swi` supports this with `janus.engine()`)
4. Document that the Python API is not thread-safe without external locking

**Effort:** Medium. Most of the fix is adding `thread_local` and `with_mutex` wrappers.
**Impact:** High. Currently unsafe for concurrent use.

---

### 25. Version metadata — make `(version)` tell the truth

**Files:** `setup.py`, `python/pyproject.toml`, `lib/lib_meta.metta`

**The problem:** 
- `setup.py` says `version="0.1.0"` 
- Git tags say `v1.0.3`
- No way to query version at runtime

**The fix:**
1. Add `lib/lib_version.pl` with a `version/1` fact
2. Add `lib/lib_version.metta` with `(= (version) (version))` 
3. Fix `setup.py` and `pyproject.toml` to match the git tag
4. Or better: derive version from git tag at build time

**Effort:** Trivial (one afternoon).
**Impact:** Medium. Makes the project look professional.

---

### 26. Test infrastructure overhaul

**Files:** `test.sh`, `.github/workflows/ci.yml`

**The problem:**
- No per-test timeout (a hang locks CI for hours)
- First failure kills all remaining tests (no regression scope)
- No test count summary ("12/15 passed")
- Network-dependent tests are excluded via a manual skip list that rots
- Only 3 Python tests for the entire API
- grep-based test detection is fragile

**The fix:**
1. Add `timeout 30` per test in `test.sh`
2. Change from "fail fast" to "run all, report all"
3. Print summary: `"X passed, Y failed, Z skipped"`
4. Add a metadata system for tests: `; @skip-ci` or `; @requires-network` comment markers
5. Expand Python tests to cover error paths, imports, spaces
6. Consider a Makefile with `make test`, `make test-quick`, `make test-python`

**Effort:** Medium.
**Impact:** High (makes CI reliable, catches regressions).

---

### 27. Package/release automation

**Files:** `setup.py`, `MANIFEST.in`, `build.sh`, new `RELEASE.md`

**The problem:** 
- `MANIFEST.in` missing `lib/`, `python/`, `docs/` — pip sdist is broken
- `setup.py` has placeholder metadata
- No release checklist or automation
- No CHANGELOG

**The fix:**
1. Fix `MANIFEST.in` to include all directories
2. Fix `setup.py` metadata
3. Create a release script that: tags version, builds wheel, runs tests, publishes
4. Start a `CHANGELOG.md` from git history
5. Remove duplicated `python/pyproject.toml` or deduplicate metadata

**Effort:** Low-Medium.
**Impact:** Medium. Makes the project publishable.

---

### 28. Space isolation and sandboxing

**Files:** `src/spaces.pl`, `src/metta.pl`, `src/translator.pl`

**The problem:**
- Any code can modify any space (`add-atom` to `&self` is always possible)
- Type definitions in `&self` are global — all spaces share the same type system
- `remove-atom` of a function definition modifies translator state globally
- No sandboxed execution mode

**The fix:**
1. Add a `with-space` form that scopes all mutations to a specific space
2. Make type lookups space-aware (check the calling space before `&self`)
3. Add a sandbox mode that disables `py-call`, `import!`, `git-import!`, and filesystem access
4. Document space isolation guarantees (or the lack thereof)

**Effort:** High.
**Impact:** Medium-High. Needed for multi-tenant or server environments.

---

### 29. Profiling and benchmarking harness

**Files to create:** `bench/` directory, `bench/perf_test.metta`

**The problem:** No way to track performance. A change that makes the translator 10x slower on some workload would go unnoticed until someone runs a real program.

**The fix:**
1. Create a `bench/` directory with representative benchmarks
2. Use Prolog's `time/1` or `profile/1` to measure execution
3. Add a CI step that warns if benchmarks regress >20%
4. Publish benchmark results so contributors can compare

Example benchmarks:
- Fibonacci (recursive, measures function call overhead)
- Large `case` expression (measures pattern matching)
- `superpose` with 1000 elements (measures non-determinism)
- Deeply nested `let*` (measures translation complexity)
- `import!` chain (measures file loading)

**Effort:** Medium.
**Impact:** Medium. Prevents performance regressions.

---

### 30. Language specification / syntax reference

**Files to create:** `docs/language-spec.md`

**The problem:** There is no formal specification of the MeTTa language. New contributors learn by reading examples. It's impossible to tell if a behavior is intentional or a bug.

**The fix:** Write a language reference document covering:
- Syntax: S-expressions, comments, strings, numbers, symbols
- Built-in forms: `let`, `let*`, `case`, `if`, `match`, `superpose`, `collapse`, `catch`
- Function definition: `(= ...)`, `(: ...)` type declarations
- Spaces: `&self`, named spaces, `add-atom`, `remove-atom`, `match`
- Standard library: arithmetic, comparison, list ops, type system
- Imports: `import!`, `import_prolog_function`, `git-import!`
- Side effects: `println!`, `assert`, `test`
- FFI: calling Prolog, calling Python

**Effort:** Medium-High (writing docs is time-consuming but straightforward).
**Impact:** High. Every contributor needs this.

---

### 31. Structured logging

**Files:** New `src/logging.pl`, modify `src/translator.pl`, `src/filereader.pl`

**The problem:** Output is a mix of compilation traces, sexpr displays, Prolog clauses, and results — all to stdout. There's no way to filter, no log levels, no structured format.

**The fix:**
1. Create a logging module with levels: DEBUG, INFO, WARN, ERROR
2. Route diagnostics to stderr, results to stdout
3. Add a `--log-level` CLI flag
4. Keep ANSI colors but make them configurable (on/off/auto)

**Effort:** Medium.
**Impact:** Medium. Improves developer experience and server operations.

---

### 32. CLI argument parsing

**Files:** `run.sh` → new `src/cli.pl`

**The problem:** All CLI configuration is through `run.sh` which hardcodes flags. There's no `--help`, no `--version`, no way to set stack limit, log level, or library path from the command line.

**The fix:**
1. Add proper CLI argument parsing in `src/cli.pl` using SWI-Prolog's `library(optparse)`
2. Support: `--stack-limit`, `--log-level`, `--silent`, `--version`, `--help`, `--library-path`
3. Make `run.sh` pass through CLI args to `swipl` + `main.pl`
4. Make `--help` print available flags

**Effort:** Low-Medium.
**Impact:** Medium. Makes the system configurable without editing scripts.

---

### 33. Continuous integration hardening

**Files:** `.github/workflows/ci.yml`

**The problem:** CI only tests on one OS (Linux), one SWI-Prolog version, one Python version. No linters, no coverage, no timeout on individual tests.

**The fix:**
1. Add Python linting: `ruff check` + `mypy`
2. Add Prolog linting: check for common anti-patterns (especially `catch(_, _, fail)`)
3. Set `timeout-minutes` on the CI job
4. Add a test for the `.gitignore` (ensure it doesn't ignore README.md)
5. Add a test for version consistency (setup.py version ≈ git tag)

**Effort:** Medium.
**Impact:** Medium. Catches style issues and missing imports.

---

### 34. Regression test for the Python API

**Files:** `python/tests/test_petta.py`

**The problem:** Only 3 tests for the entire Python API:
- `test_load_metta_file_returns_list` (one file, one check)
- `test_process_metta_string_matches_verbose` (verbose vs silent)
- `test_var_out` (variable output format)

**Missing:**
- Test importing a library from Python
- Test error handling (malformed MeTTa string)
- Test spaces (add-atom, remove-atom, match)
- Test state (change-state!, get-state)
- Test concurrent access (two PeTTa instances)
- Test that results are correctly typed (numbers, strings, lists, atoms)
- Test edge cases: empty input, whitespace, comments only, large files

**Effort:** Low (writing test cases).
**Impact:** Medium. Catches Python-level regressions.

---

### 35. Onboarding automation

**Files to create:** `Makefile`, `Dockerfile.dev`, `scripts/check-deps.sh`

**The problem:** Setting up a dev environment is painful:
1. SWI-Prolog 9.3+ must be built from source (not in most distro repos)
2. `janus-swi` Python package requires SWI headers
3. No `make setup` or `make dev` command
4. No Docker image for local development

**The fix:**
1. Create a `Dockerfile.dev` with all dependencies pre-installed
2. Add `Makefile` targets: `make test`, `make dev`, `make lint`, `make clean`
3. Create `scripts/check-deps.sh` that verifies prerequisites and prints helpful errors
4. Document the dev setup in a `DEVELOPMENT.md` (separate from the setup journey diary)

**Effort:** Medium.
**Impact:** High. Lowers the barrier for new contributors.

---

### 36. `docs/contiributing.md` cleanup

**Files:** `docs/contiributing.md`

**The problem:** The filename is misspelled and the content is an AI conversation log, not a contributing guide. The real contributing guide is now at `CONTRIBUTING.md`.

**Fix:** Delete the old `docs/contiributing.md` (or rename and clean it up if it contains unique information).

**Effort:** Trivial.
**Impact:** Low. Tidiness.

---

## 🟣 Standard Library Expansion (New Libraries for MeTTa)

### 37. Hash library (MD5, SHA)

**Files to create:** `lib/lib_hash.pl`, `lib/lib_hash.metta`

**The problem:** There is no way to hash data from MeTTa. Hash functions are needed for caching, checksums, and data integrity checks.

**The fix:** Wrap SWI-Prolog's `library(shash)` or `library(crypto)`:
```prolog
% lib_hash.pl
metta_hash_md5(Input, Hash) :-
    atom_codes(Input, Codes),
    hex_bytes(..., md5, _, HashAtom).
```
Expose as `(= (md5 <string>) <hash>)` and `(= (sha256 <string>) <hash>)`.

**Effort:** Low.
**Impact:** Medium. Useful for caching, dedup, and web integrations.

---

### 38. HTTP client library

**Files to create:** `lib/lib_http.pl`, `lib/lib_http.metta`

**The problem:** There is no way to fetch URLs from within MeTTa. Every web integration requires an external Python script.

**The fix:** Wrap SWI-Prolog's `http_open/3`:
```prolog
metta_http_get(URL, Result) :-
    setup_call_cleanup(
        http_open(URL, Stream, []),
        read_string(Stream, _, Result),
        close(Stream)
    ).
```
Expose as `(= (http-get <url>) <body>)` and `(= (http-json <url>) <json>)` with automatic JSON parsing.

**Effort:** Low.
**Impact:** High. Enables MeTTa agents to fetch web data directly.

---

### 39. CSV parsing library

**Files to create:** `lib/lib_csv.pl`, `lib/lib_csv.metta`

**The problem:** No way to read CSV data. Users must write manual string-splitting logic.

**The fix:** Wrap SWI-Prolog's `csv/3` library:
```prolog
metta_csv_parse(String, Rows) :-
    open_string(String, Stream),
    csv_read_stream(Stream, Rows, [arity(0)]).
```
Expose as `(= (csv-parse <string>) <rows>)` and `(= (csv-file <path>) <rows>)`.

**Effort:** Low.
**Impact:** Medium. Common data interchange format.

---

### 40. Sorting and collection operations

**Files to create:** `lib/lib_sort.metta`, `lib/lib_collections.metta`

**The problem:** No built-in sorting, deduplication, or set operations. Users must implement their own.

**The fix:** New MeTTa library functions:
```metta
(= (sort <list>) (sort-by <list> <id>))
(= (sort-by <list> <fn>) ...)  ; transcode to Prolog's sort/2 or predsort/3
(= (unique <list>) ...)
(= (union <a> <b>) ...)
(= (intersection <a> <b>) ...)
(= (difference <a> <b>) ...)
(= (flatten <list>) ...)
(= (group-by <list> <fn>) ...)
```

**Effort:** Low.
**Impact:** Medium. Makes data processing in MeTTa ergonomic.

---

### 41. Statistics library (mean, median, stddev)

**Files to create:** `lib/lib_stats.metta`, `lib/lib_stats.pl`

**The problem:** No numeric analysis functions beyond basic arithmetic.

**The fix:**
```metta
(= (mean <list>) (/ (sum <list>) (len <list>)))
(= (median <list>) ...)
(= (stddev <list>) ...)
(= (variance <list>) ...)
(= (correlation <xs> <ys>) ...)
```
Some can be pure MeTTa; others (variance, correlation) benefit from Prolog-backed numeric stability.

**Effort:** Low to Medium.
**Impact:** Medium. Useful for data analysis use cases.

---

### 42. Base64 / binary encoding

**Files to create:** `lib/lib_base64.pl`, `lib/lib_base64.metta`

**The problem:** No way to encode/decode binary data for transit (API calls, file headers).

**The fix:** Wrap SWI-Prolog's `base64/2`:
```prolog
metta_base64_encode(String, Encoded) :-
    atom_codes(String, Bytes),
    base64(Bytes, Encoded).
metta_base64_decode(Encoded, String) :-
    base64(Bytes, Encoded),
    atom_codes(String, Bytes).
```

**Effort:** Trivial.
**Impact:** Low-Medium. Needed for API tokens, image data in HTTP.

---

### 43. Graph / network analysis library

**Files to create:** `lib/lib_graph.metta`

**The problem:** PeTTa is built on hypergraph rewriting but has no graph analysis utilities — no connected-components, no shortest-path, no degree calculation.

**The fix:** Leverage the space API to implement:
```metta
(= (graph-nodes &space) (get-atoms &space <type>))
(= (shortest-path &space <from> <to>) ...)
(= (connected-components &space) ...)
(= (degree &space <node>) ...)
```
These teach users to write MeTTa programs that query the space programmatically.

**Effort:** Medium.
**Impact:** Medium-High. Dogfoods PeTTa's own space API and serves AI/graph use cases.

---

## 🟢 Developer Experience (LSP, REPL, Debugger)

### 44. REPL improvements

**Files:** `src/repl.pl` (if exists) or `python/petta_repl.py`

**The problem:** The current MeTTa REPL has no tab completion, no history search, no multi-line editing, no syntax highlighting.

**The fix (pick any):**
1. Add tab completion for symbols in the current spaces
2. Add history search (Ctrl+R) via `library(editline)` or `library(readline)`
3. Support multi-line input (detect unmatched parentheses, prompt for more)
4. Add `:help`, `:trace`, `:quit` meta-commands
5. Add REPL banner with version and loaded spaces

**Effort:** Low-Medium per feature.
**Impact:** Medium. Daily driver quality-of-life.

---

### 45. MeTTa Language Server (LSP)

**Files to create:** New `lsp/` directory, `lsp/server.py` or `lsp/server.pl`

**The problem:** No editor integration means no syntax errors underlined, no go-to-definition, no autocomplete. This is the #1 barrier to adoption.

**The fix:** Create a Language Server Protocol implementation:
1. Parse MeTTa into an AST
2. Implement: `textDocument/completion`, `textDocument/diagnostic`, `textDocument/hover`, `textDocument/definition`
3. Publish as a VS Code extension (`lsp/vscode-petta/`)
4. Add a `--lsp` mode to the CLI that runs the server

**How it works:** The LSP server runs PeTTa in the background, loads the user's file, and uses the space API to query available symbols, types, and definitions.

**Effort:** High.
**Impact:** **Critical** for adoption. Developers expect IDE support.

---

### 46. Debugger / stepper

**Files to create:** `src/debugger.metta` (or `src/debugger.pl`)

**The problem:** When a MeTTa program produces a wrong result, there is no way to step through execution, inspect intermediate state, or set breakpoints.

**The fix:**
1. Wrap the translator to emit a trace log on each reduction step
2. Create a `(trace! <expr>)` form that prints the expression before and after evaluation
3. Create a `(break! <condition>)` form that pauses and opens a sub-REPL
4. Add `:step`, `:continue`, `:inspect`, `:backtrace` meta-commands in the sub-REPL

**Effort:** High.
**Impact:** High. Makes the language teachable and debuggable.

---

### 47. Code formatter for MeTTa

**Files to create:** `scripts/format_metta.py`

**The problem:** MeTTa has no canonical formatting. Every contributor writes differently. Code reviews are polluted by whitespace disagreements.

**The fix:** Write a formatter that:
1. Parse S-expressions into a tree
2. Re-indent based on nesting depth (default: 2 spaces)
3. Break long lines (>80 chars) at sensible points
4. Sort function definitions alphabetically
5. Normalize whitespace around parentheses
6. Add a `--check` mode for CI

**Effort:** Medium.
**Impact:** Medium. Eliminates formatting debates.

---

### 48. Interactive playground / tutorial

**Files to create:** `docs/tutorial/` or `playground/`

**The problem:** No interactive way to learn MeTTa. Users read a README or a dry spec, then give up.

**The fix:**
1. Create an interactive tutorial (in-browser or in-REPL) that walks through:
   - Basic arithmetic and function calls
   - Variable binding with `let`
   - Pattern matching with `case`
   - Non-determinism with `superpose`
   - Spaces and atoms
   - Type system and `:`
   - Imports and libraries
2. Each step has an explanation, an editable MeTTa cell, and expected output
3. Consider using Jupyter notebooks with a MeTTa kernel

**Effort:** High to maintain.
**Impact:** **Critical**. Lowers the learning curve from days to minutes.

---

## 🛡️ Security & Sandboxing

### 49. Resource limits (CPU, memory, file size)

**Files:** `src/main.pl`, `run.sh`

**The problem:** A buggy or malicious MeTTa program can consume infinite CPU (infinite `superpose`), overflow memory (infinite recursion), or read any file. There's no way to limit resource usage.

**The fix:**
1. Add `:- set_prolog_flag(stack_limit, 64_000_000)` for memory safety (64MB default)
2. Add a CPU time budget via `alarm/3` or `time_out/3` from `library(timeout)`
3. Add a file size limit for `open/3` (reject files >10MB)
4. Add `--limit-memory`, `--limit-cpu`, `--limit-filesize` CLI flags

**Effort:** Medium.
**Impact:** High. Prevents DoS and runaway programs.

---

### 50. Network access control

**Files:** New `lib/lib_http.pl` (extend with access control)

**The problem:** Once an HTTP library exists, any MeTTa program can call any URL. An untrusted script could exfiltrate data.

**The fix:**
1. Maintain a whitelist of allowed domains (default: none)
2. Add `(allow-url <domain>)` to add domains at runtime
3. Add `--allow-net` CLI flag (all-or-nothing), default off
4. Add `--allow-net-domains example.com,api.example.com` for fine-grained control
5. Document that untrusted scripts should be run with `--no-net`

**Effort:** Low.
**Impact:** Medium. Essential for multi-tenant servers.

---

## 🧪 Advanced Testing & Fuzzing

### 51. Property-based testing framework

**Files to create:** `lib/lib_quickcheck.metta`, `tests/property/`

**The problem:** Existing tests check specific examples. They miss edge cases like empty lists, zero, strings with special characters, or deeply nested expressions.

**The fix:** Port QuickCheck to MeTTa:
```metta
(= (for-all <generator> <property>) ...)

; Usage:
!(for-all (gen-list (gen-int)) (fn (list) (= (sort (sort list)) (sort list))))
; Tests that sorting is idempotent for random lists
```
Include generators: `gen-int`, `gen-string`, `gen-list`, `gen-atom`, `gen-expr`.

**Effort:** Medium-High.
**Impact:** Medium. Catches edge cases manually written tests miss.

---

### 52. Fuzz testing the translator

**Files:** New `tests/fuzz.py`

**The problem:** The translator (600+ lines of Prolog) is the most complex component. It has been tested on ~50 hand-written examples. A fuzzer will find infinite loops, crashes, and wrong results.

**The fix:**
1. Write a Python fuzzer that generates random S-expressions (nested lists of symbols, numbers, strings)
2. Feed them to PeTTa and check: (a) no crash, (b) no infinite loop (timeout 5s), (c) output is a valid sexpr if any
3. Use grammar-aware generation: 50% valid MeTTa, 50% adversarial (unmatched parens, odd symbols, empty lists, extremely deep nesting)
4. Run as a CI nightly job

**Effort:** Medium.
**Impact:** Medium. Finds crashes before users do.

---

### 53. Mutation testing

**Files:** `tests/mutation/`

**The problem:** No way to tell if the test suite is thorough. A test suite that passes after mutating the source code is a weak test suite.

**The fix:**
1. Write a script that systematically mutates source files (swap operators, delete branches, flip conditions)
2. Run the test suite on each mutation
3. Report the mutation score: (tests that failed) / (total mutations)
4. Goal: >80% mutation score
5. Target files: `lib/lib_string.metta`, `lib/lib_math.metta`, `lib/lib_datetime.metta`

**Effort:** Medium-High to set up.
**Impact:** Medium. Improves test quality systematically.

---

## 🌐 Ecosystem & Platform

### 54. WASM / Web build

**Files to create:** `Makefile.wasm`, `web/`

**The problem:** PeTTa is only usable from the command line. A web build would allow online demos, playgrounds, and embedding in web apps.

**The fix:**
1. Compile SWI-Prolog to WebAssembly (it has WASM support via Emscripten)
2. Bundle the MeTTa libraries
3. Create a JavaScript API: `await PeTTa.run('(+ 1 2)')` 
4. Create an interactive playground page

**Effort:** Very High (getting SWI-Prolog to compile to WASM is non-trivial).
**Impact:** Very High. Opens the browser ecosystem.

---

### 55. Jupyter kernel

**Files to create:** `python/petta_kernel/`

**The problem:** Data scientists and AI researchers use Jupyter notebooks. A MeTTa kernel would let them use MeTTa cells alongside Python, markdown, and visualizations.

**The fix:** Create a Jupyter kernel following `jupyter_client.kernelspec`:
```python
class PeTTaKernel(Kernel):
    implementation = 'PeTTa'
    implementation_version = '0.1.0'
    language = 'metta'
    language_version = '0.1.0'
    
    def do_execute(self, code, ...):
        result = run_metta(code)
        self.send_response(self.iopub_socket, 'stream', {
            'name': 'stdout',
            'text': result
        })
```
Package with `jupyter-kernel install` support.

**Effort:** Medium.
**Impact:** High. Natural fit for the AI research audience.

---

### 56. Package manager / registry

**Files to create:** `scripts/petta-pkg.py`, `pkg/`

**The problem:** There's no way to share or discover MeTTa libraries. Users copy-paste code between projects.

**The fix:**
1. Define a package format: a MeTTa file + metadata (version, deps, license)
2. Create a `petta-pkg install <lib>` command that downloads from a registry
3. Create a `petta-pkg publish` command
4. Host a simple registry (GitHub-based or a flat file index)
5. Support version constraints and dependency resolution
6. Store packages locally in `~/.petta/packages/`

**Effort:** High.
**Impact:** High. Foundation for a library ecosystem.

---

### 57. REST API server mode

**Files to create:** `src/server.pl`, `Dockerfile.prod`

**The problem:** Today, the only way to interact with PeTTa is via CLI or direct Python import. There's no HTTP API for remote access, microservices, or web UIs.

**The fix:** Create an HTTP server using SWI-Prolog's `library(http/thread_httpd)`:
```prolog
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).

:- http_handler(root(metta), handle_metta, []).

handle_metta(Request) :-
    http_read_json_dict(Request, Data),
    atom_string(Code, Data.code),
    metta_run(Code, Result),
    reply_json_dict(_{result: Result}).
```
Endpoints:
- `POST /metta` — evaluate MeTTa expression
- `POST /load` — load a file into a space
- `GET /spaces` — list available spaces
- `POST /state` — get/set state variables

**Effort:** Medium.
**Impact:** High. Enables microservice and web use cases.

---

### 58. Database persistence for spaces

**Files:** `src/spaces_db.pl`, `lib/lib_persist.metta`

**The problem:** All spaces are in-memory. Restarting PeTTa loses everything. No way to persist a knowledge base.

**The fix:** Add a SQLite-backed space:
1. Use SWI-Prolog's `library(sqlite)` to create a `petta.db`
2. On `add-atom`, also write to SQLite
3. On restart, load persisted atoms from SQLite
4. Add `(persist! &my-space "my_kb.db")` to bind a space to a file
5. Add `(load-persisted "my_kb.db")` to restore a space

**Effort:** Medium-High.
**Impact:** High. Makes PeTTa suitable for long-lived AI agents and knowledge bases.

---

## 📐 Architecture & Performance

### 59. Memoization / caching layer

**Files to create:** `lib/lib_cache.metta`

**The problem:** Pure functions are recomputed every time. A Fibonacci with `n=40` takes 2 minutes because there's no memoization. Every top-level expression in a file is re-evaluated on every `import!`.

**The fix:**
1. Create a `(memo <fn>)` combinator that wraps a function with a cache
2. Cache key = `(fn, arg1, arg2, ...)`, cache value = previous result
3. Add a `(clear-cache!)` function
4. Use `nb_setarg` for O(1) cache updates in Prolog

```metta
(= (fib n) (memo (fn (n)
    (if (<= n 1) n (+ (fib (- n 1)) (fib (- n 2)))))))
```

**Effort:** Medium.
**Impact:** Medium. Makes expensive pure functions tractable.

---

### 60. Lazy evaluation / infinite streams

**Files to create:** `lib/lib_stream.metta`

**The problem:** MeTTa evaluates expressions eagerly. There's no way to represent infinite sequences (like natural numbers, Fibonacci sequence, or a stream of sensor readings).

**The fix:** Add a lazy stream abstraction:
```metta
(= (stream-cons <head> <thunk>) ...)   ; delayed tail
(= (stream-head <stream> <n>) ...)     ; take first n
(= (stream-map <fn> <stream>) ...)
(= (stream-filter <fn> <stream>) ...)
(= (stream-take-while <fn> <stream>) ...)
(= (naturals) (stream-cons 0 (fn () (stream-map (fn (x) (+ x 1)) (naturals)))))
```
The thunk is a 0-argument function that's called only when the next element is needed.

**Effort:** Medium-High.
**Impact:** Medium. Enables functional programming patterns.

---

### 61. Tail-call optimization

**Files:** `src/translator.pl`

**The problem:** MeTTa has no guarantee of tail-call optimization. A tail-recursive function can still overflow the Prolog stack. The translator should detect tail positions and emit properly tail-recursive Prolog.

**The fix:**
1. Identify tail positions in `case` branches and `if/2`
2. In tail position, avoid creating choice points
3. For `let*` in tail position, fold into the continuation

**Example:**
```metta
(= (range n acc)
   (if (<= n 0) acc (range (- n 1) (cons n acc))))
```
This should run in O(1) stack space, not O(n).

**Effort:** Medium.
**Impact:** Medium-High. Prevents stack overflow on recursive algorithms.

---

### 62. Out-of-order / incremental loading

**Files:** `src/filereader.pl`

**The problem:** Files are loaded top-to-bottom. A forward reference (calling a function before its definition) fails. This forces users to order definitions manually and makes it impossible to split code across files without careful import ordering.

**The fix:** Two-pass loading:
1. First pass: scan for all `(= ...)` definitions and register them (without body)
2. Second pass: load function bodies and evaluate side-effect expressions
This matches how most languages handle top-level definitions.

**Effort:** Medium-High.
**Impact:** High. Eliminates forward-reference errors.

---

## 🧰 Utilities & Quality of Life

### 63. File watcher / auto-reload for development

**Files:** `scripts/watch.sh` or Python equivalent

**The problem:** Development cycle: edit file → run test.sh → see error → edit file → run test.sh. A file watcher would run tests automatically on save.

**The fix:**
```bash
# scripts/watch.sh
# Uses inotifywait or fswatch
while true; do
    inotifywait -r -e modify src/ lib/ tests/
    ./test.sh
done
```
Or a Python script using `watchdog`.

**Effort:** Low.
**Impact:** Medium. Accelerates development.

---

### 64. Dependency graph visualization

**Files to create:** `scripts/dep-graph.py`

**The problem:** No way to see how files depend on each other. When refactoring a library, you don't know what else will break.

**The fix:**
1. Parse all `import!` calls from MeTTa files and `use_module` from Prolog files
2. Generate a DOT graph
3. Highlight circular dependencies
4. Render with Graphviz

```bash
python scripts/dep-graph.py | dot -Tpng > deps.png
```

**Effort:** Low.
**Impact:** Low-Medium. Useful for library maintainers.

---

### 65. `petta` command-line binary / shell wrapper

**Files:** `petta` (shell script) or `bin/petta`

**The problem:** Running `bash run.sh <file>` is awkward and not discoverable. Users expect `petta <file>`.

**The fix:**
1. Create a `petta` shell script that wraps `run.sh`:
```bash
#!/bin/bash
exec "$(dirname "$0")/run.sh" "$@"
```
2. Or better, a small Python script `bin/petta` that uses the Python API:
```python
#!/usr/bin/env python3
import sys
from petta.petta import PeTTa
p = PeTTa()
result = p.load_metta_file(sys.argv[1])
print(result)
```
Make sure `bin/` is in PATH or suggest adding it.

**Effort:** Trivial.
**Impact:** Medium. Makes the tool feel like a real CLI tool.

---

## 🟤 Language Features & Syntax

### 66. Hygienic macros (code generation at compile time)

**Files:** `src/translator.pl`, new `lib/lib_macro.metta`

**The problem:** MeTTa has no way to define syntactic abstractions. Users repeat boilerplate patterns (e.g., defining `when` as `(if condition ... ())`) because there's no macro system.

**The fix:** Add a `defmacro` form:
```metta
(defmacro (when condition . body)
  (if condition (do . body) ()))

; Usage expands at compile time:
(when (> x 0) (println! "positive") x)
; → (if (> x 0) (do (println! "positive") x) ())
```
Key considerations:
- Hygiene: macro-introduced symbols should not shadow user symbols (uses `gensym`)
- Macro expansion happens during translation, before evaluation
- Macros can inspect their own source (code as data)

**Effort:** Medium-High (requires translator changes).
**Impact:** **Very High**. A macro system is transformative for expressiveness.

---

### 67. Threading macros (pipeline operator)

**Files:** `lib/lib_threading.metta` or translator built-in

**The problem:** Nested function calls are hard to read. Compare:
```metta
; Current style — inside-out
(println! (sort (filter (fn (x) (> x 0)) (map (fn (x) (* x 2)) data))))

; With threading — left-to-right
(-> data (map (fn (x) (* x 2))) (filter (fn (x) (> x 0))) sort println!)
```

**The fix:** Add threading macros as either pure macros (if #66 exists) or translator special forms:
- `(-> <value> <fn1> <fn2> ...)` — thread value as first argument
- `(->> <value> <fn1> <fn2> ...)` — thread value as last argument
- `(as-> <value> <name> <fn1> ...)` — named threading

**Effort:** Low (if macros exist) to Medium (as translator built-in).
**Impact:** Medium. Dramatically improves readability of data pipelines.

---

### 68. Destructuring bind in `let`

**Files:** `src/translator.pl`

**The problem:** `let` only binds single values. Extracting elements from a list requires nested `car`/`cdr` or index accesses:
```metta
(let ((x (car (car data))) (y (cdr (car data)))) ...)
```

**The fix:** Add destructuring patterns to `let`:
```metta
(let (((a b) data))      ; list destructure — a = car, b = cadr
  ...)

(let (((a b . rest) data))  ; with rest
  ...)

(let (({:type :key val} data))  ; associative destructure (future)
  ...)
```
Nested patterns should work: `(let ((((x y) z) data)) ...)`.

**Effort:** Medium.
**Impact:** Medium. Eliminates boilerplate extraction.

---

### 69. Contract / invariant system (design by contract)

**Files to create:** `lib/lib_contract.metta`

**The problem:** No way to specify preconditions, postconditions, or invariants. Functions silently return wrong results for invalid inputs. Users must manually add `if` guards everywhere.

**The fix:** Add contract combinators:
```metta
(= (positive? x) (> x 0))

(: divide (-> Number Number Number))
(contract divide
  ; Precondition: denominator must be non-zero
  #:pre (fn (n d) (!= d 0))
  ; Postcondition: result is never zero
  #:post (fn (result) (!= result 0))
  ; Implementation
  (fn (n d) (/ n d)))
```
Contracts are checked at runtime. Violations produce clear error messages. Can be disabled in production with `--no-contracts`.

**Effort:** Medium.
**Impact:** Medium. Catches bugs early, serves as documentation.

---

## 🟤 Space Operations & Knowledge Management

### 70. Space diff, snapshot, and rollback

**Files:** `src/spaces.pl`, `lib/lib_spaces.metta`

**The problem:** Spaces are mutable and irreversible. There is no undo, no time-travel debugging, no way to compare two space states.

**The fix:**
1. **Snapshot**: `(= (snapshot &space) <id>)` — capture all atoms at a moment
2. **Diff**: `(= (space-diff &a &b) <added-removed>)` — compare two snapshots
3. **Rollback**: `(= (rollback! &space <id>) ...)` — restore to a snapshot
4. **Undo**: `(undo! &space)` — revert the last change

Implementation: store a log of `add-atom`/`remove-atom` operations per space, keyed by timestamp. Snapshot = current state + log position.

**Effort:** Medium-High.
**Impact:** High. Essential for knowledge base management and debugging.

---

### 71. Space event system (pub/sub)

**Files:** `src/spaces.pl`, `lib/lib_events.metta`

**The problem:** No way to react to changes in a space. A reactive agent must poll for changes, wasting CPU and introducing latency.

**The fix:** Add an event system:
```metta
; Subscribe to all atom additions
(on-add &space (fn (atom) (println! "added:" atom)))

; Subscribe to specific patterns
(on-match &space (my-fact ?x ?y) (fn (x y) (println! "matched:" x y)))

; Remove subscription
(! (unsubscribe @my-listener))
```
Events are delivered asynchronously. Each event handler runs in a separate logical thread (or sequentially with fair scheduling).

**Effort:** Medium-High.
**Impact:** High. Enables reactive agents and forward-chaining inference.

---

### 72. Transactional spaces (atomic multi-atom updates)

**Files:** `src/spaces.pl`

**The problem:** Adding multiple atoms is not atomic. If the second `add-atom` fails, the first is already committed. If two threads concurrently add inconsistent atoms, there's no rollback.

**The fix:** Add a transaction form:
```metta
(transaction &space
  (add-atom &space (parent child1))
  (add-atom &space (parent child2))
  ; Either both succeed or neither does
  (assert! ...))
```
Implementation: buffer all mutations, validate at commit time, apply atomically. Use Prolog's `setup_call_cleanup/3` to ensure rollback on failure.

**Effort:** Medium.
**Impact:** Medium. Correctness guarantee for concurrent/structured updates.

---

### 73. Space query language (SQL-like for spaces)

**Files to create:** `lib/lib_space_query.metta`

**The problem:** Querying a space requires writing MeTTa match expressions. There's no declarative query interface — no projections, no joins between spaces, no aggregations.

**The fix:** Add a query DSL:
```metta
; Select all triples where subject is ?s and predicate is "type"
(space-select ?s ?o (where (and (triple ?s "type" ?o) (> ?o 5))))

; Join across spaces
(space-select ?name ?age
  (and (match &users (user ?id ?name))
       (match &profiles (profile ?id ?age))))
```
Implementation: each `where` clause compiles to a space match. Projections and joins are syntactic sugar over nested matches.

**Effort:** Medium.
**Impact:** Medium-High. Makes space queries more accessible.

---

## 🟣 Integration & Interop

### 74. LLM / OpenAI integration

**Files to create:** `lib/lib_llm.pl`, `lib/lib_llm.metta`

**The problem:** PeTTa is designed for AI but has no built-in way to call LLMs. Users must write Python glue code to invoke models.

**The fix:** Create a library that wraps API calls:
```metta
; Synchronous call
(= (llm-complete "What is 2+2?") 
   (http-json ...OpenAI API...))

; With system prompt
(= (llm-chat system-prompt user-msg)
   ...)

; Streaming (future)
(= (llm-stream prompt callback) ...)

; Local model via llama.cpp
(= (llm-local "Tell me a joke" "models/llama.gguf")
   ...)
```
Support configurable model, temperature, max-tokens. Respect `--allow-net` for security.

**Effort:** Medium.
**Impact:** **Very High**. Core use case for an AI language.

---

### 75. Pandas / tabular data integration

**Files to create:** `lib/lib_table.metta`, `python/bridge_pandas.py`

**The problem:** Data scientists work with tabular data (CSV → Pandas DataFrame → analysis). MeTTa has no concept of tables or columnar operations.

**The fix:** Create a Pandas bridge:
```metta
; Load CSV as table
(= (table-load "data.csv") <table>)

; Operations
(= (table-filter <table> (fn (row) (> (row "age") 30))) <filtered>)
(= (table-group-by <table> "city") <grouped>)
(= (table-join <a> <b> "user_id") <joined>)
(= (table-plot <table> "x" "y") <chart>)   ; matplotlib
```
Implementation: store tables as Python Pandas DataFrames, exposed to MeTTa as opaque references with a MeTTa API layer.

**Effort:** Medium-High.
**Impact:** High. Opens the data science audience.

---

### 76. Visualization / plotting library

**Files to create:** `lib/lib_plot.pl`, `lib/lib_plot.metta`

**The problem:** No way to visualize data from MeTTa. Output is text-only.

**The fix:** Wrap matplotlib (or a simpler chart library):
```metta
(= (plot-line <xs> <ys> "output.png") ...)
(= (plot-bar <labels> <values> "output.png") ...)
(= (plot-scatter <xs> <ys> "output.png") ...)
(= (plot-histogram <data> "output.png") ...)
```
Each call generates a PNG file. Future: inline display in Jupyter.

**Effort:** Low-Medium.
**Impact:** Medium. Makes MeTTa useful for data exploration.

---

### 77. ROS / robotics integration

**Files to create:** `lib/lib_ros.pl`, `lib/lib_ros.metta`

**The problem:** PeTTa's space model maps naturally to robotics knowledge bases (situation awareness, planning), but there's no ROS integration.

**The fix:** Create a bridge to Robot Operating System:
```metta
; Subscribe to a ROS topic
(= (ros-subscribe "/camera/image" (fn (msg) (process-image msg))) ...)

; Publish a command
(= (ros-publish "/cmd_vel" (linear 0.5 angular 0.0)) ...)

; Query ROS parameter server
(= (ros-get-param "/robot_description") ...)
```
Implementation: use `rospy` via Python bridge. Each subscription maps to a MeTTa callback.

**Effort:** High (requires ROS environment).
**Impact:** Niche but high for the robotics community.

---

### 78. Game engine integration (Godot / Unity)

**Files to create:** `bindings/` directory

**The problem:** PeTTa's hypergraph could serve as a game's knowledge base (NPC state, quest tracking, dialogue trees), but there's no game engine binding.

**The fix:** Create a Godot GDNative/GDExtension plugin:
```gdscript
# Godot GDScript
var petta = PeTTa.new()
petta.run("(load! npc_dialogue.metta)")
var response = petta.run("(get-dialogue 'npc_01 'greeting)")
```
Or a Unity C# package:
```csharp
using PeTTa;
var space = new Space();
space.Run("(= (greeting) (quote Hello, brave traveler!))");
```
Implementation: embed SWI-Prolog via shared library, expose a C API, wrap in GDNative/C#.

**Effort:** Very High.
**Impact:** Medium. Opens a creative coding audience.

---

## 🟢 Community & Process

### 79. Issue and PR templates

**Files to create:** `.github/ISSUE_TEMPLATE/bug_report.md`, `.github/ISSUE_TEMPLATE/feature_request.md`, `.github/PULL_REQUEST_TEMPLATE.md`

**The problem:** Bug reports often lack essential info (OS, SWI-Prolog version, MeTTa input, expected vs actual). Feature requests are vague. PRs lack context.

**The fix:** Create structured templates:
- **Bug report**: reproduction steps, expected vs actual, environment, minimal `.metta` input
- **Feature request**: motivation, proposed API, alternatives considered
- **PR**: linked issue, summary, checklist (tests passed, docs updated, linted)

**Effort:** Trivial (one afternoon).
**Impact:** Medium. Standardizes contributor communication.

---

### 80. Code of conduct

**Files to create:** `CODE_OF_CONDUCT.md`

**The problem:** No behavioral guidelines. As the project grows, conflicts and inappropriate behavior become inevitable.

**The fix:** Adopt the [Contributor Covenant](https://www.contributor-covenant.org/) (industry standard). Add an email contact or reporting process.

**Effort:** Trivial (copy template, fill in contact).
**Impact:** Low. But necessary for a healthy community.

---

### 81. Governance model / maintainer guide

**Files to create:** `GOVERNANCE.md`

**The problem:** No decision-making process. Who can merge PRs? How are contentious decisions resolved? What is the release process?

**The fix:** Document:
1. **Roles**: lead maintainer, committers, contributors
2. **Decision-making**: lazy consensus for minor, vote for major
3. **Release process**: who cuts releases, how often, semver policy
4. **PR review expectations**: review timeline, merge criteria
5. **Conflict resolution**: escalation path

**Effort:** Low to write, ongoing to maintain.
**Impact:** Medium. Prevents governance bottleneck as project grows.

---

### 82. Roadmap / vision document

**Files to create:** `ROADMAP.md`

**The problem:** New contributors don't know where the project is headed. Effort is duplicated. No long-term planning.

**The fix:** Create a roadmap with:
- **Short-term** (0–3 months): language stability, test coverage, CI
- **Medium-term** (3–12 months): LSP, package manager, WASM
- **Long-term** (1–3 years): full type system, self-hosting, formal verification
- **Non-goals**: things the project explicitly won't do

**Effort:** Low-Medium.
**Impact:** Medium. Aligns contributor effort with project direction.

---

### 83. Benchmarking dashboard

**Files to create:** `bench/dashboard/`, GitHub Pages

**The problem:** Performance changes silently creep in. A translator optimization might speed up one pattern by 10x but regress another by 2x.

**The fix:**
1. Run benchmarks in CI on every commit
2. Store results in a time-series format (JSON)
3. Publish a GitHub Pages dashboard with:
   - Line charts of execution time over commits
   - Flame graphs for hot spots
   - Comparison view (current vs last release)
4. Flag commits that regress >10%

**Effort:** Medium-High.
**Impact:** Medium. Prevents silent performance regressions.

---

## 📚 Library Expansion (Continued)

### 84. Unit conversion library

**Files to create:** `lib/lib_units.metta`

**The problem:** Users must manually convert units (km to miles, Celsius to Fahrenheit, bytes to KB). Error-prone and repetitive.

**The fix:** A declarative conversion table:
```metta
(= (unit:convert 100 'km 'mi) 62.137)
(= (unit:convert 32 'degC 'degF) 89.6)
(= (unit:convert 1 'GB 'MB) 1000)

; Internal encoding
(= (unit:def 'km 1000.0 'm))
(= (unit:def 'mi 1609.34 'm))
;; conversion = factor_from / factor_to
```

Support: length, mass, temperature, time, data size, speed, volume.

**Effort:** Low.
**Impact:** Low-Medium. Quality-of-life for MeTTa programs.

---

### 85. Color manipulation library

**Files to create:** `lib/lib_color.metta`

**The problem:** No color operations — RGB→HSL, hex parsing, brightness, blending.

**The fix:**
```metta
(= (color:rgb-hex 255 0 0) "#FF0000")
(= (color:hex-rgb "#00FF00") (0 255 0))
(= (color:rgb-hsl 255 0 0) (0.0 1.0 0.5))  ; hue, saturation, lightness
(= (color:blend "#FF0000" "#0000FF" 0.5) "#7F007F")
(= (color:brightness "#FF0000") 0.299)
(= (color:complement "#FF0000") "#00FFFF")
```

**Effort:** Low.
**Impact:** Low. But useful for generative art and UI.

---

### 86. XML / HTML parsing

**Files to create:** `lib/lib_xml.pl`, `lib/lib_xml.metta`

**The problem:** No way to parse XML or HTML. Common web APIs return XML. HTML scraping is impossible.

**The fix:** Wrap SWI-Prolog's `library(sgml)`:
```prolog
metta_xml_parse(String, Term) :-
    open_string(String, Stream),
    load_xml(Stream, Term, [space(remove)]).
```
Expose as:
```metta
(= (xml-parse "<root><item id='1'/></root>")
   (root (item (@ (id "1")))))
(= (html-parse "<html>...</html>") ...)
```

**Effort:** Low.
**Impact:** Medium. Web data is often XML/HTML.

---

### 87. Natural language toolkit (tokenization, stemming)

**Files to create:** `lib/lib_nlp.metta`

**The problem:** PeTTa is an AI language but has no text preprocessing — no tokenizer, no stemmer, no stop-word filter.

**The fix:** Wrap Python NLTK or spaCy:
```metta
(= (nlp:tokenize "Hello, world!") ("Hello" "," "world" "!"))
(= (nlp:lowercase "Hello") "hello")
(= (nlp:stem "running") "run")
(= (nlp:remove-stopwords ("the" "cat" "sat")) ("cat" "sat"))
(= (nlp:ngrams 2 ("a" "b" "c")) (("a" "b") ("b" "c")))
```
Implementation via Python bridge (NLTK). Pure MeTTa versions of simpler functions (lowercase, ngrams).

**Effort:** Low-Medium.
**Impact:** Medium. Natural for a knowledge representation language.

---

### 88. JSON Schema validation

**Files to create:** `lib/lib_json_schema.pl`, `lib/lib_json_schema.metta`

**The problem:** `json-parse` returns data but can't validate it against a schema. No type checking for API responses.

**The fix:**
```metta
; Define a schema
(= (schema:person {:type "object"
                   :properties {:name {:type "string"}
                                :age {:type "integer" :minimum 0}}
                   :required ["name"]}) ...)

; Validate
(= (schema:validate person-schema {"name" "Alice" "age" 30}) 
   {:valid true})
(= (schema:validate person-schema {"name" "Bob"})
   {:valid false :errors ["missing required: 'age'"]})
```
Implementation: convert JSON Schema to Prolog validation predicates.

**Effort:** Medium.
**Impact:** Medium. Quality assurance for data-heavy MeTTa programs.

---

### 89. URL parsing and validation

**Files to create:** `lib/lib_url.metta`

**The problem:** No URL manipulation — can't extract domain, path, query params, or validate a URL.

**The fix:**
```metta
(= (url:parse "https://example.com/path?q=hello#sec")
   {:scheme "https" :host "example.com" :path "/path"
    :query "q=hello" :fragment "sec"})
(= (url:valid? "not-a-url") false)
(= (url:encode "hello world") "hello%20world")
(= (url:decode "hello%20world") "hello world")
```

**Effort:** Low.
**Impact:** Low-Medium. Needed for web-related libraries.

---

### 90. TOML / INI / DOTENV config parsing

**Files to create:** `lib/lib_config.pl`, `lib/lib_config.metta`

**The problem:** No standard config file parsing. Users must write ad-hoc parsers for `.env`, `.ini`, or `TOML` files.

**The fix:**
```metta
(= (config:dotenv ".env") {"DB_HOST" "localhost" "DB_PORT" "5432"})
(= (config:toml "config.toml") {:title "My App" :version 1})
(= (config:ini "settings.ini") {:database {:host "localhost"}})
```

**Effort:** Low-Medium.
**Impact:** Medium. MeTTa programs need to read config.

---

### 91. Probability distributions library

**Files to create:** `lib/lib_probability.metta`

**The problem:** No statistical distributions. Users implementing probabilistic reasoning (common in AI) must compute PDF/CDF/sampling manually.

**The fix:**
```metta
(= (prob:normal-pdf 0.0 1.0 0.0) 0.3989)  ; N(0,1) at x=0
(= (prob:normal-sample 0.0 1.0) 0.4321)    ; random sample
(= (prob:uniform-sample 0.0 1.0) 0.5678)
(= (prob:bernoulli 0.5) true)              ; coin flip
(= (prob:binomial-pmf 10 0.5 3) 0.1172)   ; 3 heads in 10 flips
```

Support: normal, uniform, bernoulli, binomial, poisson, exponential, beta, gamma.

**Effort:** Medium (math + Prolog random).
**Impact:** Medium. Core for probabilistic AI.

---

### 92. Matrix / linear algebra library

**Files to create:** `lib/lib_matrix.pl`, `lib/lib_matrix.metta`

**The problem:** No matrix operations. Linear algebra is fundamental for AI (neural networks, embeddings, optimization).

**The fix:**
```metta
(= (matrix:create 2 3 [[1 2 3] [4 5 6]]) ...)
(= (matrix:add A B) ...)
(= (matrix:multiply A B) ...)
(= (matrix:transpose A) ...)
(= (matrix:inverse A) ...)
(= (matrix:determinant A) ...)
(= (matrix:eigenvalues A) ...)
```
Implementation: wrap NumPy via Python bridge for performance, or implement pure MeTTa for small matrices.

**Effort:** Medium.
**Impact:** High. An AI language without linear algebra is limited.

---

### 93. Graph algorithm library (shortest path, centrality, isomorphism)

**Files to create:** `lib/lib_graph_algo.pl`, `lib/lib_graph_algo.metta`

**The problem:** The existing #43 (graph analysis) covers basic queries. For real graph algorithms (Dijkstra, PageRank, isomorphism), you need algorithmic implementations, not just space queries.

**The fix:**
```metta
(= (graph:shortest-path &space <from> <to>) <distance>)
(= (graph:dijkstra &space <from>) <distances>)
(= (graph:pagerank &space <damping>) <ranks>)
(= (graph:is-isomorphic? &a &b) true/false)
(= (graph:topological-sort &space) <ordered-atoms>)
(= (graph:strongly-connected-components &space) <components>)
```

**Effort:** Medium-High.
**Impact:** Medium. Graph algorithms are core to MeTTa's use case.

---

## 🧪 Documentation & Learning

### 94. Architecture Decision Records (ADRs)

**Files to create:** `docs/adr/0001-use-swi-prolog.md`, `docs/adr/0002-space-model.md`, ...

**The problem:** No record of why architectural decisions were made. New contributors ask "why did you do X?" and no one remembers.

**The fix:** Document key decisions as ADRs:
```
# ADR 1: Use SWI-Prolog as the Host Language

## Context
PeTTa needed a host for its MeTTa interpreter...

## Decision
We chose SWI-Prolog because...

## Consequences
- Rich constraint library available
- Python bridge via janus-swi
- WebAssembly support is experimental
```
Cover: Prolog choice, space model, translator architecture, Python bridge, test approach, library format.

**Effort:** Low (record existing knowledge).
**Impact:** Medium. Invaluable for long-term maintenance.

---

### 95. MeTTa by example (cookbook)

**Files to create:** `docs/cookbook.md`

**The problem:** Users know what they want to do ("parse a file", "make an HTTP request", "define a data type") but don't know the MeTTa syntax.

**The fix:** A problem-solution cookbook:
```markdown
## How to iterate over a list

Use `fold`:
```metta
(= (sum-list lst) (fold + 0 lst))
!(assertEqual (sum-list (1 2 3)) 6)
```

## How to define a recursive data type

Use atoms and `case`:
```metta
(= (length (cons _ rest)) (+ 1 (length rest)))
(= (length ()) 0)
```
```
Cover: 50+ recipes organized by task category.

**Effort:** Medium.
**Impact:** High. Most users learn from examples.

---

### 96. FAQ / troubleshooting guide

**Files to create:** `docs/faq.md`

**The problem:** Same questions appear repeatedly ("Why is my function returning `()`?", "How do I debug?", "What is a space?").

**The fix:**
```markdown
## Why is my function returning `()`?

This usually means the function returned `()` (empty list). Common causes:
- You forgot a base case in recursion
- You used `if` without an else branch
- A pattern match didn't match any case

## Stack overflow in recursive function

Add a base case! Or try using accumulator recursion (see #61 TCO).
```
Start with 20-30 questions from real user experience.

**Effort:** Low.
**Impact:** Medium. Reduces support burden.

---

### 97. Auto-generated API reference

**Files:** New build step, `docs/api/`

**The problem:** Library documentation is either the source code or non-existent. Users must read MeTTa source to learn function signatures.

**The fix:** Create a docstring convention and doc generator:
```metta
; @doc "Return the first element of a list"
; @param list The input list
; @return The first element, or () if empty
; @example (car (1 2 3)) → 1
(= (car (head . _)) head)
```
Write a script that:
1. Scans `lib/*.metta` for `; @doc` annotations
2. Generates structured Markdown
3. Groups by library file
4. Cross-references with types

**Effort:** Medium.
**Impact:** Medium. Makes the library accessible.

---

## 🔴 Module System & Namespacing

### 98. Module system (namespaces, exports, imports with prefix)

**Files:** `src/module.pl`, `lib/module_system.metta`, modify `src/translator.pl`

**The problem:** All definitions live in a single global namespace. Two libraries can't both define `map` without conflict. There's no encapsulation — every internal helper is visible to users.

**The fix:** Design a module system:
```metta
; File: lib/strings.metta
(module strings
  (export concat join split uppercase lowercase)
  
  ; Private — not exported
  (= (internal:validate s) ...)
  
  (= (concat a b) (string:append a b))
  (= (uppercase s) ...)
)

; Consumer
(import strings :prefix str)
(= (greeting name) (str:concat "Hello, " name))
```
Implementation approaches (pick one):
1. **File-as-module**: each file is implicitly a module, `import!` accepts `:only` and `:prefix` options
2. **Explicit module form**: `(module name ...)` wraps a block, controls exports
3. **Space-as-module**: each module lives in its own space, imported symbols are references

**Why this matters:** Without modules, the language cannot scale beyond a few libraries. Name collisions become inevitable.

**Effort:** High (touches translator, loader, and every library).
**Impact:** **Critical**. Foundation for ecosystem growth.

---

## 🔴 Debugging & Developer Experience

### 99. MeTTa-level stack traces

**Files:** `src/translator.pl`, `src/errors.pl`

**The problem:** When a MeTTa program crashes, the error is a raw Prolog trace. The user sees `ERROR: Unknown procedure: '(/)/2'` but doesn't know which MeTTa expression caused it, what the arguments were, or the call chain.

**The fix:**
1. During translation, annotate every goal with source location (file, line, column)
2. Maintain a MeTTa call stack: before translating each function call, push a frame
3. On error, print:
```
Error: Division by zero
  at (arithmetic/2) called from: (/ 1 0)
    called from: (compute-average (10 0 20))
    called from: (process-dataset "data.csv")
    called from: (main ())
  File: examples/compute.metta, line 15, column 3
```
4. Use Prolog's `exception/3` hook or `:- dynamic '$translate_exception'/3` to intercept errors

**Effort:** High (requires tracking source locations through the entire translator).
**Impact:** **Critical**. Without this, every error is a guessing game.

---

### 100. Hot code reloading (swap functions without restart)

**Files:** `src/hot_reload.pl`, `src/filereader.pl`

**The problem:** Development cycle is: edit file → restart PeTTa → re-import all libraries → run test. For large knowledge bases, this takes 30+ seconds each iteration.

**The fix:** Add a `(reload! <file>)` function that:
1. Scans the file for `(= ...)` definitions
2. Retracts old clauses for each function name
3. Loads new definitions
4. Preserves state (no space reset, no variable loss)
5. Warns if the new definition has a different arity

```metta
; While developing:
!(reload! "my_lib.metta")   ; swap definitions in-place
!(test-all)                 ; re-run tests with new code
```

**Effort:** Medium.
**Impact:** **Very High**. Drastically improves iteration speed.

---

### 101. MeTTa profiler (find slow code)

**Files to create:** `src/profiler.pl`, `lib/lib_profiler.metta`

**The problem:** No way to know why a MeTTa program is slow. Users guess and optimize blindly.

**The fix:** A sampling or instrumenting profiler:
```metta
; Profile a specific expression
(= (profile (expensive-computation 1000)) ...)

; Output:
; Function               Calls  Total(ms)  Self(ms)
; expensive-computation   1      2340       120
:   recursive-step       999     1350       1350
:   inner-computation    999      870        870
```
Implementation options:
1. **Instrumenting**: wrap each function call with timing (simpler, adds overhead)
2. **Sampling**: suspend execution every 10ms and record the call stack (complex, low overhead)
3. **Structural**: use Prolog's `statistics/2` and `profile/1` to measure at the Prolog level, map back to MeTTa lines

**Effort:** Medium-High.
**Impact:** High. Makes optimization data-driven.

---

## 🔴 AI & Knowledge Features

### 102. Temporal reasoning system

**Files to create:** `lib/lib_temporal.pl`, `lib/lib_temporal.metta`

**The problem:** Atoms are timeless. There's no way to express "X was true on Monday but false on Tuesday" or query "what was the state of the knowledge base at time T?"

**The fix:** Add temporal annotations to atoms and time-aware queries:
```metta
; Fact with temporal scope
(assert! (weather :rainy) :valid-from "2025-01-01" :valid-to "2025-01-15")

; Query with time context
(match &self (weather ?status) :at "2025-01-10")
;; → (weather rainy)

(match &self (weather ?status) :at "2025-01-20")
;; → no match (expired)

; Interval relations (Allen's interval algebra)
(temporal:before ?a ?b)
(temporal:overlaps ?a ?b)
(temporal:during ?a ?b)
(temporal:meets ?a ?b)
```
Implementation: store atoms with `:valid-from` / `:valid-to` metadata. Queries with `:at` filter by timestamp. Interval relations use Prolog's `library(clpfd)` for constraint solving.

**Effort:** High (pervasive change to atom storage and matching).
**Impact:** **Very High**. Enables planning, scheduling, event processing, and historical queries.

---

### 103. Truth maintenance system (belief revision)

**Files to create:** `lib/lib_tms.pl`, `lib/lib_tms.metta`

**The problem:** Atoms have no justification. If you assert `(bird tweety)` and `(flies tweety)` via a rule, then retract `(bird tweety)`, the derived `(flies tweety)` persists as orphaned knowledge.

**The fix:** Implement a justification-based truth maintenance system (JTMS):
```metta
; Each assertion tracks dependencies
(assert! (bird tweety) :justification "observed")
(assert! (=> (bird ?x) (flies ?x)) :justification "rule")

; Query reveals dependencies
(why (flies tweety))
;; → (flies tweety) follows from:
;;     (bird tweety) via rule (=> (bird ?x) (flies ?x))

; Retraction cascades:
(retract! (bird tweety))
;; → also retracts (flies tweety) because its justification is invalid
```
Types of truth maintenance:
1. **JTMS** (justification-based): each fact tracks its support
2. **ATMS** (assumption-based): facts can be true under multiple assumptions
3. **LTMS** (logic-based): uses logical constraints

**Effort:** High.
**Impact:** **Very High**. Core AI capability. Turns PeTTa into a proper knowledge representation system.

---

### 104. Causal reasoning / counterfactual querying

**Files to create:** `lib/lib_causal.pl`, `lib/lib_causal.metta`

**The problem:** No way to ask "what if?" questions. Users can write rules but can't express causal relationships or compute interventions.

**The fix:** Add a causal reasoning library based on Pearl's do-calculus:
```metta
; Define a causal model
(= (causal:def-model smoking
   ((smoking) → (lung-cancer))
   ((smoking) → (stained-fingers))
   ((lung-cancer) → (shortness-of-breath)))
   ...)

; Query: probability of lung cancer given smoking
(causal:query smoking-cancer (smoking true) (lung-cancer true))
;; → 0.15

; Intervention: what if we banned smoking?
(causal:do smoking-cancer (smoking false) (lung-cancer true))
;; → 0.02

; Counterfactual: would this patient have cancer if they hadn't smoked?
(causal:counterfactual patient
  (observed (smoking true) (lung-cancer true))
  (intervention (smoking false))
  (query (lung-cancer true)))
;; → 0.05 (probably not)
```

**Effort:** Very High (requires probability + graph + do-calculus).
**Impact:** Very High. Differentiating AI capability.

---

### 105. Explanation generation ("why did you return that?")

**Files to create:** `lib/lib_explain.pl`, `src/trace.pl`

**The problem:** PeTTa is a black box. Functions return values but provide no explanation. For an AI language, this is a critical gap — users need to understand *why* a conclusion was reached.

**The fix:** Add an explanation subsystem:
```metta
; Normal evaluation
(= (tax-owed income) (if (> income 50000) (* income 0.3) (* income 0.2)))

; With explanation
(= (tax-owed income) (with-explanation
   (if (> income 50000)
     (explain (tax-owed income) "High bracket: >$50K" (* income 0.3))
     (explain (tax-owed income) "Low bracket: ≤$50K" (* income 0.2)))))

; Query
(explain (tax-owed 75000))
;; → 22500
;;   Because: income 75000 > 50000, so high bracket applies
;;   75000 * 0.3 = 22500
```

**Effort:** Medium-High.
**Impact:** High. Makes an AI language interpretable.

---

### 106. Knowledge graph visualizer (space → graphviz)

**Files to create:** `lib/lib_viz.pl`, `lib/lib_viz.metta`

**The problem:** Spaces are invisible. Users program a hypergraph but can never see it. Debugging complex space interactions is nearly impossible.

**The fix:** A visualization library that renders a space as a graph:
```metta
; Generate a DOT graph from a space
(= (viz:space->dot &self "space.dot") ...)
; Or render directly:
(= (viz:render &self "space.png" :layout "neato") ...)

; Filter by type or pattern
(= (viz:render &self "types.png" :filter (match &self (: ?x ?type))) ...)

; Interactive HTML (D3.js)
(= (viz:render-html &self "space.html") ...)
```

**Effort:** Medium.
**Impact:** **Very High**. Makes the knowledge graph tangible and debuggable.

---

### 107. Forward-chaining inference engine

**Files:** `lib/lib_forward_chain.pl`, `lib/lib_forward_chain.metta`

**The problem:** Rules are only evaluated when called (backward chaining). There's no way to say "whenever X becomes true, derive Y." No automatic rule firing, no reactive knowledge base.

**The fix:** Add a forward-chaining rule engine:
```metta
; Define forward rules
(rule:forward
  (if (bird ?x) (=> (animal ?x)))
  (println! "Inferred:" (animal ?x)))

; When we assert:
(assert! (bird tweety))
;; → Immediately fires:
;;   Inferred: (animal tweety)
;;   Asserts: (animal tweety)

; Control execution
(rule:step &self)           ; one round of rule firing
(rule:run &self)             ; until fixpoint
(rule:run-limit &self 100)   ; max N iterations
```
Implementation: maintain an agenda of triggered rules. On each `add-atom`, check which rule antecedents match, fire them, add consequents, repeat until quiescence.

**Effort:** Medium-High.
**Impact:** **Very High**. Transforms PeTTa from a functional language into a true production system / expert system shell.

---

## 🔴 Production & Deployment

### 108. Docker image + docker-compose for production

**Files to create:** `Dockerfile`, `docker-compose.yml`, `.dockerignore`

**The problem:** No containerized deployment. Every user must install SWI-Prolog + Python manually. No way to deploy PeTTa as a service.

**The fix:**
```dockerfile
FROM swipl:latest
RUN apt-get update && apt-get install -y python3 python3-pip
COPY . /app
WORKDIR /app
RUN pip install -e python/
RUN make
CMD ["swipl", "-g", "main", "-t", "halt", "src/main.pl", "--"]
```
Plus `docker-compose.yml` for multi-service setups (PeTTa API + Redis + Postgres):
```yaml
services:
  petta:
    build: .
    ports:
      - "8080:8080"
    command: ["swipl", "-g", "server_main", "src/server.pl"]
    volumes:
      - ./data:/data
    environment:
      - PETTA_LOG_LEVEL=info
```

**Effort:** Low.
**Impact:** High. Makes PeTTa deployable in any cloud.

---

### 109. Prometheus metrics / health endpoint

**Files:** `src/metrics.pl`, `src/health.pl`

**The problem:** No observability. If PeTTa is serving as a microservice, you can't monitor request latency, error rate, memory usage, or uptime.

**The fix:**
1. **Metrics endpoint** (`GET /metrics`): expose Prometheus-style counters:
```
# HELP petta_requests_total Total MeTTa requests
# TYPE petta_requests_total counter
petta_requests_total{status="ok"} 42
petta_requests_total{status="error"} 3
# HELP petta_space_atoms Number of atoms per space
# TYPE petta_space_atoms gauge
petta_space_atoms{space="&self"} 1523
petta_space_atoms{space="&library"} 847
# HELP petta_request_duration_ms Request latency
petta_request_duration_ms{quantile="0.95"} 45
```
2. **Health endpoint** (`GET /health`): return `{"status": "ok", "spaces": 5, "atoms": 10000, "uptime": 86400}`
3. **Graceful shutdown**: catch SIGTERM, save state, flush metrics, exit cleanly

**Effort:** Medium.
**Impact:** High. Essential for production deployment.

---

### 110. Standalone binary compilation

**Files:** `Makefile.compile`, `scripts/compile.sh`

**The problem:** PeTTa requires SWI-Prolog installed. Users can't distribute a single binary. No `pip install petta` that just works.

**The fix:** Use SWI-Prolog's `swipl-ld` or SWIPL's compilation capabilities:
```bash
#!/bin/bash
# Compile a MeTTa program + runtime into a standalone binary
swipl-ld -o my_program \
  -pl-lib src/main.pl \
  -pl-load "lib/lib_string.metta" \
  -pl-load "lib/lib_math.metta" \
  -goal "main, halt" \
  my_program.metta
```
Or better: bundle Python + SWI-Prolog via PyInstaller:
```bash
pyinstaller --onefile \
  --add-data "src/*.pl:src/" \
  --add-data "lib/*.metta:lib/" \
  python/petta_cli.py -n petta
```
This produces a single `petta` binary with no external dependencies.

**Effort:** Medium-High.
**Impact:** **Very High**. Removes the #1 adoption barrier (no SWI-Prolog install).

---

## 🔴 Language & Runtime

### 111. Gradual type system

**Files to create:** `src/type_checker.pl`, `lib/lib_types.metta`

**The problem:** The current type system is a thin annotation layer. Types are documented but not checked. A function declared `(: add (-> Number Number Number))` will happily accept strings and crash at runtime.

**The fix:** Implement gradual typing:
1. **Untyped code works as before** (gradual = no mandatory annotations)
2. **Type assertions are checked at call boundaries**:
```metta
(: square (-> Number Number))
(= (square x) (* x x))

(square "hello")  ; Runtime error: expected Number, got String
```
3. **Type inference for simple cases**: if `(+ x 1)` succeeds, `x` must be Number
4. **Type variables**: `(: id (-> ?a ?a))`
5. **Optional static checking**: `petta --check-types program.metta` validates without running

Implementation: translate type annotations to runtime assertions inserted at function boundaries. Optimize away checks after proving safety.

**Effort:** Very High.
**Impact:** **Critical**. A type system is the difference between a toy language and a serious one.

---

### 112. Continuations / coroutines / generators

**Files:** `src/continuations.pl`, `lib/lib_coroutines.metta`

**The problem:** MeTTa evaluates an expression to completion. You can't yield intermediate results, pause execution, or create iterators.

**The fix:** Add generators (semi-coroutines):
```metta
; A generator yields values one at a time
(= (fibonacci)
   (generator
     (let loop ((a 0) (b 1))
       (yield a)
       (loop b (+ a b)))))

; Usage
(let ((gen (fibonacci)))
  (println! (gen:next gen))  ; 0
  (println! (gen:next gen))  ; 1
  (println! (gen:next gen))  ; 1
  (println! (gen:next gen))  ; 2
  (println! (gen:next gen))  ; 3
)
```
Implementation: transform generator bodies into state machines. Each `yield` saves the continuation. Resume on next call.

**Effort:** High.
**Impact:** High. Enables streaming, lazy IO, async patterns.

---

### 113. Pattern matching with guards and or-patterns

**Files:** `src/translator.pl`

**The problem:** `case` expressions can match structure but not conditions. Users need nested `if` inside `case` branches for conditional matching.

**The fix:** Extend `case` with guards and or-patterns:
```metta
(= (classify x)
   (case x
     ((?n :guard (> n 0)) "positive")
     ((?n :guard (< n 0)) "negative")
     (0 "zero")
     (?else "unknown")))

; Or-patterns (multiple patterns, same body)
(= (vowel? c)
   (case c
     ((or "a" "e" "i" "o" "u") true)
     (?else false)))
```

**Effort:** Medium (translator changes).
**Impact:** Medium. Makes pattern matching significantly more expressive.

---

### 114. Multi-methods / generic functions

**Files:** `src/multimethods.pl`, `lib/lib_multimethods.metta`

**The problem:** Functions dispatch on the first argument only. You can't define behavior that depends on multiple arguments' types.

**The fix:** Add multi-methods (dispatch on all arguments):
```metta
; Define a generic function
( defgeneric collide)

; Methods specialized by argument types
(defmethod collide ((a asteroid) (b asteroid))
  "Both break apart"
  ...)

(defmethod collide ((a asteroid) (b spaceship))
  "Spaceship destroyed"
  ...)

(defmethod collide ((a spaceship) (b asteroid))
  "Same as above — symmetric"
  ...)

(defmethod collide ((a spaceship) (b spaceship))
  "Both damaged"
  ...)
```
Implementation: at call site, collect all method definitions, filter by argument type match, select most specific (or signal ambiguity).

**Effort:** High.
**Impact:** High. Enables elegant OOP-style dispatch without classes.

---

### 115. MeTTa → Python / JavaScript compilation

**Files to create:** `compilers/` directory

**The problem:** MeTTa can only run inside PeTTa. If you want to embed MeTTa logic in a web app (JS), a data pipeline (Python), or a game (C#), you must run a full SWI-Prolog instance.

**The fix:** Create transpilers that emit equivalent code in target languages:
- **Python**: emit Python functions from MeTTa `(= ...)` definitions
- **JavaScript**: for web embedding
- **C**: for embedded/IoT

```metta
(= (fib n)
   (if (<= n 1) n (+ (fib (- n 1)) (fib (- n 2)))))

;; → Python:
; def fib(n):
;     if n <= 1: return n
;     return fib(n-1) + fib(n-2)
```

**Effort:** Very High.
**Impact:** **Very High**. Makes MeTTa a compile-to-anything language.

---

### 116. Unicode / full internationalization support

**Files:** `lib/lib_unicode.pl`, modify `src/filereader.pl`

**The problem:** MeTTa symbols are ASCII-only. You can't write identifiers in Greek, Cyrillic, CJK, or use Unicode string operations.

**The fix:**
1. Allow Unicode identifiers in the reader (already supported by SWI-Prolog)
2. Add Unicode string operations:
```metta
(= (unicode:length "Hello") 5)
(= (unicode:length "日本語") 3)       ; not 9 bytes
(= (unicode:upcase "straße") "STRASSE")
(= (unicode:downcase "HELLO") "hello")
(= (unicode:char-at "abc" 0) "a")    ; not byte-at
(= (unicode:normalize "é" nfc) "é")   ; normalization forms
```
3. Add `(i18n:translate <key> <lang>)` for multilingual applications
4. Support Unicode properties: `(unicode:is-letter? "A")`, `(unicode:is-digit? "3")`

**Effort:** Medium.
**Impact:** High. Makes MeTTa globally accessible.

---

### 117. Bulk data loading engine (CSV/JSON → space, 1M+ atoms)

**Files:** `src/bulk_loader.pl`, `lib/lib_loader.metta`

**The problem:** Loading a CSV with 100K rows via MeTTa REPL takes minutes. Each `add-atom` is a separate Prolog assert. The translator overhead per assertion kills performance.

**The fix:** A bulk loader that bypasses translation:
```metta
; Bulk load CSV
(= (load:csv->space "large.csv" &kb :delimiter "," :batch 1000)
   (load:csv->space ...))  ; 100K rows in ~2 seconds

; Bulk load JSON
(= (load:json->space "large.json" &kb :flatten true) ...)

; Bulk load from Python (Pandas DataFrame)
(= (load:dataframe->space df &kb) ...)
```
Implementation: use SWI-Prolog's `csv_read_file_row/3` or Python's Pandas for streaming. Batch assertz with `asserta` + `flush`. Disable translator for raw atom insertion.

**Effort:** Medium.
**Impact:** **Very High**. Makes PeTTa viable for real-world data sizes.

---

### 118. Incremental space indexing (performance at scale)

**Files:** `src/space_index.pl`

**The problem:** Space lookups use linear scan over all atoms. With 10K atoms, `match` is noticeable. With 1M atoms, it's unusable.

**The fix:** Add indexes:
1. **Functor index**: map `(predicate ...)` to atoms with that predicate (hash table)
2. **Argument index**: for common patterns like `(: ?x Type)`, index by argument position
3. **Type index**: map types to atoms of that type
4. **Full-text index**: for string atoms, support substring search

```prolog
% Index structure (using SWI-Prolog's nb_set/2 or term_hash/2)
add_to_index(Atom) :-
    functor(Atom, F, _),
    hash_add(functor_index, F, Atom).

match_indexed(F, Pattern) :-
    hash_lookup(functor_index, F, Candidates),
    member(Atom, Candidates),
    term_variables(Pattern, Vars),
    ...  % match against candidates only
```

**Effort:** Medium-High.
**Impact:** **Very High**. Makes PeTTa scale from toy examples to real knowledge bases.

---

## 🟢 Self-Hosting & Dogfooding

### 119. Rewrite the translator in MeTTa (partial self-hosting)

**Files to create:** `src/self_hosted/`

**The problem:** The translator is 600+ lines of Prolog. Only Prolog programmers can modify it. This creates a bottleneck: language developers must know Prolog, MeTTa users cannot contribute to the compiler.

**The fix:** Incrementally rewrite the translator in MeTTa:
1. Identify the simplest translation rule (e.g., `if` → Prolog)
2. Write a MeTTa function `(translate-if <args>)` that emits Prolog code
3. Replace the Prolog implementation with a call to the MeTTa version
4. Repeat for `case`, `let`, `let*`, `superpose`, `match`, `collapse`
5. Eventually: the entire translator is a MeTTa program

```metta
; MeTTa-level translator rule (future vision)
(= (translate (if condition then else) continuation)
   (let ((c (translate condition))
         (t (translate then continuation))
         (e (translate else continuation)))
     `(if ,c ,t ,e)))
```

**Effort:** Very High (years-long project).
**Impact:** **Transformative**. A self-hosting MeTTa is independent of Prolog.

---

### 120. Write the test runner in MeTTa

**Files:** `lib/lib_test_runner.metta` + `test.metta`

**The problem:** `test.sh` is a bash script. Adding a new test means editing a shell script. Test discovery is grep-based. Test output is unstructured.

**The fix:** Write the test framework in MeTTa itself:
```metta
; Define a test
(describe "String library"
  (it "concatenates two strings"
      (assert-equal (concat "a" "b") "ab"))
  (it "handles empty strings"
      (assert-equal (concat "" "b") "b")))

; Run all tests
(! (run-tests))

; Output:
; ✓ String library > concatenates two strings
; ✓ String library > handles empty strings
; 2 passed, 0 failed
```
Implementation: each `it` form registers a test. `run-tests` collects all registered tests, executes them, and prints results with colors.

**Effort:** Medium.
**Impact:** High. Dogfoods MeTTa and empowers users to write tests in MeTTa.

---

## 🟢 Benchmark / Scale Testing

### 121. Scale benchmark: 1K, 10K, 100K, 1M atom spaces

**Files to create:** `bench/scale/`

**The problem:** No one knows how PeTTa performs at scale. The largest test file has ~100 atoms. Real use cases may have millions.

**The fix:** Create scale benchmarks:
```metta
; bench/scale/1k_atoms.metta — generated, not hand-written
! (add-atom &self (fact 0))
! (add-atom &self (fact 1))
... 1000 atoms
! (match &self (fact ?x) ?x)  ; measure match time

; bench/scale/1m_atoms.metta (generated by Python script)
```
Measure and report:
- Time to insert N atoms
- Time to match a specific atom
- Time to match with variable (full scan)
- Memory usage after N atoms
- Time to load from file (parsing + insertion)
- Time to export space to file

**Effort:** Low (generate scripts).
**Impact:** Medium. Critical data for architecture decisions.

---

### 122. Fuzz testing at scale (random MeTTa programs)

**Files to create:** `tests/fuzz_programs/`

**The problem:** Unit tests only test what developers thought of. Fuzzing finds bugs at the intersection of features (e.g., `case` inside `let*` inside `superpose`).

**The fix:** Generate and test random MeTTa programs:
1. Define a grammar of MeTTa expressions: `(if ...)`, `(let ...)`, `(case ...)`, `(= ...)`, `(match ...)`...
2. Generate random ASTs with controlled depth (2-8 levels)
3. Transpile to MeTTa source
4. Run and check: (a) no crash, (b) no infinite loop (timeout 5s), (c) output is valid sexpr
5. Run 10,000 random programs in CI nightly

**Effort:** Medium.
**Impact:** High. Finds bugs humans won't.

---

## 🔴 Language Usability

### 123. Keyword & optional arguments with defaults

**Files:** `src/translator.pl`

**The problem:** Every argument is positional and required. Callers must remember parameter order. No backward-compatible way to add parameters.

**The fix:** Support keyword (named) arguments with optional defaults:
```metta
; Definition with keyword argument
(= (http-get url :timeout 5 :headers ())
   ...)

; Call with default
(http-get "https://example.com")
;; → uses timeout=5, headers=()

; Override specific defaults
(http-get "https://example.com" :timeout 30)
```
Implementation: translate keyword args to a destructuring `let` that binds defaults and merges overrides. Signature becomes `(= (http-get url . kvs) ...)` where kvs is processed at runtime.

**Effort:** Medium.
**Impact:** High. Makes library APIs ergonomic and extensible.

---

### 124. String interpolation (embed expressions in strings)

**Files:** `lib/lib_string_interp.metta`, `src/reader.pl`

**The problem:** Building strings from values requires concatenation: `(string:append "Hello " name ", you are " (number->string age) " years old")`. Unreadable and error-prone.

**The fix:** Add string interpolation syntax:
```metta
; Using a function (runtime interpolation)
(= (greeting name age) (str $"Hello {name}, you are {age} years old"))

; Or reader-level (compile-time expansion)
(= (greeting name age) #s"Hello ${name}, you are ${age} years old")
```
Implementation: `str` or `#s"..."` is MeTTa syntax that parses the string, extracts `{...}` expressions, and assembles a `string:append` chain.

**Effort:** Low-Medium.
**Impact:** High. Dramatically improves string-building ergonomics.

---

### 125. Literate programming (.metta.md files)

**Files:** `src/literate.pl`

**The problem:** Code and documentation are separate files that drift apart. No way to write explanations alongside code that can be rendered as documents.

**The fix:** Support `.metta.md` files — Markdown files with embedded MeTTa code blocks:
````markdown
# Fibonacci in MeTTa

The Fibonacci sequence is defined recursively:

```metta
(= (fib 0) 0)
(= (fib 1) 1)
(= (fib n) (+ (fib (- n 1)) (fib (- n 2))))
```

Usage:

```metta
!(assertEqual (fib 10) 55)
```
````
The literate loader:
1. Reads the markdown file
2. Extracts all ```` ```metta ```` blocks
3. Concatenates and evaluates them
4. Ignores (or renders) the markdown content

**Effort:** Low.
**Impact:** Medium. Encourages documentation-skew-free development.

---

### 126. Docstrings as first-class metadata

**Files:** `lib/lib_doc.metta`, `src/translator.pl`

**The problem:** No standard way to attach documentation to functions. Current `; comments` are discarded. Library docs are separate markdown files that rot.

**The fix:** Add docstring syntax stored as runtime-accessible metadata:
```metta
"Return the number of elements in a list"
(= (length ()) 0)
(= (length (head . rest)) (+ 1 (length rest)))

; Query docs at runtime
(! (doc length))
;; → "Return the number of elements in a list"

; Generate docs page automatically
(! (doc:generate "docs/api.md"))
```
Implementation: the translator stores string literals immediately before `(= ...)` as metadata associated with the function name. `doc` is a built-in that retrieves it.

**Effort:** Low.
**Impact:** Medium. Self-documenting code.

---

## 🟠 Distributed & Collaborative

### 127. Distributed spaces (P2P knowledge sharing)

**Files to create:** `src/distributed.pl`, `lib/lib_distributed.metta`

**The problem:** Every PeTTa instance is isolated. Two instances can't share a space over the network. No collaborative knowledge bases.

**The fix:** Add distributed space synchronization:
```metta
; Connect to a remote space
(= (space:connect "tcp://other-petta:9090" &remote) ...)

; Subscribe to changes
(= (space:sync &local &remote :direction bidirectional) ...)

; Changes propagate automatically
(assert! (fact "shared knowledge"))
;; → replicated to remote space
```
Implementation options:
1. **Simple**: WebSocket + JSON serialization of atoms, broadcast on `add-atom`
2. **CRDT**: commutative replicated data types for conflict-free merging
3. **Gossip**: periodic anti-entropy sync for eventually-consistent knowledge

**Effort:** High.
**Impact:** **Very High**. Enables multi-agent systems and collaborative knowledge bases.

---

### 128. P2P / IPFS-based content-addressed knowledge

**Files to create:** `src/p2p.pl`, `lib/lib_p2p.metta`

**The problem:** Knowledge is stored on a single machine. No content addressing, no decentralization, no verifiability.

**The fix:** Integrate with IPFS (InterPlanetary File System):
```metta
; Store an atom on IPFS, get back a content hash
(= (p2p:publish (important-fact 42)) 
   "QmXk..."  ; IPFS content identifier

; Load atom from IPFS by hash
(= (p2p:load "QmXk...") 
   (important-fact 42))

; Publish a space snapshot
(= (p2p:publish-space &self)
   "QmY...")

; Verify authenticity (sign with GPG/SSH key)
(= (p2p:sign space-hash private-key) signature)
(= (p2p:verify space-hash signature public-key) true)
```
Implementation: call IPFS HTTP API (`ipfs add`, `ipfs cat`). Atoms are serialized to JSON/IPLD.

**Effort:** High.
**Impact:** **Very High**. Decentralized, verifiable knowledge. Future-proof.

---

### 129. Collaborative space editing (operational transform / CRDT)

**Files to create:** `src/crdt.pl`, `lib/lib_collab.metta`

**The problem:** Two users can't simultaneously edit the same space. Concurrent `add-atom` and `remove-atom` operations collide silently.

**The fix:** Implement CRDT (Conflict-free Replicated Data Type) for spaces:
```metta
; Two peers concurrently:
;; Alice: (add-atom &space (temperature 25))
;; Bob:   (add-atom &space (temperature 30))

; After sync, the space contains both atoms (no data loss)
; Conflict resolution: LWW (last-writer-wins) or merge

; Explicit conflict handling:
(= (space:resolve-conflict &space :strategy 'lww) ...)
(= (space:resolve-conflict &space :strategy 'add-all) ...)
(= (space:resolve-conflict &space :strategy 'custom resolver-fn) ...)
```
Implementation: atoms carry vector clocks or timestamps. Concurrent additions both survive. Concurrent add + remove uses tombstone markers.

**Effort:** Very High.
**Impact:** High. Enables Google-Docs-for-knowledge-bases.

---

## 🧠 Advanced AI

### 130. Common sense knowledge base integration

**Files:** `lib/lib_commonsense.pl`, `lib/lib_commonsense.metta`

**The problem:** PeTTa has no common sense. `(is-liquid water)` returns false unless explicitly asserted. Every trivial fact must be hand-coded.

**The fix:** Integrate with ConceptNet or similar common sense KB:
```metta
; Query common sense
(= (commonsense:query "water" "IsA" ?category)
   ("liquid" "beverage" "chemical" "substance"))

(= (commonsense:query "bird" "CapableOf" ?action)
   ("fly" "sing" "build nest" "eat worms"))

; Load relevant facts into a space
(= (commonsense:populate &space "bird")
   ...)  ; adds: (is-a bird animal), (has bird wings), (capable-of bird fly), ...
```
Implementation: ship a subset of ConceptNet (or OpenCyc) as a bundled MeTTa file, or query a remote API.

**Effort:** Medium.
**Impact:** **Very High**. Makes PeTTa programs less brittle.

---

### 131. Analogy engine (structure mapping)

**Files to create:** `lib/lib_analogy.pl`, `lib/lib_analogy.metta`

**The problem:** PeTTa can match exact patterns but can't find analogies. It can't see that the solar system is like an atom, or that water flow is like electricity.

**The fix:** Implement structure-mapping theory (SME — Structure Mapping Engine):
```metta
; Define a source domain
(= (analogy:define 'solar-system
   ((orbits earth sun) (orbits mars sun) (hotter-than sun earth))
   ...))

; Define a target domain
(= (analogy:define 'atom
   ((orbits electron nucleus) (orbits proton nucleus))
   ...))

; Find analogies
(= (analogy:match 'solar-system 'atom)
   ;; → Mapping: sun↔nucleus, earth↔electron, mars↔proton
   ;; Confidence: 0.87
   )

; Transfer knowledge via analogy
(= (analogy:transfer 'solar-system 'atom 'hotter-than ?x ?y)
   ;; → (hotter-than nucleus electron)
   )
```
Implementation: compare relational structure rather than surface features. Use graph isomorphism + semantic similarity.

**Effort:** Very High.
**Impact:** **Very High**. A core cognitive capability missing from most AI systems.

---

### 132. Dialogue management / conversational agent framework

**Files to create:** `lib/lib_dialogue.metta`

**The problem:** No framework for building conversational agents. Building a chatbot in MeTTa requires manual state management, intent recognition, and response generation.

**The fix:** A dialogue management library:
```metta
; Define a dialogue
(= (dialogue:define greet-bot
   ;; States
   (state greeting
     :on-enter (fn () (say "Hello! What's your name?"))
     :transitions ((user-says ?name) → ask-hobby)))
   
   (state ask-hobby
     :on-enter (fn () (say (str $"Nice to meet you, {name}!")))
     :transitions (...))
   
   ;; Initial state
   :start greeting))
```

Features:
- State machine with slots (fill-in-the-blank knowledge acquisition)
- Intent matching: pattern + keyword-based NLU
- Context management: track conversation history
- Multi-turn: handle interruptions, corrections, digressions
- Plugable NLU backends (regex → spaCy → LLM)

**Effort:** High.
**Impact:** High. Natural fit for PeTTa's knowledge representation.

---

### 133. Autonomous curiosity / active learning

**Files to create:** `lib/lib_curiosity.pl`, `lib/lib_curiosity.metta`

**The problem:** PeTTa only answers asked questions. It never explores, never asks questions, never seeks knowledge autonomously.

**The fix:** Add an autonomous exploration engine:
```metta
; Define curiosity drive
(= (curiosity:drive
   :novelty-weight 0.5
   :coverage-goal 0.8
   :max-iterations 100)
   ...)

; The engine:
; 1. Scans the space for unconnected concepts
; 2. Generates hypotheses: (= (hypothesis:relation ?a ?b) ...)
; 3. Tests: tries to prove the hypothesis, queries external sources
; 4. Consolidates: if confirmed, adds to space; if refuted, marks as ¬
; 5. Repeats until coverage goal met

; Example:
(= (curiosity:explore &self)
   → "Learned 15 new facts about mammals"
   → "Generated 3 hypotheses about bird migration"
   → "Queried ConceptNet for 50 related concepts")
```
Implementation: track concept frequency. Find knowledge gaps (concepts mentioned but not defined). Form analogies. Query external KBs.

**Effort:** Very High.
**Impact:** **Transformative**. An AI that learns by itself.

---

## 🛠 Project Infrastructure

### 134. All-contributors bot / contributor recognition

**Files:** `.all-contributorsrc`

**The problem:** Contributors are not systematically recognized. There's no way to celebrate non-code contributions (docs, design, testing, community).

**The fix:** Add the [all-contributors](https://allcontributors.org/) spec:
```json
// .all-contributorsrc
{
  "projectName": "PeTTa",
  "projectOwner": "patham9",
  "files": ["README.md"],
  "contributors": [
    {
      "login": "patham9",
      "contributions": ["code", "design", "ideas"]
    },
    {
      "login": "contributor-example",
      "contributions": ["code", "doc", "test"]
    }
  ]
}
```
Add a bot that automatically adds contributors when they merge a PR. Add a contributors section to README.md.

**Effort:** Trivial (add config, add bot).
**Impact:** Medium. Encourages contributions by recognizing them.

---

### 135. Stale issue / PR management

**Files:** `.github/stale.yml`

**The problem:** Issues and PRs pile up unanswered. Contributors lose motivation when their work is ignored for months.

**The fix:** Add a stale bot config:
```yaml
# .github/stale.yml
staleLabel: stale
daysUntilStale: 60
daysUntilClose: 14
exemptLabels:
  - pinned
  - security
  - roadmap
markComment: >
  This issue has been inactive for 60 days. 
  Please update if it's still relevant.
closeComment: >
  Closing due to inactivity. 
  Feel free to reopen if needed.
```

**Effort:** Trivial.
**Impact:** Medium. Keeps the issue tracker healthy.

---

### 136. SECURITY.md & responsible disclosure policy

**Files to create:** `SECURITY.md`

**The problem:** No way for security researchers to report vulnerabilities. No coordinated disclosure policy.

**The fix:**
```markdown
# Security Policy

## Supported Versions
| Version | Supported |
|---------|-----------|
| 1.0.x   | ✅        |
| < 1.0   | ❌        |

## Reporting a Vulnerability

Report vulnerabilities to security@petta.org (or GitHub private vulnerability reporting).
Do not file public issues for security vulnerabilities.

We aim to respond within 48 hours and patch within 7 days.
```

**Effort:** Trivial.
**Impact:** Low-Medium. Necessary for production use.

---

### 137. FUNDING.yml & sponsorship

**Files to create:** `.github/FUNDING.yml`

**The problem:** No way for supporters to contribute financially. No GitHub Sponsors, Open Collective, or Patreon.

**The fix:**
```yaml
# .github/FUNDING.yml
github: [patham9]
open_collective: petta
custom: ["https://paypal.me/patham9"]
```

**Effort:** Trivial.
**Impact:** Medium. Funds development.

---

## 📚 Data Structure Library

### 138. Priority queue / heap

**Files to create:** `lib/lib_heap.metta`

**The problem:** No built-in priority queue. Tasks that need ordered processing (Dijkstra, A*, scheduling) require manual sorting.

**The fix:**
```metta
; Create a min-heap
(= (heap:create) ())
(= (heap:push (3 "low") (1 "high") (2 "medium")) ...)
(= (heap:peek heap) (1 "high"))  ; peek at min
(= (heap:pop heap) ((1 "high") remaining-heap))
(= (heap:size heap) 2)
```
Implementation: store as a balanced binary tree or use SWI-Prolog's `library(heaps)`.

**Effort:** Low.
**Impact:** Medium. Foundation for graph algorithms and schedulers.

---

### 139. LRU cache with configurable eviction

**Files to create:** `lib/lib_cache_lru.metta`

**The problem:** The memoization cache (#59) has no eviction policy. It grows forever, consuming memory.

**The fix:** An LRU (least recently used) cache:
```metta
; Cache with max 1000 entries
(= (cache:create 1000) ...)
(= (cache:get cache key) ...)  ; returns value or ()
(= (cache:put! cache key value) ...)
(= (cache:delete! cache key) ...)
(= (cache:stats cache) {:hits 500 :misses 20 :evictions 50 :size 1000})
```
Implementation: doubly-linked list (for LRU ordering) + hash map (for O(1) lookup). TTL support optional.

**Effort:** Medium.
**Impact:** Medium. Prevents unbounded memory growth.

---

### 140. Trie / prefix tree (autocomplete, spellcheck)

**Files to create:** `lib/lib_trie.metta`

**The problem:** No efficient prefix-based search. Finding all functions starting with "get-" requires scanning every symbol.

**The fix:**
```metta
; Build a trie from a list of words
(= (trie:build ("cat" "car" "card" "dog" "door")) trie)

; Prefix search
(= (trie:prefix-search "ca" trie) ("cat" "car" "card"))

; Longest common prefix
(= (trie:longest-prefix "catalog" trie) "cat")

; Fuzzy search (Levenshtein distance)
(= (trie:fuzzy-search "car" 1 trie) ("car" "cat" "card"))
```

**Effort:** Medium.
**Impact:** Medium. Powers autocomplete, spellcheck, and symbol search.

---

### 141. Disjoint-set / union-find (for graph clustering)

**Files to create:** `lib/lib_union_find.metta`

**The problem:** No way to efficiently track connected components as edges are added. Naive graph traversal is O(n) per query.

**The fix:**
```metta
; Create a disjoint-set for 1000 elements
(= (uf:create 1000) uf)

; Union two elements
(= (uf:union! uf 5 12) uf')
(= (uf:union! uf' 12 20) uf'')

; Find the representative of an element
(= (uf:find uf'' 5) 5)   ; same set as 12 and 20
(= (uf:find uf'' 20) 5)  ; same representative

; Check if connected
(= (uf:connected? uf'' 5 20) true)
(= (uf:connected? uf'' 5 99) false)

; Count components
(= (uf:components uf'') 998)  ; reduced from 1000 by 3 unions
```
Implementation: path compression + union by rank for near-O(1) amortized operations.

**Effort:** Low.
**Impact:** Medium. Crucial for graph algorithms at scale.

---

## 🌍 Geospatial & Environment

### 142. Geospatial / GIS library

**Files to create:** `lib/lib_geo.pl`, `lib/lib_geo.metta`

**The problem:** No geographic or spatial operations. Users building location-aware agents or maps have no support.

**The fix:**
```metta
; Coordinate operations
(= (geo:distance 48.8566 2.3522 51.5074 -0.1278) 344.0)  ; km (Paris→London)
(= (geo:bounding-box 48.0 2.0 100.0) 
   {:min-lat 47.55 :max-lat 48.45 :min-lon 1.55 :max-lon 2.45})

; GeoJSON support
(= (geo:parse-geojson "{\"type\":\"Point\",\"coordinates\":[2.3522,48.8566]}")
   (geo:point 48.8566 2.3522))

; Spatial indexing (R-tree)
(= (geo:rtree-create points) rtree)
(= (geo:rtree-query rtree (geo:bounding-box ...)) nearby-points)

; Reverse geocode (optional, requires OpenStreetMap data)
(= (geo:reverse-geocode 48.8566 2.3522) "Paris, France")
```

**Effort:** Medium-High.
**Impact:** Medium. Opens location-aware AI applications.

---

### 143. Time zone / DST handling

**Files to create:** `lib/lib_timezone.metta`

**The problem:** No time zone support. The datetime library (#20) works in UTC only. Scheduling across time zones is impossible.

**The fix:** Wrap the IANA timezone database (tzdata):
```metta
(= (tz:list-zones) ...)            ; all ~600 zone names
(= (tz:offset "2025-01-15" "America/New_York") -5)
(= (tz:offset "2025-07-15" "America/New_York") -4)  ; DST
(= (tz:convert "2025-01-15T10:00:00" "America/New_York" "Asia/Tokyo") 
   "2025-01-16T00:00:00")  ; +14h
(= (tz:dst? "2025-07-15" "Europe/London") true)
(= (tz:next-change "2025-01-01" "Europe/Paris") "2025-03-30T01:00:00Z")
```
Implementation: SWI-Prolog's `library(tz)` or call the `tz` command-line tool. Ship a compact version of tzdata.

**Effort:** Low-Medium.
**Impact:** Medium. Essential for scheduling applications.

---

## 🎨 Creative & Media

### 144. Image processing library

**Files to create:** `lib/lib_image.pl`, `lib/lib_image.metta`

**The problem:** No image manipulation. Users building visual AI agents or generative art can't read, write, or transform images.

**The fix:** Wrap Python Pillow (PIL):
```metta
(= (image:load "photo.jpg") img)
(= (image:resize img 800 600) resized)
(= (image:crop img 100 100 300 300) cropped)
(= (image:grayscale img) bw)
(= (image:blur img 5) blurred)
(= (image:save img "output.png") ...)
(= (image:info img) {:width 1920 :height 1080 :format "JPEG"})

; Pixel-level access
(= (image:get-pixel img 100 200) (255 128 0))  ; RGB
(= (image:set-pixel! img 100 200 (0 255 0)) img')  ; set to green
```

**Effort:** Medium.
**Impact:** Medium. Enables computer vision and creative coding.

---

### 145. Turtle graphics / SVG generation

**Files to create:** `lib/lib_turtle.metta`

**The problem:** No way to generate vector graphics from MeTTa. No visual output beyond text.

**The fix:** A Logo-style turtle graphics library that emits SVG:
```metta
; Turtle graphics
(= (turtle:create) {:x 400 :y 300 :angle 0 :pen-down true :color "black"})

; Draw a square
(= (draw-square size)
   (turtle:do
     (turtle:forward size)
     (turtle:right 90)
     (turtle:forward size)
     (turtle:right 90)
     (turtle:forward size)
     (turtle:right 90)
     (turtle:forward size)))

; Export as SVG
(= (turtle:render (draw-square 100)) "<svg>...</svg>")
(= (turtle:save (draw-square 100) "square.svg") ...)
```
Recursive patterns (snowflakes, trees, fractals) are natural in MeTTa:
```metta
(= (snowflake size depth)
   (if (> depth 0)
     (turtle:do
       (snowflake (/ size 3) (- depth 1))
       (turtle:left 60)
       (snowflake (/ size 3) (- depth 1))
       (turtle:right 120)
       (snowflake (/ size 3) (- depth 1))
       (turtle:left 60)
       (snowflake (/ size 3) (- depth 1)))
     (turtle:forward size)))
```

**Effort:** Low-Medium.
**Impact:** Medium. Fun on-ramp for learning MeTTa + generates shareable visuals.

---

## 📱 User Interfaces

### 146. Terminal dashboard / TUI for space monitoring

**Files to create:** `python/petta_dashboard.py` or `src/tui.pl`

**The problem:** PeTTa's state is invisible. No way to see what atoms are in a space, how many there are, or what the system is doing in real time.

**The fix:** A terminal UI (using `textual` in Python or `library(browser)` in Prolog):
```
┌─────────────────────────────────────────────────────────┐
│  PeTTa Space Monitor                  [Ctrl+Q to quit]  │
├───────────────┬─────────────────────────────────────────┤
│  Spaces       │  Atoms in &self                        │
│  ───────────  │  ┌──────────────────────────────────┐  │
│  &self    1.5K│  │  (isa tweety bird)               │  │
│  &library  847│  │  (color tweety yellow)            │  │
│  &kb      12K │  │  (can-fly tweety)                 │  │
│  &temp     42 │  │  (rule (=> (bird ?x) (animal ?x)))│  │
│               │  │  (isa simba cat)                  │  │
│               │  │  ...                              │  │
├───────────────┴─────────────────────────────────────────┤
│  Activity Log                                            │
│  [14:32:01] Added (isa tweety bird) to &self             │
│  [14:32:01] Rule fired: (=> (bird ?x) (animal ?x))      │
│  [14:32:01] Inferred (isa tweety animal)                 │
│  [14:32:02] Connected to remote space at 10.0.0.1:9090  │
└─────────────────────────────────────────────────────────┘
```

**Effort:** Medium.
**Impact:** High. Makes PeTTa observable and debuggable.

---

### 147. Web-based REPL playground (try.petta.org)

**Files to create:** `web/playground/`

**The problem:** The only way to try MeTTa is to install SWI-Prolog + clone the repo. This kills curiosity-driven exploration.

**The fix:** A web-based REPL similar to [try.ocaml](https://try.ocaml.org) or [replit](https://replit.com):
```html
<!-- Static page that loads WASM build of PeTTa -->
<div id="editor">(= (greet name) (str $"Hello {name}!"))
!(greet "World")</div>
<div id="output">"Hello World!"</div>
<button onclick="run()">▶ Run</button>
```
Features:
- Code editor with syntax highlighting (CodeMirror/Monaco)
- Output panel with ANSI color rendering
- Share button (creates a URL with the encoded code)
- Example gallery (pre-loaded examples from the cookbook)
- Mobile responsive

**Effort:** High (depends on WASM build #54).
**Impact:** **Very High**. Removes the #1 adoption barrier.

---

### 148. PeTTa Desktop App (Electron/Tauri)

**Files to create:** `desktop/`

**The problem:** CLI is intimidating for non-developers. Researchers and domain experts want a GUI for exploring spaces, writing queries, and visualizing results.

**The fix:** A desktop application:
- **Backend**: PeTTa server running locally (REST API #57)
- **Frontend**: Electron (JS) or Tauri (Rust) providing:
  - Code editor with syntax highlighting
  - Space browser (tree/graph view of atoms)
  - Query panel (type a query, see results)
  - Library explorer (browse installed libraries)
  - Project manager (open/save .metta files)
  - Visual knowledge graph (#106)
  - Settings (theme, font size, API keys for LLM)

**Effort:** Very High.
**Impact:** High. Makes PeTTa accessible to non-CLI users.

---

## 🔬 Formal Methods & Verification

### 149. Assertion-based verification with SMT solvers

**Files to create:** `lib/lib_verify.metta`

**The problem:** No way to formally verify MeTTa programs. Tests only cover the tested cases. Bugs in edge cases (division by zero, overflow, off-by-one) slip through.

**The fix:** Integrate with Z3 or CVC5 SMT solver:
```metta
; Assert a property about a function
(: verify (-> Function Property) Result)
(= (verify (fn (x) (* x x)) 
           (forall (?x) (>= (fn ?x) 0)))
   :verified)

; Type-safe function with verification
(: safe-divide (-> Number Number Number))
(= (safe-divide n d)
   (assert-before! (!= d 0) "Division by zero")
   (assert-after! (finite? result) "Result overflow")
   (/ n d))
```

**Effort:** Very High.
**Impact:** Very High. Catches bugs no test can.

---

### 150. Model checking for reactive MeTTa programs

**Files to create:** `src/model_check.pl`, `lib/lib_model_check.metta`

**The problem:** Reactive programs (event-driven agents, forward-chaining rules) can have subtle bugs: infinite rule loops, contradictory conclusions, unreachable states. No way to verify temporal properties.

**The fix:** Model checking for MeTTa programs:
```metta
; Specify a property in linear temporal logic (LTL)
(= (model-check:property always-safe
   (always (=> (hazard-detected) (eventually safe-action))))

; Verify the program
(= (model-check:verify program property)
   :verified  ; or :counterexample with trace
   )
```
Implementation: translate MeTTa rules into a transition system. Use bounded model checking via SAT/SMT. For finite-state spaces, exhaustive exploration.

**Effort:** Very High.
**Impact:** Very High. Makes PeTTa suitable for safety-critical systems.

---

## How to Pick

| Your Goal | Start With |
|-----------|------------|
| **First contribution** | #1 (string lib), #3 (tests), #4 (docs) |
| **Quick win** | #13 (UUID), #14 (path traversal), #19 (metadata), #36 (cleanup), #42 (base64), #63 (file watcher), #65 (petta CLI), #85 (color), #89 (URL), #108 (Docker), #126 (docstrings), #134 (all-contributors), #135 (stale bot), #136 (SECURITY.md), #137 (FUNDING) |
| **Visible impact** | #1 (strings), #6 (test infra), #8 (JSON), #21 (error handling), #38 (HTTP), #74 (LLM), #76 (plot), #106 (viz), #108 (Docker), #124 (string interp), #146 (dashboard) |
| **Prolog practice** | #2 (math), #5 (file I/O), #7 (regex), #9 (random), #37 (hash), #39 (CSV), #84 (units), #86 (XML), #118 (indexing), #141 (union-find) |
| **Data science** | #40 (sort), #41 (stats), #43 (graph), #55 (Jupyter), #75 (Pandas), #76 (plot), #92 (matrix) |
| **AI / NLP** | #74 (LLM), #87 (NLP), #91 (probability), #93 (graph algos), #102 (temporal), #103 (TMS), #104 (causal), #105 (explain), #107 (forward-chain), #130 (common sense), #131 (analogy), #132 (dialogue) |
| **Language design** | #66 (macros), #67 (threading), #68 (destructuring), #69 (contracts), #111 (types), #113 (guards), #114 (multimethods), #123 (kwargs), #124 (interpolation) |
| **Spaces / knowledge** | #70 (snapshot), #71 (events), #72 (transactions), #73 (query lang), #98 (modules), #106 (viz), #107 (forward-chain), #127 (distributed), #129 (CRDT) |
| **Architecture** | #22 (leaks), #23 (translator), #28 (spaces), #61 (TCO), #62 (incremental load), #117 (bulk load), #118 (indexing), #149 (verification), #150 (model checking) |
| **CI / DevOps** | #26 (test infra), #27 (release), #33 (CI), #35 (onboarding), #49 (resource limits), #83 (bench dash), #108 (Docker), #109 (metrics), #135 (stale), #136 (security) |
| **Documentation** | #30 (language spec), #36 (cleanup), #48 (playground), #94 (ADRs), #95 (cookbook), #96 (FAQ), #97 (API docs), #125 (literate), #126 (docstrings) |
| **Developer Experience** | #44 (REPL), #45 (LSP), #46 (debugger), #47 (formatter), #63 (file watcher), #99 (stack traces), #100 (hot reload), #101 (profiler), #147 (web REPL), #148 (desktop app) |
| **Community** | #79 (templates), #80 (CoC), #81 (governance), #82 (roadmap), #134 (all-contributors), #137 (funding) |
| **Ecosystem** | #54 (WASM), #55 (Jupyter), #56 (package mgr), #57 (REST), #58 (persistence), #78 (game), #110 (binary), #127 (P2P), #128 (IPFS) |
| **Testing** | #51 (property), #52 (fuzz), #53 (mutation), #120 (MeTTa test runner), #122 (fuzz programs) |
| **Functional programming** | #59 (memoization), #60 (lazy streams), #61 (TCO), #67 (threading), #112 (coroutines) |
| **Self-hosting** | #119 (translator in MeTTa), #120 (test runner in MeTTa) |
| **Security** | #49 (resource limits), #50 (network access), #136 (SECURITY.md) |
| **Scale & Performance** | #117 (bulk loader), #118 (indexing), #121 (scale bench) |
| **Creative / Media** | #144 (images), #145 (turtle/SVG), #148 (desktop app) |
| **Geospatial** | #142 (geo), #143 (timezone) |
| **Data Structures** | #138 (heap), #139 (LRU), #140 (trie), #141 (union-find) |
| **Formal Methods** | #149 (SMT verification), #150 (model checking) |
| **Big challenge** | #11 (PLN/NARS), #15 (timeout), #23 (translator), #45 (LSP), #54 (WASM), #56 (package mgr), #74 (LLM), #78 (game), #102 (temporal), #103 (TMS), #104 (causal), #110 (binary), #111 (types), #115 (transpiler), #119 (self-host), #128 (IPFS), #131 (analogy), #133 (curiosity), #149 (verification), #150 (model checking) |

All **150 items** are documented with effort, impact, file paths, and concrete guidance above. Pick anything that interests you and I'll help implement it.

| Your Goal | Start With |
|-----------|------------|
| **First contribution** | #1 (string lib), #3 (tests), #4 (docs) |
| **Quick win** | #13 (UUID), #14 (path traversal), #19 (metadata), #36 (cleanup), #42 (base64), #63 (file watcher), #65 (petta CLI), #85 (color), #89 (URL), #108 (Docker) |
| **Visible impact** | #1 (strings), #6 (test infra), #8 (JSON), #21 (error handling), #38 (HTTP), #74 (LLM), #76 (plot), #106 (viz), #108 (Docker) |
| **Prolog practice** | #2 (math), #5 (file I/O), #7 (regex), #9 (random), #37 (hash), #39 (CSV), #84 (units), #86 (XML), #118 (indexing) |
| **Data science** | #40 (sort), #41 (stats), #43 (graph), #55 (Jupyter), #75 (Pandas), #76 (plot), #92 (matrix) |
| **AI / NLP** | #74 (LLM), #87 (NLP), #91 (probability), #93 (graph algos), #102 (temporal), #103 (TMS), #104 (causal), #105 (explain), #107 (forward-chain) |
| **Language design** | #66 (macros), #67 (threading), #68 (destructuring), #69 (contracts), #111 (types), #113 (guards), #114 (multimethods) |
| **Spaces / knowledge** | #70 (snapshot), #71 (events), #72 (transactions), #73 (query lang), #98 (modules), #106 (viz), #107 (forward-chain) |
| **Architecture** | #22 (leaks), #23 (translator), #28 (spaces), #61 (TCO), #62 (incremental load), #117 (bulk load), #118 (indexing) |
| **CI / DevOps** | #26 (test infra), #27 (release), #33 (CI), #35 (onboarding), #49 (resource limits), #83 (bench dash), #108 (Docker), #109 (metrics) |
| **Documentation** | #30 (language spec), #36 (cleanup), #48 (playground), #94 (ADRs), #95 (cookbook), #96 (FAQ), #97 (API docs) |
| **Developer Experience** | #44 (REPL), #45 (LSP), #46 (debugger), #47 (formatter), #63 (file watcher), #99 (stack traces), #100 (hot reload), #101 (profiler) |
| **Community** | #79 (templates), #80 (CoC), #81 (governance), #82 (roadmap) |
| **Ecosystem** | #54 (WASM), #55 (Jupyter), #56 (package mgr), #57 (REST), #58 (persistence), #78 (game), #110 (binary) |
| **Testing** | #51 (property), #52 (fuzz), #53 (mutation), #120 (MeTTa test runner), #122 (fuzz programs) |
| **Functional programming** | #59 (memoization), #60 (lazy streams), #61 (TCO), #67 (threading), #112 (coroutines) |
| **Self-hosting** | #119 (translator in MeTTa), #120 (test runner in MeTTa) |
| **Security** | #49 (resource limits), #50 (network access) |
| **Scale & Performance** | #117 (bulk loader), #118 (indexing), #121 (scale bench) |
| **Big challenge** | #11 (PLN/NARS), #15 (timeout), #23 (translator), #45 (LSP), #54 (WASM), #56 (package mgr), #74 (LLM), #78 (game), #102 (temporal), #103 (TMS), #104 (causal), #110 (binary), #111 (types), #115 (transpiler), #119 (self-host) |

All **122 items** are documented with effort, impact, file paths, and concrete guidance above. Pick anything that interests you and I'll help implement it.
