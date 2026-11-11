---
paths:
  - "ml/**/*.py"
  - "rl/**/*.py"
---
# Python rules

- Use `uv` only (`uv add`, `uv run`, `uv sync`); never `pip install`. `ml/` is Python 3.12 + current PyTorch; `rl/` is Python 3.10.12 + torch 2.2 + mlagents. Do not mix their environments.
- Type hints on all function signatures. Format and lint with `ruff`.
- Small, testable functions; every module has pytest coverage for its pure logic.
- Anything random or data-generating takes a `seed` argument and is deterministic (seed `random`, `numpy` and `torch` explicitly).
- Never commit datasets, checkpoints, training runs or `.venv`.
- Look up current docs for uv, PyTorch and ML-Agents rather than relying on memory.
