# n8n-ytdlp 🍀
N8n Unlocked: Run latest n8n with extra features:
- \* Uses latest official n8n package, no weird mods
-  [Yt-dlp](https://github.com/yt-dlp/yt-dlp) for video downloading (writes to `./downloads` on host machine). Yt-dlp discord:   [![Discord](https://img.shields.io/discord/807245652072857610?color=blue&labelColor=555555&label=&logo=discord&style=for-the-badge)](https://discord.gg/H5MNcFW63r "Discord")
-  Deno
-  Python Code node enabled
-   Execute Command node

![](https://raw.githubusercontent.com/gkp1/files/refs/heads/main/n8n-ytdlp/exec2026-01-02_23-08.png)
-   Local File Trigger node

![](https://raw.githubusercontent.com/gkp1/files/refs/heads/main/n8n-ytdlp/localfile2026-01-02_23-08_1.png)

-   Allow install any npm package in custom community nodes

### Requirements:
- Docker
- [Docker compose](https://docs.docker.com/compose/install) (optional, strongly recommended)

#### ☁️ Running in serverless cloud providers:
- This will run fine on serverless, you just won't be able to save files locally - use `yt-dlp -g <link>` in Execute Command node to get direct video file urls without needing any disk read/write permissions. Then fetch media with http node or elsewhere.
------------
#### 🛡️ Security: 
The only extra file system perms this image has is:
- adding WriteFile+ReadFile node permission to access the downloads folder (by default .n8n-files is only folder with r/w allowed)
   - `- N8N_RESTRICT_FILE_ACCESS_TO=/home/node/.n8n-files;/home/node/downloads/`
   - container still can't read/write to any other folder, only those 2 folders
   - container still can't run cli commands on the host, only inside the container
   - n8n nodes (Code/Exec/Etc) do not have access to any env variable content
   - We set these by default in n8n vars:
      - `N8N_NODES_DATA_ALLOW_LIST=/home/node/downloads/` - Mandatory, Allow nodes to access media folder
      - `N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=false` - Mandatory, Probably needed
      - `N8N_INSECURE_DISABLE_WEBHOOK_IFRAME_SANDBOX=true` - Optional, Allow returning raw html pages in Respond to webhook node / other web app related uses (disable if you don't need)
      - `N8N_BLOCK_FS_READ_ACCESS=false` - Optional
      - `N8N_BLOCK_FS_WRITE_ACCESS=false` - Optional
--------

#### 📥 Saving media locally: 
- Yt-dlp automatically saves files to `/home/node/downloads` -> mapped to host machine `./downloads`
- ReadFile/WriteFile node access permissions: `/home/node/downloads`

-------

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

⚠️ Important:
If you're on linux: run on host (allow container write)
```sh
chown -R 1000:1000 ./downloads
```

# ⬆️ Updating:

Rebuild with no cache, restart. 
_default: latest n8n version from npm_

```sh
docker buildx build -t n8n:ytdlp --no-cache . && docker compose down && docker compose up -d
```

#### todo
- sync n8n runners and n8n versions
- add default localhost ip ready to go env vars
- gh action to build + push to docker hub
- optimize docker image size / expand official image
