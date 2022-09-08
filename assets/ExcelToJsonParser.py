import codecs
import pandas as pd
import json
import os.path

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

df = pd.read_excel("All Classes.xlsx")

df.fillna("none", inplace=True)


def getColumn(name):
    return df[name].values

def calc(add):
    classNames = getColumn("ClassNames" + add)
    subjectNames = getColumn("SubjectName" + add)
    coefs = getColumn("SubjectCoef" + add)
    combiNames = getColumn("CombiName" + add)
    combiCoefs = getColumn("CombiCoef" + add)

    out = []

    lastCoef = -1
    currentClass = {}
    currentCombiSubject = None

    for i in range(len(classNames)-1):

        if coefs[i] != "none":  # always check if coef got updated
            lastCoef = coefs[i]

        if subjectNames[i] == "none" and combiNames[i] == "none":
        # row is empty, new subject starts

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

            # check for successive combiSubjects
            if currentCombiSubject != None:
                # it was a successive one
                currentClass["subjects"].append(currentCombiSubject)
                currentCombiSubject = None

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
            currentCombiSubject = None

        # if the code gets here it is a normal subject
        currentClass["subjects"].append({
            "name": subjectNames[i],
            "coef": lastCoef
        })

    j = json.dumps(out, indent=2)

    filename = ""
    if add == "":
        filename = os.path.join(BASE_DIR, *"/other/output/classiqueClasses.json".split("/"))
    elif add == ".1":
        filename = os.path.join(BASE_DIR, *"/other/output/techniqueClasses.json".split("/"))
    elif add == ".2":
        filename = os.path.join(BASE_DIR, *"/other/output/premiereClasses.json".split("/"))
    else:
        print("ERROR")
    f = codecs.open(filename, "w", "utf-8")
    f.write(j)
    f.close()


    
addOptions = ["", ".1", ".2"]
if __name__ == "__main__":
    for add in addOptions:
        calc(add);
    print("programm executed successfully")