FROM pytorch/pytorch:2.5.0-cuda12.1-cudnn9-runtime

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    unzip \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# The base image already has conda in /opt/conda
ENV PATH=/opt/conda/bin:$PATH

RUN conda install -y -c conda-forge -c bioconda -c nvidia -c pytorch \
    mmseqs2 \
    "faiss-cpu>=1.8" \
    numpy \
    scikit-learn \
    transformers=4.36.2 \
    einops && \
    conda clean -afy

WORKDIR /app
RUN curl -fLsS https://github.com/RolandFaure/search_protein/archive/refs/heads/master.tar.gz | tar -xz --strip-components=1

## python3 embed_query.py -h

# Pre-download the model and cache it in the image. This will avoid downloading the model every time the tool is run. 
ENV HF_HOME=/app/.cache/huggingface
RUN python -c "from transformers import AutoModel, AutoTokenizer; \
    model_name = 'tattabio/gLM2_650M_embed'; \
    AutoTokenizer.from_pretrained(model_name, trust_remote_code=True); \
    AutoModel.from_pretrained(model_name, trust_remote_code=True)"
