import codecs
import pandas as pd
import json

df = pd.read_excel("All Classes.xlsx")

df.fillna("none", inplace=True)


def getColumn(name):
    return df[name].values


# insert a .1 or .2 to access the differen columns
# example: ClassNames or ClassNames.1 or ClassNames.2
classNames = getColumn("ClassNames.1")
subjectNames = getColumn("SubjectName.1")
coefs = getColumn("SubjectCoef.1")
combiNames = getColumn("CombiName.1")
combiCoefs = getColumn("CombiCoef.1")

out = []

lastCoef = -1
currentClass = {}
currentCombiSubject = {
    "subSubjects": []
}

for i in range(len(classNames)-1):

    if coefs[i] != "none":  # always check if coef got updated
        lastCoef = coefs[i]

    # row is empty, new subject starts
    if subjectNames[i] == "none" and combiNames[i] == "none":

        # keep the computed class
        if currentClass != {}:  # check if not the first row
            if currentClass["name"] != "none":  # check if not empty finishing part
                out.append(currentClass)

        # start a new class
        currentClass = {
            "name": classNames[i+1],
            "subjects": []
        }
        continue

    if subjectNames[i] != "none" and combiNames[i] != "none":
        # new combi subject has started
        currentCombiSubject = {
            "name": subjectNames[i],
            "coef": lastCoef,
            "subSubjects": []
        }

    if combiNames[i] != "none":
        # add row to subSubjects
        currentCombiSubject["subSubjects"].append({
            "name": combiNames[i],
            "coef": combiCoefs[i]
        })
        continue

    if subjectNames[i] != "none" and combiNames[i-1] != "none":
        # combi subject has ended!
        currentClass["subjects"].append(currentCombiSubject)

    # if the code gets here it is a normal subject
    currentClass["subjects"].append({
        "name": subjectNames[i],
        "coef": lastCoef
    })

j = json.dumps(out, indent=2)

f = codecs.open("outputJSON.json", "w", "utf-8")
f.write(j)
f.close()

print("Wrote successfully to outputJSON.json")
