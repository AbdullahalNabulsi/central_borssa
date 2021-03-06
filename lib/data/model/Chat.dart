class Chat {
  late Data data;

  Chat({required this.data});

  Chat.fromJson(Map<String, dynamic> json) {
    data = (json['data'] != null ? new Data.fromJson(json['data']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.toJson();
    return data;
  }
}

class Data {
  late List<Message> message;
  late int total;

  Data({required this.message, required this.total});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['message'] != null) {
      message = <Message>[];
      json['message'].forEach((v) {
        message.add(new Message.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message.map((v) => v.toJson()).toList();
    data['total'] = this.total;
    return data;
  }
}

class Message {
  late String createdAt;
  late String username;
  late String companyImage;
  late String message;
  late String? replayOn;
  late int companyId;
  late String companyName;
  late int userId;
  late String userPhone;

  Message.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    username = json['username'];
    companyImage = json['company_image'];
    message = json['message'];
    if (json['replay_on'] != null) replayOn = json['replay_on'];
    companyId = json['company_id'];
    companyName = json['company_name'];
    userId = json['user_id'];
    userPhone = json['user_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['username'] = this.username;
    data['company_image'] = this.companyImage;
    data['message'] = this.message;
    if (this.replayOn != null) data['replay_on'] = this.replayOn;
    data['company_id'] = this.companyId;
    data['company_name'] = this.companyName;
    data['user_id'] = this.userId;
    data['user_phone'] = this.userPhone;
    return data;
  }
}
