# n8n-ytdlp 🍀
N8n Unlocked: Run latest n8n with extra features:
-  [Yt-dlp](https://github.com/yt-dlp/yt-dlp) for video downloading (default download path is ./downloads on host machine)

- Yt-dlp discord:   [![Discord](https://img.shields.io/discord/807245652072857610?color=blue&labelColor=555555&label=&logo=discord&style=for-the-badge)](https://discord.gg/H5MNcFW63r "Discord")
-  Deno
-  Python Code node enabled
-   Execute Command node

![](https://raw.githubusercontent.com/gkp1/files/refs/heads/main/n8n-ytdlp/exec2026-01-02_23-08.png
)
-   Local File Trigger node

![](https://raw.githubusercontent.com/gkp1/files/refs/heads/main/n8n-ytdlp/localfile2026-01-02_23-08_1.png
)

-   Allow install any npm package in custom community nodes
- Uses latest official n8n package, no weird mods

### Requirements:

#### 📥 Saving media locally: 
Permission to write to disk (./downloads)

#### ☁️ Running in serverless cloud providers:
This will run fine on serverless, you just won't be able to save files locally - use `yt-dlp -g <link>` in Execute Command node to get direct video file urls without needing any disk read/write permissions. Then fetch media elsewhere.

## Steps:

### Clone repo && cd 

```sh
git clone https://github.com/gkp1/n8n-ytdlp.git && cd n8n-ytdlp
```

### Build docker image n8n:ytdlp

```sh
docker buildx build -t n8n:ytdlp .
```

### Add valid n8n .env variables

```sh
nano .env
```

### Run -detached

```sh
docker compose up -d && docker ps
```

important:
If you're on linux: run on host (allow container write)
```sh
chown -R 1000:1000 ./downloads
```

# Updating:

Run build again with no cache, will replace old image with the up to date one. Then simply restart. 
_default version: latest n8n version from npm_

```sh
docker buildx build -t n8n:ytdlp --no-cache . && docker compose down && docker compose up -d
```
