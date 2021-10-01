#!/bin/env python3

import urllib.request
import os.path
from html.parser import HTMLParser
from enum import Enum, auto
from datetime import datetime

class StateMachine(Enum):
    tagNotOpened = auto()
    tagOpened = auto()

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
        if self.myState == StateMachine.tagOpened:
            self.dailyReadings[self.dataPos].append(data)
        elif data == "These are the readings for the memorial":
            self.dailyReadings.append([data])

    def handle_endtag(self, tag):
        if self.myState == StateMachine.tagOpened:
            if tag == "table":
                self.myState = StateMachine.tagNotOpened


parser = DailyReadingsParser()

mass_date = datetime.now().strftime("%Y%m%d")
cache_file = f"/tmp/{mass_date}_mreadings"

if not os.path.exists(cache_file):
    f = urllib.request.urlopen(f'https://universalis.com/australia/{mass_date}/mass.htm')
    parser.feed(f.read().decode('utf-8'))
    with open(cache_file, "w") as w:
        w.write("Today's Readings\n\n")
        for readings in parser.dailyReadings:
            if len(readings) >= 2:
                w.write(f"{readings[0]:-<20}{readings[1]:->30}\n")
            elif len(readings) == 1:
                w.write(f"\n{readings[0]}\n\n")

with open(cache_file, "r") as output:
    print(output.read())
