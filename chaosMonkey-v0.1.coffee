# CHAOS MONKEY
#
# Accepts:
#	Original Data
#	User's Monkey Settings (dictionary)
#		chaos_probability	- Chaos Probability (defaults to 0.1)
#		chaos_return_value	- Return value in event of chaos (defaults to null)
#		logging				- Logging (defaults to false)
#		chaos_function		- Chaos Transform Function (optional)
#
# Returns one of the following based on Chaos Probability:
#	- Original data, left intact
#	- Data modified by chaos transform function if provided
#	- chaos_return_value if no chaos function provided
#
# Author: Gilman Callsen
# Date: 2014-04-18
#

'use strict'
(() ->
	module = angular.module('chaosmonkey', [])

	module.factory('ChaosMonkey', () ->

		error_messages =
			'no_data': 'No data provided.'
			'bad_probability': 'Please ensure the chaos_probability is a positive float.'
			'bad_logging': 'Please ensure your logging value is boolean.'
			'bad_function': 'Please ensure your chaos function is a valid function.'

		throwError = (msg) ->
			return {'monkey_error': msg}

		messItUp: (data, user_monkey_settings={}) ->
			if not data?
				return error_messages.no_data

			monkey_settings =
				'chaos_probability': 0.1
				'chaos_return_value': null
				'logging': false
				'chaos_function': null

			# Extend defaults with user provided settings
			angular.extend(monkey_settings, user_monkey_settings)

			# Quick validation of final settings
			if typeof(monkey_settings.chaos_probability) isnt 'number'
				return throwError(error_messages.bad_probability)
			if typeof(monkey_settings.logging) isnt 'boolean'
				return throwError(error_messages.bad_logging)
			if monkey_settings.chaos_function isnt null\
			and typeof(monkey_settings.chaos_function) isnt 'function'
				return throwError(error_messages.bad_function)

			# Decide whether the monkey is angry.
			cause_chaos = if (Math.random() <= monkey_settings.chaos_probability) then true else false

			# If monkey is happy, return data intact
			if not cause_chaos
				return data

			if monkey_settings.logging
				console.log "Monkey mad and causing chaos."

			# If no chaos function provided, then we return either data or null
			if not monkey_settings.chaos_function?
				return monkey_settings.chaos_return_value

			# If monkey is angry and there's a chaos function, pass data through
			return monkey_settings.chaos_function(data)

	)
)()