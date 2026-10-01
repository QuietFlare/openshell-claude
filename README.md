# openshell-claude

Claude Code inside an [OpenShell](https://github.com/NVIDIA/OpenShell) sandbox, signed in with a Claude subscription and allowed to reach two hosts.

The story behind it: [I locked Claude Code in a sandbox. It needed two rules.](https://www.quietflare.net/blog/claude-code-in-a-sandbox)

## Read this first

The subscription login leaves a token inside the sandbox, where the agent can read it. Use this on your own machine, for your own work. With an API key, OpenShell keeps the credential outside the sandbox, and that is the setup for anything you run for other people. Anthropic does not allow products to offer Claude subscription login to their users.

## What is here

| File | What it is |
|---|---|
| `Dockerfile` | A Node image with Claude Code installed, running as a non-root user |
| `policy.yaml` | The two network rules: the model API and sign-in. Everything else is refused |

## Use it

You need OpenShell installed with a running gateway, and Docker.

```bash
docker build -t openshell-claude:1 .
openshell sandbox create --name claude --from openshell-claude:1 \
  --policy policy.yaml --no-auto-providers
```

You land in a shell inside the sandbox. Sign in and try it:

```bash
claude auth login --claudeai
claude -p "reply with OK"
```

The login prints a link. Open it in the browser on your own machine, approve, and paste the code back.

## If the sandbox does not start on Docker Desktop

The supervisor container looks for the gateway on `127.0.0.1`, which under Docker Desktop is Docker's own virtual machine. Add this to the gateway's `gateway.toml` and restart the gateway:

```toml
[openshell.drivers.docker]
grpc_endpoint = "https://host.docker.internal:17670"
```

See [OpenShell issue 3880](https://github.com/NVIDIA/OpenShell/issues/3880).

## Change the policy

The rules name the real Claude Code executable, not the `claude` link in `/usr/local/bin`. If you install Claude Code another way, read the path from the sandbox log and put it in `policy.yaml`:

```bash
openshell logs claude --since 10m --source sandbox
```

A refused request shows the program and the host it wanted. Before you widen the policy, ask the prover whether your new version still fits inside this one:

```bash
openshell-prover check --boundary policy.yaml your-policy.yaml
```

## Tested with

OpenShell 0.1.2, Claude Code 2.1.286, Docker Desktop 4.76.0 on macOS 26.6.2, on 1 October 2026.

## License

MIT. See [LICENSE](LICENSE).
