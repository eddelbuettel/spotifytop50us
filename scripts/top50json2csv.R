#!/usr/bin/env Rscript

url <- "https://raw.githubusercontent.com/brianckeegan/SpotifyUSTop50/main/top50.json"
res <- jsonlite::fromJSON(url) 	# load and parses into list of data.frame objects

dates <- names(res) 		# top-level names are time stamps
				# we fuse dates and data.frame into a new data.frame
rl <- mapply(\(d, r) data.frame(date=d, r), dates, res, SIMPLIFY=FALSE, USE.NAMES=FALSE)
D <- do.call(rbind, rl) 	# and collate data.frame list elemnst into one large data.frame

write.csv(D, file="data/top50.csv", row.names=FALSE)
saveRDS(D, file="data/top50.rds") 	# for convenience
