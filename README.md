# ai-team-setup

Claude Code için yapay zekâ ekip kurulumu. Etkileşimli sorularla ürünü öğrenir, gereken rolleri önerir ve projeye ekip yapısını kurar.

**Roller:** team-lead, web (full-stack), backend, frontend, flutter, ios, android, qa, araştırmacı (iş akışı / kural denetçisi), devops, tasarımcı.

## Kurulum (tek komut)

```bash
curl -fsSL -H "Authorization: token $(gh auth token)" https://raw.githubusercontent.com/hakanngul/ai-team-setup/main/install.sh | bash
```

ya da depoyu indirdiysen `bash install.sh`. `~/tools/ai-team-setup`'a kurar ve `ai-team-setup` komutunu ekler; tekrar çalıştırınca günceller.

## Kullanım

```bash
python3 ai-team-setup.py ~/Projects/YeniProje            # etkileşimli kurulum
python3 ai-team-setup.py ~/Projects/YeniProje --dry-run  # dosya yazmadan önizleme
```

Gereksinim: Python 3.10+ (yalnız standart kütüphane). Graphify için `uv` ya da `pipx`.

## Ürettikleri

| Yol | İçerik |
|---|---|
| `CLAUDE.md` | Ekibin tek kural kaynağı: roller, görev akışı, QA kapısı, kanıtla review, push / gizli bilgi kuralları, hafıza kuralları |
| `.claude/agents/<rol>.md` | Rol tanımı (`claude --agent <rol>` ya da subagent) |
| `.claude/agent-memory/<rol>/` | `MEMORY.md` (kalıcı kurallar) + `HANDOFF.md` (güncel durum) |
| `.claude/skills/` | görev-aç, görev-review, qa-doğrula, kural-denetimi, oturum-sonu |
| `.team/` | Görev defteri (`tasks/`), mesaj protokolü, kararlar günlüğü, `team.json` |
| `scripts/team_board.py` | `.team/tasks` → `TEAM.md` panosu |

## Kalıcı hafıza

- Dosya tabanlı hafıza her rol için kurulur.
- İsteğe bağlı [Graphify](https://github.com/Graphify-Labs/graphify): kod, doküman ve şemalardan sorgulanabilir bilgi grafiği. Script kurulu değilse `uv tool install graphifyy` ile kurar, `graphify install` ile Claude Code'a kaydeder. İlk grafik için Claude Code'da `/graphify .`.

## Güvenlik

Var olan dosyaların üzerine yazmadan önce sorar ve `.bak` yedeği alır. Gizli bilgi üretmez veya istemez.
