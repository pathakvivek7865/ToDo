class Todo {
  int _id;
  String _title;
  int _prority;
  String _date;
  int _isDone;

  Todo(this._title, this._prority, this._date, [this._isDone = 0]);
  Todo.withId(this._id, this._title, this._prority, this._date, [this._isDone]);

  int get id => _id;
  String get title => _title;
  int get priority => _prority;
  String get date => _date;
  int get isDone => _isDone;

  set title(String newTitel) {
    if (newTitel.length <= 255) {
      _title = newTitel;
    }
  }

  set priority(int newPriority) {
    if (newPriority > 0 && newPriority <= 4) {
      _prority = newPriority;
    }
  }

  set createdAt(String newCreatedAt) {
    if (newCreatedAt != null) {
      _date = newCreatedAt;
    }
  }

  set isDone(int newIsDone) {
    if (newIsDone == 0 || newIsDone == 1) {
      _isDone = newIsDone;
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();

    map["title"] = _title;
    map["priority"] = _prority;
    map["date"] = _date;
    map["isDone"] = _isDone;
    if (_id != null) {
      map["id"] = _id;
    }

    return map;
  }

  Todo.fromObject(dynamic obj) {
    this._id = obj["id"];
    this._title = obj["title"];
    this._prority = obj["priority"];
    this._date = obj["date"];
    this._isDone = obj["isDone"];
  }
}
