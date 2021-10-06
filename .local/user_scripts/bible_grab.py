#!/bin/env python3

import urllib.request
import os.path
from html.parser import HTMLParser
from enum import Enum, auto

class StateMachine(Enum):
    wrapperNotOpened = auto()
    verseNotOpened = auto()
    verseOpened = auto()

class bibleVerseParser(HTMLParser):
    def __init__(self):
        self.myState = StateMachine.wrapperNotOpened
        self.verses = list()
        super().__init__()

    def handle_starttag(self, tag, attrs):
        if self.myState == StateMachine.wrapperNotOpened:
            if tag == "div" and ('class', 'version-NRSVCE result-text-style-normal text-html') in attrs:
                print("opening div found")
                self.myState = StateMachine.verseNotOpened
        elif self.myState == StateMachine.verseNotOpened:
            if tag == "p" and ('class', 'line') in attrs:
                print("verse p found")
                self.myState = StateMachine.verseOpened

    def handle_data(self, data):
        if self.myState == StateMachine.verseOpened:
            self.verses.append(data)

    def handle_endtag(self, tag):
        if self.myState == StateMachine.verseOpened:
            if tag == "p":
                self.myState = StateMachine.verseNotOpened
        elif self.myState == StateMachine.verseNotOpened:
            if tag == "div":
                self.myState = StateMachine.wrapperNotOpened


parser = bibleVerseParser()

f = urllib.request.urlopen(f'https://www.biblegateway.com/passage/?search=Lamentations+3%3A22-24&version=NRSVCE')

parser.feed(f.read().decode('utf-8'))

for verse in parser.verses:
    print(verse)
