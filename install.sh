#!/usr/bin/env sh
#/tmp/hdconfigure_tools/install.sh
#Copyright (C) 2026 by Theron Kauk and John Morris Beck <hdconfigure.direct@gmail.com> THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
# ==============================================================================
# POSIX-Compliant Master Installer Script for hdconfigure_tools
# ==============================================================================
# This script executes a sequence of validation and installation tools located 
# in /tmp/hdconfigure_tools/installer_tools/ in the exact order specified:
#   1. check_for_debian_host
#   2. verify_git_is_installed
#   3. verify_user_is_not_root
#   4. verify_home_directory_exists
#   5. create_hdconfigure_tools_directory
#   6. install_initial_hdconfigure_tools
#   7. add_hdconfigure_tools_path_to_system_path
#
# Each step is invoked via the standard POSIX 'sh' interpreter and is strictly 
# wrapped in an explicit if/then/else/fi statement to ensure zero errors occur.
# - If all checks pass successfully, prints the required success message to stderr and exits 0.
# - If any step fails, the 'else' block prints the required error message to stderr and exits 1.
# ==============================================================================

# Define the base directory containing the installer tools
INSTALLER_DIR="/tmp/hdconfigure_tools/installer_tools"

# Step 1: Run and verify check_for_debian_host
if sh "$INSTALLER_DIR/check_for_debian_host"; then

    # Step 2: Run and verify verify_git_is_installed
    if sh "$INSTALLER_DIR/verify_git_is_installed"; then

        # Step 3: Run and verify verify_user_is_not_root
        if sh "$INSTALLER_DIR/verify_user_is_not_root"; then

            # Step 4: Run and verify verify_home_directory_exists
            if sh "$INSTALLER_DIR/verify_home_directory_exists"; then

                # Step 5: Run and verify create_hdconfigure_tools_directory
                if sh "$INSTALLER_DIR/create_hdconfigure_tools_directory"; then

                    # Step 6: Run and verify install_initial_hdconfigure_tools
                    if sh "$INSTALLER_DIR/install_initial_hdconfigure_tools"; then

                        # Step 7: Run and verify add_hdconfigure_tools_path_to_system_path
                        if sh "$INSTALLER_DIR/add_hdconfigure_tools_path_to_system_path"; then

                            # Success: All installation scripts executed successfully
                            echo "success: hdconfigure_tools successfully installed" >&2
                            exit 0

                        else
                            # Error handling for Step 7
                            echo "error: failed to install hdconfigure_tools" >&2
                            exit 1
                        fi

                    else
                        # Error handling for Step 6
                        echo "error: failed to install hdconfigure_tools" >&2
                        exit 1
                    fi

                else
                    # Error handling for Step 5
                    echo "error: failed to install hdconfigure_tools" >&2
                    exit 1
                fi

            else
                # Error handling for Step 4
                echo "error: failed to install hdconfigure_tools" >&2
                exit 1
            fi

        else
            # Error handling for Step 3
            echo "error: failed to install hdconfigure_tools" >&2
            exit 1
        fi

    else
        # Error handling for Step 2
        echo "error: failed to install hdconfigure_tools" >&2
        exit 1
    fi

else
    # Error handling for Step 1
    echo "error: failed to install hdconfigure_tools" >&2
    exit 1
fi
