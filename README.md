# 📝 Markdown品質チェックツール

このプロジェクトでは、Markdownファイルの品質を自動的にチェックするためのツールとワークフローを提供しています。

## 🎯 概要

3つの主要なチェックを実行します：

- **🔍 Markdownlint**: Markdown記法の構文チェック
- **🎨 Prettier**: フォーマットの整合性チェック
- **🔗 Link Check**: リンクの有効性チェック

## 📁 ファイル構成

```txt
.
├── scripts/
│   └── check-markdown.sh          # ローカル実行用スクリプト
├── .github/
│   └── workflows/
│       └── markdown-check.yml     # GitHub Actions ワークフロー
├── .markdownlint.json             # Markdownlint設定ファイル
├── .markdown-link-check.json      # Link check設定ファイル
└── README.md                      # このファイル
```

## 🚀 使用方法

### ローカルでの実行

#### 1. スクリプトに実行権限を付与

```bash
chmod +x scripts/check-markdown.sh
```

#### 2. スクリプトを実行

```bash
./scripts/check-markdown.sh
```

### GitHub Actionsでの自動実行

プルリクエスト作成時に自動的に実行されます。以下のファイルが変更された場合にトリガーされます：

- `docs/*.md`
- `README.md`
- `.markdownlint.json`
- `.markdown-link-check.json`

## ⚙️ 設定のカスタマイズ

### チェック対象ファイルの変更

#### ローカルスクリプト (`scripts/check-markdown.sh`)

```bash
# チェック対象のMarkdownファイルパスを定義
MD_PATHS=(
  "docs/*.md"
  "README.md"
  # 新しいパスを追加する場合はここに記述
)
```

#### GitHub Actions (`.github/workflows/markdown-check.yml`)

```yaml
# 環境変数でMarkdownパスを定義
env:
  MD_PATHS: '"docs/*.md" "README.md"'
  MD_GLOB_PATTERN: "docs/*.md README.md"
```

### Markdownlint設定

`.markdownlint.json`ファイルでルールをカスタマイズできます。

```json
{
  "default": true,
  "MD013": {
    "line_length": 120,
    "code_blocks": false
  },
  "MD033": {
    "allowed_elements": ["br", "kbd"]
  }
}
```

### Link Check設定

`.markdown-link-check.json`ファイルでリンクチェックの動作をカスタマイズできます。

```json
{
  "ignorePatterns": [
    {
      "pattern": "^http://localhost"
    }
  ],
  "timeout": "5s",
  "retryOn429": true,
  "retryCount": 3
}
```

## 🔧 必要な依存関係

以下のnpmパッケージが自動的にインストールされます：

- `markdownlint-cli2`: Markdown構文チェック
- `prettier`: フォーマットチェック
- `markdown-link-check`: リンク有効性チェック

## 📊 GitHub Actionsの結果確認

### プルリクエストでの確認

1. **ステータスチェック**: プルリクエストページでチェック結果を確認
2. **コメント**: エラーがある場合、自動的にコメントが投稿
3. **サマリー**: Actions実行ページでチェック結果の詳細を確認

### エラーの対処法

#### Markdownlintエラー

```bash
# ローカルでエラー内容を確認
npx markdownlint-cli2 "docs/*.md" "README.md" --config .markdownlint.json
```

#### Prettierフォーマットエラー

```bash
# 自動修正を実行
npx prettier --write "docs/*.md" "README.md"
```

#### リンクエラー

```bash
# ローカルでリンクチェックを実行
npx markdown-link-check README.md --config .markdown-link-check.json
```

## 🎨 カスタマイズ例

### 新しいディレクトリを追加

```bash
# scripts/check-markdown.sh
MD_PATHS=(
  "docs/*.md"
  "README.md"
  "guides/*.md"      # 新しく追加
  "tutorials/*.md"   # 新しく追加
)
```

```yaml
# .github/workflows/markdown-check.yml
env:
  MD_PATHS: '"docs/*.md" "README.md" "guides/*.md" "tutorials/*.md"'
  MD_GLOB_PATTERN: "docs/*.md README.md guides/*.md tutorials/*.md"
```

### 除外ファイルの設定

```bash
# scripts/check-markdown.sh
EXCLUDE_PATHS=(
  "./node_modules/*"
  "./.github/*"
  "./temp/*"         # 新しく追加
)
```

## 🤝 トラブルシューティング

### よくある問題

1. **npmパッケージのインストールエラー**

   ```bash
   # キャッシュをクリアして再実行
   npm cache clean --force
   ./scripts/check-markdown.sh
   ```

2. **権限エラー**

   ```bash
   # スクリプトに実行権限を付与
   chmod +x scripts/check-markdown.sh
   ```

3. **設定ファイルが見つからない**
   - `.markdownlint.json`と`.markdown-link-check.json`がプロジェクトルートにあることを確認

### サポート

問題が発生した場合は、以下の情報と共にIssueを作成してください：

- 実行環境（OS、Node.jsバージョン）
- エラーメッセージの全文
- 実行したコマンド

## 📄 ライセンス

このツールセットは[MITライセンス](./LICENSE)の下で公開されています。
