Uri adminUrl = Uri.parse('https://tlemi.takjug.tech/admin/');
Uri loginUrl = Uri.parse('https://tlemi.takjug.tech/api/token/');
Uri memberList = Uri.parse('https://tlemi.takjug.tech/api/member/list/');
Uri memberAdd = Uri.parse('https://tlemi.takjug.tech/api/member/create/');
Uri departmentUrl = Uri.parse('https://tlemi.takjug.tech/api/department/list/');

Uri memberDeleteUrl(String id) {
  return Uri.parse('https://tlemi.takjug.tech/api/member/$id/delete/');
}

Uri memberUpdateUrl(String id) {
  return Uri.parse('https://tlemi.takjug.tech/api/member/$id/edit/');
}

Uri departmentlist =
    Uri.parse('https://tlemi.takjug.tech/api/department/list/');

Uri attendancelist =
    Uri.parse('https://tlemi.takjug.tech/api/attendance/list/');

Uri departmentDeleteUrl(String id) {
  return Uri.parse('https://tlemi.takjug.tech/api/department/$id/delete/');
}

Uri messageUrl(String body, String phone) {
  final queryParameters = {
    'body': body,
    'phone': phone,
  };
  return Uri.https('tlemi.takjug.tech', '/api/message/', queryParameters);
}
