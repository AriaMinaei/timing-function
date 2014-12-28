UnitBezier = require './UnitBezier'

# Some standard timing functions for transitions, originally from MooTools.
#
# See http://easings.net
module.exports = timingFunction =

	UnitBezier: UnitBezier

	# Linear easing
	linear: (p) -> p

	# To define a easing function. It'll take care of the ease in, out, and in-out
	# parts.
	#
	# Example: easing.define 'quad', (p) -> p * p
	#
	# usage: easing.quad.easeIn 0.6
	define: (name, func) ->

		if typeof name is 'object'

			timingFunction.define _name, _func for _name, _func of name

			return

		timingFunction[name] =

			easeIn: func

			easeOut: (p, x) -> 1 - func(1 - p, x)

			easeInOut: (p, x) ->

				if p <= 0.5
					return 0.5 * func(p * 2, x)
				else
					return 0.5 * (2 - func(2 * (1 - p), x))

	get: (func, x) ->

		if func instanceof Function

			return func

		else if arguments[1]? and arguments[2]? and arguments[3]?

			b = new UnitBezier arguments[0], arguments[1], arguments[2], arguments[3]

			return (p) ->

				b.solveSimple p

		unless typeof func is 'string'

			throw Error "func should either be a function or a string, like 'cubic.easeOut'"

		if func.match /\,/

			parts = func.split /\,/

			if parts.length isnt 4

				throw Error "Invalid func '#{func}'"

			for part, i in parts

				comp = parseFloat part.replace(/\s+/g, '')

				unless isFinite comp

					throw Error "Invalid number '#{part}' in '#{func}'"

				parts[i] = comp

			b = new UnitBezier parts[0], parts[1], parts[2], parts[3]

			return (p) ->

				b.solveSimple p

		parts = func.split '.'

		f = timingFunction

		for part in parts

			f = f[part]

		if typeof f is 'undefined'

			throw Error "Cannot find easing function '#{func}'"

		if x?

			return (p) -> f(p, x)

		f

# Defining the standard easings
timingFunction.define

	quad: 	(p) -> Math.pow p, 2

	cubic: 	(p) -> Math.pow p, 3

	quart: 	(p) -> Math.pow p, 4

	quint: 	(p) -> Math.pow p, 5

	expo: 	(p) -> Math.pow 2, 8 * (p - 1)

	circ:	(p) -> 1 - Math.sin Math.cos p

	sine:	(p) -> 1 - Math.cos p * Math.PI / 2

	elastic: (p, x) -> Math.pow(2, 10 * (p - 1)) * Math.cos(20 * Math.PI * x / 3 * p)

	bow: (p, x) -> Math.pow(p, 2) * ((x + 1) * p - x)

	bounce: (p) ->

		`for(var a = 0, b = 1, result; 1; a += b, b /= 2) {

			if (p >= (7 - 4 * a) / 11) {

				return -Math.pow((11 - 6 * a - 11 * p) / 4, 2) + Math.pow(b, 2)
			}

		}//`

		return


isFinite = (value) ->

	return no unless typeof value is 'number'

	return no if value isnt value or value is Infinity or value is -Infinity

	return yes