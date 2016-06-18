'use strict';
describe('foo', function () {

  function matchDeepPath(obj, paths, pattern) {
    var path, value;
    
    if (_.isString(paths)) {
      paths = paths.split('.');
    }

    if (!_.isObject(obj) || !_.isArray(paths)) { 
      return false;
    }

    path  = paths[0];
    value = obj[path];

    if (_.isString(value) && value.match(pattern)) {
      return true;
    }

    if (_.isObject(value) && matchDeepPath(value, _.tail(paths), pattern)) {
      return true;
    }

    return !! _.find(obj, function (value) {
      return matchDeepPath(value, paths, pattern);
    });
  }

  var thing1 = {
    root: { 
      foo: { 
        bar: 'blah'
      }
    },
    foo: 'bar',
    func: function () {
      return 'funcy';
    }
  };

  var thing2 = {
    root: { two: 'blah' }
  };
  
  it('should deep match yo', function () {
    expect(matchDeepPath(thing1, ['foo', 'bar'],         'blah')).toBeTruthy();
    expect(matchDeepPath(thing1, ['bar'],                'blah')).toBeTruthy();
    expect(matchDeepPath(thing1, ['root', 'foo', 'bar'], 'blah')).toBeTruthy();
    expect(matchDeepPath(thing1, ['bar'],                'bla' )).toBeTruthy();
    expect(matchDeepPath(thing1, ['bar'],                '^bla')).toBeTruthy();
    expect(matchDeepPath(thing1, ['bar'],                'lah' )).toBeTruthy();
    expect(matchDeepPath(thing1, 'foo.bar',              'blah')).toBeTruthy();

    expect(matchDeepPath(thing1, ['bar'],                '^lah')).toBeFalsy();
    expect(matchDeepPath(thing1, ['bar'],                'zorb')).toBeFalsy();
    expect(matchDeepPath(thing2, ['foo', 'bar'],         'blah')).toBeFalsy();
  });

});
