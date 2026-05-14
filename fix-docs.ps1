# fix-docs.ps1
# Run from: C:\Users\ozoem\Downloads\docs-main (1)\docs-main

$files = Get-ChildItem -Recurse -Filter "*.mdx"

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw

    # Fix 1 — strip nested paths from hrefs, keep only final slug
    # e.g. href="/integration-guides/evm-smart-contracts/handle-stale-data" -> href="/handle-stale-data"
    $content = $content -replace 'href="/[a-z-]+/[a-z-]+/([a-z-]+)"', 'href="/$1"'
    $content = $content -replace 'href="/[a-z-]+/([a-z-]+)"', 'href="/$1"'

    # Fix 2 — strip full domain URLs in hrefs
    $content = $content -replace 'href="https://docs\.ifalabs\.com/[a-z-]+/[a-z-]+/([a-z-]+)"', 'href="/$1"'
    $content = $content -replace 'href="https://docs\.ifalabs\.com/[a-z-]+/([a-z-]+)"', 'href="/$1"'
    $content = $content -replace 'href="https://docs\.ifalabs\.com/([a-z-]+)"', 'href="/$1"'

    # Fix 3 — plain text domain references in markdown links
    $content = $content -replace '\(/[a-z-]+/[a-z-]+/([a-z-]+)\)', '(/$1)'
    $content = $content -replace '\(/[a-z-]+/([a-z-]+)\)', '(/$1)'

    # Fix 4 — emails
    $content = $content -replace 'ifalabstudio@gmail\.com', 'support@ifalabs.com'
    $content = $content -replace 'security@ifalabs\.com', 'support@ifalabs.com'

    Set-Content $file.FullName $content -NoNewline
}

Write-Host "Done. All .mdx files updated."