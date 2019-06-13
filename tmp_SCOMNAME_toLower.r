library(stringr)
library(datasets)

#Import current Element Tracking (ET) file into NHA database
ET_path <- "P://Conservation Programs/Natural Heritage Program/Data Management/Biotics Database Areas/Element Tracking/current element lists" # this is the path to the element tracking list folder on the p-drive in Pittsburgh.

ET_file <- list.files(path=ET_path, pattern=".xlsx$")  # --- make sure your excel file is not open.
ET_file
# look at the output and choose which shapefile you want to run
# enter its location in the list (first = 1, second = 2, etc)
n <- 3
ET_file <- ET_file[n]
# read the ET spreadsheet into a data frame
ET <- read.xlsx(xlsxFile=paste(ET_path,ET_file, sep="/"), skipEmptyRows=FALSE, rowNames=FALSE)  #, sheet=COA_actions_sheets[n]

names(ET) <- c("Element.Subnational.ID","ELCODE","SNAME","SCOMNAME")
names(ET)[names(ET) == "Element.Subnational.ID"] <- "ELSubID"
names(ET)[names(ET) == "SCIENTIFIC.NAME"] <- "SNAME"
names(ET)[names(ET) == "COMMON.NAME"] <- "SCOMNAME"

ETcom <- ET[c("ELSubID","ELCODE","SNAME","SCOMNAME")]

ETcom$lower <- tolower(ETcom$SCOMNAME)

# get a list of states
names_states <- datasets::state.name
names_months <- month.name

propernames <- c("Allegheny","American","Appalachian","Arctic","Atlantic","Baltimore","Canada","Canadian","Carolina","Chesapeake","Great Lakes","Jefferson","Karner","Nova Scotia","Aleutian","Andromeda","Anakeesta","St. John's","Cape May","Carlotta","Cheat","Chinese","Chickasaw","Chilean","Chuck-will's","Christmas","Curtis'","Delmarva","Edwards","Erie","Eurasian","European","Harris'","Hartford","Hudsonian","Huron","Iceland","Iroquois","Japanese","Labrador","Lake Erie","Laurentian","New Belgium","New England","New Zealand","North American","Nottoway Valley","Ontario","Philadelphia","Pocono","Shenandoah","St Andrew","St Peter","St. Lawrence","Wiggins","Williams","Wrights", "Yadkin River", "York", "West Virginia","Wiegands","Carex")

#possesives
poss <- str_extract_all(ETcom$lower,  "\\b[[:alnum:]']+\\b")
poss <- unlist(poss)
poss <- poss[which(!is.na(poss))]
names_poss <- grep("'", poss, value=TRUE)
rm(poss, n, ET_file, ET_path)
poss2remove <- c("cat's","will's","devil's","dragon's","elephant's","lion's","lizard's")
names_poss <- names_poss[!names_poss %in% poss2remove]
 
#Junegrass Mayfly

names_states <- str_to_title(names_states)
names_months <- str_to_title(names_months)
names_poss <- str_to_title(names_poss)

ProperNames1 <- c(names_states, names_months, names_poss, propernames)
ProperNames1 <- ProperNames1[which(ProperNames1!="")]

ETcom$CorrectName <- ETcom$lower

vecnames <- tolower(ProperNames1)
names(ProperNames1) <- vecnames
rm(vecnames)

for(i in 1:length(ProperNames1)){
  ETcom$CorrectName <- str_replace_all(ETcom$CorrectName, ProperNames1[i])
}

write.csv(ETcom, "lowercasenames.csv", row.names=FALSE)

