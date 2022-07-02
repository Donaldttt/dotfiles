import json
import sys
from urllib.request import urlopen

Usage = """
Usage: python3 dict.sh [word]
"""

HAS_RICH = 0
try:
    from rich.console import Console
    HAS_RICH = 1
except:
    pass

def basic_paring(data):
    word = data["word"]
    defs = data["def"]
    samples = data["sample_sentence"]
    ponetic = data["phonetic"]
    
    print(word)

    if len(ponetic.items()) > 0:
        for _, v in ponetic.items():
            print(v, end="  ")
        print()
    print()

    if len(defs) > 0:
        for k in defs:
            print(k, defs[k])
        print()

    for s in samples[:2]:
        print("-", end=" ")
        print(s['en'])
        print()

def rich_paring(data):
    console = Console()
    word = data["word"]
    defs = data["def"]
    ponetic = data["phonetic"]
    samples = data["sample_sentence"]

    console.print(word, style="bold purple")

    if len(ponetic.items()) > 0:
        for _, v in ponetic.items():
            v = v.replace('[', '\[').replace(']', ']')
            console.print(v, style="yellow")
        print()
    print()
    
    if len(defs) > 0:
        for k in defs:
            console.print(k, style="green")
            console.print(defs[k], style="cyan")
        print()

    for s in samples[:2]:
        ens = s['en'].replace('"', '\"')
        console.print("-", end=" ", style="rgb(154,91,2)")
        console.print(ens, style="rgb(165,38,28)")
        print()
        #console.print(s['cn'], style="rgb(13,245,86)")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(Usage)
        exit(1)

    word = sys.argv[1]
    url = "http://10.0.0.100:10008/{}".format(word)
    r = urlopen(url)
    content = r.read()
    json_content = json.loads(content)
    if not HAS_RICH:
        basic_paring(json_content)
    else:
        rich_paring(json_content)
