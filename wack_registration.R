library(lubridate)
library(openxlsx)
library(data.table)

child_data <- as.data.table(fread("C:/Users/andre/Downloads/WACK_2025_Camper_Registration (1).csv"))
sponsor_data <- as.data.table(fread("C:/Users/andre/Downloads/WACK_2025_Sponsor_Registration (1).csv"))

setnames(child_data, "Child - Amount", "Name")
setnames(child_data, "Child - Person's Name - First Name", "First")
setnames(child_data, "Child - Person's Name - Last Name", "Last")
setnames(child_data, "Child - Gender", "Gender")
setnames(child_data, "Child - Last Grade Completed", "Grade")
setnames(child_data, "Child - Church", "Church")
setnames(child_data, "Child - Track Assignment", "Track")
setnames(child_data, "Child - T-Shirt Size", "Size")
setnames(child_data, "Child - Medical Information/Allergies", "Medical Info")
child_data[Church == "Other", Church := `Child - Church Name`]
child_data[Track == "PHOTOGRAPHY (must bring a digital camera)", Track := "PHOTOGRAPHY"]
child_data[Track == "STOMP (must bring drum sticks)", Track := "STOMP"]
child_data[Track == "Selected for Speaking Drama Role", Track := "DRAMA"]
child_data[, "Name" := paste(First, Last)]
child_data[, c("First", "Last", "Child - Church Name", "Created At", "V13") := NULL]

setnames(sponsor_data, "Sponsor - Amount", "Name")
setnames(sponsor_data, "Sponsor - Person's Name - First Name", "First")
setnames(sponsor_data, "Sponsor - Person's Name - Last Name", "Last")
setnames(sponsor_data, "Sponsor - Gender", "Gender")
setnames(sponsor_data, "Sponsor - Church", "Church")
setnames(sponsor_data, "Sponsor - T-Shirt Size", "Size")
setnames(sponsor_data, "Sponsor -", "Type")

setcolorder(sponsor_data, c("Name", "Gender", "Type", "Sponsor - Preferred Job Assignment Details", "Church", "Sponsor - Preferred Job Assignment",  "Size", "Email"))
sponsor_data[Church == "Other", Church := `Sponsor - Church Name`]
sponsor_data[, "Name" := paste(First, Last)]

sponsor_data[, c("First", "Last", "Sponsor - Church Name", "Created At") := NULL]


list <- unique(child_data$Church)
wb <- createWorkbook()
headerStyle <- createStyle(fontSize = 12, textDecoration = "bold", valign = "center", halign = "center", fgFill = "#D9E1F2", border = c("Bottom", "Left", "Right"))
numStyle <- createStyle(fontSize = 11, halign = "right")

for (value in list){
  child_subset <- child_data[Church == value]
  sponsor_subset <- sponsor_data[Church == value]
  
  addWorksheet(wb, value)
  
  camper_start <- 1
  writeData(wb, value, child_subset, startRow = camper_start, startCol = 1)
  
  sponsor_row <- nrow(child_subset) + 3
  
  spacer_row <- nrow(child_subset) + 2
  writeData(wb, value, "SPONSORS", startRow = spacer_row, startCol = 1)
  mergeCells(wb, value, startRow = spacer_row, endRow = spacer_row, startCol = 1, endCol = ncol(sponsor_subset))
  
  writeData(wb, value, sponsor_subset, startRow = sponsor_row, startCol = 1)
  
  size_row <- nrow(child_subset) + sponsor_row + nrow(sponsor_subset) + 2
  size_summary <- child_subset[, .(Count = .N), by = Size][order(-Count)]
  size_text <- paste(size_summary$Size, ":", size_summary$Count, collapse = ", ")
  writeData(wb, value, paste("T-Shirt Sizes:", size_text), startRow = size_row, startCol = 1)
  
  addStyle(wb, value, headerStyle, rows = 1, cols = 1:ncol(child_subset), gridExpand = TRUE)
  addStyle(wb, value, headerStyle, rows = sponsor_row, cols = 1:ncol(sponsor_subset), gridExpand = TRUE)
  addStyle(wb, value, headerStyle, rows = spacer_row, cols = 1, gridExpand = TRUE)
}

saveWorkbook(wb, "C:/Users/andre/Downloads/WACK_2025_Camper_Registration_By_Church.xlsx", overwrite = TRUE)



list <- unique(child_data$Track)
wb <- createWorkbook()

for (value in list){
  child_subset <- child_data[Track == value]
  addWorksheet(wb, value)
  writeData(wb, value, child_subset, startRow = 1, startCol = 1)
  addStyle(wb, value, headerStyle, rows = 1, cols = 1:ncol(child_subset), gridExpand = TRUE)
}

saveWorkbook(wb, "C:/Users/andre/Downloads/WACK_2025_Camper_Registration_By_Track.xlsx", overwrite = TRUE)