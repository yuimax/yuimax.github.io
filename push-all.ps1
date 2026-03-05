# 現在の日時をフォーマットして取得
$timestamp = Get-Date -Format "yyyy/MM/dd HH:mm (UTCz)"

# 変更をコミットしてプッシュ
Write-Host "プッシュを開始します..." -ForegroundColor Cyan
git add .
git commit -m "cmt: $timestamp"
git push origin main

# ワークフローが生成されるまで少し待機 (GitHub側の反映待ち)
Write-Host "`nワークフローの生成を待機中..." -ForegroundColor Gray
Start-Sleep -Seconds 3

# 最新の実行IDを取得
# --limit 1 で最新1件に絞り、その ID を取得します
$runID = gh run list --limit 1 --json databaseId --jq '.[0].databaseId'

if (!$runID) {
    Write-Host "`n実行中のワークフローが見つかりませんでした。確認してください。" -ForegroundColor Yellow
    exit
}

# 特定のIDを監視 (選択画面が出ません)
Write-Host "`nワークフロー (ID: $runID) を監視中..." -ForegroundColor Magenta
gh run watch $runID

# 終了をアナウンスする
if ($runID) {
	$conclusion = gh run view $runID --json conclusion --jq '.conclusion'
	if ($conclusion -eq "success") {
		$text = "お待たせしました。JOB が完了しました。";
		$color = "Green";
	} else {
		$text = "`n処理が失敗しました (Result: $conclusion)";
		$color = "Red";
	}
} else {
	$text = "mainブランチに実行中のrunが見つかりませんでした。"
	$color = "Red";
}

Write-Host "`n$text" -ForegroundColor $color;
Add-Type -AssemblyName System.Speech;
$voice = New-Object System.Speech.Synthesis.SpeechSynthesizer;
$voice.Volume = 100;
$voice.Rate = 1;
$voice.Speak($text);


