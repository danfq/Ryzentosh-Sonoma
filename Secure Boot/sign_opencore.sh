#!/bin/bash

# Copyright (c) 2021 by profzei
# Copyright (c) 2024 by DanFQ
# Licensed under the terms of the GPL v3

VERSION=$1
TYPE=$2

# Download and Unzip OpenCore
wget https://github.com/acidanthera/OpenCorePkg/releases/download/${VERSION}/OpenCore-${VERSION}-${TYPE}.zip
unzip "OpenCore-${VERSION}-${TYPE}.zip" "X64/*" -d "./Downloaded"
rm "OpenCore-${VERSION}-${TYPE}.zip"

# Download HfsPlus (for Older Systems - Pre 2017)
wget https://github.com/acidanthera/OcBinaryData/raw/master/Drivers/HfsPlus.efi -O ./Downloaded/X64/EFI/OC/Drivers/HfsPlus.efi

# Decrypt Keys
if [ -f "./ISK.key" ]; then
    echo "ISK.key was Decrypted Successfully"
fi

if [ -f "./ISK.pem" ]; then
    echo "ISK.pem was Decrypted Successfully"
fi

# Recursively Sign Drivers
# Avoid Files Starting with . (Dot)
find ./Downloaded/X64/EFI/**/* -type f -name "*.efi" ! -name '.*' | cut -c 3- | xargs -I{} bash -c 'sbsign --key ISK.key --cert ISK.pem --output $(mkdir -p $(dirname "./Signed/{}") | echo "./Signed/{}") ./{}'

# Clean
rm -rf Downloaded
echo "Cleaned..."
