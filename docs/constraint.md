CLP(FD) extension for PeTTa

This small extension exposes SWI-Prolog CLP(FD) solving to MeTTa via a Prolog backend.

API
- `(cp-solve VARS_STR CONSTRAINTS_STR)` — returns a single solution as a list of variable values. `VARS_STR` is a comma-separated string of variable names (e.g. "X,Y"). `CONSTRAINTS_STR` is a Prolog CLP(FD) constraint expression (e.g. "X in 1..9, Y in 1..9, X + Y #= 10").
- `(cp-enumerate VARS_STR CONSTRAINTS_STR LIMIT)` — returns up to `LIMIT` solutions as a list of value-lists.

Quick run

```bash
sh run.sh ./examples/constraint_example.metta
sh run.sh ./examples/constraint_test.metta
```
