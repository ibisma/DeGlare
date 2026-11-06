# DeGlare

**Self-supervised specular highlight removal for industrial inspection**, together with
**MIR** — the Multi-Illumination Robotics dataset used to train and evaluate it.

<!-- TBD: fill in once the venue is final -->
> 📄 **Paper:** *TBD — title, authors, venue, year*
> 🔗 **Project page:** *TBD*
> 📦 **Dataset download:** see [Download](#download)

---

## Overview

Specular highlights on metallic machinery corrupt the appearance cues that downstream
vision systems rely on. Supervised highlight-removal methods need pixel-aligned diffuse
ground truth, which is impractical to acquire for a bespoke industrial subject.

DeGlare is a **lightweight self-supervised adaptation procedure**. A practitioner captures a
modest multi-illumination sequence of the target subject, trains without any true diffuse
labels, and obtains a **single-image** specular-removal model for that subject. Supervision
comes from an approximate diffuse image derived with the Weiss multi-illumination estimate,
combined with a self-supervised loss that suppresses the specular residual the Weiss
estimate leaves behind.

Key properties:

- **Single-image inference** — no multi-illumination sequence needed at test time.
- **No ground-truth diffuse labels** required for training.
- **~5× fewer parameters** and **~4× faster forward pass** than the competing supervised baseline.
- Trains from **~500 unlabelled images of a single scene**, versus thousands of labelled
  natural images for supervised pre-training.

## The MIR dataset

MIR captures a robotic rig under tightly varied illumination from several fixed viewpoints.
Three machine-vision cameras (`cam0`, `cam1`, `cam2`) were positioned around the rig. For
each static rig configuration, a series of images was recorded under randomised illumination
— varying lighting **direction**, **intensity**, and **colour temperature** — and the
procedure was repeated across multiple rig positions (`pos0`, `pos1`, `pos2`).

### Splits

The split is deliberately **cross-viewpoint and cross-pose**: every test image comes from a
camera *and* rig position never seen during training, so it measures generalisation rather
than memorisation.

| Split | Configuration | Images |
|---|---|---:|
| `training` | `cam0`, `pos0` | 500 |
| `test/test1` | `cam1`, `pos1` — unseen viewpoint & pose | 150 |
| `test/test2` | `cam2`, `pos2` — unseen viewpoint & pose | 150 |
| | **Total** | **800** |

### Composition

| Property | Value |
|---|---|
| Material | aluminium (~85%), plastic (~10%), glass (~5%) |
| Object geometry | cylinder, wheels, linear actuator |
| Surface colours | silver metallic, black |
| Lighting directions | > 50 |
| Image format | *TBD* |
| Resolution | *TBD* |

### Image statistics

Training images:

| Category | Channel | Mean | Median | Std. dev. |
|---|---|---:|---:|---:|
| Brightness | Luma (BT.601) | 96.1552 | 91.0000 | 60.1530 |
| RGB | R | 94.4153 | 89.0000 | 59.9795 |
| RGB | G | 96.8494 | 91.0000 | 60.5370 |
| RGB | B | 97.0629 | 90.0000 | 61.6318 |
| CIELAB | L\* | 39.7372 | 38.4314 | 24.6706 |
| CIELAB | a\* | -0.6315 | -1.0000 | 1.8263 |
| CIELAB | b\* | -0.3671 | 0.0000 | 7.1707 |

Test images:

| Category | Channel | Mean | Median | Std. dev. |
|---|---|---:|---:|---:|
| Brightness | Luma (BT.601) | 78.8282 | 68.0000 | 57.0741 |
| RGB | R | 52.4965 | 35.0000 | 55.4325 |
| RGB | G | 91.5273 | 84.0000 | 60.8320 |
| RGB | B | 82.7013 | 72.0000 | 58.9282 |
| CIELAB | L\* | 35.0069 | 32.5490 | 23.9905 |
| CIELAB | a\* | -14.8619 | -16.0000 | 12.5469 |
| CIELAB | b\* | 1.2607 | 2.0000 | 4.5156 |

The lower mean red channel and strongly negative `a*` in the test set reflect the different
illumination colour temperatures used at the held-out rig positions.

## Directory layout

```
dataset/
├── training/          # 500 input images — cam0, pos0
├── test/
│   ├── test1/         # 150 input images — cam1, pos1
│   └── test2/         # 150 input images — cam2, pos2
└── gt/                # diffuse references, filenames mirroring the inputs
    ├── training/      # approximate diffuse labels (Weiss estimate) used for training
    ├── test1/         # ground-truth diffuse references for evaluation
    └── test2/
```

Each file under `gt/` shares the basename of its corresponding input image, so an input and
its reference can be paired by filename alone.

> **Note on `gt/training`:** these are *approximate* diffuse images produced by the Weiss
> multi-illumination estimate, not true diffuse references. They still contain visible
> specular residual (see Fig. 3(b) in the paper) and are used as a practical proxy label.
> Only the test references should be treated as evaluation ground truth.

## Download

The image data is distributed via **GitHub Releases** rather than tracked in this
repository, which holds only the structure and documentation.

<!-- TBD: replace with the real release tag and asset names once uploaded -->
1. Go to the [Releases page](../../releases).
2. Download the dataset archive(s) from the latest release.
3. Extract into `dataset/`, preserving the layout above.

```bash
# TBD: update tag/filename after the first release is published
gh release download v1.0.0 --repo ibisma/DeGlare --pattern 'mir-*.zip'
unzip 'mir-*.zip' -d dataset/
```

## Results

Comparison against the Weiss multi-illumination estimate on the MIR test set:

| Method | Input at inference | PSNR ↑ | SSIM ↑ |
|---|---|---:|---:|
| Weiss | multi-image, static scene, fixed pose | 11.37 | **0.676** |
| **DeGlare (ours)** | **single image** | **14.22** | 0.620 |

Comparison against supervised baselines fine-tuned on the MIR training split (200 epochs,
learning rate 1e-4, initialised from published pre-trained weights):

| Method | PSNR ↑ | SSIM ↑ |
|---|---:|---:|
| Hu et al. | 11.16 | 0.52 |
| TSHRNet | 14.22 | **0.65** |
| **DeGlare (ours)** | **14.22** | 0.62 |

Downstream segmentation with SAM3 using a fixed text prompt, scored as IoU against manually
annotated masks on the MIR test set:

| Method | Average IoU ↑ |
|---|---:|
| Raw input | 0.1009 |
| TSHRNet | 0.0307 |
| Hu et al. | 0.1698 |
| **DeGlare (ours)** | **0.2255** |

DeGlare matches TSHRNet on PSNR while being substantially smaller, and gives the largest
improvement on the downstream task — the practical signal that matters for inspection.

## Citation

<!-- TBD: replace with the final published reference -->
```bibtex
@inproceedings{TBD,
  title     = {TBD},
  author    = {TBD},
  booktitle = {TBD},
  year      = {TBD}
}
```

## License

The MIR dataset is released under
[Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/).
See [LICENSE](LICENSE). You may share and adapt the data, including commercially, provided
you give appropriate credit by citing the paper above.

## Contact

<!-- TBD: confirm the address you want listed publicly -->
*TBD* — questions and issues are also welcome via the
[issue tracker](../../issues).
