#!/bin/env python3

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
                self.dailyReadings.append("")
                self.dataPos = len(self.dailyReadings) - 1
                print("Table tag opened")

    def handle_data(self, data):
        if self.myState == StateMachine.tagOpened:
            self.dailyReadings[self.dataPos] += data + "\t"
            print("Adding data:", data)

    def handle_endtag(self, tag):
        if self.myState == StateMachine.tagOpened:
            if tag == "table":
                self.myState = StateMachine.tagNotOpened
                print("Table tag closed")


parser = DailyReadingsParser()
f = open("mass.htm", "r")

parser.feed(f.read())
