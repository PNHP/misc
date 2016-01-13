# Import modules
import csv

# Input file
infile = r"C:\Users\ctracey\Dropbox\PNHP_ConservationPlanning\WRCP Edge-of-range Plant Species\python\Ranks_PA_adjacentstates.csv"
# This will either create a new file or overwrite an existing file
outfile = open(r"C:\Users\ctracey\Dropbox\PNHP_ConservationPlanning\WRCP Edge-of-range Plant Species\python\RanksAllStates.csv", 'wb')
# Define writer object
writer = csv.writer(outfile, delimiter=',')

# Loop through the input file and close it when done
with open(infile, 'rb') as f:
    # Define reader object
    reader = csv.reader(f)
    # For each row in the input file
    for row in reader:
        # The data type of the row is a Python list, to access the first item in
        # the list use bracket notation and index zero
        sname = row[0]
        # Convert the second row to a list
        # Items between a comma and space become items in the list
        state_list = row[1].split(", ")
        # For each item in the list
        for i in state_list:
            # State is the first two characters of the string (google python slice notation)
            state = i[:2]
            # Rank is equal to the characters between the first three characters and the last character
            rank = i[3:][:-1]
            print [sname, state, rank]
            # Write sname, state, and rank to the new file
            writer.writerow([sname, state, rank])

# Close the output file (the input file was closed when the script exited the "with" loop)
outfile.close()
