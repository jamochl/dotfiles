#!/bin/python3

# Script to create, view and edit notes in my notes directory
# $1 greps category, $2 greps note. If more than one, return numbered list of
# results and when chosen, enter in vim

# I really need to plan out my scripts better

import os
import subprocess
import sys
import re

DIR = os.path.expanduser('~/notesv2')

def editNote (path):
    subprocess.run(["vim", "path"])


def createNote (path, category, noteName):
    subprocess.run(["mkdir", "-p", f"{path}/{category}"])
    subprocess.run(["vim", f"{path}/{category}/__{noteName}.md"])


def lineInsensitiveGrep (lines, search):
    matchLines = []
    caseFoldedSearch = search.casefold()
    for line in lines:
        if line.casefold().find(caseFoldedSearch) > 0:
            matchLines.append(line)
    return matchLines

def isInt(n):
    try:
        int(n)
        return True
    except ValueError:
        return False

def narrowChoice (list):
    for index, item in enumerate(list, start=0):
        print(f"[{index}]: {item}")
    while True:
        inputNumber = input("choose number[0]:> ")
        number = 0
        if isInt(inputNumber):
            number = int(inputNumber)
        if int(inputNumber[0]) < len(list) and int(inputNumber[0]) >= 0:
            return int(inputNumber)
        else:
            print(f"input {inputNumber} is invalid")


if len(sys.argv) < 2:
    print("Needs at least two args")
    exit(1)


argOne = sys.argv[1]
argTwo = sys.argv[2]
print(f"args are: {sys.argv}")

categoryProc = subprocess.run(["find", DIR, "-type", "d", "-iname", f"*{argOne}*"],
                              stdout=subprocess.PIPE, text=True)
arrayCategory = categoryProc.stdout.strip().split('\n');
print(arrayCategory)

# For each category display full tree and save into string
for category in arrayCategory:
    print(os.listdir(category))


listNotes = lineInsensitiveGrep(arrayCategory, argTwo)
print(listNotes)

print('end')
# createNote(dir, 'test', 'test')
