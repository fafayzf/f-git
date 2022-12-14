#!/usr/bin/env sh
set -e

git checkout master
git merge dev

VERSION=`npx select-version-cli`

read -p "Releasing $VERSION - are you sure? (y/n)" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo "Releasing $VERSION ..."

  # commit
  npx npx-version create $VERSION
  git add -A
  git commit -m "[build] $VERSION"
  npm version $VERSION --message "[release] $VERSION"

  # publish
  git push gitee master -f
  git push gitee refs/tags/v$VERSION
  git push origin master -f
  git push origin refs/tags/v$VERSION
  git checkout dev
  git rebase master
  git push gitee dev
  git push origin dev

  if [[ $VERSION =~ "beta" ]]
  then
    npm publish --tag beta
  else
    npm publish
  fi
fi
