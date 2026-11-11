from __future__ import annotations

from importlib.metadata import version

import torch


def test_pinned_versions() -> None:
    # D-005/D-011: mlagents 1.1.0 pairs with Unity package com.unity.ml-agents 4.1.0.
    assert version("mlagents") == "1.1.0"
    assert version("mlagents-envs") == "1.1.0"
    assert torch.__version__.startswith("2.2.")


def test_mlagents_imports() -> None:
    import mlagents.trainers  # noqa: F401
    import mlagents_envs.environment  # noqa: F401


def test_seeded_torch_is_deterministic() -> None:
    gen = torch.Generator().manual_seed(7)
    a = torch.randn(4, generator=gen)
    b = torch.randn(4, generator=torch.Generator().manual_seed(7))
    assert torch.equal(a, b)
