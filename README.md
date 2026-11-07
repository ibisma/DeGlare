# DeGlare: Self-Supervised Specular Removal for Industrial Metallic Surfaces via Multi-Illumination Priors

## Dataset Availability: The MIR dataset is coming soon

## The MIR Dataset Directory layout

```
dataset/
├── training/          # input images — cam0, pos0
├── test/
│   ├── test1/         # 150 input images — cam1, pos1
│   └── test2/         # 150 input images — cam2, pos2
└── gt/                # diffuse references, filenames mirroring the inputs
    ├── training/      # approximate diffuse labels (Weiss estimate) used for training
    ├── test1/         # ground-truth diffuse references for evaluation
    └── test2/
```



## License

The MIR dataset is released under
[Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/).


