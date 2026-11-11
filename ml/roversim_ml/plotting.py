"""Headless plotting helpers for the Phase 2 exercises.

Uses matplotlib's object API (no pyplot), so no GUI backend is needed and no global state
is touched. Scaffolding only: the exercises that produce the data are written by the user.
"""

from __future__ import annotations

from pathlib import Path

import numpy as np
from matplotlib.backends.backend_agg import FigureCanvasAgg
from matplotlib.figure import Figure


def save_step_response(
    path: str | Path,
    t: np.ndarray,
    y: np.ndarray,
    *,
    setpoint: float | None = None,
    title: str = "",
    ylabel: str = "",
) -> Path:
    """Save a time-vs-response plot as a PNG and return its path.

    Parent directories are created. The same inputs give identical bytes (no timestamps in
    the metadata), so plots can be diffed and committed.
    """
    out = Path(path)
    out.parent.mkdir(parents=True, exist_ok=True)

    fig = Figure(figsize=(6.0, 3.6), dpi=120)
    FigureCanvasAgg(fig)
    ax = fig.add_subplot(1, 1, 1)
    ax.plot(t, y, label="response")
    if setpoint is not None:
        ax.axhline(setpoint, color="tab:red", linestyle="--", linewidth=1.0, label="setpoint")
    ax.set_xlabel("time [s]")
    ax.set_ylabel(ylabel)
    ax.set_title(title)
    ax.grid(True, alpha=0.3)
    ax.legend()
    fig.tight_layout()
    fig.savefig(out, format="png", metadata={"Software": None})
    return out
