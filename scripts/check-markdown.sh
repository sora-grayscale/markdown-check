#!/bin/bash

# シェルスクリプトの実行を停止するためのオプション
set -e

# ========== 設定 ==========
# チェック対象のMarkdownファイルパスを定義
MD_PATHS=(
  #"docs/*.md"
  "README.md"
)

# 除外するパス（link checkで使用）
EXCLUDE_PATHS=(
  "./node_modules/*"
  "./.github/*"
)

# ========== 色の定義 ==========
COLOR_BLUE="\033[1;34m"
COLOR_GREEN="\033[1;32m"
COLOR_YELLOW="\033[1;33m"
COLOR_PURPLE="\033[1;35m"
COLOR_RESET="\033[0m"

# ========== 関数定義 ==========
# 配列を文字列として結合する関数
join_array() {
  local IFS="$1"
  shift
  echo "$*"
}

# package.jsonから依存関係を取得
echo -e "${COLOR_BLUE}======== 依存関係をインストール中... ========${COLOR_RESET}"
if [ ! -f package.json ]; then
  npm install -D markdownlint-cli2 prettier markdown-link-check
else
  npm ci
fi

# Markdownlintの実行
echo -e "${COLOR_GREEN}======== Markdownlintを実行中... ========${COLOR_RESET}"
npx markdownlint-cli2 $(join_array " " "${MD_PATHS[@]}") --config .markdownlint.json

# Prettierの実行
echo -e "${COLOR_YELLOW}======== Prettierを実行中... ========${COLOR_RESET}"
npx prettier --check $(join_array " " "${MD_PATHS[@]}")

# Link checkの実行
echo -e "${COLOR_PURPLE}======== リンクチェックを実行中... ========${COLOR_RESET}"

# 除外パスの構築
exclude_args=""
for exclude_path in "${EXCLUDE_PATHS[@]}"; do
  exclude_args="${exclude_args} -not -path \"${exclude_path}\""
done

# findコマンドでMarkdownファイルを検索してlink checkを実行
eval "find . -name \"*.md\" ${exclude_args} -exec npx markdown-link-check {} --config .markdown-link-check.json \\;"