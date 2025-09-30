# OpenFortiVPN Docker Container

[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![OpenFortiVPN](https://img.shields.io/badge/OpenFortiVPN-VPN%20Client-blue?style=for-the-badge)](https://github.com/adrienverge/openfortivpn)

A lightweight, containerized OpenFortiVPN client for connecting to FortiGate VPN servers. Designed for both development and production environments with npm-style commands via Makefile.

## 🚀 Features

- **Lightweight**: Based on Debian stable-slim (~50MB)
- **Secure**: Credentials excluded from version control via `.gitignore`
- **Flexible**: Separate configurations for development and deployment
- **User-friendly**: NPM-style commands via Makefile
- **Production-ready**: Privileged container with proper network capabilities
- **Auto-restart**: Automatic restart on failure
- **Host networking**: Seamless VPN connectivity

## 📋 Prerequisites

- Docker and Docker Compose
- Host system with TUN/TAP device support
- Make utility (for NPM-style commands)

## ⚡ Quick Start

### 1. Initial Setup
```bash
# Clone the repository (if not already done)
git clone https://github.com/runsystemid/openfortivpn.git
cd openfortivpn

# Setup configuration template
make setup
```

### 2. Configure VPN Credentials
Edit `.openfortivpn.conf` with your FortiGate VPN details:
```ini
host = your-vpn-server.com
port = 443
username = your-username
password = your-password
trusted-cert = your-cert-fingerprint
```

### 3. Start VPN Connection
```bash
# Development mode (builds locally)
make dev

# View connection logs
make logs
```

## 🛠️ Available Commands

### Setup & Installation
| Command | Description |
|---------|-------------|
| `make setup` | Copy configuration template |
| `make install` | Complete setup with validation |
| `make config-check` | Validate configuration exists |

### Development Workflow
| Command | Description |
|---------|-------------|
| `make dev` | Start development environment (build + run) |
| `make logs` | View development logs (follow mode) |
| `make restart` | Restart development containers |
| `make stop` | Stop all containers |
| `make status` | Show container status |

### Build & Deployment
| Command | Description |
|---------|-------------|
| `make build` | Build Docker image locally |
| `make deploy` | Deploy using production configuration |
| `make logs-deploy` | View deployment logs |
| `make push` | Build and push image to registry |

### Maintenance
| Command | Description |
|---------|-------------|
| `make clean` | Clean up containers, networks, and volumes |
| `make all` | Full reset (clean + build + dev) |
| `make help` | Show all available commands |

## 🏗️ Project Structure

```
openfortivpn/
├── .gitignore                 # Excludes .openfortivpn.conf
├── .openfortivpn.conf.example # Configuration template
├── .openfortivpn.conf         # Your VPN credentials (git-ignored)
├── Dockerfile                 # Container definition
├── Makefile                   # NPM-style commands
├── docker-compose.dev.yml     # Development configuration
├── docker-compose.yml         # Production configuration
├── entrypoint.sh             # Container startup script
└── README.md                 # This file
```

## ⚙️ Configuration

The container uses OpenFortiVPN configuration format. Required parameters:

| Parameter | Description | Example |
|-----------|-------------|---------|
| `host` | FortiGate VPN server | `vpn.company.com` |
| `port` | VPN server port | `443` |
| `username` | Your VPN username | `john.doe` |
| `password` | Your VPN password | `secretpassword` |
| `trusted-cert` | Server certificate fingerprint | `sha256:abc123...` |

Additional OpenFortiVPN options can be added as needed. See [OpenFortiVPN documentation](https://github.com/adrienverge/openfortivpn) for all available options.

## 🔒 Security

- **Credential Protection**: `.openfortivpn.conf` is excluded from version control
- **Template Provided**: Use `.openfortivpn.conf.example` as starting point
- **Production Considerations**: Consider using Docker secrets or environment variables for production
- **Privileged Mode**: Required for VPN functionality but isolated in container

## 🐳 Docker Configurations

### Development Mode (`docker-compose.dev.yml`)
- Builds image locally from Dockerfile
- Perfect for development and testing
- Includes build cache for faster iterations

### Production Mode (`docker-compose.yml`)
- Uses pre-built image from registry
- Faster deployment times
- Consistent across environments

## 🔧 Manual Docker Commands

If you prefer direct Docker Compose commands:

### Development
```bash
docker-compose -f docker-compose.dev.yml up -d --build  # Start with build
docker-compose -f docker-compose.dev.yml logs -f        # View logs
docker-compose -f docker-compose.dev.yml down           # Stop
```

### Production
```bash
docker-compose up -d  # Start production
docker-compose logs -f # View logs
docker-compose down    # Stop
```

### Build & Push
```bash
docker build -t runsystemid/openfortivpn:latest .
docker push runsystemid/openfortivpn:latest
```

## 🐛 Troubleshooting

### Common Issues

**Connection Fails**
- Check logs: `make logs`
- Verify credentials in `.openfortivpn.conf`
- Ensure VPN server is accessible

**TUN Device Issues**
```bash
# Check if TUN device exists
ls -la /dev/net/tun

# Create if missing (requires root)
sudo mkdir -p /dev/net
sudo mknod /dev/net/tun c 10 200
```

**Permission Issues**
- Ensure Docker has privileged access
- Check that user is in docker group

**Configuration Not Found**
```bash
# Run setup to create config template
make setup

# Verify config exists
make config-check
```

## 📝 Development

### Adding New Features
1. Modify `Dockerfile` or `entrypoint.sh`
2. Test with `make dev`
3. Build and push: `make push`
4. Deploy: `make deploy`

### Contributing
1. Fork the repository
2. Create feature branch
3. Test changes with `make dev`
4. Submit pull request

## 📄 License

This project is open source. The underlying OpenFortiVPN client is licensed under GPL v3.

## 🔗 Links

- [OpenFortiVPN GitHub](https://github.com/adrienverge/openfortivpn)
- [Docker Hub](https://hub.docker.com/r/runsystemid/openfortivpn)
- [FortiGate Documentation](https://docs.fortinet.com/)

---

**Need help?** Run `make help` to see all available commands.
