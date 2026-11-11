---
name: hybrid-fit-screen-mockup
description: "Edita screencasts e stories do Hybrid Fit, recebidos no chat ou na fila Cru do Drive. Usa o mockup estático v1 por padrão, inclusive em edita o cru; usa o modelo 3D v2 somente em pedidos explícitos como stories 3D, faça um 3D ou v2. Nomeia pela experiência, entrega em gravações tela e remove de Cru apenas a fonte concluída."
---

# Gravações de tela do Hybrid Fit

## Resultado esperado

Usar o modelo existente, conferir o vídeo e enviar o MP4 com nome descritivo para a pasta definida abaixo. Esse é o fluxo pedido pelo usuário para novas capturas. Uma instrução atual como “só local”, “não subir” ou uma alteração visual prevalece. Uma consulta ou análise de vídeo, sozinha, não pede render nem upload.

Não reabrir entrevista de design para aplicar estes modelos: fundo, geometria, silêncio e ausência de texto editorial já estão aprovados. Não criar um projeto novo ou refazer o iPhone.

## Escolher o modelo antes de preparar a captura

| Pedido no contexto das gravações do Hybrid Fit | Modelo |
| --- | --- |
| Sem indicação de estilo; “edita o cru”, “edit o cru”, “edite as gravações”, “faz igual aos anteriores” | **v1 estático**, `hybrid-fit-stories-mockup/` |
| “stories 3D”, “faça um 3D”, “faz em 3D”, “3D”, “v2”, “edita o cru em 3D” | **v2 3D**, `hybrid-fit-photo-3d/` |
| “original”, “v1”, “estático”, “sem 3D” | **v1 estático** |

3D/v2 precisa ser uma escolha afirmativa do usuário para esta edição; menção negada, número de versão de outro assunto ou o último modelo usado não muda o padrão. Uma indicação explícita de 3D/v2 também vale quando a fonte vem de Cru. Se houver duas instruções de estilo conflitantes na mesma solicitação, esclarecer apenas essa escolha.

Para **v2**, ler [o guia de stories 3D](references/stories-3d.md) antes de preparar a captura. Ele registra a referência, o exemplo aprovado, o plano de câmera e o executor. As regras abaixo de inspeção, fila, nomeação, destino, confirmação e limpeza valem para ambos. As restrições visuais e o comando da seção v1 não se aplicam à v2.

## Projeto e visual aprovados — v1 padrão

- Repositório: `C:/dev/videos`.
- Projeto: `C:/dev/videos/hybrid-fit-stories-mockup`.
- Composição: `index.html`; dimensões e intenção: `design.md`.
- Executor existente: `render-capture.ps1`.
- 1080 × 1920, 30 fps, fundo azul escuro, iPhone frontal estático com `scale(1.18)` e centro preservado. Aproximadamente 402 px livres acima do aparelho.
- Sem textos editoriais, logo adicional, música, áudio, zoom ou transição. O texto que já aparece na gravação permanece.
- Manter sequência, velocidade e duração integrais; arredondamento máximo de um quadro na exportação. Usar `object-fit: contain`, sem esticar ou cortar a interface. A Dynamic Island já vem na captura; não duplicar.

Ler o `AGENTS.md` do projeto. Usar as skills HyperFrames e Google Drive disponíveis apenas nas operações correspondentes, aproveitando o projeto existente. Não reinstalar ferramentas ou recriar o fluxo sem necessidade.

## Inspecionar e escolher o nome

### Entrada pelo chat ou pela fila Cru

- Um arquivo ou link específico enviado pelo usuário tem prioridade. Se o pedido for aplicar/editar as gravações do Hybrid Fit e não trouxer uma fonte específica, buscar diretamente a fila **Hybrid Fit → gravações tela → Cru**. Não pedir que o usuário anexe o vídeo que já está nessa pasta.
- Pasta Cru: **`1ZBMQy_yoheQi887N1Ljdc7UOCdU5R0Zm`**; URL: https://drive.google.com/drive/folders/1ZBMQy_yoheQi887N1Ljdc7UOCdU5R0Zm
- Listar os vídeos diretamente nessa pasta. Sem seleção explícita, processar os vídeos pendentes encontrados no início da execução, um de cada vez, do mais antigo ao mais recente. Não incluir subpastas ou arquivos que chegarem depois. Se não houver vídeos, informar que a fila está vazia.
- Antes de renderizar uma fonte da fila, consultar os registros `qa/*-delivery.json`, `qa/delivery.json` e `.md` dos dois projetos pelo ID do Drive e pela versão baixada. Se já houver saída confirmada **do modelo selecionado** e somente a limpeza estiver pendente, verificar a saída e tratar apenas a remoção; não gerar outro vídeo. Uma entrega de v1 não substitui uma nova edição v2 pedida explicitamente. Registros antigos sem `model` representam v1, exceto o exemplo 3D documentado em `hybrid-fit-photo-3d/qa/delivery.json`.
- Ler metadados e confirmar MIME, tamanho e parent antes de baixar. Usar `google_drive_fetch` com `download_raw_file=true` e `include_base64=false`. Materializar o `file_uri` autenticado ou seu `download_url` em `incoming/<ID_DO_DRIVE>.<extensão>`; não expor a URL temporária nem usar links públicos alternativos. Confirmar o tamanho baixado.
- Registrar o ID da fonte, seu nome, tamanho/hash e parent em `qa/`. A remoção de Cru depende desse vínculo exato entre fonte e entrega; nunca selecionar o arquivo a excluir apenas pelo nome.

