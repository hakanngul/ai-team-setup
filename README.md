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
| `.team/decisions/_TEMPLATE.md` | Kullanıcı kararı şablonu (`K-<no>`, PENDING / DECIDED); bağlı görev `depends_on: [K-<no>]` |
| `.team/policy.json` | Rol → yazma kapsamı (glob). team.json rollerinden ve klasör cevaplarından üretilir; yalnız kullanıcı değiştirir |
| `.claude/hooks/session_start.py` | SessionStart: rolü tespit eder, açık görevleri, HANDOFF'u (kısaltılmış), bekleyen kararları ve `team_check` özetini bağlama verir |
| `.claude/hooks/guard_write.py` | PreToolUse (Write/Edit/MultiEdit/NotebookEdit): kapsam dışını ve kök dışını (`outside_root_allow` hariç) reddeder; rol bilinmiyorsa izin verir, uyarır |
| `.claude/hooks/stop_check.py` | Stop: HANDOFF bu oturumda güncellenmediyse ya da TEAM.md görevlerden eskiyse oturumda bir kez uyarır |
| `.claude/settings.json` | Hook kayıtları + deny izinleri (force push, main'e push, pkill/killall, `.env*`, `*.pem/.p8/.key` okuma). Varsa birleştirilir (`.bak` alınır) |
| `contracts/API.md` | API sözleşmesi şablonu; tek yazar backend (yoksa web) |
| `contracts/business-rules/_TEMPLATE.yaml` | İş kuralı şablonu: `BR-<ALAN>-NNN`, DRAFT / APPROVED, statement, enforced_by, tested_by, ui_expectation, error |
| `scripts/team_board.py` | `.team/tasks` → `TEAM.md` panosu |
| `scripts/team_check.py` | Defter doğrulayıcı: zorunlu alanlar, status, owner, depends_on, BR kimlikleri; DONE için branch + tests + reviewed_by (+ `user_facing: true` ise qa). `--brief`, hata varsa çıkış 1 |
| `scripts/heavy_job.sh` | Ağır iş kilidi: `heavy_job.sh <rol> <dk> -- <komut>`, FIFO, süre aşımında yalnız kendi süreci, `durum`, `KILIT_ADI=<cihaz>`, log `/tmp/<proje>-heavy-job.log`. Saniye sınırı: `20s` |
| `scripts/resume_role.sh` | `resume_role.sh <rol> "<mesaj>"`: rolün son oturum id'sini bulur, `claude -p --resume` ile arka planda sürdürür (`--id`, `--yazdir`); aynı anda tek arka plan oturumu |

Kurulumda iki ek soru var: hook'lar ve ağır iş kilidi (ikisi de varsayılan evet).
Rol tespiti sırası: `TEAM_ROLE` / `CLAUDE_AGENT` ortam değişkeni, `claude --agent <rol>`, oturum adı, rolün klasörü.

## Kalıcı hafıza

- Dosya tabanlı hafıza her rol için kurulur.
- İsteğe bağlı [Graphify](https://github.com/Graphify-Labs/graphify): kod, doküman ve şemalardan sorgulanabilir bilgi grafiği. Script kurulu değilse `uv tool install graphifyy` ile kurar, `graphify install` ile Claude Code'a kaydeder. İlk grafik için Claude Code'da `/graphify .`.

## Güvenlik

Var olan dosyaların üzerine yazmadan önce sorar ve `.bak` yedeği alır. Gizli bilgi üretmez veya istemez.
