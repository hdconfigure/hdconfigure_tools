#!/bin/sh
#copyright 2026 Theron Kauk and John Morris Beck - hd.configure.direct@gmail.com - all rights reserved
# POSIX-compliant script to set up hdconfigure directories, git/tools subdirectories, and applications

install_hd_app() {
    target_dir="$1"
    repo_url="$2"
    base_dir="$HOME/.config/hdconfigure/git"
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
    config_dir="$HOME/.config/hdconfigure"
    tools_dir="$config_dir/tools"
    git_dir="$config_dir/git"
    success=true

    # Ensure the main config directory, tools subdirectory, and git subdirectory exist
    if [ ! -d "$config_dir" ] || [ ! -d "$tools_dir" ] || [ ! -d "$git_dir" ]; then
        if ! mkdir -p "$tools_dir" "$git_dir"; then
            echo "Error: Failed to create directories under $config_dir" >&2
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
    else
        # Copy install_hd_tool.sh from the git folder to tools/install_hd_tool and make executable
        source_script="$git_dir/$repo/install_hd_tool.sh"
        dest_script="$tools_dir/install_hd_tool"
        if [ -f "$source_script" ]; then
            if ! cp "$source_script" "$dest_script"; then
                echo "Error: Failed to copy install_hd_tool" >&2
                success=false
            elif ! chmod +x "$dest_script"; then
                echo "Error: Failed to make install_hd_tool executable" >&2
                success=false
            fi
        else
            echo "Error: $source_script not found." >&2
            success=false
        fi
    fi

    # Final summary messages
    if [ "$success" = true ]; then
        sh "$HOME/.config/hdconfigure/git/hdconfigure_tools/install_hd_tool.sh" hdconfigure hd_tools_slurp
        echo "tool successfully installed
to enable your tools add this to your path \"$HOME/.config/hdconfigure/tools\""
    else
        echo "tool install failed" >&2
        exit 1
    fi
}

main "$@"
