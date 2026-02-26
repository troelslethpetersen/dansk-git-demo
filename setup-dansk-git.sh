#!/usr/bin/env bash
# setup-dansk-git.sh
# Installs Danish Git aliases globally. Safe to run multiple times.

set -euo pipefail

echo "📦 Installerer danske Git-aliasser globalt..."

git config --global alias.hiv         pull
git config --global alias.puf         push
git config --global alias.gren        branch
git config --global alias.forgren     branch
git config --global alias.fastlaeg    commit
git config --global alias.ompod       rebase
git config --global alias.flet        merge
git config --global alias.sammenflet  merge
git config --global alias.gem         stash
git config --global alias.klandr      blame
git config --global alias.marker      tag
git config --global alias.maerke      tag
git config --global alias.indkreds    bisect
git config --global alias.klon        clone
git config --global alias.flyt        mv

echo ""
echo "✅ Følgende danske aliasser er nu installeret:"
echo ""
printf "  %-16s → %s\n" "git hiv"        "git pull"
printf "  %-16s → %s\n" "git puf"        "git push"
printf "  %-16s → %s\n" "git gren"       "git branch"
printf "  %-16s → %s\n" "git forgren"    "git branch"
printf "  %-16s → %s\n" "git fastlaeg"   "git commit"
printf "  %-16s → %s\n" "git ompod"      "git rebase"
printf "  %-16s → %s\n" "git flet"       "git merge"
printf "  %-16s → %s\n" "git sammenflet" "git merge"
printf "  %-16s → %s\n" "git gem"        "git stash"
printf "  %-16s → %s\n" "git klandr"     "git blame"
printf "  %-16s → %s\n" "git marker"     "git tag"
printf "  %-16s → %s\n" "git maerke"     "git tag"
printf "  %-16s → %s\n" "git indkreds"   "git bisect"
printf "  %-16s → %s\n" "git klon"       "git clone"
printf "  %-16s → %s\n" "git flyt"       "git mv"
echo ""
echo "🎉 Klar! Git taler nu dansk."
