from __future__ import annotations

from pathlib import Path

import numpy as np

from dronesim_ml.plotting import save_step_response

PNG_MAGIC = b"\x89PNG\r\n\x1a\n"


def _response() -> tuple[np.ndarray, np.ndarray]:
    t = np.linspace(0.0, 2.0, 201)
    return t, 1.0 - np.exp(-3.0 * t)


def test_writes_png_and_creates_parent_dirs(tmp_path: Path) -> None:
    t, y = _response()
    out = tmp_path / "plots" / "nested" / "step.png"
    result = save_step_response(out, t, y, setpoint=1.0, title="step", ylabel="altitude [m]")
    assert result == out
    assert out.read_bytes().startswith(PNG_MAGIC)


def test_setpoint_is_optional(tmp_path: Path) -> None:
    t, y = _response()
    out = save_step_response(tmp_path / "step.png", t, y)
    assert out.stat().st_size > 0


def test_same_input_gives_same_bytes(tmp_path: Path) -> None:
    t, y = _response()
    a = save_step_response(tmp_path / "a.png", t, y, setpoint=1.0)
    b = save_step_response(tmp_path / "b.png", t, y, setpoint=1.0)
    assert a.read_bytes() == b.read_bytes()
