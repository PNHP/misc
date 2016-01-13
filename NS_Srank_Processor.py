#---------------------------------------------------------------------------------------------
# Name: NS_Srank_Processor.py
# Purpose: processes a list of formated s-ranks (e.g. fromm NatureServe Explorer) into a more usuable list (one per row)
# Author: Christopher Tracey
# Created: 2014-06-05
# Updated: 2016-01-12
#
# Updates:
# * 2015-03-06 - added possible values for the threshold rule
#
# To Do List/Future Ideas:
# * 
#---------------------------------------------------------------------------------------------

# Import modules
import csv

# Input file - this should be in the format of:
# 	SNAME,SUBNATIONS_SRANKS
#	Abies balsamea,"CT(S1), IA(S1), MA(SNR), MD(S1), ME(S5), MI(SNR), MN(SNR)"
#	...
infile = r"Ranks_PA_adjacentstates.csv"
# This will either create a new file or overwrite an existing file
outfile = open(r"RanksAllStates1.csv", 'wb')
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
