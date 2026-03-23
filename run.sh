#!/bin/bash

set -e

# ========= 配置区 =========
COLLECTION_NAME="hocgin Swift Packages"
COLLECTION_OVERVIEW="Internal Swift Packages"
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

cat > $PACKAGES_FILE << EOF
{
  "formatVersion": "1.0",
  "collections": [
    {
      "name": "$COLLECTION_NAME",
      "identifier": "com.hocgin.swift-packages",
      "overview": "$COLLECTION_OVERVIEW",
      "authorName": "hocgin",
      "keywords": [
        "Swift",
        "SwiftUI",
        "iOS",
        "macOS"
      ],
      "packages": [
EOF

for i in "${!PACKAGES[@]}"; do
  URL=${PACKAGES[$i]}

  if [ $i -lt $((${#PACKAGES[@]} - 1)) ]; then
    echo "        { \"url\": \"$URL\" }," >> $PACKAGES_FILE
  else
    echo "        { \"url\": \"$URL\" }" >> $PACKAGES_FILE
  fi
done

cat >> $PACKAGES_FILE << EOF
      ]
    }
  ]
}
EOF

echo "✅ packages.json created"

# ========= 可选签名 =========
if [ "$ENABLE_SIGN" = true ]; then
  echo "🔐 Signing collection..."

  swift package-collection sign "$PACKAGES_FILE" \
    --private-key "$PRIVATE_KEY_PATH" \
    --cert-chain "$CERT_PATH" \
    --output "signed-$PACKAGES_FILE"

  echo "✅ signed-$PACKAGES_FILE generated"
fi

echo ""
echo "🎉 Done!"
echo "👉 Output: $PACKAGES_FILE"
