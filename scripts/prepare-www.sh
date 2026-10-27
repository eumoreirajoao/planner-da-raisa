#!/usr/bin/env bash
# Monta a pasta www/ que vai dentro do APK: a página do planner, as bibliotecas e a configuração.
set -euo pipefail
rm -rf www && mkdir -p www/vendor
{
  printf '<!doctype html>\n<html lang="pt-BR"><head><meta charset="utf-8">'
  printf '<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">'
  printf '<style>:root{color-scheme:light;padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}body{margin:0;font:14px system-ui,sans-serif}img{max-width:100%%}[hidden]{display:none!important}</style>'
  printf '</head><body>\n'
  cat planner.html
  printf '\n</body></html>\n'
} > www/index.html
cp node_modules/@supabase/supabase-js/dist/umd/supabase.js www/vendor/supabase.js
cp node_modules/katex/dist/katex.min.js www/vendor/katex.min.js
node -e '
const e = process.env;
require("fs").writeFileSync("www/build.json", JSON.stringify({
  version: e.VERSION || "dev", build: +(e.BUILD || 0), repo: e.GITHUB_REPOSITORY || "",
  supabaseUrl: e.SUPABASE_URL || "", supabaseKey: e.SUPABASE_ANON_KEY || ""
}));'
echo "www/ pronta (versão ${VERSION:-dev})"
