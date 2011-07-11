# Movies

Ruby bindings for [Subtitle Source].

Follow me on [Twitter](http://twitter.com/linusoleander) or [Github](https://github.com/oleander/) for more info and updates.

## How to use

### Request an API key

You can easely request an API key for Subtitle Source [here](http://www.subtitlesource.org/help/contact).

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

### Find by imdb id

You can pass an imdb id, **without** the tt-part.

```` ruby
@s.imdb("0813715").fetch
````

### Specify a page

If no page is given, the first one will be used.

```` ruby
@s.imdb("0813715").page(2).fetch
````

## Data to work with

These accessors are available for the object that is being returned from the `fetch` method.

- **year** (*Fixnum*) Year of the movie.
- **released** (*Date*) Release date.
- **writers** (*Array < String >*) Writers.
- **actors** (*Array < String>*) Actors.
- **director** (*String*) Name of director.
- **rating** (*Float*) Rating from 1.0 to 10.0.
- **votes** (*Float*) Number of votes.
- **runtime** (*Fixnum*) Run time in seconds.
- **href** (*String*) IMDb url.
- **id** (*String*) IMDb id.
- **poster** (*String*) Url to poster.
- **found?** (*Boolean*) Where anything found?

## How to install

    [sudo] gem install movies

## Requirements

*Movies* is tested in *OS X 10.6.7* using Ruby *1.9.2*.

## License

*Movies* is released under the *MIT license*.