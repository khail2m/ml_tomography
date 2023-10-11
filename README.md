# Seismic Traveltime Tomography using Deep Learning

## Training data generation
- How to create velocity models from [RandomVelocityGenerator](https://github.com/pkgpl/RandomVelocityGenerator).
- First-arrival traveltime modeling: data/Generate_traveltime.py  

## Training/Validation/Test
- Net: data/Net.py, ConvNet.py
- DataLoader: data/DataLoader.py
- Train & Results: data/Tomography_CNN_Pytorch.ipynb, Tomography_nCNN_Pytorch.ipynb
- Test Benchmark: data/Tomography_CNN_Benchmark.ipynb
- Test Gulf of Mexico: data/Tomography_CNN_Congo.ipynb

## Conventional traveltime tomography
- Test_data: ref_tomo_cpu/traveltime_tomography_test_data-phess_NAG.ipynb
- Plot results: ref_tomo_cpu/Graph.ipynb


# Projects using [pkgpl_base](https://github.com/pkgpl/pkgpl_base) docker images

## Requirements
- [docker](https://docs.docker.com/engine/install/) for cpu.
- [nvidia-docker](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) for gpu.

## Docker Setting

In `docker` directory, add additional packages you need to `Dockerfile`.
Set `PROJECT_NAME` and `DEVICE` in `Env.sh` and run following commands.

```
./build.sh    # docker build
./run.sh      # docker run
./exec.sh -h  # docker exec
./helper.sh   # docker images, ps, stop, rmi
```
