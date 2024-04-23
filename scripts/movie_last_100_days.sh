#!/bin/bash

graphdir=saved_graphs
if [ ! -d ${graphdir} ]; then
    mkdir ${graphdir}
fi

## We retrieve the last 99 committed ones -- plus the current (not yet committed) one
N=99
cp -vax graphs/top50us.png ${graphdir}/top50us_1100.png

## get all commits, use top N, and reverse
commits=$(git log --oneline graphs/top50us.png | awk '{print $1}' | head -${N} | tac)

## start at 1000 to always have four digits, also count backwards to reverse order of commits
counter=1000
for cmt in ${commits}; do
    git checkout ${cmt} -- graphs/top50us.png
    ## we could use git log to get the date of the commit but the files are really tempfiles so ...
    counter=$(expr ${counter} + 1)
    cp -vax graphs/top50us.png ${graphdir}/top50us_${counter}.png
done

## we use 'gm convert' from graphicsmagick (formerly imagemagick)
## the CRAN package imagemagick allows this from R too
gm convert -delay 20 ${graphdir}/*.png graphs/movie_last_n_days.gif

rm -rf ${graphdir}

## not really needed in github action: restore to last commit of chart
git restore --staged graphs/top50us.png
git restore graphs/top50us.png
