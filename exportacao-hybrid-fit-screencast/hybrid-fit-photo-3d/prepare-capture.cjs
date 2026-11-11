// Prepara a captura e emite chamadas GSAP explicitas para o checker do HyperFrames.
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const { execFileSync } = require('node:child_process');
const root = __dirname;
const [inputArg, planArg] = process.argv.slice(2);
if (!inputArg || !planArg) throw new Error('Uso: node prepare-capture.cjs CAPTURA PLANO.json');
const input = fs.realpathSync(inputArg);
const planPath = fs.realpathSync(planArg);
const probe = JSON.parse(execFileSync('ffprobe', ['-v','error','-show_streams','-show_format','-of','json',input], { encoding:'utf8' }));
const stream = probe.streams.find(s => s.codec_type === 'video');
if (!stream) throw new Error('A fonte nao tem faixa de video.');
const duration = Number(stream.duration ?? probe.format.duration);
const finite = v => typeof v === 'number' && Number.isFinite(v);
if (!finite(duration) || duration <= 0) throw new Error('Duracao invalida.');
const plan = JSON.parse(fs.readFileSync(planPath, 'utf8').replace(/^\uFEFF/, ''));
if (plan.schemaVersion !== 1 || !finite(plan.durationSeconds) || Math.abs(plan.durationSeconds - duration) > 1/30) {
  throw new Error('O plano precisa ter schemaVersion 1 e a duracao desta captura (+/- um quadro).');
}
function pose(value, keys, label) {
  if (!value || keys.some(k => !finite(value[k]))) throw new Error('Pose incompleta ou invalida: ' + label);
  return Object.fromEntries(keys.map(k => [k, value[k]]));
}
const cameraKeys = ['x','y','z','scale'];
const deviceKeys = ['rotationX','rotationY','rotationZ'];
const initialCamera = pose(plan.initial?.camera, cameraKeys, 'camera inicial');
const initialDevice = pose(plan.initial?.device, deviceKeys, 'aparelho inicial');
if (initialCamera.scale <= 0) throw new Error('Escala precisa ser positiva.');
if (!Array.isArray(plan.beats) || !plan.beats.length) throw new Error('O plano precisa de movimentos.');
let lastEnd = 0;
const labels = new Set();
const moves = plan.beats.map(b => {
  if (!finite(b.at) || !finite(b.d) || b.at < 0 || b.d <= 0 || b.at + b.d > duration + 0.000001 || b.at < lastEnd - 0.000001) {
    throw new Error('Movimento fora da duracao, fora de ordem ou sobreposto: ' + b.label);
  }
  if (typeof b.label !== 'string' || !b.label || labels.has(b.label)) throw new Error('Rotulo vazio ou repetido.');
  labels.add(b.label);
  lastEnd = b.at + b.d;
  const c = pose(b.c, cameraKeys, b.label);
  const p = pose(b.p, deviceKeys, b.label);
  if (c.scale <= 0) throw new Error('Escala precisa ser positiva.');
  return { ...b, c, p };
});
const shadows = plan.shadows ?? [];
for (const b of shadows) {
  if (!finite(b.at) || !finite(b.d) || b.at < 0 || b.d <= 0 || b.at+b.d > duration+0.000001 || !finite(b.scaleX) || !finite(b.opacity) || b.scaleX<=0 || b.opacity<0 || b.opacity>1) {
    throw new Error('Movimento de sombra invalido.');
  }
}
const sha256 = file => crypto.createHash('sha256').update(fs.readFileSync(file)).digest('hex');
const hash = sha256(input);
const approved = JSON.parse(fs.readFileSync(path.join(root, 'approved-model.json'), 'utf8'));
let assetName;
if ([approved.source.sha256, approved.capture.sha256].includes(hash)) {
  assetName = approved.capture.path;
  if (sha256(path.join(root,assetName)) !== approved.capture.sha256) throw new Error('A captura aprovada foi alterada.');
} else {
  assetName = 'assets/capture-' + hash + '.mp4';
  const assetPath = path.join(root,assetName);
  if (!fs.existsSync(assetPath)) {
    // Mantem proporcao, timestamps e a sequencia; remove audio. GOP de um segundo permite seek no Studio.
    const tempPath = assetPath + '.partial.mp4';
    try {
      execFileSync('ffmpeg', ['-v','error','-n','-i',input,'-map','0:v:0','-an','-c:v','libx264','-preset','medium','-crf','16','-pix_fmt','yuv420p','-g','30','-keyint_min','30','-sc_threshold','0','-fps_mode','passthrough','-movflags','+faststart',tempPath], { stdio:'inherit' });
      fs.renameSync(tempPath,assetPath);
    } catch(e) { if (fs.existsSync(tempPath)) fs.unlinkSync(tempPath); throw e; }
  }
}
const ratio = stream.width / stream.height;
if (Math.abs(ratio - 540/1170) > 0.005) console.warn('Outra proporcao: a tela usa contain; confira margens e alvos de foco.');
const lines = [
  'const tl = gsap.timeline({paused:true});',
  `tl.set("#camera", ${JSON.stringify(initialCamera)},0);`,
  `tl.set("#device", ${JSON.stringify(initialDevice)},0);`,
  '// Absolute pose ladder. Camera and object each own disjoint transform channels.'
];
for (const b of moves) {
  lines.push(`tl.addLabel(${JSON.stringify(b.label)},${b.at});`);
  lines.push(`tl.to("#camera", ${JSON.stringify({...b.c,duration:b.d,ease:'power2.inOut'})},${b.at});`);
  lines.push(`tl.to("#device", ${JSON.stringify({...b.p,duration:b.d,ease:'power2.inOut'})},${b.at});`);
}
lines.push(`tl.fromTo(".ambient-light", {x:-45,y:25,scale:0.98}, {x:55,y:-30,scale:1.08,duration:${duration},ease:"sine.inOut"},0);`);
for (const b of shadows) lines.push(`tl.to(".ground-shadow", ${JSON.stringify({scaleX:b.scaleX,opacity:b.opacity,duration:b.d,ease:'power2.inOut'})},${b.at});`);
lines.push('window.__timelines["main"] = tl;');
const template = fs.readFileSync(path.join(root,'templates/phone-3d.html.template'),'utf8');
const composition = template.replaceAll('__DURATION__', duration.toFixed(6)).replaceAll('__CAPTURE_ASSET__',assetName).replace('__CAMERA_JS__',lines.join('\n'));
if (/__(DURATION|CAPTURE_ASSET|CAMERA_JS)__/.test(composition)) throw new Error('Template nao foi preenchido.');
fs.writeFileSync(path.join(root,'index.html'),composition);
const manifest = {
  model:'stories-3d-v2',source:input,sha256:hash,asset:assetName,
  width:stream.width,height:stream.height,duration,
  cameraPlan:planPath,cameraPlanSha256:sha256(planPath),
  output:{width:1080,height:1920,fps:30,audio:false},sourcePreserved:true
};
fs.writeFileSync(path.join(root,'capture.json'),JSON.stringify(manifest,null,2)+'\n');
console.log(`Preparado: ${duration.toFixed(6)} s; ${moves.length} movimentos; modelo stories-3d-v2.`);
