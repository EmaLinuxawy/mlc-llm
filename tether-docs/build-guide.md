# Build and Run Guide

## Overview

This guide covers building MLC-LLM from source and running the compiled packages across different platforms.

## Quick Start

### 1. Repository Setup

```bash
# Clone with submodules
git clone --recursive https://github.com/mlc-ai/mlc-llm.git
cd mlc-llm

# If already cloned, initialize submodules
git submodule update --init --recursive
```

### 2. Environment Setup

```bash
# Set required environment variables
export CARGO_INCREMENTAL=0
export CARGO_PROFILE_DEV_DEBUG=0
export CARGO_TERM_COLOR=always
export RUST_BACKTRACE=short
export RUSTFLAGS="-D warnings"
```

## Linux Build

### Prerequisites

See [Prerequisites](prerequisites.md) for system dependencies.

### Build Process

```bash
# 1. Install Python dependencies
pip install --upgrade pip wheel setuptools
pip install build auditwheel twine
pip install torch --index-url https://download.pytorch.org/whl/cpu
pip install transformers tokenizers numpy scipy

# 2. Install Rust toolchain
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env

# 3. Setup ccache (optional but recommended)
export CCACHE_COMPILERCHECK=content
export CCACHE_NOHASHDIR=1

# 4. Build MLC-LLM libraries
mkdir -p build && cd build

# Configure CMake
echo "set(USE_VULKAN ON)" >> config.cmake
echo "set(CMAKE_BUILD_TYPE Release)" >> config.cmake

cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)

# 5. Build Python wheel
cd ../python
python setup.py bdist_wheel

# 6. Repair wheel for Linux compatibility
auditwheel repair \
    --plat auto \
    --exclude libtvm \
    --exclude libtvm_runtime \
    --exclude libvulkan \
    -w ../wheels/ \
    dist/*.whl
```

### Verification

```bash
# Install and test the wheel
pip install wheels/*.whl

# Verify installation
python -c "
import pkg_resources
dist = pkg_resources.get_distribution('mlc-llm')
print(f'Wheel installed: {dist.version}')
print(f'Location: {dist.location}')
"
```

## Windows Build

### Prerequisites

- Miniconda installed
- Git with long paths enabled: `git config --global core.longpaths true`

### Build Process

```cmd
REM 1. Setup conda environment
conda env create -f ci/build-environment.yaml
conda activate mlc-llm-build

REM 2. Build using official script
ci/task/build_win.bat

REM 3. Build Python wheel
cd python
python setup.py bdist_wheel

REM 4. Move wheels to output directory
if not exist "..\wheels" mkdir ..\wheels
move dist\*.whl ..\wheels\
```

### Verification

```cmd
REM Install and test
for %%f in (wheels\*.whl) do pip install %%f

REM Verify installation
python -c "import pkg_resources; dist = pkg_resources.get_distribution('mlc-llm'); print(f'Wheel installed: {dist.version}')"
```

## Docker Build

### Multipurpose Image

```bash
# Build the Docker image
docker build -t mlc-llm:local .

# Push to registry (optional)
docker tag mlc-llm:local ghcr.io/username/tether-task:latest
docker push ghcr.io/username/tether-task:latest
```

### Usage Modes

See [Docker Usage Guide](docker-usage.md) for detailed usage instructions.

## Running MLC-LLM

### Basic Usage

```bash
# Install compatible TVM runtime
pip install --pre -f https://mlc.ai/wheels mlc-ai-nightly-cpu

# Install MLC-LLM wheel
pip install wheels/mlc_llm-*.whl

# Basic import test
python -c "import mlc_llm; print('MLC-LLM imported successfully')"
```

### Advanced Usage

#### Development Setup

```bash
# For development with source-built TVM
git clone --recursive https://github.com/mlc-ai/relax.git tvm-unity
cd tvm-unity
# Follow TVM Unity build instructions
```

#### Production Usage

```bash
# Use official prebuilt packages
pip install --pre -f https://mlc.ai/wheels mlc-ai-nightly-cpu mlc-llm-nightly-cpu
```

## Platform-Specific Notes

### Linux

- **GPU Support**: Install appropriate drivers (CUDA, ROCm, or Vulkan)
- **Performance**: Use `ccache` for faster rebuilds
- **Dependencies**: Vulkan development headers required for full functionality

### Windows

- **Long Paths**: Must be enabled system-wide
- **Build Tools**: Visual Studio 2019+ build tools required
- **Conda**: Official conda environment recommended

### Docker

- **Multi-stage**: Image supports development, build, and runtime modes
- **Security**: Runs as non-root user `developer`
- **Performance**: Use BuildKit for faster builds

## Troubleshooting

### Common Issues

#### Build Failures

```bash
# Clean build
rm -rf build/
git submodule deinit --all -f
git submodule update --init --recursive
```

#### TVM Compatibility

```bash
# Check TVM installation
python -c "import tvm; print('TVM version:', tvm.__version__)"

# Reinstall compatible version
pip uninstall tvm mlc-llm
pip install --pre -f https://mlc.ai/wheels mlc-ai-nightly-cpu
pip install wheels/mlc_llm-*.whl
```

#### Windows Long Path Issues

```cmd
REM Enable long paths
git config --global core.longpaths true
REM May require Windows registry modification
```
