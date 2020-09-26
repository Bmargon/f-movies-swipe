class Actores {
  List<Actor> actores = new List();
  Actores.fromjsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    jsonList.forEach((item) {
      final actor = Actor.fromJsonMap(item);
      actores.add(actor);
    });
  }
}


class Actor {
  int castId;
  String character;
  String creditId;
  int gender;
  int id;
  String name;
  int order;
  String profilePath;

  Actor({
    this.castId,
    this.character,
    this.creditId,
    this.gender,
    this.id,
    this.name,
    this.order,
    this.profilePath,
  });

  Actor.fromJsonMap(Map<String, dynamic> json) {
    castId = json['cast_id'];
    character = json['character'];
    creditId = json['credit_id'];
    gender = json['gender'];
    id = json['id'];
    name = json['name'];
    order = json['order'];
    profilePath = json['profile_path'];
  }

  getFoto() {
    if (profilePath == '' ) {
      return 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQxDL0cMBIl5E50eiGVrUg6RcMxmZ23RJOWoTf8XKw0fmhhA9tb&usqp=CAU';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$profilePath';
    }
  }
}
