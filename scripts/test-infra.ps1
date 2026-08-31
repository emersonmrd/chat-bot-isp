Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  TESTE DE SANIDADE DA INFRAESTRUTURA   " -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

$services = @(
    @{ Name = "PostgreSQL"; Port = 5432 },
    @{ Name = "Redis"; Port = 6379 },
    @{ Name = "Evolution API"; Port = 8080; Url = "http://localhost:8080" },
    @{ Name = "n8n"; Port = 5678; Url = "http://localhost:5678/healthz" },
    @{ Name = "Chatwoot"; Port = 3000; Url = "http://localhost:3000" }
)

$allHealthy = $true

foreach ($svc in $services) {
    Write-Host -NoNewline "Verificando $($svc.Name) (Porta $($svc.Port))... "
    
    $tcp = Test-NetConnection -ComputerName "localhost" -Port $svc.Port -WarningAction SilentlyContinue
    if ($tcp.TcpTestSucceeded) {
        Write-Host "[PORTA OK]" -ForegroundColor Green
    } else {
        Write-Host "[FALHA NA PORTA]" -ForegroundColor Red
        $allHealthy = $false
    }
}

Write-Host ""
if ($allHealthy) {
    Write-Host ">>> TODOS OS SERVICOS RESPONDENDO COM SUCESSO! <<<" -ForegroundColor Green
    exit 0
} else {
    Write-Host ">>> ALGUNS SERVICOS AINDA ESTAO INICIANDO OU COM FALHA <<<" -ForegroundColor Yellow
    exit 1
}
