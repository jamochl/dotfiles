#!/bin/env python3

import urllib.request
from html.parser import HTMLParser
from enum import Enum

class StateMachine(Enum):
    tagNotOpened = 1
    tagOpened = 2

class DailyReadingsParser(HTMLParser):
    def __init__(self):
        self.myState = StateMachine.tagNotOpened
        self.dataPos = -1
        self.dailyReadings = list()
        super().__init__()

    def handle_starttag(self, tag, attrs):
        if self.myState == StateMachine.tagNotOpened:
            if tag == "table" and ('class', 'each') in attrs:
                self.myState = StateMachine.tagOpened
                self.dailyReadings.append(list())
                self.dataPos = len(self.dailyReadings) - 1

    def handle_data(self, data):
        if data == "These are the readings for the memorial":
            self.dailyReadings.append(list())
            self.dataPos = len(self.dailyReadings) - 1
            self.dailyReadings[self.dataPos].append(data)
        if self.myState == StateMachine.tagOpened:
            self.dailyReadings[self.dataPos].append(data)

    def handle_endtag(self, tag):
        if self.myState == StateMachine.tagOpened:
            if tag == "table":
                self.myState = StateMachine.tagNotOpened


parser = DailyReadingsParser()

f = urllib.request.urlopen('https://universalis.com/australia/20211001/mass.htm')

parser.feed(f.read().decode('utf-8'))

print("Today's Readings\n")

for readings in parser.dailyReadings:
    if len(readings) >= 2:
        print(f"{readings[0]:-<20}{readings[1]:->30}")
    elif len(readings) == 1:
        print(f"\n{readings[0]}\n")
