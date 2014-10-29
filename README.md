# Timing Function

Simple API for easing functions and Bezier curves

## Installation

Install with npm:
```
npm install timing-function
```

## Usage

```javascript

var t = require('timing-function');

// choose any timing function
var func = t.get('sine.easeOut');

// func now takes a float between 0 and 1
func(0.3); // returns 0.45

// for cubic-bezier:
func = t.get(0.1, 0.3, 0.4, 0.2);

func(0.3);
```

## Functions

```javascript
// linear
t.get('linear')

// sine
t.get('sine.easeIn')
t.get('sine.easeOut')
t.get('sine.easeInOut')

// quad
t.get('quad.easeIn')
t.get('quad.easeOut')
t.get('quad.easeInOut')

// cubic
t.get('cubic.easeIn')
t.get('cubic.easeOut')
t.get('cubic.easeInOut')

// quart
t.get('quart.easeIn')
t.get('quart.easeOut')
t.get('quart.easeInOut')

// quint
t.get('quint.easeIn')
t.get('quint.easeOut')
t.get('quint.easeInOut')

// expo
t.get('expo.easeIn')
t.get('expo.easeOut')
t.get('expo.easeInOut')

// circ
t.get('circ.easeIn')
t.get('circ.easeOut')
t.get('circ.easeInOut')

// sine
t.get('sine.easeIn')
t.get('sine.easeOut')
t.get('sine.easeInOut')

// cubic-bezier (works just like css` cubic-bezier())
t.get(0.1, 0.2, 0.3, 0.4)
```

Functions are also available with direct calls:
```javascript
t.sine.easeInOut(0.3)
```

## UnitBezier

Normally, using `timingFunction.get(p1x, p1y, p2x, p2y)` should suffice for cubic-beziers. But if you need to directly work with the bezier class, here is an examples for it:

```javascript
var UnitBezier = require('timing-function').UnitBezier;

var b = new UnitBezier(0.1, 0.2, 0.3, 0.4);

// to solve a point:
b.solveSimple(0.3);

// to solve with custom epsilon:
b.solve(0.3, 1e-6);

// to reset control points:
b.set(1.0, 0.5, 0.3, 0.0);

```

## Acknowledgements

Trig functions come from [MooTools](https://github.com/mootools/mootools-core/blob/master/Source/Fx/Fx.Transitions.js), and cubic-bezier calculator comes from [here](http://codepen.io/onedayitwillmake/details/EHDmw).

## License

MIT