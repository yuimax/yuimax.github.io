# 現在の日時を取得
$timestamp = Get-Date -Format "yyyy/MM/dd HH:mm (UTCz)"

# ローカルリポジトリの変更をコミットしてプッシュ
git add .
git commit -m "cmt: $timestamp"
git push origin main

# GitHubの準備ができるまで少し待つ
Start-Sleep -Seconds 3

# 最新の実行IDを取得
$id = gh run list --limit 1 --json databaseId --jq '.[0].databaseId'
if (!$id) {
    Write-Host "`n実行中の Actions がありません。"
    exit
}

# 実行IDを監視
gh run watch $id

# 終了メッセージを表示する
$result = gh run view $id --json conclusion --jq '.conclusion'
if ($result -eq "success") {
    Write-Host "`nActions が完了しました。";
} else {
    Write-Host "`n処理が失敗しました (Result: $result)"
}
