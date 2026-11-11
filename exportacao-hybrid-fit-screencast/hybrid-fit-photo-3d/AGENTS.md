# Hybrid Fit Stories 3D / v2

Modelo aprovado em 05/10/2026. Antes de editar novas capturas, ler `../skills/hybrid-fit-screen-mockup/SKILL.md` e sua referência `references/stories-3d.md`.

Este projeto só é escolhido quando o usuário pede `3D`, `stories 3D`, `faça um 3D` ou `v2` para as gravações do Hybrid Fit. Sem indicação de estilo, `edita o cru` e pedidos de modelo original/v1 usam `../hybrid-fit-stories-mockup/`.

Preservar a geometria, materiais e linguagem de câmera aprovados em `templates/phone-3d.html.template`. Para novas capturas, inspecionar o fluxo e criar um plano de câmera próprio; executar `render-capture.ps1`. Não editar a composição/temporização do projeto v1.

Usar as skills HyperFrames correspondentes antes de modificar composições. Registrar uma timeline GSAP raiz pausada em `window.__timelines.main`, manter lógica determinística e mídia contínua, sem áudio. Sempre executar `npm run check` após mudanças e conferir o MP4 exportado por decodificação e quadros reais. Não considerar somente o preview como prova da exportação.

O executor altera `index.html` e `capture.json`: processar uma captura de cada vez. `templates/approved-example.html.template`, `camera-plan.example.json`, a referência e o MP4 aprovado são a base de comparação e devem ser preservados.
