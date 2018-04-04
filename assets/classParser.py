# Format: 
# createYear("3MB", ["Mathé", "German"], [4, 3])

import pandas as pd
from pandas.compat import u

df = pd.read_excel("All Classes.xlsx")

df.fillna("none", inplace=True)

def getColumn(name):
    return df[name].values

classNames = getColumn("ClassNames")
subjectNames = getColumn("SubjectName")
coefs = getColumn("SubjectCoef")

out = ""

lastCoef = -1
currentClass = "none"
currentNames = []
currentCoefs = []
for i in range(len(classNames)):
    if subjectNames[i] == "none":
        if currentClass != "none":
            # get the output
            out += "createYear('" + str(currentClass) + "', " + str(currentNames) + ", " + str(currentCoefs) + ")\n"

        # start a new class 
        currentClass = classNames[i+1]
        currentNames = []
        currentCoefs = []
        continue

    if coefs[i] != "none":
        lastCoef = coefs[i]

    currentNames.append(subjectNames[i])
    currentCoefs.append(int(lastCoef))

import codecs
f = codecs.open("output.txt", "w", "utf-8")
f.write(out.replace("'", '"'))
f.close()