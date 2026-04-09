# Strip block comments (/* */), HTML comments (<!-- -->), and leading-line // comments
# Runs recursively from the workspace root

$root = Get-Location
$patternBlock = '/\*.*?\*/'
$patternHtml = '<!--.*?-->'
$patternLine = '^[ \t]*//.*'

$files = Get-ChildItem -Path $root -Recurse -Include *.js,*.css,*.html -File
foreach ($f in $files) {
    try {
        $text = Get-Content -Raw -Encoding UTF8 $f.FullName
    } catch {
        Write-Output "Skipping (read error): $($f.FullName)"
        continue
    }

    $orig = $text
    $text = [regex]::Replace($text, $patternBlock, '', [System.Text.RegularExpressions.RegexOptions]::Singleline)
    $text = [regex]::Replace($text, $patternHtml, '', [System.Text.RegularExpressions.RegexOptions]::Singleline)
    $text = [regex]::Replace($text, $patternLine, '', [System.Text.RegularExpressions.RegexOptions]::Multiline)

    if ($text -ne $orig) {
        Set-Content -Path $f.FullName -Value $text -Encoding UTF8
        Write-Output "Processed: $($f.FullName)"
    } else {
        Write-Output "No change: $($f.FullName)"
    }
}
