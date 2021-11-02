# fork-syncer
Automation to keep the repositories I've forked up to date. Most times I will fork a project to make a specific change, and after it is merged, my fork will drift from upstream changes. Iterating over the values in the [forks](forks) file, a github action using the [fork-sync](https://github.com/marketplace/actions/fork-sync) action to create PRs for specific repository/forks.

If you'd like to use this automation, fork this project, and change the values in the [forks](forks) file to match the forks you want to keep in sync with upstream.

```bash
REPO_OWNER=mathew-fleisch && while read -r line; do repo=$(echo "$line" | awk '{print $1}' | cut -d '/' -f 2); echo "https://github.com/$REPO_OWNER/$repo"; done < forks
```

## Trigger GitHub Action via Curl

```bash
GIT_TOKEN=xxx \
  && REPO_OWNER=mathew-fleisch \
  && REPO_NAME=fork-syncer \
  && ./trigger.sh
```
