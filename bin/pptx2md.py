#!/usr/bin/env python3
"""Merge pandoc's Markdown rendering of a .pptx with what pandoc leaves behind.

pandoc reads .pptx, but it emits every slide as a bare "## Slide N" and drops
speaker notes entirely -- and in a Google Slides deck the notes are usually
where the actual argument lives.  This reads the .pptx alongside pandoc's
output and puts back what is missing:

  * real slide titles, taken from the topmost text box (Google's export tags
    every shape as a body placeholder, so there is no title to look up);
  * speaker notes, as a blockquote under each slide;
  * slides in presentation order, which is *not* the order of the slideN.xml
    file names.

Usage:  pptx2md.py <deck.pptx> <pandoc.md> [--slide-images DIR]

With --slide-images, a rendered DIR/slide-NN.png is referenced under each
heading when that file exists.  The merged Markdown body goes to stdout.

Called by the `gslides` shell function; useful on its own for any .pptx.
"""

import os
import re
import sys
import zipfile
from xml.etree import ElementTree as ET

A = "{http://schemas.openxmlformats.org/drawingml/2006/main}"
P = "{http://schemas.openxmlformats.org/presentationml/2006/main}"
R = "{http://schemas.openxmlformats.org/officeDocument/2006/relationships}"

# Consecutive paragraphs at most this long are floating labels off a diagram,
# not prose, and read better on one line than as a column of one-word blocks.
LABEL_MAX = 40


def rels(z, part):
    d, f = part.rsplit("/", 1)
    try:
        root = ET.fromstring(z.read(f"{d}/_rels/{f}.rels"))
    except KeyError:
        return {}
    return {r.get("Id"): r.get("Target") for r in root}


def resolve(base, target):
    """Resolve a relationship target against the part that declares it."""
    if target.startswith("/"):
        return target.lstrip("/")
    stack = []
    for p in (base.rsplit("/", 1)[0] + "/" + target).split("/"):
        if p == "..":
            if stack:
                stack.pop()
        elif p and p != ".":
            stack.append(p)
    return "/".join(stack)


def paras(el):
    out = []
    for p in el.iter(A + "p"):
        t = "".join(n.text or "" for n in p.iter(A + "t")).strip()
        if t:
            out.append(t)
    return out


def ph_type(sp):
    ph = sp.find(f"./{P}nvSpPr/{P}nvPr/{P}ph")
    return ph.get("type") if ph is not None else None


def title_of(root):
    """The first line of the topmost text box on the slide."""
    best = None
    for i, sp in enumerate(root.iter(P + "sp")):
        if ph_type(sp) == "sldNum":
            continue
        ps = paras(sp)
        if not ps:
            continue
        off = sp.find(f".//{A}off")
        y = int(off.get("y")) if off is not None and off.get("y") else 1 << 62
        if best is None or (y, i) < best[:2]:
            best = (y, i, ps[0])
    if best is None:
        return ""
    t = re.sub(r"\s+", " ", best[2]).strip()
    return t if len(t) <= 100 else ""       # a paragraph is not a heading


def notes_of(z, part):
    for tgt in rels(z, part).values():
        p = resolve(part, tgt)
        if "/notesSlides/" not in p:
            continue
        root = ET.fromstring(z.read(p))
        body = [c for sp in root.iter(P + "sp") if ph_type(sp) == "body"
                for c in paras(sp)]
        if not body:
            body = [c for sp in root.iter(P + "sp")
                    if ph_type(sp) != "sldNum" for c in paras(sp)]
        return body
    return []


def norm(s):
    return re.sub(r"\s+", " ", s).strip().lower()


def collapse_labels(body):
    """Join runs of short bare paragraphs -- diagram labels -- onto one line."""
    blocks = re.split(r"\n{2,}", body)
    out, run = [], []

    def flush():
        if len(run) > 1:
            out.append(" · ".join(run))
        elif run:
            out.append(run[0])
        run.clear()

    for b in blocks:
        bare = ("\n" not in b and len(b) <= LABEL_MAX
                and not re.match(r"[-*+>#|!\[]|\d+\.", b.strip()))
        if bare:
            run.append(b.strip())
        else:
            flush()
            out.append(b)
    flush()
    return "\n\n".join(x for x in out if x.strip())


def main():
    argv = sys.argv[1:]
    imgdir = None
    if "--slide-images" in argv:
        i = argv.index("--slide-images")
        imgdir = argv[i + 1]
        del argv[i:i + 2]
    if len(argv) != 2:
        sys.exit("usage: pptx2md.py <deck.pptx> <pandoc.md> [--slide-images DIR]")
    pptx, mdfile = argv

    z = zipfile.ZipFile(pptx)
    pres = ET.fromstring(z.read("ppt/presentation.xml"))
    prel = rels(z, "ppt/presentation.xml")
    order = [resolve("ppt/presentation.xml", prel[s.get(R + "id")])
             for s in pres.find(P + "sldIdLst")]

    meta = []
    for part in order:
        root = ET.fromstring(z.read(part))
        meta.append((title_of(root), notes_of(z, part)))

    with open(mdfile, encoding="utf-8") as fh:
        md = fh.read()
    md = re.sub(r"(?m)^<!-- -->\n?", "", md)                    # shape separators
    md = re.sub(r'(!\[[^\]]*\]\([^)\s]+) "[^"]*"\)', r"\1)", md)  # shape-id titles

    chunks = re.split(r"(?m)^## Slide (\d+)[ \t]*$\n?", md)
    out = [chunks[0].strip()]

    for i in range(1, len(chunks), 2):
        n = int(chunks[i])
        body = chunks[i + 1].strip("\n")
        title, notes = meta[n - 1] if n <= len(meta) else ("", [])

        # The title text is also dumped into the body; do not say it twice.
        if title:
            lines = body.split("\n")
            for j, ln in enumerate(lines):
                if ln.strip() and norm(ln) == norm(title):
                    del lines[j]
                    break
            body = "\n".join(lines).strip("\n")

        out.append(f"## {n}. {title}" if title else f"## Slide {n}")

        if imgdir:
            # pdftoppm pads the page number to the width of the page count.
            for width in (2, 3, 4):
                png = os.path.join(imgdir, f"slide-{n:0{width}d}.png")
                if os.path.exists(png):
                    out.append(f"![Slide {n}]({png})")
                    break

        body = collapse_labels(body)
        if body.strip():
            out.append(body)
        if notes:
            block = "**Notes** — " + "\n\n".join(notes)
            out.append("\n".join("> " + ln if ln else ">"
                                 for ln in block.split("\n")))

    print("\n\n".join(x for x in out if x.strip()) + "\n")


if __name__ == "__main__":
    main()
