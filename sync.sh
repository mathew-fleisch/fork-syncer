#!/bin/bash

# Check dependencies
expected="git"
for expect in $expected; do
    if ! command -v $expect > /dev/null; then
    echo "Missing dependency: $expect"
    exit 1
    fi
done

echo "Check environment variables are set..."
REPO_EMAIL="${REPO_EMAIL:-github-actions@github.com}"
REPO_USER="${REPO_USER:-github-actions}"
expected="GIT_TOKEN REPO_EMAIL REPO_USER"
for expect in $expected; do
  if [[ -z "${!expect}" ]]; then
    echo "Missing Github Secret: $expect"
    exit 1
  fi
done

TMP_DIR=${TMP_DIR:-/tmp/fork-syncer}
rm -rf $TMP_DIR && mkdir -p $TMP_DIR

fork_owner=$1
fork_upstream=$2
sync_branch=$3

if [ -z "$fork_owner" ] || [ -z "$fork_upstream" ] || [ -z "$sync_branch" ]; then
  echo "Usage: $0 <fork_owner> <fork_upstream> <sync_branch>"
  echo "Example: $0 mathew-fleisch grafana/loki main"
  exit 1
fi

fork_base=$(echo $fork_upstream | cut -d '/' -f 1)
fork_repo=$(echo $fork_upstream | cut -d '/' -f 2)

echo "fork_base: $fork_base"
echo "fork_repo: $fork_repo"




pushd $TMP_DIR
  git clone https://${GIT_TOKEN}:x-oauth-basic@github.com/$fork_owner/$fork_repo.git
  pushd $fork_repo
    git config --global user.email "${REPO_EMAIL}"
    git config --global user.name "${REPO_USER}"
    git remote add upstream https://github.com/$fork_base/$fork_repo.git
    git fetch upstream
    git reset --hard upstream/$sync_branch
    git push origin $sync_branch --force
    echo "$fork_repo synced: $fork_base -> $fork_owner"
    echo "--------------------------------------------"
  popd
popd
rm -rf $TMP_DIR
