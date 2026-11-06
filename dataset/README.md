# MIR dataset

This directory holds the Multi-Illumination Robotics (MIR) dataset. The image files are
**not tracked in git** — they are distributed via
[GitHub Releases](../../../releases) and extracted here. Only this documentation and the
directory structure are versioned.

## Expected layout

```
dataset/
├── training/          # 500 input images — cam0, pos0
├── test/
│   ├── test1/         # 150 input images — cam1, pos1
│   └── test2/         # 150 input images — cam2, pos2
└── gt/
    ├── training/      # approximate diffuse labels (Weiss estimate)
    ├── test1/         # ground-truth diffuse references
    └── test2/
```

Inputs and references are paired **by filename**: `gt/test1/<name>` is the diffuse
reference for `test/test1/<name>`.

## Splits

| Split | Camera | Rig position | Images | Role |
|---|---|---|---:|---|
| `training` | `cam0` | `pos0` | 500 | self-supervised training |
| `test/test1` | `cam1` | `pos1` | 150 | unseen viewpoint & pose |
| `test/test2` | `cam2` | `pos2` | 150 | unseen viewpoint & pose |

Training and test configurations are disjoint in both camera and rig position, so the test
splits measure generalisation to novel viewpoints and rig orientations.

## Labels

`gt/training` contains **approximate** diffuse images from the Weiss multi-illumination
estimate, used as a proxy label because true cross-polarised diffuse references are
impractical to capture at scale. They retain some specular residual and should not be used
as evaluation ground truth.

`gt/test1` and `gt/test2` are the diffuse references used for quantitative evaluation
(PSNR / SSIM).

Specular maps, where a method requires them for supervision, are derived from the additive
image formation model `S = I - D`, with `I` the input and `D` the diffuse reference.

## Verifying a download

<!-- TBD: publish checksums alongside the release assets, then document the command here -->
After extracting, check the file counts:

```bash
find dataset/training -type f | wc -l    # expect 500
find dataset/test/test1 -type f | wc -l  # expect 150
find dataset/test/test2 -type f | wc -l  # expect 150
```

See the [root README](../README.md) for composition statistics, results, licensing, and
citation details.
