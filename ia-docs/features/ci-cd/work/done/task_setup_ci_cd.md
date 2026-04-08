# Task: Setup CI/CD and Production Docker Compose

**Feature:** ci-cd
**Tipo:** FEATURE
**Complexidade:** SMALL

**State:** in_progress
**Blocked By:** null
**Next Agent:** developer
**Promise:** <promise>AGENT_COMPLETE: developer | implementation ready</promise>

## Contexto
The project has a Docker setup for SSH but lacks an automated way to build/push images and a production-ready compose file that pulls these images.

## Acceptance Criteria
- [ ] GitHub Actions workflow created in `.github/workflows/docker-publish.yml`
- [ ] Workflow triggers on push to `main`
- [ ] `docker-compose.prod.yml` created using image from registry instead of building
- [ ] SSH service in `docker-compose.prod.yml` uses the image built by CI

## Subtasks
- [x] Create `.github/workflows/docker-publish.yml`
  **File:** `.github/workflows/docker-publish.yml` (create)
- [x] Create `docker-compose.prod.yml`
  **File:** `docker-compose.prod.yml` (create)
- [x] Update `ia-docs/registry.md`
  **File:** `ia-docs/registry.md` (modify)
- [x] Create `ia-docs/features/ci-cd/spec.md`
  **File:** `ia-docs/features/ci-cd/spec.md` (create)

## Quality Gates
- [x] Code review (reviewer)
- [x] Test quality audit (test-auditor)
