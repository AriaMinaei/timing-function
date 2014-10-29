###
 * Source: http://stackoverflow.com/a/11697909/607997
 * http://codepen.io/onedayitwillmake/details/EHDmw
 * by Mario Gonzalez
###

###
 * Solver for cubic bezier curve with implicit control points at (0,0) and (1.0, 1.0)
###
module.exports = class UnitBezier

	constructor: (p1x, p1y, p2x, p2y) ->

		@set p1x, p1y, p2x, p2y

	set: (p1x, p1y, p2x, p2y) ->

		# pre-calculate the polynomial coefficients
		# First and last control points are implied to be (0,0) and (1.0, 1.0)
		@_cx = 3.0 * p1x
		@_bx = 3.0 * (p2x - p1x) - @_cx
		@_ax = 1.0 - @_cx - @_bx
		@_cy = 3.0 * p1y
		@_by = 3.0 * (p2y - p1y) - @_cy
		@_ay = 1.0 - @_cy - @_by

		return

	@epsilon: 1e-6 # Precision

	_sampleCurveX: (t) ->

		((@_ax * t + @_bx) * t + @_cx) * t

	_sampleCurveY: (t) ->

		((@_ay * t + @_by) * t + @_cy) * t

	_sampleCurveDerivativeX: (t) ->

		(3.0 * @_ax * t + 2.0 * @_bx) * t + @_cx

	_solveCurveX: (x, epsilon) ->

		t0 = undefined
		t1 = undefined
		t2 = undefined
		x2 = undefined
		d2 = undefined
		i = undefined

		# First try a few iterations of Newton's method -- normally very fast.
		t2 = x
		i = 0

		while i < 8

			x2 = @_sampleCurveX(t2) - x

			return t2 if Math.abs(x2) < epsilon

			d2 = @_sampleCurveDerivativeX(t2)

			break if Math.abs(d2) < epsilon

			t2 = t2 - x2 / d2

			i++

		# No solution found - use bi-section
		t0 = 0.0
		t1 = 1.0
		t2 = x

		return t0  if t2 < t0

		return t1  if t2 > t1

		while t0 < t1

			x2 = @_sampleCurveX(t2)

			return t2 if Math.abs(x2 - x) < epsilon

			if x > x2

				t0 = t2

			else

				t1 = t2

			t2 = (t1 - t0) * .5 + t0

		# Give up
		t2


	# Find new T as a function of Y along curve X
	solve: (x, epsilon) ->

		@_sampleCurveY @_solveCurveX(x, epsilon)

	solveSimple: (x) ->

		@_sampleCurveY @_solveCurveX(x, 1e-6)