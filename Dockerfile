FROM node:22-bookworm-slim
#node:22-bookworm

USER root

# 1. OS deps 
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip python3-venv ffmpeg curl unzip git make gcc g++ \
    && rm -rf /var/lib/apt/lists/* \
    && npm install -g n8n ejs

   # 2. Deno
   RUN curl -fsSL https://deno.land/install.sh | sh \
       && mv /root/.deno/bin/deno /usr/local/bin/deno \
       && chmod +x /usr/local/bin/deno

   # 3.  Python Venv & Packages
   RUN python3 -m venv /home/node/.venv \
       && /home/node/.venv/bin/pip install --upgrade pip setuptools wheel \
       && /home/node/.venv/bin/pip install \
          "yt-dlp[default,curl-cffi]" \
          requests websockets brotli certifi curl-cffi mutagen \
          pycryptodomex secretstorage \
       && ln -s /home/node/.venv/bin/yt-dlp /usr/local/bin/yt-dlp


# 4. Configs & Permissions
RUN mkdir -p /home/node/downloads /home/node/.config/yt-dlp \
    && echo '-P /home/node/downloads/' > /home/node/.config/yt-dlp/config \
    && chown -R node:node /home/node

ENV DENO_INSTALL="/usr/local"
ENV PATH="/home/node/.venv/bin:$DENO_INSTALL/bin:$PATH"
ENV NODES_EXCLUDE=[]

USER node
EXPOSE 5678
CMD ["n8n"]
