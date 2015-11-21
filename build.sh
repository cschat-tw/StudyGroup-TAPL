#!/bin/sh
gitbook build
cp -R ./_book/ ./dist
git add ./dist
git commit -m "Update gh-pages"
git subtree push --prefix dist origin gh-pages
