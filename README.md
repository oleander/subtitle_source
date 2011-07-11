# Subtitle Source

Ruby bindings for [subtitlesource.org](http://www.subtitlesource.org/).

Follow me on [Twitter](http://twitter.com/linusoleander) or [Github](https://github.com/oleander/) for more info and updates.

## How to use

### Request an API key

You can easily request an API key for Subtitle Source [here](http://www.subtitlesource.org/help/contact).

### Initialize 

Pass your API key to the constructor

```` ruby
@subtitles = SubtitleSource.new("6894b779456d330e")
````

### Search for a subtitle

```` ruby
@subtitles.query("Heroes.S03E09.HDTV.XviD-LOL").fetch
````

### Search for a subtitle, in a specific language

```` ruby
@subtitles.language("english").query("Heroes.S03E09.HDTV.XviD-LOL").fetch
````

### Find by IMDb id

```` ruby
@subtitles.imdb("tt0813715").fetch
````

### Specify a page

If no page is given, the first one will be used.

```` ruby
@subtitles.imdb("tt0813715").page(2).fetch
````

### Find subtitle based on a release name

```` ruby
@subtitles.imdb("tt0813715").fetch.based_on("The Town EXTENDED 2010 480p BRRip XviD AC3 FLAWL3SS")
````

### Sensitive

Specify how sensitive the `based_on` method should be, `0.0` to `1.0`. Default is `0.4`.

```` ruby
@subtitles.imdb("tt0813715").fetch.based_on("The Town EXTENDED 2010 480p BRRip XviD AC3 FLAWL3SS", limit: 0.0)
````

## Data to work with

The `fetch` method returns a list for subtitles. Each subtitle has the following accessors.

```` ruby
@subtitles.imdb("tt0813715").fetch.first.release_name
# => "Heroes.S03E09.HDTV.XviD-LOL"
````

- **title** (*String*) Movie/TV serie title.
- **imdb** (*String*) IMDb id.
- **id** (*Fixnum*) Subtitle Source id.
- **rid** (*Fixnum*) Same as above, I think.
- **language** (*String*) Subtitle language.
- **season** (*Fixnum*) Season for the given TV serie.
- **episode** (*Fixnum*) Episode for the given TV serie.
- **release_name** (*String*) Subtitle release name.
- **fps** (*Fixnum*) Frames per second.
- **cd** (*Fixnum*) The amount of cd's for the given TV serie.
- **details** (*String*) Url to the details page. [Example](http://www.subtitlesource.org/subs/73538/Source.Code.(2011).DVDRip.XviD-MAXSPEED).
- **url** (*String*) Url to the zipped subtitle. [Example](http://www.subtitlesource.org/download/zip/73538).
- **hi** (*Fixnum*)

## How to install

    [sudo] gem install subtitlesource

## Requirements

*Subtitle Source* is tested in *OS X 10.6.8* using Ruby *1.9.2*.

## License

*Subtitle Source* is released under the *MIT license*.