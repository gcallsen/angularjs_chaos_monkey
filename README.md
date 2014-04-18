# AngularJS Chaos Monkey Service

This is a simple service you can inject anywhere inside an
[AngularJS](http://www.angularjs.org) application.  It allows you to test
random oddities in data throughout your application to ensure robust architecture.

___Example Use Case___
An application that asynchronously retrieves and uses data from a server. That
data may be lost in transit under certain circumstances, which leads to
nondeterministic application behavior if not handled correctly.  You can use
Chaos Monkey to simulate that random data loss at any point your application.

## Set Up

### Include Source
You can include the minified version `chaosMonkey-v0.1.min.js` with your application
or compile/minify on your own by including `chaosMonkey-v0.1.coffee` with your
application assets.

### Expose to Angular
Once Chaos Monkey is included with your app assets, include as an application
dependency:

	// Add Chaos Monkey as a dependency to your app
	angular.module('your-angular-app', ['chaosmonkey']);

Then you can use Chaos Monkey anywhere in your application by injecting it
as a dependency:

	// Use Chaos Monkey in your Foo Controller
	angular.module('your-angular-app').controller('FooCtrl', function($scope, ChaosMonkey) {
		// ...
	});

## Using Chaos Monkey
Chaos Monkey accepts any data and returns either the data untouched (i.e. what
normal application flow should look like) or messed up in some way (simulating
some application breakdown, network failure, etc.).  The Monkey will accept
a configuration object where you can specify any non-default behavior. See
below for more details on `configuration options`. An example:

	// Your normal data
	var data = [1,2,3,4,5];

	// Custom Chaos
	var chaos_config = {'chaos_probability': 0.5};

	// Overwrite data with output of Chaos monkey
	data = ChaosMonkey.messItUp(data, chaos_config);

	// Proceed to your normal next step
	console.log('My data! ' + data);

The example above will, about half the time, return `null` instead of your
normal value of `data`.  You can also define a custom transform function to
manipulate your data in some predetermined way, e.g. a function that doubles
every array value whenever chaos strikes:

	// Transform function
	var chaos_fn = function (orig_arr) {
		var new_arr = [];
		for (var i = 0; i<orig_arr.length; i++) {
			new_arr.push(orig_arr[i]*2);
		};
		return new_arr;
	};

	// Tell chaos monkey about it
	var chaos_config = {'chaos_function': chaos_fn};

	// Use our newly configured monkey
	data = ChaosMonkey.messItUp(data, chaos_config);

## Configuration Options
Chaos Monkey's main method is `messItUp`, which expects to see at least some
`data` and optionally some `user_monkey_settings`

___data___ can be anything.

___user_monkey_settings___ is in the form of a dictionary with the following
possible options:

	chaos_probability	- Chaos Probability (defaults to 0.1)
	chaos_return_value	- Return value in event of chaos (defaults to null)
	logging				- Logging (defaults to false)
	chaos_function		- Chaos Transform Function (optional)

Chaos Monkey will return one of the following based on Chaos Probability:
- Original data, left intact
- Data modified by chaos transform function if provided
- chaos_return_value if no chaos function provided
