from __future__ import annotations

import sys

import pytest
import torch

from dronesim_ml import get_device, seeded_generator


def test_seeded_generator_is_deterministic() -> None:
    a = torch.randn(8, generator=seeded_generator(42))
    b = torch.randn(8, generator=seeded_generator(42))
    c = torch.randn(8, generator=seeded_generator(43))
    assert torch.equal(a, b)
    assert not torch.equal(a, c)


def test_tiny_matmul_on_best_device() -> None:
    dev = get_device()
    x = torch.ones(4, 4, device=dev)
    y = (x @ x).cpu()
    assert torch.allclose(y, torch.full((4, 4), 4.0))


@pytest.mark.skipif(sys.platform != "darwin", reason="MPS is macOS only")
def test_mps_available_on_mac() -> None:
    assert torch.backends.mps.is_available()
