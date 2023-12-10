#!/usr/bin/env Rscript

suppressMessages({
    library(tinyspotifyr)
})

## this retrieves a (large) nest list object, the id for the 'top50'
## playlist is also given in https://open.spotify.com/playlist/37i9dQZEVXbLRQDuF5jeBp
rl <- get_playlist(playlist_id = "37i9dQZEVXbLRQDuF5jeBp", market = "US")

items <- rl$tracks$items                        	# key part

artistslist <- rl$tracks$items$track.artists            # list of artists data.frames
nameslist <- lapply(artistslist, "[[", "name")          # extract the 'name' field into list
namesstrlst <- lapply(nameslist, paste, collapse=",")   # collpase lists into single string
names <- sapply(namesstrlst, c)                         # concatenate into vector

dd <- data.frame(date = Sys.time(), 			# time of request
                 pos = seq(1, 50),              	# simple sequence
                 id = items$track.id, 			# track id
                 artists = names,         		# one or more artists listed
                 name = items$track.name,               # track name
                 popularity = items$track.popularity)   # popularity

oldD <- readRDS("data/top50.rds")

if (as.Date(max(dd$date)) > as.Date(max(oldD$date))) {
    D <- rbind(oldD, dd)
    write.csv(D, file="data/top50.csv", row.names=FALSE)
    saveRDS(D, file="data/top50.rds") 	# for convenience
}
