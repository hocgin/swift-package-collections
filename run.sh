#!/bin/bash

set -e

# ========= 配置区 =========
COLLECTION_NAME="hocgin Swift Packages"
COLLECTION_OVERVIEW="Internal Swift Packages"

# 输入/输出文件
INPUT_FILE="packages.json"
OUTPUT_FILE="collection.json"
SIGNED_OUTPUT_FILE="collection-signed.json"

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

# ========= 生成输入文件 packages.json =========
echo "📦 Generating input file: $INPUT_FILE..."

cat > $INPUT_FILE << EOF
{
  "name": "$COLLECTION_NAME",
  "overview": "$COLLECTION_OVERVIEW",
  "packages": [
EOF

for i in "${!PACKAGES[@]}"; do
  URL=${PACKAGES[$i]}

  if [ $i -lt $((${#PACKAGES[@]} - 1)) ]; then
    echo "    { \"url\": \"$URL\" }," >> $INPUT_FILE
  else
    echo "    { \"url\": \"$URL\" }" >> $INPUT_FILE
  fi
done

cat >> $INPUT_FILE << EOF
  ]
}
EOF

echo "✅ $INPUT_FILE created"

# ========= 生成完整的 collection =========
echo "📚 Generating collection: $OUTPUT_FILE..."

package-collection-generate "$INPUT_FILE" "$OUTPUT_FILE"

echo "✅ $OUTPUT_FILE generated"

# ========= 可选签名 =========
if [ "$ENABLE_SIGN" = true ]; then
  echo "🔐 Signing collection..."

  package-collection-sign \
    "$OUTPUT_FILE" \
    "$SIGNED_OUTPUT_FILE" \
    "$PRIVATE_KEY_PATH" \
    "$CERT_PATH"

  echo "✅ $SIGNED_OUTPUT_FILE generated"
  echo ""
  echo "🎉 Done!"
  echo "👉 Output: $SIGNED_OUTPUT_FILE"
else
  echo ""
  echo "🎉 Done!"
  echo "👉 Output: $OUTPUT_FILE"
fi
