# How to update the class presets

1. Change the All Classes Google Sheet in this [document](https://docs.google.com/spreadsheets/d/1_bjoGzVaFy8XgOoz9mldlm5kqt3VKw-_l5aDw5iqao4/edit?usp=sharing)
2. Download the file as .xlsx and replace the current "All Classes.xlsx" file in this directory
3. cd assets
4. run 'python ExcelToJsonParser.py' which writes the current files to the output folder
5. copy all the contents from that file to the desired file in Model/\*-Classes.json
