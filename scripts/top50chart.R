#!/usr/bin/env Rscript

suppressMessages({
    library(data.table)
    library(anytime)
    library(ggplot2)
    library(hrbrthemes)
})

D <- readRDS("data/top50.rds")
setDT(D)

D[, song_artist := paste0(artists, "\n", name)] 	# prettier song + artist string
D[, dt := anytime::anydate(date)]                       # use just the date
D2w <- D[dt >= max(dt)-14,]                             # subset to last two weeks
D2w[, meanpos := mean(pos), by=song_artist]             # compute 'average' position
D2w[, cnt := nrow(.SD), by=name]                        # count of Top50 appearances

D2w <- D2w[order(meanpos)] 				# order by average position
D2w[, song_artist := as.ordered(song_artist)]           # make song_artist an ordered factor

crit <- max(head(unique(D2w[,meanpos]), 9)) 		# cut-off to include top nine

p <- ggplot(data=D2w[meanpos <= crit]) +
    aes(x=dt, y=pos, colour=song_artist) +
    geom_line(linewidth=1.25) +
    facet_wrap(~ song_artist) +
    hrbrthemes::theme_ipsum_rc() +
    theme(legend.position="none") +
    xlab("Date") + ylab("Top 50 Position") +
    scale_y_reverse() +
    labs(title = "Spotify 'Top 50' in the US: Top Nine Songs in the Last Fourteen Days",
         subtitle = paste("Songs ranked by average 'Top 50' position over last two",
                          "weeks up to and including", format(D2w[, max(dt)], "%B %d")),
         caption = paste("Initial data from https://github.com/brianckeegan/SpotifyUSTop50/; ",
                         "more recent data and graphics from",
                         "https://github.com/eddelbuettel/spotifytop50us.",
                         "Chart last updated at", format(round(Sys.time(),0))))

png("graphs/top50us.png", 1200, 600)
p
ignoreme <- dev.off()
