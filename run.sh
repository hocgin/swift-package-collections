#!/bin/bash

set -e

# ========= 配置区 =========
COLLECTION_NAME="hocgin Swift Packages"
COLLECTION_OVERVIEW="Internal Swift Packages"
OUTPUT_FILE="collection.json"
PACKAGES_FILE="packages.json"

# 私有仓库列表（自己改）
PACKAGES=(
  "git@github.com:hocgin/SwiftUIS.git"
  "git@github.com:hocgin/SwiftUIS-SUPlanet.git"
  "git@github.com:hocgin/SwiftAI.git"
  "git@github.com:hocgin/CacheKit.git"
  "git@github.com:hocgin/SwiftStore.git"
  "git@github.com:hocgin/SwiftICONS.git"
  "git@github.com:hocgin/SwiftChangeKit.git"
  "git@github.com:hocgin/SwiftContext.git"
  "git@github.com:hocgin/SwiftGlass.git"
  "git@github.com:hocgin/SwiftShare.git"
  "git@github.com:hocgin/SwiftGRDB.git"
  "git@github.com:hocgin/SwiftAPI.git"
  "git@github.com:hocgin/SwiftPermissionKit.git"
  "git@github.com:hocgin/SwiftPopup.git"
  "git@github.com:hocgin/SwiftGuideKit.git"
  "git@github.com:hocgin/SwiftToast.git"
  "git@github.com:hocgin/SwiftTraceKit.git"
  "git@github.com:hocgin/SwiftError.git"
  "git@github.com:hocgin/SwiftLogKit.git"
  "git@github.com:hocgin/SwiftWebKit.git"
  "git@github.com:hocgin/SwiftExtensionsKit.git"
  "git@github.com:hocgin/SwiftTCA.git"
)

# 是否签名（true / false）
ENABLE_SIGN=false

# 证书路径（签名时用）
PRIVATE_KEY_PATH="./private-key.pem"
CERT_PATH="./certificate.pem"

# ========= 生成 packages.json =========
echo "📦 Generating packages.json..."

echo '{ "packages": [' > $PACKAGES_FILE

for i in "${!PACKAGES[@]}"; do
  URL=${PACKAGES[$i]}

  if [ $i -lt $((${#PACKAGES[@]} - 1)) ]; then
    echo "  { \"url\": \"$URL\" }," >> $PACKAGES_FILE
  else
    echo "  { \"url\": \"$URL\" }" >> $PACKAGES_FILE
  fi
done

echo ']}' >> $PACKAGES_FILE

echo "✅ packages.json created"

# ========= 生成 collection =========
echo "📚 Generating collection.json..."

swift package-collection generate "$OUTPUT_FILE" \
#  --input "$PACKAGES_FILE" \
  --name "$COLLECTION_NAME" \
  --overview "$COLLECTION_OVERVIEW"

echo "✅ collection.json generated"

# ========= 可选签名 =========
if [ "$ENABLE_SIGN" = true ]; then
  echo "🔐 Signing collection..."

  swift package-collection sign "$OUTPUT_FILE" \
    --private-key "$PRIVATE_KEY_PATH" \
    --cert-chain "$CERT_PATH" \
    --output "signed-$OUTPUT_FILE"

  echo "✅ signed-$OUTPUT_FILE generated"
fi

echo ""
echo "🎉 Done!"
echo "👉 Output: $OUTPUT_FILE"
