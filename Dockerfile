# Claude Code in an image OpenShell can run. The workload must not run as root,
# and its working directory is the one place it may write besides /tmp.
FROM node:22-slim
RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates curl git \
 && rm -rf /var/lib/apt/lists/*
RUN npm install -g @anthropic-ai/claude-code
USER node
WORKDIR /home/node
