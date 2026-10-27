#!/usr/bin/env bash
# ai-team-setup kurulumu: ~/tools/ai-team-setup'a indirir (ya da günceller) ve `ai-team-setup` komutunu ekler.
# Kullanım: bash install.sh
set -euo pipefail

REPO="https://github.com/hakanngul/ai-team-setup.git"
DIR="$HOME/tools/ai-team-setup"
BIN="$HOME/.local/bin"

command -v git >/dev/null || { echo "HATA: git yok."; exit 1; }
command -v python3 >/dev/null || { echo "HATA: python3 yok."; exit 1; }
python3 -c 'import sys; sys.exit(0 if sys.version_info >= (3, 10) else 1)' || { echo "HATA: Python 3.10+ gerekli."; exit 1; }

if [ -d "$DIR/.git" ]; then
  echo "• Güncelleniyor: $DIR"
  git -C "$DIR" pull --ff-only -q
elif [ -d "$DIR" ] && [ -z "$(ls -A "$DIR")" ]; then
  rmdir "$DIR"
  echo "• İndiriliyor: $DIR"
  git clone -q "$REPO" "$DIR"
elif [ -d "$DIR" ]; then
  echo "HATA: $DIR dolu ve git deposu değil. Taşı ya da sil, sonra tekrar çalıştır."; exit 1
else
  mkdir -p "$(dirname "$DIR")"
  echo "• İndiriliyor: $DIR"
  git clone -q "$REPO" "$DIR"
fi

chmod +x "$DIR/ai-team-setup.py"
mkdir -p "$BIN"
ln -sf "$DIR/ai-team-setup.py" "$BIN/ai-team-setup"
echo "• Komut eklendi: $BIN/ai-team-setup"

case ":$PATH:" in
  *":$BIN:"*) ;;
  *)
    RC="$HOME/.zshrc"; [ -n "${BASH_VERSION:-}" ] && [ "$(basename "${SHELL:-}")" = bash ] && RC="$HOME/.bashrc"
    if ! grep -qs 'HOME/.local/bin' "$RC"; then
      printf '\n# ai-team-setup\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$RC"
      echo "• PATH'e eklendi ($RC). Yeni terminal aç ya da: source $RC"
    fi
    ;;
esac

if command -v uv >/dev/null || command -v pipx >/dev/null; then
  echo "• Graphify için uv/pipx hazır (kurulumda sorulur)."
else
  echo "• Not: Graphify için uv gerekli: curl -LsSf https://astral.sh/uv/install.sh | sh"
fi

echo
echo "Tamam. Kullanım:  ai-team-setup ~/Projects/YeniProje   (önizleme: --dry-run)"