1. Confirmar o arquivo fornecido e usar `ffprobe` para duração, dimensões e rotação.
2. Extrair e **ver** uma contact sheet com quadros do início, meio e fim e das principais mudanças. Para uma primeira amostra de cinco quadros, calcular `intervalo = duração / 5` e usar `ffmpeg -vf "fps=1/INTERVALO,scale=270:-1,tile=5x1" -frames:v 1 ...`. Substituir INTERVALO pelo número com ponto decimal. Se a ação não estiver clara, inspecionar quadros adicionais.
3. Nomear pela experiência principal demonstrada, considerando o vídeo inteiro. Uma tela inicial de dieta seguida de abertura de medalhas é uma experiência de conquista. Não decidir pelo nome do arquivo, primeiro quadro ou cor do app.

| Conteúdo observado | Nome no Drive |
| --- | --- |
| Dieta, refeições, análise de comida por foto, cardápio | `experiência dieta.mp4` |
| Medalhas, desbloqueios, coleção ou compartilhamento de conquista | `experiência conquista.mp4` |
| Exercícios, séries, execução ou plano de treino | `experiência treino.mp4` |
| Corrida, percurso, ritmo ou sessão de corrida | `experiência corrida.mp4` |

Para outra função, usar `experiência <função observada>.mp4`. Para um vídeo com várias funções igualmente importantes, escolher um nome curto que as represente. Perguntar apenas se a inspeção não permitir identificar o assunto. Um nome explicitamente fornecido pelo usuário prevalece.

Evitar nomes genéricos como “Captura 02” ou o nome do WhatsApp. A palavra “experiência” é nome de arquivo, **não** texto para colocar no vídeo.

Em v2, acrescentar ` - 3D` ao nome, por exemplo `experiência dieta - 3D.mp4`, salvo nome explícito do usuário. Manter o sufixo de duplicatas depois do estilo: `experiência dieta - 3D - 02.mp4`.

## Renderizar e conferir

Os executores alteram `index.html` e `capture.json` no projeto selecionado; processar capturas **uma de cada vez**. Preservar vídeos anteriores e cópias locais dos originais. As fontes na fila Cru só são removidas ao concluir o fluxo abaixo. Usar um nome local único, por exemplo `experiencia-conquista-20261002-114437.mp4`.

**Comando de v1:**

```powershell
Set-Location 'C:\dev\videos\hybrid-fit-stories-mockup'
.\render-capture.ps1 -InputVideo 'CAMINHO_ABSOLUTO_DA_CAPTURA' -OutputVideo 'CAMINHO_ABSOLUTO_DO_NOVO_MP4'
```

Substituir os caminhos por valores reais. O script copia a fonte para assets com hash, atualiza src/duração, executa `npm run check` e exporta. Para revisar antes do render, usar `-PrepareOnly` e então os comandos HyperFrames do projeto. Não usar saída já existente.

**Para v2**, usar o executor e plano de câmera descritos em [stories-3d.md](references/stories-3d.md); não passar a fonte pelo executor v1.

Conferir o MP4 final com `ffprobe` e decodificação integral (`ffmpeg -v error -i ARQUIVO -f null NUL`). Extrair e ver quadros do início, meio e fim e das principais ações do **MP4 exportado**. Confirmar tela dentro dos cantos do aparelho, reprodução real da nova captura, duração correta e ausência de áudio. **V1:** aparelho estável e inteiro durante todo o vídeo. **V2:** movimento suave e volume rígido; telefone inteiro na abertura/fechamento, closes intencionais com a ação relevante legível, sem congelar a captura. Uma proporção diferente pode gerar margens estreitas; conferir visualmente e preservar a proporção.

