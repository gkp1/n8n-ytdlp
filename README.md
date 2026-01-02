# n8n-ytdlp
N8n Unlocked: Run latest n8n with extra features:
- [Yt-dlp](https://github.com/yt-dlp/yt-dlp) for video downloading
-  Deno
-  Python Code node enabled
-   Execute Command node
-   Local File Trigger node

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
run on host (allow container write)
```sh
chown -R 1000:1000 ./downloads
```
