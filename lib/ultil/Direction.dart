class Direction {
  Direction(this._value);

  static const int right = 1;
  static const int left = -1;

  int _value;

  set value(newValue) => _value = newValue > 0 ? right : left;
  get value => _value;
}
