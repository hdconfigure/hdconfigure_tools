#!/bin/sh
#copyright 2026 Theron Kauk and John Morris Beck - hd.configure.direct@gmail.com - all rights reserved

# POSIX-compliant script to set up hdconfigure directories, git/tools subdirectories, and applications

install_hd_app() {
    github_username="$1"
    repository_name="$2"
    base_dir="$HOME/.config/hdconfigure/git"
    target_path="$base_dir/$repository_name"
    repo_url="https://github.com/$github_username/$repository_name"

    if [ -d "$target_path" ]; then
        rm -rf "$target_path"
    fi

    if ! git clone "$repo_url" "$target_path"; then
        echo "Error: Failed to clone $repository_name from $repo_url" >&2
        return 1
    fi
    if ! (cd "$target_path" && sh install.sh); then
        echo "Error: Failed to execute install.sh for $repository_name" >&2
        return 1
    fi
    echo "$repository_name successfully installed"
    return 0
}

main() {
    config_dir="$HOME/.config/hdconfigure"
    tools_dir="$config_dir/tools"
    git_dir="$config_dir/git"
    success=true

    # Unconditionally ensure config, tools, and git subdirectories exist
    if ! mkdir -p "$config_dir" "$tools_dir" "$git_dir"; then
        echo "Error: Failed to create directories under $config_dir" >&2
        exit 1
    fi

    github_username="$1"
    repository_name="$2"
    
    if [ -z "$github_username" ] || [ -z "$repository_name" ]; then
        echo "Error: Missing arguments. Usage: $0 <github_username> <repository_name>" >&2
        exit 1
    fi

    if ! install_hd_app "$github_username" "$repository_name"; then
        success=false
    fi

    # Final summary messages
    if [ "$success" = true ]; then
        echo "tool successfully installed
to enable your tools add this to your path \"$HOME/.config/hdconfigure/tools\""
    else
        echo "tool install failed" >&2
        exit 1
    fi
}

main "$@"
