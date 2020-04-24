import pandas as pd


df = pd.read_excel("All Classes.xlsx")

df.fillna("none", inplace=True)


def print_all_class_names():
    arr = list(df["ClassNames"].unique()) + \
        list(df["ClassNames.1"].unique()) + list(df["ClassNames.2"].unique())

    arr = list(filter(lambda x: x != "none", arr))
    print(", ".join(arr))


def print_all_subject_names():
    arr = list(df["SubjectName"].unique()) + \
        list(df["SubjectName.1"].unique()) + list(df["SubjectName.2"].unique())
    arr = list(filter(lambda x: x != "none", arr))
    # print(", ".join(arr))
    for n in arr:
        print(f'"{n}" = "{n}";')


print_all_subject_names()
