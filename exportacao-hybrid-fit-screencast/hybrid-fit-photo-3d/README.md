# Hybrid Fit — Stories 3D / v2

Segundo modelo aprovado em **05/10/2026**, com telefone de espessura visível, movimento 3D e zooms orientados pelas ações da screencast. O modelo estático em `../hybrid-fit-stories-mockup/` continua sendo o padrão.

| Pedido | Modelo |
| --- | --- |
| Sem estilo, “edita o cru”, “edit o cru”, original ou v1 | Estático v1 |
| “stories 3D”, “faça um 3D”, “3D” ou “v2” | Este modelo v2 |

O último modelo utilizado não muda o padrão. A skill canônica é [hybrid-fit-screen-mockup](../skills/hybrid-fit-screen-mockup/SKILL.md), com [guia de v2](../skills/hybrid-fit-screen-mockup/references/stories-3d.md).

## Arquivos preservados

- [Vídeo aprovado](renders/experiencia-analise-foto-modelo-3d.mp4) e [entrega no Drive](https://drive.google.com/file/d/1Sbvnjc3AFrCU2XCD6ae_X_nIE6fZXb8O/view?usp=drivesdk).
- [Referência original](references/phone-3d-reference.mp4), [contact sheet](references/contact_sheet_all.jpg) e [decupagem](decupagem-referencia.md).
- [Adaptação à análise por foto](decupagem-e-adaptacao.md), [design](design.md) e [storyboard do exemplo](STORYBOARD.md).
- `templates/approved-example.html.template`: composição congelada da aprovação; `approved-model.json`: fontes, hashes e vínculo de entrega.
- `templates/phone-3d.html.template`: mesma geometria aprovada, com captura/duração/plano substituíveis.
- `camera-plan.example.json`: poses e tempos completos do exemplo; `camera-beats.json`: registro dos beats.
- `incoming/`: fonte original do exemplo. `assets/analysis-photo-seekable.mp4`: captura equivalente para seek no Studio; os 767 quadros decodificados coincidem com a captura usada no render aprovado.
- `qa/`: comprovante de entrega, metadados, frames finais e equivalência da captura. Caches, renders novos e QA de trabalho são ignorados pelo Git.

## Novas capturas

Inspecionar o vídeo e criar um plano de câmera próprio no formato de `camera-plan.example.json`. Ajustar sua duração e os pontos de foco às ações observadas. O plano do exemplo pertence à análise de foto; copiar seus timestamps para outra gravação pode destacar a tela errada.

```powershell
.\render-capture.ps1 -InputVideo 'C:\caminho\captura.mov' -CameraPlan 'C:\caminho\plano.json' -PrepareOnly
# Revisar a composição preparada; depois exportar com um destino novo:
.\render-capture.ps1 -InputVideo 'C:\caminho\captura.mov' -CameraPlan 'C:\caminho\plano.json' -OutputVideo 'C:\caminho\saida-3d.mp4'
```

O preparador conserva a proporção e sequência, normaliza o vídeo para H.264 com GOP curto e gera a composição com chamadas GSAP explícitas. O executor verifica e renderiza em 1080 × 1920, 30 fps, silencioso. A inspeção visual do MP4 final continua obrigatória.

Para reproduzir a demonstração aprovada após trabalhar em outras fontes:

```powershell
.\render-example.ps1 -OutputVideo 'C:\caminho\novo-exemplo-3d.mp4'
```

`npm run check` verifica a composição; `npm run dev` abre o Studio. Agentes usam `npx --yes hyperframes@0.8.134 preview --background` e verificam `preview --status`. Node, FFmpeg e FFprobe precisam estar no PATH. A versão HyperFrames está fixada em 0.8.134; a v1 conserva 0.8.113.
