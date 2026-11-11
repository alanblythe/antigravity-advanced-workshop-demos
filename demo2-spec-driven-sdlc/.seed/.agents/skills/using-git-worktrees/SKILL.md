---
name: using-git-worktrees
description: Guidelines for managing isolated subagent git worktrees without main repo collisions.
---

# Git Worktree Protocol

1. Register worktrees in local exclude:
   ```bash
   echo ".worktrees/" >> .git/info/exclude
   ```
2. Spawn a worktree:
   ```bash
   git worktree add .worktrees/<branch-name> -b <branch-name>
   ```
3. Remove worktree when done:
   ```bash
   git worktree remove .worktrees/<branch-name>
   ```
