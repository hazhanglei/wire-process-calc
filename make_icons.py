from PIL import Image, ImageDraw
import math, os

OUT = r"E:\default\Projects\wire-process-calc"
os.makedirs(OUT, exist_ok=True)

S = 512
C = 256

def make():
    img = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)

    # rounded-square background, theme blue
    bg = (56, 116, 167, 255)      # #3874a7
    d.rounded_rectangle([32, 32, S - 32, S - 32], radius=104, fill=bg)

    # cable cross-section (white insulation disc + subtle ring)
    d.ellipse([C - 176, C - 176, C + 176, C + 176], fill=(255, 255, 255, 255))
    d.ellipse([C - 176, C - 176, C + 176, C + 176],
              outline=(203, 213, 224, 255), width=6)

    # copper conductor: 7-strand bundle (1 center + 6 around)
    copper = (208, 130, 58, 255)   # #d0823a
    gap = 4
    sr = 42                        # strand radius
    ring = 46                      # distance center -> outer strand centers
    positions = [(C, C)]
    for i in range(6):
        a = math.radians(60 * i)
        positions.append((C + ring * math.cos(a), C + ring * math.sin(a)))
    for (x, y) in positions:
        d.ellipse([x - sr, y - sr, x + sr, y + sr],
                  fill=copper, outline=(150, 88, 30, 255), width=2)

    return img

base = make()

# PNG sizes for PWA manifest
base.save(os.path.join(OUT, "icon-512.png"))
base.resize((192, 192), Image.LANCZOS).save(os.path.join(OUT, "icon-192.png"))

# favicon (multi-size .ico + a 32 png for modern browsers)
ico = base.resize((32, 32), Image.LANCZOS)
sizes = [(32, 32), (48, 48), (64, 64)]
imgs = [base.resize(s, Image.LANCZOS) for s in sizes]
imgs[0].save(os.path.join(OUT, "favicon.ico"),
             format="ICO", sizes=sizes, append=imgs[1:])

for f in ("icon-512.png", "icon-192.png", "favicon.ico"):
    print(f, os.path.getsize(os.path.join(OUT, f)))
print("OK")