Salvar evidência e a fonte em `qa/` com nome próprio da captura. Não enviar ao Drive um render que falhou ou cuja tela ficou vazia. Após duas tentativas sem resolver a mesma falha, informar o problema concreto e preservar os arquivos para correção.

## Destino fixo no Google Drive

- Caminho: **Hybrid Fit → gravações tela**.
- Pasta Hybrid Fit: `14uI5YyqOk_t2COuEDNV0t6LZjE5ZoCEl`.
- Pasta de destino: **`1NyONuP-Gcz8zKJREMinr3ZVsuqn6i6jd`**.
- URL: https://drive.google.com/drive/folders/1NyONuP-Gcz8zKJREMinr3ZVsuqn6i6jd

Existem duas pastas chamadas Hybrid Fit neste Drive. Usar o ID acima, sem escolher outra por busca de nome e sem criar outra pasta “gravações tela”.

1. Usar o conector Google Drive para ler os metadados da pasta e listar seus arquivos. Confirmar o destino acessível. Se não existir ou faltar acesso, entregar o MP4 local e informar a limitação; não subir em outra pasta.
2. Nomear conforme a inspeção. Se o nome existir, usar o próximo sufixo livre: `experiência dieta - 02.mp4`, `experiência dieta - 03.mp4`. Não substituir nem renomear vídeos anteriores sem pedido.
3. Descobrir o schema atual de `google_drive_upload_file`. Neste ambiente, `file_uri` recebe o caminho local absoluto; `file_name` recebe o nome descritivo, `mime_type` é `video/mp4` e `parent_folder_id` é `1NyONuP-Gcz8zKJREMinr3ZVsuqn6i6jd`. O host materializa o upload. Nunca enviar base64 manualmente nem usar serviço público intermediário.
4. Aguardar a conclusão e ler os metadados do arquivo criado. Conferir nome, tamanho em bytes e parent. Retornar somente link observado na resposta do conector. Não modificar compartilhamento.
5. Se o upload tiver resultado incerto, listar a pasta e conferir nome/tamanho antes de repetir, para não criar duplicatas. Registrar nome, ID, URL, tamanho, fonte local/ID de origem e `model` (`stories-v1` ou `stories-3d-v2`) em `qa/<nome>-delivery.json` ou `.md` no projeto selecionado. Para v2, registrar também o caminho/hash do plano de câmera usado.

## Remover de Cru somente depois da entrega

O usuário autorizou retirar da fila os originais concluídos. A sequência é obrigatória: baixar e preservar cópia local → renderizar → inspecionar o MP4 final → subir em gravações tela → confirmar metadados da saída → remover **somente a fonte processada** de Cru.

- Antes da remoção, reler metadados da fonte e confirmar o parent Cru e que tamanho/modified_time correspondem à versão baixada. Se a fonte tiver sido alterada ou movida, preservar e informar.
- Preferir mover a fonte para a lixeira quando o mecanismo disponível permitir. Não confundir o `google_drive_delete_file` com lixeira: essa ferramenta exclui definitivamente. Se somente essa exclusão estiver disponível, a remoção pedida pelo usuário pode ser feita após todas as verificações acima e preservação da cópia local; informar a forma usada com precisão.
- Nunca excluir a pasta Cru, outro vídeo pendente ou o arquivo final editado. Fontes fornecidas só por caminho local ou de outras pastas não entram nesta limpeza.
- Confirmar por nova listagem que o ID da fonte saiu de Cru. Registrar `source_cleanup` e o modo usado no comprovante da entrega.
- Se qualquer etapa anterior falhar, não remover a fonte. Se apenas a limpeza falhar, entregar o link do resultado e informar que o original continua pendente; numa nova execução, usar o registro fonte→saída para verificar a entrega e retomar somente a limpeza, sem renderizar/subir duplicado.
- Um erro `403 appNotAuthorizedToFile` significa que o conector não recebeu acesso de escrita àquele arquivo, mesmo que consiga lê-lo e criar arquivos na pasta. Registrar esse bloqueio, não repetir a exclusão nem tentar contornar a permissão, e informar que o original continua em Cru. O usuário pode removê-lo manualmente ou ajustar o acesso do conector.

Entregar uma resposta curta com nome, duração e link do vídeo. Se o usuário pediu apenas saída local, devolver o link local. Se faltar autenticação do Drive, concluir a exportação local e explicar que o envio ficou pendente.
