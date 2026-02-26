#!/usr/bin/env bash
# demo-dansk-git.sh
# Demonstrates Danish Git terminology through a realistic Git workflow.
# Safe to run multiple times (uses a temp workspace).

set -euo pipefail

# ── Helpers ───────────────────────────────────────────────────────────────────
pause() { sleep "${1:-1}"; }

say() {
  echo ""
  echo "💬  $*"
  echo ""
  pause 1
}

run() {
  echo "$ $*"
  "$@"
  pause 1
}

section() {
  echo ""
  echo "─────────────────────────────────────────────"
  echo "  $*"
  echo "─────────────────────────────────────────────"
  echo ""
  pause 1
}

# ── Setup: temporary workspace ─────────────────────────────────────────────────
WORKSPACE=$(mktemp -d)
REMOTE=$(mktemp -d)
trap 'rm -rf "$WORKSPACE" "$REMOTE"' EXIT

export GIT_AUTHOR_NAME="Dansk Git"
export GIT_AUTHOR_EMAIL="dansk@git.dk"
export GIT_COMMITTER_NAME="Dansk Git"
export GIT_COMMITTER_EMAIL="dansk@git.dk"

# Short, clean prompt for readability
export PS1="git-dk \$ "

# ── Initialise bare "remote" repo ──────────────────────────────────────────────
section "Initialiserer fjernlager (remote)"
cd "$REMOTE"
run git init --bare --initial-branch=hoved .
pause 1

# ── Clone remote into workspace ────────────────────────────────────────────────
section "Kloner lager til arbejdsmappe"
cd "$WORKSPACE"
run git klon "$REMOTE" projekt
cd "$WORKSPACE/projekt"
pause 1

# ── Create initial commit on hoved ────────────────────────────────────────────
section "Første fastlæggelse på hovedgrenen"
echo "# Dansk Git Demo" > README.md
run git add README.md
run git fastlaeg -m 'Første fastlæggelse: tilføj README'
run git puf origin hoved
pause 1

# ── Scenario 1 ────────────────────────────────────────────────────────────────
# "Gider I hale fra den gren, jeg lige har genbaseret og puffet til GitHub?"
section "Scenarie 1: genbasér og puf"
say "Gider I hale fra den gren, jeg lige har genbaseret og puffet til GitHub?"

run git forgren feature/ny-funktion
run git checkout feature/ny-funktion
echo "function hello() { echo 'Hej verden'; }" > hello.sh
run git add hello.sh
run git fastlaeg -m 'Tilføj hilsen-funktion'

# Rebase onto hoved
run git ompod hoved
run git puf origin feature/ny-funktion
pause 1

# Collaborator pulls the rebased branch
say "Hiver fra den genbaserede gren..."
run git hiv --rebase origin feature/ny-funktion
pause 1

# ── Scenario 2 ────────────────────────────────────────────────────────────────
# "Jeg har lige skudt en gren og har fastlagt ændringerne fra mit gemme der."
section "Scenarie 2: gem (stash) og fastlæg"
say "Jeg har lige skudt en gren og har fastlagt ændringerne fra mit gemme der."

# Stash some work-in-progress
echo "# Midlertidigt arbejde" > wip.md
run git add wip.md
run git gem

# Create a new branch and apply the stash there
run git forgren feature/fra-gemme
run git checkout feature/fra-gemme
run git gem pop
run git fastlaeg -m 'Fastlæg ændringer fra gemmet'
run git puf origin feature/fra-gemme
pause 1

# ── Scenario 3 ────────────────────────────────────────────────────────────────
# "Send lige en haleanmodning, når du er færdig med fletningen!"
section "Scenarie 3: flet (merge) og haleanmodning"
say "Send lige en haleanmodning, når du er færdig med fletningen!"

run git checkout hoved
run git flet feature/ny-funktion --no-ff -m 'Flet feature/ny-funktion ind i hoved'
run git puf origin hoved
echo "(Haleanmodning sendt — PR oprettet på GitHub)"
pause 1

# ── Scenario 4 ────────────────────────────────────────────────────────────────
# "Det håndplukker vi da bare fra udviklergrenen."
section "Scenarie 4: håndpluk (cherry-pick)"
say "Det håndplukker vi da bare fra udviklergrenen."

run git forgren udvikler
run git checkout udvikler
echo "function bonus() { echo 'Bonus!'; }" > bonus.sh
run git add bonus.sh
run git fastlaeg -m 'Tilføj bonus-funktion (til håndpluk)'

CHERRY=$(git rev-parse HEAD)

run git checkout hoved
run git cherry-pick "$CHERRY"
pause 1

# ── Scenario 5 ────────────────────────────────────────────────────────────────
# "Hov, jeg tvangspuffede vistnok til hovedgrenen!"
section "Scenarie 5: tvangspuf (force push)"
say "Hov, jeg tvangspuffede vistnok til hovedgrenen!"

run git checkout feature/ny-funktion
# Amend last commit to simulate needing a force push
echo "# Opdateret" >> hello.sh
run git add hello.sh
run git fastlaeg --amend --no-edit
run git puf --force-with-lease origin feature/ny-funktion || true
echo "(Tvangspuf gennemført — brug med omtanke!)"
pause 1

# ── Scenario 6 ────────────────────────────────────────────────────────────────
# "Husk at kvase dine fastlæggelser, inden du fletter."
section "Scenarie 6: kvas (squash) fastlæggelser"
say "Husk at kvase dine fastlæggelser, inden du fletter."

run git forgren feature/kvases
run git checkout feature/kvases

for i in 1 2 3; do
  echo "Ændring $i" >> kvases.md
  run git add kvases.md
  run git fastlaeg -m "WIP-fastlæggelse $i"
done

# Squash the last 3 commits: soft-reset then recommit as one
echo "(I produktion: git rebase -i HEAD~3  →  vælg 'squash' / 'fixup')"
run git reset --soft HEAD~3
run git fastlaeg -m 'Kvas: samlet alle WIP-fastlæggelser til én'
echo "(Alle WIP-fastlæggelser er nu kvaset til én pæn fastlæggelse)"
pause 1

# ── Scenario 7 ────────────────────────────────────────────────────────────────
# "Hvis du har gaflet min gren skal du lige huske at hente opstrøms."
section "Scenarie 7: hiv opstrøms (upstream pull)"
say "Hvis du har gaflet min gren skal du lige huske at hente opstrøms."

run git checkout hoved
# Add upstream remote (pointing to the same bare repo to avoid network calls)
run git remote add opstrøm "$REMOTE" || true
run git hiv opstrøm hoved || true
echo "(Opstrøms ændringer hentet og flettet ind)"
pause 1

# ── Afslutning ─────────────────────────────────────────────────────────────────
section "🎉 Demo afsluttet"
echo "  Alle syv danske Git-dialoger er demonstreret:"
echo ""
echo "  1. hiv / ompod / puf          → pull, rebase, push"
echo "  2. gem / forgren / fastlaeg   → stash, branch, commit"
echo "  3. flet / puf                 → merge, push (+ PR)"
echo "  4. cherry-pick               → håndpluk"
echo "  5. puf --force-with-lease    → tvangspuf"
echo "  6. ompod --autosquash / kvase → squash commits"
echo "  7. hiv opstrøm               → hent opstrøms"
echo ""
pause 2
