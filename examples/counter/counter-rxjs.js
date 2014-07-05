/**
  Inspired by [simple counter](http://baconjs.github.io/)
*/
$(function () {
  "use strict";

  var MIN_VALUE = 0;

  var upButton = $("#up");
  var downButton = $("#down");
  var counterEl = $("#counter");

  var $up   = Rx.Observable.fromEvent(upButton[0], "click");
  var $down = Rx.Observable.fromEvent(downButton[0], "click");

  var $counter =
    // map up to 1, down to -1
    $up.map(function () { return 1; }).merge($down.map(function () { return -1; }))
    .scan(0, function(x,y) { return Math.max(MIN_VALUE, x + y); })
    .startWith(0);

  $counter.subscribe(function (x) {
    counterEl.text(x);

    if (x <= MIN_VALUE) {
      downButton.attr("disabled", "disabled");
    } else {
      downButton.removeAttr("disabled");
    }
  });
});
