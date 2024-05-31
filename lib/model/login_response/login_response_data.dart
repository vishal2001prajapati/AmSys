class LoginResponseData {
  String? timeStamp;
  String? requestID;
  String? resource;
  int? status;
  String? description;
  String? data;
  int? processingSpan;

  LoginResponseData(
      {this.timeStamp,
        this.requestID,
        this.resource,
        this.status,
        this.description,
        this.data,
        this.processingSpan});

  LoginResponseData.fromJson(Map<String, dynamic> json) {
    timeStamp = json['timeStamp'];
    requestID = json['requestID'];
    resource = json['resource'];
    status = json['status'];
    description = json['description'];
    data = json['data'];
    processingSpan = json['processingSpan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timeStamp'] = this.timeStamp;
    data['requestID'] = this.requestID;
    data['resource'] = this.resource;
    data['status'] = this.status;
    data['description'] = this.description;
    data['data'] = this.data;
    data['processingSpan'] = this.processingSpan;
    return data;
  }
}
