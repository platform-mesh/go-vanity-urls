# go.platform-mesh.io Vanity Domain

This repository holds the configuration files for [vangen](https://codeberg.org/xrstf/vangen) to
generate the necessary HTML files to make the `go.platform-mesh.io` vanity domain work. This domain
enables us to use a custom domain for our Go modules and not rely on hardcoding `github.com/...`
everywhere.

The contents of this repository is hosted directly by GitHub Pages.

## Managing Repositories

Simply edit the `vangen.yaml` and then run `hack/vangen.sh` to re-generate the
HTML files. Commit, push, open a PR and you're done.
