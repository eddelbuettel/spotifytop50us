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
D[, song_artist := tail(song_artist,1), by=id]  # sometimes artists names are messed up / change
D[, dt := anytime::anydate(date)]               # use just the date

makeChart <- function(days = 28, keep = 7) {
    days <- match.arg(as.character(days), c("7", "14", "21", "28"))
    D2 <- D[dt > max(dt) - as.integer(days),]   # subset to selected window
    D2[, meanpos := mean(pos), by=song_artist]  # compute 'average' position
    D2[, lastpos := tail(pos,1), by=song_artist]# compute 'last' position
    D2[, cnt := .N, by=song_artist]             # count of Top50 appearances

    D2 <- D2[cnt >= keep][order(meanpos),]	# subset, sort, ensure song_artist is ordered factor
    D2[, song_artist := ordered(song_artist, levels=unique(song_artist))]

                                                # sort by meanpos and lastpos (to break ties), pick top nine
    songs <- as.character(D2[order(meanpos), .(meanpos=head(meanpos,1),lastpos=head(lastpos,1)), by=song_artist][order(meanpos,lastpos)][1:9, song_artist])
    ndays <- switch(days, "7" = "Seven", "14" = "Fourteen", "21" = "Twentyone", "28" = "Twentyeight")
    nweeks <- switch(days, "7" = "one week", "14" = "two weeks", "21" = "three weeks", "28" = "four weeks")

    p <- ggplot(D2[song_artist %in% songs]) +
        aes(x=dt, y=pos, colour=song_artist) +
        geom_step(linewidth=1.0) +
        facet_wrap(~ song_artist) +
        scale_y_reverse() +
        tinythemes::theme_ipsum_rc() +
        theme(legend.position="none") +
        xlab("Date") + ylab("Top 50 Position") +
        labs(title = paste("Spotify 'Top 50' in the US: Top Nine Songs in the Last", ndays, "Days"),
             subtitle = paste("Songs ranked by average 'Top 50' position over last", nweeks,
                              "spanning", format(D2[, min(dt)], "%B %d"), "to", format(D2[, max(dt)], "%B %d"),
                              "and subject to at least", keep, "appearances"),
             caption = paste("Initial data from https://github.com/brianckeegan/SpotifyUSTop50/; ",
                             "more recent data and graphics from",
                             "https://github.com/eddelbuettel/spotifytop50us.",
                             "Chart last updated at", format(round(Sys.time(),0)), "UTC"))
    p
}

p <- makeChart()
png("graphs/top50us.png", 1200, 600)
p
ignoreme <- dev.off()
