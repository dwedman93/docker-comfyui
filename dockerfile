FROM archlinux:latest


    
RUN pacman -Sy --noconfirm \
    && pacman -Sy --noconfirm git \
    && pacman -Sy --noconfirm gcc \
    && pacman -Sy --noconfirm rust \
    && pacman -Sy --noconfirm base-devel \
    && pacman -Sy --noconfirm openssl \
    && pacman -Sy --noconfirm zlib \
    && pacman -Sy --noconfirm bzip2 \
    && pacman -Sy --noconfirm readline \
    && pacman -Sy --noconfirm sqlite \
    && pacman -Sy --noconfirm tk \
    && pacman -Sy --noconfirm xz \
    && pacman -Sy --noconfirm libffi \
    && pacman -Sy --noconfirm curl

# Install pyenv
RUN curl https://pyenv.run | bash

# Set environment variables for pyenv
ENV PATH="/root/.pyenv/bin:/root/.pyenv/shims:${PATH}"
RUN echo 'export PATH="/root/.pyenv/bin:$PATH"' >> ~/.bashrc
RUN echo 'eval "$(pyenv init --path)"' >> ~/.bashrc
RUN echo 'eval "$(pyenv init -)"' >> ~/.bashrc

# Install Python 3.10
RUN /root/.pyenv/bin/pyenv install 3.10.0
RUN /root/.pyenv/bin/pyenv global 3.10.0

WORKDIR /app
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /app/ComfyUI

WORKDIR /app/ComfyUI
RUN python -m venv .venv

RUN . .venv/bin/activate \
    && python -m pip install --upgrade pip \
    && pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu126 \
    && python -m pip install -r requirements.txt

# Install additional packages
RUN git clone https://github.com/ltdrdata/ComfyUI-Manager.git /app/ComfyUI/custom_nodes/ComfyUI-Manager


EXPOSE 8188
CMD [".venv/bin/python", "main.py", "--listen", "0.0.0.0"] 


# Multiline comment

#RUN . .venv/bin/activate \
#    && python -m pip install --upgrade pip \
#    && pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu126 \
#    && python -m pip install -r requirements.txt

#CMD ["/bin/bash"]