"""Simulator ML package (plotting helpers now; detector and datasets in Phase 5)."""

from __future__ import annotations

import torch


def get_device() -> torch.device:
    """Best available device: MPS, then CUDA, then CPU."""
    if torch.backends.mps.is_available():
        return torch.device("mps")
    if torch.cuda.is_available():
        return torch.device("cuda")
    return torch.device("cpu")


def seeded_generator(seed: int) -> torch.Generator:
    """CPU generator seeded explicitly; pass it to every random call."""
    gen = torch.Generator(device="cpu")
    gen.manual_seed(seed)
    return gen
