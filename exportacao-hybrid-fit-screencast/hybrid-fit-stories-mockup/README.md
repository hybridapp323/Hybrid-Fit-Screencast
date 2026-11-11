# Hybrid Fit — modelo 01 para Stories

Modelo reutilizável de vídeo vertical. Fundo azul escuro, iPhone frontal fixo e área livre acima para textos adicionados depois. Sem textos, música ou animação do aparelho.

## Entrega inicial

- `renders/hybrid-fit-stories-modelo-01-v2.mp4` — versão atual, com iPhone 18% maior conforme a marcação do usuário.
- `renders/hybrid-fit-stories-modelo-01.mp4` — primeira versão preservada.
- 1080 × 1920, 30 fps, 26,4 segundos, silencioso.
- A captura original está em `assets/screen-01.mp4`.
- `index.html` é a composição editável do HyperFrames.
- `design.md` registra as medidas e a identidade visual.

## Colocar outra captura

Captura 02 já aplicada: `renders/hybrid-fit-stories-captura-02.mp4`, aproximadamente 24 segundos, mesmo mockup e fundo. A fonte e seu hash estão em `capture.json`.

No PowerShell, dentro desta pasta:

```powershell
.\render-capture.ps1 -InputVideo 'E:\Downloads\nova-captura.mp4'
```

O comando preserva o arquivo original, copia a nova captura para um nome baseado no hash, atualiza a duração, confere a composição e exporta um novo MP4 com data e hora. O fundo, o iPhone, a posição e o tamanho permanecem iguais. O áudio fica desligado.

Para apenas preparar a captura e revisar antes de exportar:

```powershell
.\render-capture.ps1 -InputVideo 'E:\Downloads\nova-captura.mp4' -PrepareOnly
npx hyperframes preview --background
```

O enquadramento é ideal para gravações com proporção 480:1040 (6:13). Outras proporções cabem integralmente na tela, com margens quando necessário. Conferir o encaixe se a captura mudar de aparelho ou resolução.

## Texto acrescentado depois

A área acima do aparelho tem cerca de 402 px de altura. Uma região prática para textos é x=100..980, y=170..350. Essas guias não aparecem no vídeo.

## Verificação

Após cada nova captura, conferir um quadro do início, do meio e do fim do MP4. O telefone deve ficar parado, com a captura dentro dos cantos arredondados e sem tela preta inesperada. A duração deve corresponder à gravação original, com arredondamento máximo de um quadro na saída a 30 fps.

Produção local com HyperFrames 0.8.111. Modelo visual adaptado do componente `device-frame-stage`, sem os movimentos de entrada, flutuação ou saída.
