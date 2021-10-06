#!/bin/env python3

import urllib.request
import os.path
from html.parser import HTMLParser
from enum import Enum, auto

# div -> div -> p -> span -> JUICY DATA -> /span -> /p -> /div -> /div
# stack unwind
debug = 0

def log(message):
    if debug == 1:
        print(message)

class StateMachine(Enum):
    topDivNotOpened = auto()
    subDivNotOpened = auto()
    pNotOpened = auto()
    spanNotOpened = auto()
    opened = auto()

class bibleVerseParser(HTMLParser):
    def __init__(self):
        self.myState = StateMachine.topDivNotOpened
        self.verses = list()
        self.pos = -1
        self.firstSubDiv = True
        self.spanIndent = 0
        super().__init__()

    def handle_starttag(self, tag, attrs):
        if self.myState == StateMachine.topDivNotOpened:
            if tag == "div" and ('class', 'version-NRSVCE result-text-style-normal text-html') in attrs:
                log("opening div found")
                self.myState = StateMachine.subDivNotOpened
        elif self.myState == StateMachine.subDivNotOpened:
            if tag == "div":
                log("sub div found")
                self.myState = StateMachine.pNotOpened
        elif self.myState == StateMachine.pNotOpened:
            if tag == "p" and ('class', 'line') in attrs:
                log("verse p found")
                self.myState = StateMachine.spanNotOpened
        elif self.myState == StateMachine.spanNotOpened:
            if tag == "span":
                log("verse span found")
                self.verses.append(list())
                self.pos = len(self.verses) - 1
                self.myState = StateMachine.opened
        elif self.myState == StateMachine.opened:
            if tag == "span":
                self.spanIndent += 1

    def handle_data(self, data):
        if self.myState == StateMachine.opened:
            self.verses[self.pos].append(data)

    def handle_endtag(self, tag):
        if self.myState == StateMachine.subDivNotOpened:
            if tag == "div":
                self.myState = StateMachine.topDivNotOpened
        elif self.myState == StateMachine.pNotOpened:
            if tag == "div":
                self.myState = StateMachine.subDivNotOpened
        elif self.myState == StateMachine.spanNotOpened:
            if tag == "p":
                #if self.firstSubDiv == False:
                self.verses.append("")
                #else:
                #    self.firstSubDiv = False
                self.myState = StateMachine.pNotOpened
        elif self.myState == StateMachine.opened:
            if tag == "span":
                if self.spanIndent > 0:
                    self.spanIndent -= 1
                elif self.spanIndent == 0:
                    self.myState = StateMachine.spanNotOpened

parser = bibleVerseParser()

f = urllib.request.urlopen(f'https://www.biblegateway.com/passage/?search=Lamentations+3%3A22-34&version=NRSVCE')

parser.feed(f.read().decode('utf-8'))

for verse in parser.verses:
    print("".join(verse))
