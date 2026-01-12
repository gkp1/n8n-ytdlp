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

<details><summary>Click to expand</summary>
<p>

The only extra file system perms this image has is:
- adding WriteFile+ReadFile node permission to access the downloads folder: (by default .n8n-files is only folder with r/w allowed)
   - `- N8N_RESTRICT_FILE_ACCESS_TO=/home/node/.n8n-files;/home/node/downloads/`
   - container still can't read/write to any other folder, only those 2 folders
   - container still can't run cli commands on the host, only inside the container

- n8n nodes (Code/Exec/Etc) do not have access to any env variable content

- We set these by default in n8n vars:
   - `N8N_NODES_DATA_ALLOW_LIST=/home/node/downloads/` - Mandatory, Allow nodes to access media folder
   - `N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=false` - Mandatory, Probably needed
   - `N8N_BLOCK_FS_READ_ACCESS=false` - Optional
   - `N8N_BLOCK_FS_WRITE_ACCESS=false` - Optional
   - `NODE_FUNCTION_ALLOW_BUILTIN=*` - Optional, Allow any built in npm libs
   - `NODE_FUNCTION_ALLOW_EXTERNAL=*` - Optional, Allow any external npm libs


</p>
</details>


#### 🖥️ If you want to embed some of your n8n webhooks in other apps:
<details><summary>Click to expand</summary>
<p>

 - ⚠️ Setting the variable below to true leaves your n8n instance vulnerable to XSS (Cross-Site Scripting). **Leave it commented out or set it to false.**

`N8N_INSECURE_DISABLE_WEBHOOK_IFRAME_SANDBOX=false`

 - ⚠️ The effect of this variable was changed: n8n no longers wraps your webhook responses in iframes, now it uses Content-Security-Policy headers. They changed this variable to remove your security headers. (??)

------------------

> From n8n source: "Set [Content-Security-Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP) headers as [helmet.js](https://helmetjs.github.io/#content-security-policy) nested directives object."

- Add this .env var and insert your trusted domains at the end inside **frame-ancestors** to allow embedding (keep the 'self' item tho):

```
N8N_CONTENT_SECURITY_POLICY="{\"default-src\":[\"'self'\"],\"script-src\":[\"'self'\",\"'unsafe-inline'\",\"'unsafe-eval'\",\"https://cdn-rs.n8n.io\",\"https://static.cloudflareinsights.com\",\"https://us.i.posthog.com\"],\"style-src\":[\"'self'\",\"'unsafe-inline'\"],\"connect-src\":[\"'self'\",\"https://api.n8n.io\",\"https://us.i.posthog.com\"],\"img-src\":[\"'self'\",\"data:\",\"blob:\"],\"frame-ancestors\":[\"'self'\",\"https://trustedsite.com\",\"https://subdomain.myothersite.com\"]}"
```
- Explanation: 
```
# connect-src : https://api.n8n.io for security updates & general update info
# script-src: Added the CDNs (n8n, Cloudflare, Posthog) so the UI logic doesn't crash
# img-src: Added blob: and data:. This fixes the Favicon and icon loading errors
```

- Or if you want specific control over **specific webhooks allowing specific sites to embed** them:

 1. In the RESPOND TO WEBHOOK node:  ; 2. Click "Add Options" --> "Response Headers"
 3. type in Name field: `Content-Security-Policy` ; 4. type in Value field: `default-src * 'unsafe-inline' 'unsafe-eval'; script-src * 'unsafe-inline' 'unsafe-eval'; style-src * 'unsafe-inline'; frame-ancestors 'self' https://app.mychat.com;` - replace app.mychat.com
</p>
</details>


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
cp .env.example .env && nano .env
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

```sh
cd n8n-ytdlp
```

Rebuild with no cache -> restart

```sh
docker buildx build -t n8n:ytdlp --no-cache . && docker compose down && docker compose up -d
```

_default version: latest n8n version from npm_


#### todo
- sync n8n runners and n8n versions
- add default localhost ip ready to go env vars
- gh action to build + push to docker hub
- optimize docker image size / expand official image
