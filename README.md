# Subtitlesource

Ruby bindings for [Subtitle Source](http://www.subtitlesource.org/).

Follow me on [Twitter](http://twitter.com/linusoleander) or [Github](https://github.com/oleander/) for more info and updates.

## How to use

### Request an API key

You can easily request an API key for Subtitle Source [here](http://www.subtitlesource.org/help/contact).

### Initialize 

Pass your API key to the constructor

```` ruby
@s = Subtitlesource.new("6894b779456d330e")
````

### Search for a subtitle

```` ruby
@s.query("Heroes.S03E09.HDTV.XviD-LOL").fetch
````

### Search for a subtitle, in a specific language

```` ruby
@s.language("english").query("Heroes.S03E09.HDTV.XviD-LOL").fetch
````

### Find by IMDb id

```` ruby
@s.imdb("tt0813715").fetch
````

### Specify a page

If no page is given, the first one will be used.

```` ruby
@s.imdb("tt0813715").page(2).fetch
````

## Data to work with

The `fetch` method returns a list for subtitles. Each subtitle has the following accessors.

- **title** (*String*) Movie/TV serie title.
- **imdb** (*String*) IMDb id.
- **id** (*Fixnum*) Subtitlesource id.
- **rid** (*Fixnum*) Same as above, I think.
- **language** (*String*) Subtitle language.
- **season** (*Fixnum*) Season for the given TV serie.
- **episode** (*Fixnum*) Episode for the given TV serie.
- **releasename** (*String*) Subtitle release name.
- **fps** (*Fixnum*) Frames per second.
- **cd** (*Fixnum*) The amount of cd's for the given TV serie.
- **hi** (*Fixnum*)

## How to install

    [sudo] gem install subtitlesource

## Requirements

*Subtitlesource* is tested in *OS X 10.6.8* using Ruby *1.9.2*.

## License

*Subtitlesource* is released under the *MIT license*.