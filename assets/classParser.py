# Format: 
# add("2MB", [mc("Combi", 4, co(["mathe2", "info"], [3, 1])), ms("Mathematiques", 4)])

import pandas as pd
from pandas.compat import u

df = pd.read_excel("All Classes.xlsx")

df.fillna("none", inplace=True)

def getColumn(name):
    return df[name].values

classNames = getColumn("ClassNames")
subjectNames = getColumn("SubjectName")
coefs = getColumn("SubjectCoef")
combiNames = getColumn("CombiName")
combiCoefs = getColumn("CombiCoef")

out = ''

lastCoef = -1
currentClass = "none"
currentMetas = ""
currentCombiNames = []
currentCombiCoefs = []

for i in range(len(classNames)):

    if subjectNames[i] == "none"  and combiNames[i] == "none": # row is empty, new subject starts
        if currentClass != "none": #check if it's not the first row
            # get the output
            out += 'add("{}"'.format(currentClass) + ", " + str(currentMetas[:-2]) + '])  \n'
       
        # start a new class 
        currentClass = classNames[i+1]
        currentMetas = "["
        continue

    if subjectNames[i] != "none" and len(currentCombiNames) > 0: # check if combi streak ended
        # print and reset the combi subjects
        subIndex = i-len(currentCombiCoefs)
        currentMetas += 'mc("{}", {}, co({}, {})), '.format(subjectNames[subIndex], lastCoef, currentCombiNames, currentCombiCoefs)
        currentCombiNames = []
        currentCombiCoefs = []

        if coefs[i] != "none":
            lastCoef = coefs[i]

    if coefs[i] != "none": # always check if coef got updated
        lastCoef = coefs[i]

    if combiNames[i] != "none": # check if this is a combi subject
        # this is a combi subject
        currentCombiNames.append(combiNames[i])
        currentCombiCoefs.append(combiCoefs[i])
        continue

    currentMetas += 'ms("{}", {}), '.format(subjectNames[i], lastCoef)

out = out.replace("'", '"')

import codecs
f = codecs.open("output.txt", "w", "utf-8")
f.write(out)
f.close()

f = codecs.open("console.txt", "w", "utf-8")
f.write(str(df.SubjectName.unique().tolist()))
f.close()