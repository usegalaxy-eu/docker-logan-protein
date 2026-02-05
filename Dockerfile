# Base image with PyTorch + CUDA 12.1 + cuDNN 8 runtime
FROM pytorch/pytorch:2.2.2-cuda12.1-cudnn8-runtime

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Use a non-root user for security (optional)
RUN useradd -ms /bin/bash appuser
USER appuser
WORKDIR /home/appuser

# Install your tool from PyPI or any other way ...
RUN pip install --no-cache-dir doclayout-yolo==0.0.4

