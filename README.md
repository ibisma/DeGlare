# DeGlare: Self-Supervised Specular Removal for Industrial Metallic Surfaces via Multi-Illumination Priors

## Dataset Availability

The MIR dataset is available as a [GitHub Release (dataset-v1.0)](https://github.com/ibisma/DeGlare/releases/tag/dataset-v1.0). Images are not stored in the git tree.

**Quick download** (from the repo root; downloads, verifies the SHA-256 checksum and unpacks into `dataset/`):

```bash
bash scripts/download_dataset.sh
```

**Manual download:**

```bash
curl -L -O https://github.com/ibisma/DeGlare/releases/download/dataset-v1.0/MIR-dataset-v1.0.zip
curl -L -O https://github.com/ibisma/DeGlare/releases/download/dataset-v1.0/SHA256SUMS
shasum -a 256 -c SHA256SUMS
unzip MIR-dataset-v1.0.zip      # creates ./dataset
```

## The MIR Dataset Directory layout

Images are numbered sequentially (`0001.jpg`, `0002.jpg`, ...) within each folder.

```
dataset/
├── training/
│   └── train-val-split/
│       ├── train/     # 384 input images
│       └── val/       # 97 input images
├── test/
│   ├── test1/         # 150 input images
│   └── test2/         # 150 input images
└── gt/
    ├── training/      # 0001.png: approximate diffuse label (Weiss estimate) used for training
    ├── test1/
    │   ├── gt_test1.png        # ground-truth diffuse reference
    │   └── mask/
    │       ├── mask_img.png    # mask as image
    │       └── mask_numpy.npy  # mask as NumPy array
    └── test2/
        ├── gt_test2.png
        └── mask/
            ├── mask_img.png
            └── mask_numpy.npy
```

## License

The MIR dataset is released under
[Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/).


