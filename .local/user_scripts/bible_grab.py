#!/bin/env python3

import urllib.request
import urllib.parse
import os.path
import argparse
from html.parser import HTMLParser
from enum import Enum, auto

# div -> (div ||  p) -> span -> JUICY DATA -> /span -> (/div || /p) -> /div
# stack unwind
# <div>
#   <div or p>
#       Juicy content
#   </div or p>
#   <div or p>
#       Juicy content
#   </div or p>
# </div>
debug = 0

parser = argparse.ArgumentParser()
parser.add_argument('chapter')
parser.add_argument('verses')
args = parser.parse_args()

def log(message):
    if debug == 1:
        print(message)

class StateMachine(Enum):
    topDivNotOpened = auto()
    topDivOpened = auto()

class bibleVerseParser(HTMLParser):
    def __init__(self):
        self.myState = StateMachine.topDivNotOpened
        self.verses = list()
        self.htmlStackDepth = 0
        self.pos = -1
        super().__init__()

    def handle_starttag(self, tag, attrs):
        if self.myState == StateMachine.topDivNotOpened:
            if tag == "div" and ('class', 'version-NRSVCE result-text-style-normal text-html') in attrs:
                log("opening div found")
                self.myState = StateMachine.topDivOpened
        elif self.myState == StateMachine.topDivOpened:
            if self.htmlStackDepth == 0:
                log("valid div or p tag encountered")
                if tag == "div" or tag == "p":
                    self.verses.append(list())
                    self.pos = len(self.verses) - 1
                    self.htmlStackDepth += 1
            else:
                log(f"incrementing stackDepth: {self.htmlStackDepth} + 1")
                self.htmlStackDepth += 1

            if tag == "br":
                log("br encountered")
                self.verses.append(list())
                self.pos = len(self.verses) - 1

            if tag == "div" and ('class', 'footnotes') in attrs:
                log("Footnotes reached, ending parse")
                self.myState = StateMachine.topDivNotOpened


    def handle_data(self, data):
        if self.myState == StateMachine.topDivOpened:
            if self.htmlStackDepth > 1:
                self.verses[self.pos].append(data)

    def handle_endtag(self, tag):
        if self.myState == StateMachine.topDivOpened:
            if self.htmlStackDepth == 1:
                self.verses.append("")
            if self.htmlStackDepth > 0:
                log(f"decrementing stackDepth: {self.htmlStackDepth} - 1")
                self.htmlStackDepth -= 1
            elif self.htmlStackDepth == 0 and tag == "div":
                self.myState = StateMachine.topDivNotOpened
                log("Closing top div")

parser = bibleVerseParser()

query = urllib.parse.urlencode({'search': f"{args.chapter} {args.verses}", 'version': 'nrsvce'})

log(f"Calling -> https://www.biblegateway.com/passage/?{query}")
f = urllib.request.urlopen(f"https://www.biblegateway.com/passage/?{query}")

parser.feed(f.read().decode('utf-8'))

for verse in parser.verses:
    print("".join(verse))
