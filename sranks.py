import csv
input_file = csv.DictReader(open("Ranks_PA_adjacentstates-columns.csv"))

for row in input_file:
    print row[sname]
