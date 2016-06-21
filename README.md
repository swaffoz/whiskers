<img src="https://raw.githubusercontent.com/zaneswafford/whiskers/master/whiskers.png" height="100">  
Whiskers
========

Whiskers is a dandy little gem for quickly spinning up sites using [SASS](http://sass-lang.com), [CoffeeScript](http://coffeescript.org), and [Thoughtbot’s Bourbon](http://bourbon.io).

There’s no fancy magic here. Just a Ruby script that copies some web pages around. 
All wrapped up in a gem you can call from the command line.

This dingus automates a lot of tedious command line work I was doing previously.
If you would like to use it, be my guest.

## What does it do?
You can read the source for yourself if you’re so inclined. If you’re lazy, like me, here is a flyover:

	1. Make a directory structure for organizing your scripts and stylesheets.
	2. Download jQuery, require.js, normalize.css
	3. Download Bourbon, Neat, Bitters, and some Refills.
	4. Copy over a template to get started on a project
	5. Provide an easy way to live compile CoffeeScript and Sass


## Why the Hell would I want that?
You probably don’t. This is a tool for *me*. **Not everything is about you**. 

I apologize, that was curt. You’re a pleasant person and you do a good job.

## How do install it?
You can run:
```
	$ gem install whiskers
```

💥 Boom, you’re done. Though you’ll want to [install CoffeeScript](http://coffeescript.org/#installation) for it to work.

## How do I use it?
If you want to get up and running, you can create a new Whiskers site, open the directory, and tell Whiskers to watch for changes like so:

```
	$ whiskers new nameOfMySite
	$ cd nameOfMySite
	$ whiskers watch
```

If you want to create a site with a template beyond the base template you could run:
```
	$ whiskers new nameOfMySite nameOfMyTemplate
```

You can see the templates available using:
```
	$ whiskers list
```

You can also ask for help using:
```
	$ whiskers help
```

## What do all these files and folders do?
### index.html
The main html page for the generated site, but you already knew that.
	
### scripts/
Where the `.js` and `.coffee` files go
- `lib/`
	- Where all compiled Javascript files can be thrown.
	- Also where you may want to put any Javascript libraries you plan on using.
- `src/`
	- Where all your CoffeeScript source files go.
	- `layouts/`
		- CoffeeScript for specific layouts can go here. (e.g. Scripts that are for the homepage go in `home.coffee`)
		- These files can also use require to include CoffeeScript from the `modules` directory.
	- `modules/`
		- Small reusable bits of CoffeeScript for UI elements and the like can go here.
	- `plugins/`
		- CoffeeScript plugins you want to use can go here.

### stylesheets/ 
Where the `.css`, `.scss`, and `.sass` files go
- `app.sass`
	- Tells SASS to compile the files hiding in the other subdirectories of `stylesheets/`
- `layouts/`
	- Where layout specific SASS files go. (e.g. Styles that are for the homepage go in `home.sass`)
	- `layouts.sass`
		- Contains a list of all the layouts that should be compiled in the `layouts/` folder
- `modules/`
	- Where styles related to small, reusable modules should go.
	- `modules.sass`
		- Contains a list of all the modules that should be compiled in the `modules/` folder
- `plugins/`
	- Where all of your SASSy plugins can be dumped.
	- `plugins.sass`
		- Contains a list of all the plugins that should be compiled in the `plugins/` folder
	
## How do I add my own scripts or stylesheets to a Whiskers project?
- Put your CoffeeScript files in a subdirectory of `scripts/src/` and edit `app.coffee` or the corresponding CoffeeScript file in `scripts/src/layouts` so your scripts get included.
- Put your SASS files in a subdirectory of `stylsheets/` and edit `app.sass` or the corresponding SASS file for that directory so your styles get included.
- See the section above titled: “*What do all these files and folders do?*”

## What OS’s does this run on?
I run it on Mac OS X 10.11 but it would likely work various flavors of Linux or BSD as well. There is not much here that is system specific.

## Can you change something for me?
Probably not, but if you play your cards right we can get an ice cream cone, sport. 🍨

## Can I change something?
Sure, go for gold.

## What’s with the logo?
I like [otters](https://otters.io). 


- - -

*Made with ❤️ in Kansas.*
