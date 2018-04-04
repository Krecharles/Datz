
def file_get_contents(filename):
    with open(filename, encoding="utf-8") as f:
        return f.read().encode('utf-8')

source = file_get_contents("table.html")

from bs4 import BeautifulSoup

def log(v): 
    print(v.encode("utf-8"))

soup = BeautifulSoup(source, "lxml")

table = soup.find("table") 

index = 4

def getOnlyContent(root):
    for c in root.children:
        return c

def getContent(root, index):
    i = 0
    for c in root.children:
        if i == index:
            return c
        i += 1

for c in soup.find("table").find_all("td")[index].children:
    log(c.text)

i = -1
for subject in soup.find_all("tr"):
    i += 1
    if i < 6:
        continue
    if i % 2 != 0:
        continue
    print(i)
    log(subject)
    print("middle")
    log(getContent(subject, 0))
    exit()

# 6


# name = "not set yet"
# while name != "Total":


# for c in soup.find("table").find_all("tr"):
#     log(c.text)

# log(table)
# 3MA "p74 ft14"
#Francais "p35 ft14"
# 4 "p46 ft14"

# name = table.find("p", "p74 ft14").text
# print(name)

# names are all "p35 ft14"
# coefs of 3MA are all "p46 ft14"