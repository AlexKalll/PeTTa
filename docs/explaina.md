Explore this codebase thoroughly and give me a comprehensive analysis. I need to understand:
1. What is this project? (read README.md, setup.py, build.sh, run.sh)
2. What languages/technologies are used?
3. What is the directory structure - look at src/, lib/, python/, faiss_ffi/, mork_ffi/, repos/, docs/, examples/
4. What does the Rust code in src/ do? Look at src/main.rs or lib.rs if they exist. List all .rs files.
5. What's in python/ - look for Python packages, setup files
6. What are the C FFI bindings in faiss_ffi/ and mork_ffi/?
7. What does the lib/ directory contain?
8. What are the docs/ about?
9. What examples exist?
10. Check .github/ for CI config
Return a detailed summary of the project: its purpose, architecture, tech stack, and key components. Read key files to get the full picture.
+ Thought: 287ms
→ Read . 
✱ Glob "*" in . (100 matches)
✱ Glob "**/*" in . (100 matches)
+ Thought: 7ms
Let me now read the key files in parallel:
→ Read README.md 
→ Read setup.py 
→ Read build.sh 
→ Read run.sh 
→ Read test.sh 
→ Read .gitignore 
→ Read LICENSE 
→ Read MANIFEST.in 
+ Thought: 683ms
Now let me explore the source code and other directories:
→ Read src 
→ Read python 
→ Read lib 
→ Read docs 
→ Read examples 
→ Read faiss_ffi 
→ Read mork_ffi 
→ Read repos 
→ Read .github 
+ Thought: 33ms
Now let me read all the source files and key configuration:
→ Read src/main.pl 
→ Read src/metta.pl 
→ Read src/parser.pl 
→ Read src/spaces.pl 
→ Read src/specializer.pl 
→ Read src/translator.pl 
→ Read src/filereader.pl 
+ Thought: 785ms
Now let me read the remaining key directories and files:
→ Read python/__init__.py 
→ Read python/petta.py 
→ Read python/pyproject.toml 
→ Read python/helper.pl 
→ Read python/HE 
→ Read python/tests 
→ Read mork_ffi/README.md 
→ Read mork_ffi/Cargo.toml 
→ Read mork_ffi/mork.c 
→ Read mork_ffi/morkspaces.pl 
+ Thought: 314ms
Let me read the remaining files:
→ Read mork_ffi/src 
→ Read mork_ffi/build.sh 
→ Read faiss_ffi/README.md 
→ Read faiss_ffi/build.sh 
→ Read faiss_ffi/embed.pl 
→ Read faiss_ffi/faiss.pl 
→ Read faiss_ffi/faiss.cpp 
→ Read faiss_ffi/lib_faiss.metta 
→ Read faiss_ffi/install_faiss.sh 
+ Thought: 281ms
Let me read the remaining files:
→ Read mork_ffi/src/lib.rs 
→ Read .github/workflows/ci.yml 
→ Read .github/ci/Dockerfile 
→ Read docs/constraint.md 
→ Read docs/contiributing.md 
→ Read docs/SETUP_JOURNEY.md 
+ Thought: 421ms
Let me read a few example and library files to round out the picture:
→ Read examples/empty.metta 
→ Read examples/fib.metta 
→ Read examples/tests.metta [limit=50]
→ Read examples/he_types.metta 
→ Read lib/lib_import.metta 
→ Read lib/lib_he.metta [limit=60]
→ Read lib/lib_pln.metta [limit=60]
→ Read lib/lib_llm.metta 
→ Read lib/lib_llm.py 
→ Read lib/lib_nars.metta [limit=50]
+ Thought: 581ms
Let me look at a few more important files:
→ Read python/tests/test_petta.py 
→ Read python/tests/conftest.py 
→ Read python/tests/data 
→ Read python/HE/pettamorph.py [limit=30]
→ Read python/HE/hyperonexperimental.metta [limit=30]
→ Read python/uv.lock [limit=20]
→ Read mork_ffi/example_space.metta 
→ Read faiss_ffi/example.metta 
→ Read repos/test_metta_lib 
→ Read examples/git_import2.metta 
+ Thought: 517ms
Now let me check for the remaining library files and any other source code:
✱ Grep "\.rs$|\.c$|\.cpp$|\.h$|\.hpp$" in . (3 matches)
✱ Glob "**/*.rs" in . (1 match)
✱ Glob "**/*.pl" in src (7 matches)
→ Read lib/lib_vector.metta 
→ Read lib/lib_clpfd.metta 
→ Read lib/lib_clpfd.pl 
→ Read lib/lib_import.pl 
→ Read lib/lib_mm2.metta [limit=30]
→ Read lib/lib_spaces.metta 
+ Thought: 407ms
Now I have a thorough understanding of the entire codebase. Here is the comprehensive analysis:
Comprehensive Analysis of PeTTa
1. Project Identity & Purpose
PeTTa (Prolog-efficient MeTTa) is an implementation of the MeTTa programming language -- a symbolic AI/neuro-symbolic reasoning language -- written entirely in SWI-Prolog. The project's tagline is "Efficient MeTTa language implementation in Prolog."
It is authored by Patrick Hammer (copyright 2025, MIT licensed) and is part of the broader OpenCog/Hyperon ecosystem. It is designed to be a fast, lightweight alternative to other MeTTa implementations (like the Python-based hyperon-experimental) by leveraging Prolog's efficient backtracking, term rewriting, and built-in indexing.
Key files read:
/mnt/data-disk/ai2cup/.config/PeTTa/README.md
/mnt/data-disk/ai2cup/.config/PeTTa/LICENSE (MIT)
/mnt/data-disk/ai2cup/.config/PeTTa/setup.py
/mnt/data-disk/ai2cup/.config/PeTTa/build.sh
/mnt/data-disk/ai2cup/.config/PeTTa/run.sh
2. Languages & Technologies
Technology	Role
SWI-Prolog (>= 9.3.x)	Core runtime -- the entire MeTTa interpreter/compiler is written in Prolog
Python 3.x	Python interop via janus-swi; the python/ package wraps PeTTa for Python consumers; also used for LLM calling
Rust	mork_ffi/ -- high-performance in-memory atomspace (backed by the MORK reasoning kernel)
C++	faiss_ffi/ -- FAISS-accelerated vector similarity search for atom-vector spaces
C	Glue layer between SWI-Prolog foreign language interface and Rust/C++ native libraries
Shell (sh)	Build scripts, test runner (test.sh), and Docker CI
Docker	CI pipeline builds a swipl:latest-based image
GitHub Actions	CI workflow (PR checks, image build/publish)
3. Directory Structure
/mnt/data-disk/ai2cup/.config/PeTTa/
|-- src/                   # Core MeTTa compiler/interpreter (Prolog)
|-- python/                # Python wrapper package (PyPeTTa)
|-- lib/                   # MeTTa standard library files (.metta, .pl, .py)
|-- mork_ffi/              # MORK atomspace FFI (Rust + C glue)
|-- faiss_ffi/             # FAISS vector-space FFI (C++ + Prolog)
|-- examples/              # 154+ example .metta files
|-- docs/                  # Documentation (constraint, contributing, setup)
|-- repos/                 # Locally cloned git repos for import
|-- .github/               # CI workflow + Dockerfile
|-- build.sh               # Build script for native extensions
|-- run.sh                 # Entry point script to run MeTTa files
|-- test.sh                # Parallel test runner for all examples
|-- setup.py               # Python package setup
|-- MANIFEST.in            # Python packaging manifest
|-- .gitignore
|-- LICENSE                # MIT
|-- README.md
4. Rust Source Code (mork_ffi/src/)
There is exactly one Rust file: /mnt/data-disk/ai2cup/.config/PeTTa/mork_ffi/src/lib.rs
All .rs files:
/mnt/data-disk/ai2cup/.config/PeTTa/mork_ffi/src/lib.rs
This Rust library implements a high-performance in-memory atomspace (knowledge store) backed by the MORK (https://github.com/trueagi-io/mork) reasoning kernel. It exposes a C FFI with these operations:
rust_mork(command, input) -- dispatches commands:
"add-atoms" -- add S-expressions to the space
"remove-atoms" -- remove S-expressions
"mm2-exec" -- execute N steps of the MeTTa-Metaculus-2 calculus
"get-atoms" -- dump all atoms
"match" -- pattern-match queries against the space
rust_string_free(ptr) -- free strings allocated by Rust
It uses a global Mutex<Space> singleton with a thread-local output buffer.
The Cargo.toml at /mnt/data-disk/ai2cup/.config/PeTTa/mork_ffi/Cargo.toml declares:
Dependencies: mork-frontend, mork-expr, mork (all local paths)
Crate type: cdylib (produces libmork_ffi.so)
The C glue at /mnt/data-disk/ai2cup/.config/PeTTa/mork_ffi/mork.c registers a SWI-Prolog foreign predicate mork/3 that calls rust_mork.
5. Python Package (python/)
Location: /mnt/data-disk/ai2cup/.config/PeTTa/python/
Files:
__init__.py -- makes it a package
petta.py -- PeTTa class: the Python API
pyproject.toml -- dependencies: janus-swi>=1.5.2, pytest
helper.pl -- Prolog helper predicates for the Python bridge
uv.lock -- lock file for uv package manager
HE/ -- Hyperon-Experimental compatibility layer
hyperonexperimental.metta -- MeTTa using petta function from Python bridge
compileme.metta
pettamorph.py -- A PatternOperation wrapper that allows Hyperon-Experimental Python code to call PeTTa as a backend
tests/ -- Python test suite
test_petta.py -- 3 tests (file loading, string processing, var output)
conftest.py -- pytest fixtures
data/dummy.metta, data/dummy2.metta -- test data
The PeTTa class (in petta.py) provides:
__init__(verbose, petta_path) -- consults src/main.pl and python/helper.pl into SWI-Prolog via janus_swi
load_metta_file(file_path) -- loads a .metta file and returns results
process_metta_string(metta_code) -- evaluates a MeTTa string
setup.py at the root packages this as pip install petta, depending on janus-swi.
6. C FFI Bindings
faiss_ffi/ (C++ + Prolog)
Location: /mnt/data-disk/ai2cup/.config/PeTTa/faiss_ffi/
Provides FAISS-powered atom-tagged vector spaces for similarity search over symbolic atoms.
Files:
faiss.cpp -- C++ foreign predicates registered with SWI-Prolog:
faiss_create_c(Dim, Index) -- create a FlatL2 + IDMap2 index
faiss_free_c(Index) -- free
faiss_add_with_ids_c(Index, Flat, Ids) -- add vectors
faiss_remove_ids_c(Index, Ids) -- remove by ID
faiss_search_c(Index, Query, K, Result) -- k-NN search returning result(Dists, Ids)
faiss.pl -- Prolog module wrapping the C foreign predicates with state management (atom-ID mapping, rebuild support)
embed.pl -- Structural symbolic embedding: converts arbitrary nested Prolog terms into random projection vectors (for "cheap structural random indexing")
lib_faiss.metta -- MeTTa library exposing:
new-atom-vectorspace, add-atom-vector, add-atom-SRI (structural random indexing)
match-k, match-SRI (similarity search)
install_faiss.sh -- installs FAISS from source (CPU-only, static library)
build.sh -- compiles faiss.cpp into faisslib.so linking against libfaiss.a
mork_ffi/ (Rust + C + Prolog)
Location: /mnt/data-disk/ai2cup/.config/PeTTa/mork_ffi/
Provides MORK-backed atomspaces for large-scale persistent atom storage.
Files:
Cargo.toml -- Rust project (crate-type: cdylib)
src/lib.rs -- Rust implementation (see section 4)
mork.c -- C glue, registers mork/3 foreign predicate in SWI-Prolog
morklib.so -- pre-built C shared library (compiled from mork.c)
morkspaces.pl -- Prolog module bridging MeTTa space operations to the MORK foreign predicate:
'add-atom'('&mork', ...) -- delegates to mork("add-atoms", ...)
'remove-atom'('&mork', ...) -- delegates to mork("remove-atoms", ...)
match('&mork', ...) -- delegates to mork("match", ...)
'get-atoms'('&mork', ...) -- delegates to mork("get-atoms", ...)
'mm2-exec'('&mork', ...) -- delegates to mork("mm2-exec", ...)
example_space.metta -- benchmarks comparing MORK vs Prolog predicate store
build.sh -- builds Rust library then C wrapper
7. Prolog Source Code (src/)
7 Prolog files form the core MeTTa compiler/interpreter:
File	Lines	Purpose
main.pl	23	Entry point: parses args, loads MeTTa file, runs code
metta.pl	317	Standard library: arithmetic, logic, lists, types, Python interop (janus), state, eval, higher-order functions, import
parser.pl	59	S-expression parser (sread) and pretty-printer (swrite) using DCG
translator.pl	432	Core compiler: translates MeTTa S-expressions into Prolog goal lists. Handles all special forms (if, case, let, superpose, collapse, match, quote, eval, foldall, forall, lambda, progn, etc.)
spaces.pl	69	Default Prolog-based atomspace implementation using dynamic predicates (add-atom, remove-atom, match, get-atoms)
specializer.pl	109	Higher-order specialization engine -- creates specialized versions of functions at compile time when higher-order arguments are known
filereader.pl	78	File loading: reads .metta files, tokenizes balanced S-expressions, handles comments (;), and processes forms as function definitions or runnable expressions (!)
Architecture: The translator (translator.pl) compiles MeTTa code into Prolog goals at load time. The reduce/2 predicate performs runtime dispatch. Functions are compiled into Prolog clauses via translate_clause/2. The specialization engine creates monomorphized copies of higher-order functions.
8. Library Directory (lib/)
20 files comprising the MeTTa standard library:
File	Type	Purpose
lib_builtin_types.metta	MeTTa	Built-in type definitions
lib_clpfd.metta	MeTTa	Constraint Logic Programming (CLP(FD)) wrapper
lib_clpfd.pl	Prolog	cp_solve, cp_enumerate -- CLP(FD) solver interface
lib_combinatorics.metta	MeTTa	Combinatorics functions
lib_datastructures.metta	MeTTa	Data structure operations
lib_he.metta	MeTTa	Hyperon-Experimental compatibility library (unify, assertEqual, type-cast, etc.)
lib_import.metta	MeTTa	Import system: import_prolog_functions_from_file, import_prolog_functions_from_module
lib_import.pl	Prolog	Git import, static import (.metta to .pl to .qlf compilation), module loading
lib_llm.metta	MeTTa	LLM integration: useGPT, useOpenRouter, useGPTEmbedding
lib_llm.py	Python	openrouter_chat, openrouter_embed -- direct HTTP calls to OpenRouter
lib_mm2.metta	MeTTa	MM2 calculus operators (+, -, ?, ~>) for MORK space
lib_nars.metta	MeTTa	NARS (Non-Axiomatic Reasoning System) truth functions (Deduction, Abduction, Induction, etc.)
lib_patrick.metta	MeTTa	Patrick Hammer's utilities
lib_pln.metta	MeTTa	Probabilistic Logic Networks -- extended reasoning rules
lib_roman.metta	MeTTa	Roman numeral utilities
lib_spaces.metta	MeTTa	Space operations: migrateAtoms, find, succeedsPredicate, remove-all-atoms, match-count
lib_tabling.metta	MeTTa	Tabling/memoization utilities
lib_vector.metta	MeTTa	Vector math: dot, cosine, norm, random-normal-vector
lib_zar.metta	MeTTa	ZAR (a reasoning system) rules
lib_zar.pl	Prolog	ZAR Prolog backend
9. Documentation (docs/)
constraint.md -- Documents the CLP(FD) extension (cp-solve, cp-enumerate)
contiributing.md -- A conversation/scratchpad log (not traditional docs); documents PR work on type-cast and PLN confidence
SETUP_JOURNEY.md -- Very detailed end-to-end setup guide for WSL/Linux, covering SWI-Prolog 9.3.36 compilation from source, Python venv setup, header symlink fixes, and daily workflow
10. Examples (examples/)
154+ .metta example files covering virtually every language feature:
Categories and notable examples:
Core language: empty.metta, eval.metta, lambda.metta, let.metta, if.metta, case.metta, quote.metta
Recursion/fibonacci: fib.metta, fibsmart.metta, fibsmartimport.metta, fibadd.metta
Spaces: spaces.metta, spaces2.metta, spaces3.metta, spaces_find.metta
Types: types.metta, types_dependent.metta, types_nondet.metta, parametric_types.metta, recursive_types.metta, meta_types.metta, functiontypes.metta
NARS reasoning: nars_direct.metta, nars_tuffy.metta
PLN reasoning: pln_direct.metta, pln_roman.metta, pln_tuffy.metta, plntest.metta
Hyperon-Experimental compat: he_atomspace.metta, he_minimalmetta.metta, he_types.metta, he_quoting.metta, he_assert.metta
Mathematics: math.metta, peano.metta, peanofast.metta, invertfunction.metta, invertpeanoplus.metta
Constraint solving: constraint_example.metta, constraint_test.metta
Specialization: specialize.metta, specializecyclic.metta, specializefunctiontypes.metta
Prolog interop: translatepredicate.metta, prologimport.metta
Python interop: python.metta, python_import.metta
LLM: llm_cities.metta
Torch: torch.metta
Git import: git_import.metta, git_import2.metta
State/mutex: state.metta, mutex_and_transaction.metta
Permutations/superpose: permutations.metta, superpose_primes.metta, hyperpose_primes.metta
Metta4: metta4_prog.metta, metta4_streams.metta
Benchmarks: scale.metta, holbenchmark.metta
11. CI Configuration (.github/)
Workflow: /mnt/data-disk/ai2cup/.config/PeTTa/.github/workflows/ci.yml
A multi-stage GitHub Actions pipeline:
Detect changes -- checks if Dockerfile changed
Build image -- builds ghcr.io/patham9/petta-ci Docker image (only on PRs if Dockerfile changed; always on push to main)
Resolve image -- picks either the PR-specific image or :latest
Test -- runs inside the container:
- Checkout code
- Set up Python (from pyproject.toml)
- Install UV and dependencies (uv sync --locked)
- Run uv run pytest tests/ (Python tests)
- Run sh test.sh (shell test runner for all examples)
Publish latest -- on push to main, rebuilds and pushes :latest
Dockerfile: /mnt/data-disk/ai2cup/.config/PeTTa/.github/ci/Dockerfile
Based on swipl:latest with build-essential, python3-dev, and git added.
12. Summary: Architecture & How It All Fits Together
  .metta file      Python script
      |                 |
      v                 v
  [run.sh]        [petta.py / janus-swi]
      |                 |
      +-----> SWI-Prolog runtime <-----+
                  |
         +--------+--------+
         |        |        |
    [src/]    [lib/]    [mork_ffi/]  [faiss_ffi/]
    Prolog    MeTTa    Rust+MORK     C+++FAISS
    compiler  standard  atomspace    vector-space
    & runtime library  (scalable)   (similarity search)
Entry: run.sh launches SWI-Prolog with src/main.pl, optionally preloading libmork_ffi.so via LD_PRELOAD.
Loading: main.pl calls load_metta_file/2 which reads a .metta file, tokenizes it (parser.pl), and processes forms (filereader.pl).
Compilation: Function definitions ((= ...)) are translated by translator.pl into Prolog clauses. The specializer (specializer.pl) creates optimized monomorphic copies when higher-order variables are known.
Execution: Runnable expressions (!(...)) are evaluated immediately. The reduce/2 predicate dispatches calls to registered Prolog predicates.
Atomspaces: Three implementations:
- Prolog predicates (spaces.pl) -- default, fast for moderate sizes
- MORK (mork_ffi/) -- Rust-backed, scales to billions of atoms
- FAISS (faiss_ffi/) -- vector similarity search over embedded atoms
Python Bridge: The python/petta.py module uses janus-swi to embed SWI-Prolog in Python, exposing load_metta_file() and process_metta_string().
LLM Integration: lib_llm.metta + lib_llm.py allow MeTTa code to call OpenAI/OpenRouter APIs.
Reasoning Libraries: NARS truth functions (lib_nars.metta), PLN rules (lib_pln.metta), and CLP(FD) constraint solving (lib_clpfd.metta + .pl).
Git Import: Libraries can be fetched directly from GitHub repos at runtime (git-import! in lib_import.pl).
Testing: All 154+ examples are run via test.sh in parallel, checking test assertions with the checkmark/cross output.
Key design insight: PeTTa is not an interpreter -- it is a compiler from MeTTa to Prolog. MeTTa functions are translated to Prolog clauses at load time, and the Prolog engine (with its efficient term indexing, backtracking, and built-in search) becomes the MeTTa runtime. This gives PeTTa significant performance advantages over tree-walking interpreters.