## spotifytop50us -- Show Recent Top Hits in the US

This repository provides a simple illustration of how to _automate_ a simple data science or statistics task via GitHub Actions.

![](https://eddelbuettel.github.io/spotifytop50us/graphs/top50us.png)

### Motivation

A [toot by Brian Keegan](https://mastodon.social/@bkeegan@hci.social/111529520117166799) described the basic idea, [his repo](https://github.com/brianckeegan/SpotifyUSTop50/) contains a basic implementation (in Python, but without chart generation when I checked).  
As this provides a nice example for use in, for example, my [STAT 447](https://stat447.com) class I decided to build on it.

### Thanks

Thanks to
- [Brian Keegan](https://github.com/brianckeegan/SpotifyUSTop50/) for the [initial toot](https://mastodon.social/@bkeegan@hci.social/111529520117166799), 
- [Troy Hernandez](https://troyhernandez.com/) for [tinyspotifyr](https://github.com/TroyHernandez/tinyspotifyr) (also a [CRAN package](https://cran.r-project.org/package=tinyspotifyr)) 
- the authors of [spotifyr](http://www.rcharlie.com/spotifyr) from which it was derived), 
- [Bob Rudis](https://rud.is/) for [hrbrthemes](https://github.com/hrbrmstr/hrbrthemes) from which I derived my [tinythemes](https://github.com/eddelbuettel/tinythemes) used here
- and also to Spotify for providing an [API](https://developer.spotify.com/documentation/web-api).

### Setup

Getting started with a RESTful API such the [Spotify Web API](https://developer.spotify.com/documentation/web-api) can be tricky.
Please consult one the existing CRAN packages for details.
You need to register an 'app' on their site in order to be authorized and get an access token.
From R this works via a pair of environment variables along with a (one-time) browser-based callback to align with your normal login to bless these credentials. 

### Author

This repository and its code have been put together by Dirk Eddelbuettel.

### License

The code in this repository is licensed under the GNU GPL, Version 2 or later.
