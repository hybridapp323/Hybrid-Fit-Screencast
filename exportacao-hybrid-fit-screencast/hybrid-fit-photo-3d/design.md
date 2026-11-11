# Hybrid Fit — modelo 02: câmera 3D

Conceito: aproximar o observador da interface real como uma câmera de produto, com um telefone de espessura visível e movimentos contínuos orientados pela análise de foto.

- Canvas: 1080 × 1920, 30 fps. Exemplo aprovado: 25.566667 s. Novas capturas usam sua própria duração integral e um plano de câmera adaptado.
- Identidade herdada: fundo #080F1B, azul #3C83F6, atmosfera #173D79, #112B54, #0B1A30. Neutros do hardware: #D8DCE1, #A8ADB5, #434B57, #919AA7, #D2D9E2, #4B5666, #AEB8C6, #05070A, #151D28, #E9F0FB, #536070, #CBD3DC, #657180, #404955. Tons derivados por alpha e color-mix somente para materiais e sombra.
- Sem tipografia externa: todos os textos pertencem à captura.
- Foco único: a experiência real de análise da refeição, sem cards reconstruídos ou resultados inventados.
- Geometria frontal herdada: 572 × 1202, tela 540 × 1170, margem 15, raio externo 88 e interno 72. Espessura 36 px em camadas rígidas no eixo Z. A frente, o corpo, os botões e a base pertencem ao mesmo objeto 3D.
- Lente fixa: perspectiva 2400 px. A câmera usa translação, escala e deslocamento em Z; a rotação do aparelho muda suavemente. Máximo de inclinação nos planos de contexto; reduzida nos planos de leitura.
- Hardware cinza metálico com reflexo azul fino; a cor do vídeo permanece sem tratamento. Dynamic Island e status bar vêm da fonte.
- Fundo radial herdado, luz difusa deslocando lentamente e sombra ambiente. Sem vinheta/grão/filtros sobre a captura.
- A sequência não muda: contexto → foto → análise → alimentos e macros → avaliação nutricional → substituir refeição → salvar → retorno à dieta.
- Os closes podem cortar as extremidades do aparelho, como na referência. O elemento importante permanece dentro do enquadramento. Abertura e fechamento mostram o telefone inteiro.
- Não girar para o verso, não duplicar aparelhos, não adicionar textos ou trilha sonora. Nenhuma tela vazia introduzida pelo mockup.

## Implementação dos movimentos
Derivações do componente de catálogo `ui-focus-zoom`: um wrapper de câmera por objeto, offsets calculados a partir do centro da região de interesse, aproximação e descanso para leitura. Movimento tridimensional segue a regra `3d-camera-flight`; ritmo de foco, aproximação e recuo segue `multi-phase-camera`.
