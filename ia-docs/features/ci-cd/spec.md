# Spec: CI/CD and Production Deployment

## Features
- **GitHub Actions Workflow:** Automates the build and push of the SSH server image to GHCR.
- **Production Docker Compose:** Provides a configuration that pulls pre-built images for faster and more consistent deployments.

## Technical Decisions
- **Registry:** Using GitHub Container Registry (GHCR) as it integrates natively with GitHub Actions.
- **Caching:** Workflow uses `type=gha` cache for faster subsequent builds.
- **Image Naming:** `ghcr.io/alexsilva-dev/leads-previews-cdn/ssh-server:latest`.

## Files Created
- `.github/workflows/docker-publish.yml`
- `docker-compose.prod.yml`
