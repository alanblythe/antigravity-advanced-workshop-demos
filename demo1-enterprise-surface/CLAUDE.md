# Claude Code Development Guidelines

## Commands
- Build: `go build ./...`
- Test: `go test -v ./...`
- Lint: `golangci-lint run`

## Architecture
- All handlers must validate inputs using strict schema definitions.
- Keep context lean by preferring targeted file searches over global reading.
