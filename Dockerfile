FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

WORKDIR /workspace

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    vim \
    nano \
    htop \
    tree \
    build-essential \
    cmake \
    ninja-build \
    python3.11 \
    python3.11-dev \
    python3.11-venv \
    python3-pip \
    libtinfo-dev \
    zlib1g-dev \
    libxml2-dev \
    libncurses5-dev \
    libffi-dev \
    libedit-dev \
    libssl-dev \
    ocl-icd-opencl-dev \
    opencl-headers \
    clinfo \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3.11 1

RUN python3 -m pip install --upgrade pip setuptools wheel

RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip install torch --index-url https://download.pytorch.org/whl/cpu

RUN pip install --pre -U -f https://mlc.ai/wheels mlc-ai-nightly-cpu mlc-llm-nightly-cpu

RUN pip install \
    pytest \
    scipy \
    numpy \
    transformers \
    tokenizers \
    jupyter \
    ipython \
    black \
    flake8 \
    mypy \
    pre-commit \
    pybind11 \
    cython \
    requests \
    tqdm \
    pyyaml \
    click

RUN useradd -m -s /bin/bash -u 1000 developer && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER developer
WORKDIR /home/developer

RUN echo 'export PATH="/opt/venv/bin:$PATH"' >> ~/.bashrc && \
    echo 'alias ll="ls -la"' >> ~/.bashrc && \
    echo 'alias python="python3"' >> ~/.bashrc

USER root
WORKDIR /workspace

RUN mkdir -p /workspace/mlc-llm && \
    chown -R developer:developer /workspace

COPY <<'EOF' /usr/local/bin/entrypoint.sh
#!/bin/bash
set -e

# Function to run tests
run_tests() {
    echo "Running MLC-LLM tests..."
    
    # Test imports first
    python -c "
import tvm
import mlc_llm
from mlc_llm.conversation_template import ConvTemplateRegistry
print('✓ All imports successful')
print('TVM version:', tvm.__version__)
"
    
    # Run pytest if tests directory exists
    if [ -d "tests/python" ]; then
        echo "Running pytest..."
        python -m pytest tests/python/ -v --tb=short --maxfail=3 || echo "Some tests failed"
    else
        echo "No tests directory found, running basic functionality test"
        python -c "
import mlc_llm
from mlc_llm.conversation_template import ConvTemplateRegistry
registry = ConvTemplateRegistry()
print('✓ Basic functionality test passed')
"
    fi
}

run_build() {
    echo "Building MLC-LLM..."
    
    # Check if we have source code mounted
    if [ ! -f "setup.py" ] && [ ! -f "pyproject.toml" ]; then
        echo "No setup.py or pyproject.toml found. Ensure source code is mounted."
        exit 1
    fi
    
    # Install in development mode if setup.py exists
    if [ -f "setup.py" ]; then
        pip install -e .
    elif [ -f "pyproject.toml" ]; then
        pip install -e .
    fi
    
    echo "Build completed successfully"
}

case "${1:-}" in
    "dev"|"development")
        echo "Starting development environment..."
        exec /bin/bash
        ;;
    "test")
        echo "Running tests..."
        run_tests
        ;;
    "build")
        echo "Running build..."
        run_build
        ;;
    "shell")
        echo "Starting interactive shell..."
        exec /bin/bash
        ;;
    "")
        if [ -t 0 ]; then
            echo "Starting interactive development environment..."
            exec /bin/bash
        else
            echo "Running in build mode..."
            run_build
        fi
        ;;
    *)
        echo "Executing: $@"
        exec "$@"
        ;;
esac
EOF

RUN chmod +x /usr/local/bin/entrypoint.sh

ENV MLC_HOME=/workspace/mlc-llm
ENV PYTHONPATH="${MLC_HOME}:${PYTHONPATH}"

EXPOSE 8888 8000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["dev"]