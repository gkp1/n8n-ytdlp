FROM node:22-bookworm-slim
#node:22-bookworm

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip python3-venv ffmpeg curl unzip git make gcc g++ \
    && rm -rf /var/lib/apt/lists/* \
    && npm install -g n8n ejs

#  yt-dlp & Deno
RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp \
    && chmod +x /usr/local/bin/yt-dlp \
    && curl -fsSL https://deno.land/install.sh | sh \
    && mv /root/.deno/bin/deno /usr/local/bin/deno \
    && chmod +x /usr/local/bin/deno

# Python Venv & Packages
RUN python3 -m venv /home/node/.venv \
    && /home/node/.venv/bin/pip install --upgrade pip setuptools wheel \
    && /home/node/.venv/bin/pip install \
       requests websockets brotli certifi curl-cffi mutagen \
       pycryptodomex secretstorage

# 4. Configs & Perm
RUN mkdir -p /home/node/downloads /home/node/.config/yt-dlp \
    && echo '-P /home/node/downloads/' > /home/node/.config/yt-dlp/config \
    && chown -R node:node /home/node

ENV DENO_INSTALL="/usr/local"
ENV PATH="/home/node/.venv/bin:$DENO_INSTALL/bin:$PATH"
ENV NODES_EXCLUDE=[]

USER node
EXPOSE 5678
CMD ["n8n"]
