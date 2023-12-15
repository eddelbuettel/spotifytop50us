#!/usr/bin/env Rscript

suppressMessages({
    library(data.table)
    library(anytime)
    library(ggplot2)
    library(tinythemes)
})

Sys.setenv("TZ"="UTC") 				# GitHub Actions runs at UTC too
D <- readRDS("data/top50.rds")
setDT(D)

D[, song_artist := paste0(artists, "\n", name)] # prettier song + artist string
D[, dt := anytime::anydate(date)]               # use just the date

D2w <- D[dt > max(dt) - 14,]                    # subset to last two weeks
D2w[, meanpos := mean(pos), by=song_artist]     # compute 'average' position
D2w[, cnt := .N, by=song_artist]            	# count of Top50 appearances

D2w <- D2w[cnt >= 4][order(meanpos),]		# subset, sort, ensure song_artist is ordered factor
D2w[, song_artist := ordered(song_artist, levels=unique(song_artist))]

 						# cut-off to include top nine, allowing ties
crit <- D2w[order(meanpos), .(meanpos=head(meanpos,1)), by=song_artist][1:9, max(meanpos)]

p <- ggplot(data=D2w[meanpos <= crit]) +
    aes(x=dt, y=pos, colour=song_artist) +
    geom_step(linewidth=1.0) +
    facet_wrap(~ song_artist) +
    scale_y_reverse() +
    tinythemes::theme_ipsum_rc() +
    theme(legend.position="none") +
    xlab("Date") + ylab("Top 50 Position") +
    labs(title = "Spotify 'Top 50' in the US: Top Nine Songs in the Last Fourteen Days",
         subtitle = paste("Songs ranked by average 'Top 50' position over last two",
                          "weeks up spanning", format(D2w[, min(dt)], "%B %d"),
                          "to", format(D2w[, max(dt)], "%B %d"),
                          "and subject to at least 4 appearances"),
         caption = paste("Initial data from https://github.com/brianckeegan/SpotifyUSTop50/; ",
                         "more recent data and graphics from",
                         "https://github.com/eddelbuettel/spotifytop50us.",
                         "Chart last updated at", format(round(Sys.time(),0)), "UTC"))

png("graphs/top50us.png", 1200, 600)
p
ignoreme <- dev.off()
