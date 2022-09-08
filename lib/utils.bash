#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/Wilfred/difftastic"
TOOL_NAME="difftastic"
TOOL_TEST="difft --version"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

# if [ -n "${GITHUB_API_TOKEN:-}" ]; then
#   curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
# fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//'
}

list_all_versions() {
  list_github_tags
}

get_latest_version() {
  local latest_version
  echo "Checking latest version for difftastic..." >&2

  latest_version=$(curl -L --silent "https://api.github.com/repos/Wilfred/difftastic/releases/latest" |
    grep '"tag_name":' |
    sed -E 's/.*"([^"]+)".*/\1/')
  echo "Latest version for difftastic is $latest_version" >&2

  echo "$latest_version"
}

download_release() {
  local version filename url down_pth
  version="$1"
  filename="$2"
  down_pth="$3"

  if [ "$version" = "latest" ]; then
    version=$(get_latest_version)
  fi

  url="$GH_REPO/releases/download/${version}/${filename}"

  echo "* Downloading $TOOL_NAME release $version..."
  curl "${curl_opts[@]}" -o "$down_pth" -C - "$url" || fail "Could not download $url"
}

get_arch() {
  arch=$(uname -m | tr '[:upper:]' '[:lower:]')

  echo "$arch"
}

get_platform() {
  plat=$(uname | tr '[:upper:]' '[:lower:]')

  case $plat in
  darwin)
    plat='apple-darwin'
    ;;
  linux)
    plat='unknown-linux-gnu'
    ;;
  windows)
    plat='pc-windows-msvc'
    ;;
  esac

  echo "$plat"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="${3%/bin}/bin"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  arch="$(get_arch)"
  platform="$(get_platform)"
  local release_file="difft-$arch-$platform.tar.gz"
  local download_pth="$ASDF_DOWNLOAD_PATH/$release_file"

  (
    mkdir -p "$install_path"
    # cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"
    download_release "$version" "$release_file" "$download_pth"
    tar -xzf "$download_pth" -C "$install_path" || fail Could not extract "$download_pth"
    rm "$download_pth"

    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
    test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error occurred while installing $TOOL_NAME $version."
  )
}
