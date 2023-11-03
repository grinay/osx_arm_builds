#!/bin/bash

# Find all 'native' directories in the current directory tree
find . -type d -name 'native' | while read native_dir; do
    echo "Processing directory: $native_dir"

    # Change to the native directory
    cd "$native_dir"

    # Iterate over all .dylib files in the current 'native' directory
    for lib in *.dylib; do
        # Update rpath for each dependency
        otool -L "$lib" | grep '@executable_path/../libs/' | awk '{print $1}' | while read -r dep; do
            depname=$(basename "$dep")
            newpath="@loader_path/$depname"
            echo "Changing $dep to $newpath in $lib"
            install_name_tool -change "$dep" "$newpath" "$lib"
        done

        # Re-sign the dylib with an ad-hoc signature
        echo "Re-signing $lib with ad-hoc signature"
        codesign --force --deep --preserve-metadata=entitlements,requirements,flags,runtime --sign - "$lib"
    done

    # Change back to the original directory
    cd -
done

echo "All .dylib files in 'native' directories have been processed and re-signed."
