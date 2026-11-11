import json
import subprocess
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

reference_dir = Path(__file__).resolve().parent
src = reference_dir / 'phone-3d-reference.mp4'
out = reference_dir / 'analysis-regenerated'
frames = out / 'frames_4fps'
frames.mkdir(parents=True, exist_ok=True)
probe = subprocess.run(['ffprobe','-v','error','-show_format','-show_streams','-of','json',str(src)],capture_output=True,text=True,check=True)
(out / 'metadata.json').write_text(probe.stdout,encoding='utf-8')
subprocess.run(['ffmpeg','-hide_banner','-loglevel','error','-y','-i',str(src),'-vf','fps=4',str(frames / 'frame_%03d.jpg')],check=True)
font = ImageFont.truetype('C:/Windows/Fonts/arial.ttf',20)
small = ImageFont.truetype('C:/Windows/Fonts/arial.ttf',14)
files = sorted(frames.glob('*.jpg'))
for page in range((len(files)+19)//20):
    sheet = Image.new('RGB',(1320,1516),'#151820')
    draw = ImageDraw.Draw(sheet)
    draw.text((12,8),f'Referência • sequência a 4 fps • {page*5:.2f}s–{min(24.75,(page+1)*5-.25):.2f}s',font=font,fill='white')
    for j,f in enumerate(files[page*20:(page+1)*20]):
        im = Image.open(f).resize((252,336),Image.Resampling.LANCZOS)
        x = 12+(j%5)*264
        y = 44+(j//5)*368
        sheet.paste(im,(x,y))
        draw.text((x,y+340),f't={((page*20+j)*.25):05.2f}s',font=font,fill='#bdf4ea')
    sheet.save(out / f'contact_sheet_{page+1:02d}.jpg',quality=94)
master = Image.new('RGB',(1480,2240),'#151820')
d = ImageDraw.Draw(master)
for i,f in enumerate(files):
    im = Image.open(f).resize((140,187),Image.Resampling.LANCZOS)
    x=8+(i%10)*148
    y=8+(i//10)*223
    master.paste(im,(x,y))
    d.text((x,y+191),f'{i*.25:.2f}s',font=small,fill='white')
master.save(out / 'contact_sheet_all.jpg',quality=94)
subprocess.run(['ffmpeg','-hide_banner','-loglevel','error','-y','-i',str(src),'-vn','-c:a','copy',str(out/'reference_audio.m4a')],check=True)
print(json.dumps({'frames':len(files),'sheets':[str(x) for x in sorted(out.glob('contact_sheet*.jpg'))],'metadata':str(out/'metadata.json')}))
