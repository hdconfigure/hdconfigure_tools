#!/bin/sh
#copyright 2026 Theron Kauk and John Morris Beck - hd.configure.direct@gmail.com - all rights reserved
# POSIX-compliant script to set up hdconfigure directories, tools subdirectory, and applications

install_hd_app() {
    target_dir="$1"
    repo_url="$2"
    base_dir="$HOME/.config/hdcongure/tools"
    target_path="$base_dir/$target_dir"

    if [ ! -d "$target_path" ]; then
        if ! git clone "$repo_url" "$target_path"; then
            echo "Error: Failed to clone $target_dir from $repo_url" >&2
            return 1
        fi
        if ! (cd "$target_path" && sh install.sh); then
            echo "Error: Failed to execute install.sh for $target_dir" >&2
            return 1
        fi
        echo "$target_dir successfully installed"
    else
        echo "$target_dir already exists, skipping clone and install."
    fi
    return 0
}

main() {
    config_dir="$HOME/.config/hdcongure"
    tools_dir="$config_dir/tools"
    success=true

    # Ensure the main config directory and tools subdirectory exist
    if [ ! -d "$config_dir" ] || [ ! -d "$tools_dir" ]; then
        if ! mkdir -p "$tools_dir"; then
            echo "Error: Failed to create directories $config_dir and $tools_dir" >&2
            exit 1
        fi
    fi

    # Stage 1: Install using dynamic user/repo arguments ($1 and $2)
    owner="hdconfigure"
    repo="hdconfigure_tools"
    
    if [ -z "$owner" ] || [ -z "$repo" ]; then
        echo "Error: Missing arguments. Usage: $0 <github_owner> <github_repo>" >&2
        exit 1
    fi

    repo_url="https://github.com/$owner/$repo"

    if ! install_hd_app "$repo" "$repo_url"; then
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
