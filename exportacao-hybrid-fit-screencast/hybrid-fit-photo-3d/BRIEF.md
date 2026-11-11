---
workflow: general-video
flow: automation
storyboard: no
message: "Uma foto da refeição se transforma em alimentos, quantidades, macros e uma atualização da dieta."
destination: "Exemplo para avaliação, entregue em Hybrid Fit → gravações tela no Google Drive"
aspect: 1080x1920
language: pt-BR
narration: no
length: "25.566667 s, gravação integral"
---

## Intent
**Registro histórico do protótipo.** Após a entrega, o usuário aprovou este modelo em 05/10/2026 e autorizou salvar a referência/modelo e atualizar AGENTS e a skill para seleção explícita de 3D/v2. As restrições abaixo sobre não atualizar skills aplicavam-se somente à criação inicial. O fluxo atual está em `README.md` e na skill do repositório.

Pedido explícito: analisar e decupar a referência anexada, criar e renderizar um segundo modelo caprichado com celular em 3D e zooms na tela, usando a captura do Drive fornecida, e enviar o MP4 ao Drive. O modelo aprovado, o executor e todas as skills ficam intactos. O usuário avaliará o vídeo pronto; esta entrega é um protótipo separado.

## Assets
- Referência local: E:/Downloads/ssstwitter.com_1791219255152 (2).mp4. Fonte visual, sem reutilizar seu conteúdo ou áudio.
- Captura: Drive 1pIkFnceVMcHhvqmai7jpjR3O6oDrufht, 886 × 1920, vídeo 25.566667 s, 767 frames. Cópia original preservada em incoming/.
- Material do mockup aprovado reaproveitado como ponto de partida, com arquivos novos em outro diretório.

## Customizations
Decisões do usuário: segunda opção separada, tela real da feature de análise por foto, profundidade 3D, aproximações, análise da referência e entrega no Drive.
Decisões de direção assumidas para o exemplo: Stories 1080 × 1920 a 30 fps para manter compatibilidade com as gravações existentes; identidade azul escura; sequência e velocidade integrais; nenhum texto editorial, narração ou música; aproximações orientadas pela ação e rotações suaves, sem giros que ocultem a tela. Saída silenciosa como no fluxo atual. O MP4 é o resultado para avaliação solicitado, portanto a renderização e o upload já estão autorizados no pedido.

## Constraints
Não modificar hybrid-fit-stories-mockup/, AGENTS.md ou nenhuma SKILL.md. Não atualizar skills nem preferências pessoais. Não substituir arquivos do Drive nem modificar compartilhamento. Manter a fonte em Cru neste teste de um novo modelo: não executar a limpeza do fluxo de produção aprovado durante avaliação de protótipo.

## Acceptance
- FR-1: o mesmo celular mantém identidade e espessura durante as mudanças de perspectiva.
- FR-2: a captura permanece na proporção original, sem duplicar Dynamic Island ou inventar UI.
- FR-3: zooms mostram análise, alimentos detectados, quantidades e avaliação nutricional em momentos observados.
- FR-4: plano final preserva aparelho visível e gravação até seu último quadro.
- SC-1: MP4 1080 × 1920 a 30 fps, duração 25.566667 s ± 1 frame, sem faixa de áudio.
- SC-2: check passa e vídeo inteiro decodifica sem erros; frames do MP4 final inspecionados.
- SC-3: hashes dos arquivos protegidos permanecem iguais; upload confirmado por nome, bytes e parent.
