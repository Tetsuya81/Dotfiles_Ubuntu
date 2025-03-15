# Dotfiles for Ubuntu Server 24.04

このリポジトリは、Ubuntu Server 24.04向けの設定ファイル（dotfiles）と自動化スクリプトを含みます。快適な開発環境を素早くセットアップするために作成されました。

## 含まれるツール

- **Homebrew**: Linuxパッケージマネージャー
- **Miniforge3**: Pythonの科学計算環境
- **Helix**: モダンなテキストエディタ
- **GitHub CLI**: GitHubをコマンドラインから操作
- **broot**: ファイル管理ツール
- **btop**: システムモニタリングツール
- **Superfile**: ファイル管理ツール
- **Starship**: カスタマイズ可能なプロンプト
- **Volta**: JavaScriptツールマネージャー
- **Claude Code**: Anthropicのコードアシスタント
- **その他**: ripgrep, zoxideなど

## インストール方法

### クイックインストール

```bash
git clone https://github.com/YOUR_USERNAME/Dotfiles_Ubuntu.git
cd Dotfiles_Ubuntu
bash install.sh
```

### ドライランモード

実際の変更を適用せずにスクリプトの動作を確認するには：

```bash
bash install.sh --dry-run
```

## ディレクトリ構造

```
Dotfiles_Ubuntu/
├── install.sh            # メインインストールスクリプト
├── link.sh               # シンボリックリンク作成スクリプト
├── README.md             # このファイル
├── packages/             # 各パッケージのインストールスクリプト
│   ├── brew.sh           # Homebrewインストール
│   ├── miniforge.sh      # Miniforge3インストール
│   ├── helix.sh          # Helixエディタインストール
│   ├── github.sh         # GitHub CLIインストール
│   ├── tools.sh          # その他ツール
│   ├── volta-claude.sh   # VoltaとClaude Codeインストール
│   └── timedate.sh       # システム時刻設定
└── config/               # 設定ファイル
    ├── bash/             # Bashの設定
    ├── helix/            # Helixエディタの設定
    ├── superfile/        # Superfileの設定
    └── starship/         # Starshipの設定
```

## カスタマイズ方法

### Bashの設定

`config/bash/.bashrc`と`config/bash/.bash_aliases`を編集することで、シェル環境をカスタマイズできます。変更後は以下のコマンドで反映：

```bash
source ~/.bashrc
```

### ツールの設定

各ツールの設定は`config/`ディレクトリ内の対応するフォルダにあります。設定を変更した後、`link.sh`を実行することで変更がシステムに反映されます。

```bash
bash link.sh
```

## 更新方法

リポジトリを更新するには：

```bash
cd Dotfiles_Ubuntu
git pull
bash install.sh
bash link.sh
```

## ライセンス

MIT

## 作者

YOUR_NAME
