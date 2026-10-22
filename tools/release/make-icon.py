import struct, zlib, os

W = H = 256
px = bytearray(W * H * 4)

def put(x, y, c):
    if 0 <= x < W and 0 <= y < H:
        i = (y * W + x) * 4
        px[i:i+4] = bytes(c)

def rect(x0, y0, x1, y1, c):
    for y in range(y0, y1):
        for x in range(x0, x1):
            put(x, y, c)

def circle(cx, cy, r, c):
    for y in range(cy - r, cy + r + 1):
        for x in range(cx - r, cx + r + 1):
            if (x - cx) ** 2 + (y - cy) ** 2 <= r * r:
                put(x, y, c)

# Deep blue field with a thin amber border (the port's own icon: no game artwork).
rect(0, 0, W, H, (18, 26, 46, 255))
rect(8, 8, W - 8, H - 8, (232, 176, 64, 255))
rect(14, 14, W - 14, H - 14, (18, 26, 46, 255))

# Three players: three warm dots in a row.
for n, cx in enumerate((74, 128, 182)):
    circle(cx, 86, 17, (232, 176, 64, 255) if n != 1 else (255, 224, 150, 255))
    rect(cx - 3, 103, cx + 4, 132, (232, 176, 64, 255))

# A simple play arrow at the bottom (the launcher's Play button, not a game sprite).
for i in range(38):
    rect(104 + i, 150 + i, 152 - i, 151 + i, (245, 245, 240, 255))

raw = bytearray()
for y in range(H):
    raw.append(0)
    raw += px[y * W * 4:(y + 1) * W * 4]

def chunk(tag, data):
    return struct.pack(">I", len(data)) + tag + data + struct.pack(">I", zlib.crc32(tag + data) & 0xFFFFFFFF)

png = b"\x89PNG\r\n\x1a\n"
png += chunk(b"IHDR", struct.pack(">IIBBBBB", W, H, 8, 6, 0, 0, 0))
png += chunk(b"IDAT", zlib.compress(bytes(raw), 9))
png += chunk(b"IEND", b"")
out = os.path.join(os.path.dirname(__file__), "dino.png")
open(out, "wb").write(png)
print("wrote", out, len(png), "bytes")
