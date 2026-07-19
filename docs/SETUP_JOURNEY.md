# PeTTa Setup Journey (WSL/Linux, End-to-End)

This document captures the full setup path used to get PeTTa running reliably in this environment, including failures, fixes, and final stable workflow.

## 1) Goal

Set up PeTTa so it can run examples and install Python interop (`janus-swi`) using:

- SWI-Prolog version >= 9.3.x
- Shared virtual environment: `/mnt/data-disk/ai2cup/.config/venvwsl`
- No repeated `PATH=...` prefix every time

## 2) Environment constraints discovered

- Ubuntu apt default SWI version on this machine was too old (`8.4.2`).
- `janus-swi` requires newer SWI (>= 9.1.12; target here was 9.3.x).
- `/home` was storage-constrained, causing instability for snap-based runtime state.
- `/mnt/data-disk` had enough free space and is better for builds and shared tooling.

## 3) Why apt/snap were not used as final solution

### Apt path

System package version was below requirement, so `janus-swi` wheel build failed.

### Snap path

Candidate channel had newer SWI, but this environment had practical issues tied to home directory usage and runtime state. Result: unstable/noisy workflow.

### Final decision

Build SWI-Prolog from source into `/mnt/data-disk` and make it first on `PATH`.

## 4) Final directory plan

- SWI source: `/mnt/data-disk/swipl-src/swipl-devel`
- SWI install prefix: `/mnt/data-disk/swipl-9.3.36`
- Shared venv: `/mnt/data-disk/ai2cup/.config/venvwsl`
- Project root: `/mnt/data-disk/ai2cup/.config/PeTTa`

## 5) Build dependencies (system)

Install required packages:

```bash
sudo apt-get update
sudo apt-get install -y \
	git cmake ninja-build pkg-config gcc g++ \
	libgmp-dev libreadline-dev libssl-dev zlib1g-dev \
	libncurses-dev libedit-dev libpcre2-dev libarchive-dev \
	uuid-dev libx11-dev libxext-dev libice-dev libxinerama-dev \
	libxft-dev libjpeg-dev libyaml-dev unixodbc-dev
```

Notes:

- `sudo` is required for apt installs.
- For everything under `/mnt/data-disk`, prefer user-owned directories to reduce repeated `sudo` use.

## 6) Clone SWI-Prolog 9.3.x source

```bash
sudo mkdir -p /mnt/data-disk/swipl-src
sudo chown -R "$USER":"$USER" /mnt/data-disk/swipl-src

git clone --recursive --branch V9.3.36 \
	https://github.com/SWI-Prolog/swipl-devel.git \
	/mnt/data-disk/swipl-src/swipl-devel
```

If you need to re-create the clone cleanly:

```bash
rm -rf /mnt/data-disk/swipl-src/swipl-devel
git clone --recursive --branch V9.3.36 \
	https://github.com/SWI-Prolog/swipl-devel.git \
	/mnt/data-disk/swipl-src/swipl-devel
```

## 7) Build and install SWI-Prolog to /mnt/data-disk

```bash
cd /mnt/data-disk/swipl-src/swipl-devel
mkdir -p build
cd build

cmake -G Ninja -DCMAKE_INSTALL_PREFIX=/mnt/data-disk/swipl-9.3.36 ..
ninja -j2
ninja install
```

If `ninja install` needs elevated permissions (it should not, if owned by user), use:

```bash
sudo ninja install
```

Version check:

```bash
/mnt/data-disk/swipl-9.3.36/src/swipl --version
```

Expected format:

```text
SWI-Prolog version 9.3.36 for x86_64-linux
```

## 8) Critical fix: broken SWI header symlink issue

Symptom during `pip install -e .`:

```text
fatal error: SWI-Prolog.h: No such file or directory
```

Root cause observed:

- `SWI-Prolog.h` under install prefix (`.../home/include`) was a symlink into source tree.
- If `/mnt/data-disk/swipl-src/swipl-devel` is missing, that header symlink breaks.

Fix:

1. Recreate source checkout at the exact expected path.
2. Ensure it contains `src/SWI-Prolog.h`.

Quick check:

```bash
ls -l /mnt/data-disk/swipl-9.3.36/home/include/SWI-Prolog.h
head -n 3 /mnt/data-disk/swipl-src/swipl-devel/src/SWI-Prolog.h
```

## 9) Persistent shell config (no more PATH prefix)

Add to `~/.bashrc`:

```bash
if [ -d /mnt/data-disk/swipl-9.3.36/src ]; then
		export SWIPL_HOME=/mnt/data-disk/swipl-9.3.36
		case ":$PATH:" in
				*":/mnt/data-disk/swipl-9.3.36/src:"*) ;;
				*) export PATH="/mnt/data-disk/swipl-9.3.36/src:$PATH" ;;
		esac
fi
```

Reload:

```bash
source ~/.bashrc
```

Verify:

```bash
command -v swipl
swipl --version
```

## 10) Shared virtual environment setup

Create once:

```bash
python3 -m venv /mnt/data-disk/ai2cup/.config/venvwsl
```

Activate when needed:

```bash
source /mnt/data-disk/ai2cup/.config/venvwsl/bin/activate
```

Install project editable:

```bash
cd /mnt/data-disk/ai2cup/.config/PeTTa
python -m pip install -U pip setuptools wheel
python -m pip install -e .
```

Import test:

```bash
python -c "import petta, janus_swi; print('imports-ok')"
```

## 11) Run PeTTa examples

With `~/.bashrc` loaded and venv activated:

```bash
cd /mnt/data-disk/ai2cup/.config/PeTTa
sh run.sh ./examples/empty.metta
```

Example success output includes:

```text
is (), should (). ✅
true
```

## 12) Optional native extensions (MORK/FAISS)

`build.sh` may require extra native prerequisites (for example `cargo`, `pkg-config`, FAISS headers). If needed:

```bash
sudo apt-get install -y cargo pkg-config
```

Then:

```bash
cd /mnt/data-disk/ai2cup/.config/PeTTa
sh build.sh
```

If FAISS headers are missing, install the corresponding development package for your distro.

## 13) What was cleaned up

- Removed redundant project-local shell file `.bashrc` from project root.
- Kept global shell config in `~/.bashrc` as the single source for SWI `PATH` export.
- Removed `setup_venv.sh` because manual, explicit venv activation is now straightforward.

## 14) Daily workflow (final)

Open a terminal and run:

```bash
source ~/.bashrc
source /mnt/data-disk/ai2cup/.config/venvwsl/bin/activate
cd /mnt/data-disk/ai2cup/.config/PeTTa
sh run.sh ./examples/empty.metta
```

That is the stable baseline.

## 15) Minimal troubleshooting checklist

If `swipl` is not found:

```bash
source ~/.bashrc
command -v swipl
```

If `janus-swi` fails to compile with missing header:

```bash
ls -l /mnt/data-disk/swipl-9.3.36/home/include/SWI-Prolog.h
test -f /mnt/data-disk/swipl-src/swipl-devel/src/SWI-Prolog.h && echo OK
```

If editable install fails, retry in clean venv context:

```bash
source /mnt/data-disk/ai2cup/.config/venvwsl/bin/activate
cd /mnt/data-disk/ai2cup/.config/PeTTa
python -m pip install -U pip setuptools wheel
python -m pip install -e .
```

If runtime still differs between shells, ensure shell startup actually loads `~/.bashrc` (interactive bash).
