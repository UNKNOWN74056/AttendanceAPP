class Markleave {
  String? toDate;
  String? fromDate;
  String? reasone;

  Markleave({this.toDate, this.fromDate, this.reasone});

  Markleave.fromJson(Map<String, dynamic> json) {
    toDate = json['To_Date'];
    fromDate = json['From_Date'];
    reasone = json['Reasone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['To_Date'] = toDate;
    data['From_Date'] = fromDate;
    data['Reasone'] = reasone;
    return data;
  }
}
