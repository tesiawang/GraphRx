# GraphRx
This is the official source codes for "GraphRx: Graph-Based Collaborative Learning among Multiple Cells for Uplink Neural Receivers".

**[INFOCOM'25][INFOCOM] | [MLSP'24][MLSP] | [Citation](#citation)**


## Getting Started

### Environment Setup
Prepare the Python environment using [conda][conda]:

```bash
conda env create -f environment.yml -n sionna
conda activate sionna
```
The above environment requires installing tensorflow-macos 2.15 and [Sionna 0.19][Sionna]; it has been tested on Apple M1/M2.

Test that key packages are installed correctly:
```bash
python -c "import tensorflow as tf; import sionna; print('TensorFlow:', tf.__version__); print('Sionna:', sionna.__version__)"
```

### Data Generation
Generate training and testing data for all configurations:

```bash
bash Runs_local/gen_data.sh
```

This script generates data for different generation types (0, 1, 2) and modes (offline, online).

### Offline Pretraining
Pretrain the neural receiver model:

```bash
bash Runs_local/pretrain.sh
```

This creates pretrained models that serve as initialization for federated learning.

### Online Adaptation and Evaluation
Run federated learning training and evaluation:

```bash
bash Runs_local/train_and_eval.sh
```

This script runs the GraphRx federated learning algorithm and evaluates performance.

### Baselines
Run baseline federated learning algorithms for comparison:

```bash
bash Runs_local/baseline.sh
```

This script runs multiple federated learning baselines including FedAvgs, FedAvgFT, FedReps, and Dittos.

Run baseline local adaptation (e.g., only local training is allowed online):

```bash
python ./OnlineAdapt/Algo/local_adapt.py
```

## Citation
If you find our work useful, please kindly consider citing our papers:

```bibtex
@INPROCEEDINGS{GraphRx,
  author={Wang, Tianxin and Wang, Xudong and Li, Geoffrey Ye},
  booktitle={IEEE INFOCOM 2025 - IEEE Conference on Computer Communications}, 
  title={Graph{Rx}: Graph-Based Collaborative Learning Among Multiple Cells for Uplink Neural Receivers}, 
  year={2025},
  pages={1-10},
  keywords={Training;Federated learning;Collaboration;Receivers;Computer architecture;Data augmentation;Servers;Uplink;Intercell interference;Signal to noise ratio}
  }
```

```
**T. Wang**, X. Wang, and G. Y. Li, "T. Wang, X. Wang and G. Y. Li, "GraphRx: Graph-Based Collaborative Learning Among Multiple Cells for Uplink Neural Receivers," IEEE INFOCOM 2025 - IEEE Conference on Computer Communications, London, United Kingdom, 2025, pp. 1-10.
```

## Others
This repository has referred to some parts of codes in [pFedGraph][pFedGraph].

[INFOCOM]: https://ieeexplore.ieee.org/document/11044726
[MLSP]: https://ieeexplore.ieee.org/abstract/document/10734801
[conda]: https://www.anaconda.com/docs/getting-started/miniconda/main
[pFedGraph]: https://github.com/MediaBrain-SJTU/pFedGraph
[Sionna]: https://jhoydis.github.io/sionna-0.19.2-doc/