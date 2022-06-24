class TutorSub {
  String? subjectName;
  String? tutorId;

  TutorSub({this.subjectName, this.tutorId});

  TutorSub.fromJson(Map<String, dynamic> json) {
    subjectName = json['subject_name'];
    tutorId = json['tutor_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subject_name'] = subjectName;
    data['tutor_id'] = tutorId;
    return data;
  }
}
