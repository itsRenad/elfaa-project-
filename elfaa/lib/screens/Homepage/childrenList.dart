class childrenList {
  String? childImagePath;
  String? childName;
  String? childID;
  DateTime? childbirthday;
  int? childHeight;
  String? childGender;
  String? notID;
  childrenList();
  Map<String, dynamic> toJson() => {
        'image': childImagePath,
        'name': childName,
        'birthday': childbirthday,
        'height': childHeight,
        'gender': childGender,
        'notID':notID
      };

  childrenList.fromSnapshot(snapshot)
      : childHeight = snapshot.data()['height'],
        childName = snapshot.data()['name'],
        childID = snapshot.id,
        childImagePath = snapshot.data()['image'],
        childbirthday = snapshot.data()['birthday'].toDate(),
        childGender = snapshot.data()['gender'],
        notID = snapshot.data()['notID'];
}
