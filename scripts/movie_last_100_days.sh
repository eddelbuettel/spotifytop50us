#!/bin/bash

graphdir=saved_graphs
if [ ! -d ${graphdir} ]; then
    mkdir ${graphdir}
fi

N=100

## get all commits, use top N, and reverse
commits=$(git log --oneline graphs/top50us.png | awk '{print $1}' | head -${N} | tac)

## start at 1000 to always have four digits, also count backwards to reverse order of commits
counter=1000
for cmt in ${commits}; do
    git checkout ${cmt}
    ## we could use git log to get the date of the commit but the files are really tempfiles so ...
    counter=$(expr ${counter} + 1)
    cp graphs/top50us.png ${graphdir}/top50us_${counter}.png
done

## we use 'gm convert' from graphicsmagick (formerly imagemagick)
## the CRAN package imagemagick allows this from R too
gm convert -delay 20 ${graphdir}/*.png graphs/movie_last_n_days.gif

rm -rf ${graphdir}

git checkout master
git pull --all
