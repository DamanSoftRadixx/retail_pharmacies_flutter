import 'package:flutter_retail_pharmacies/core/models/local/dropdown_model.dart';
import 'package:flutter_retail_pharmacies/core/utility_extensions/string_extension.dart';

class OrganisationData extends DropDownModel{
  OrganisationData({
      this.organisationName, 
      this.organisationAddress, 
      this.id, 
      this.uuid,super.dropDownId = "",super.name = ""});

  OrganisationData.fromJson(dynamic json) : super(dropDownId: "",name:"") {
    organisationName = json['organisation_name'].toString().toStringConversion();
    organisationAddress = json['organisation_address'].toString().toStringConversion();
    id = json['_id'].toString().toStringConversion();
    uuid = json['_uuid'].toString().toStringConversion();
    super.dropDownId = uuid ?? "";
    super.name = organisationAddress ?? "";
  }



  String? organisationName;
  String? organisationAddress;
  String? id;
  String? uuid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['organisation_name'] = organisationName;
    map['organisation_address'] = organisationAddress;
    map['_id'] = id;
    map['_uuid'] = uuid;
    map['dropDownId'] = uuid;
    map['dropDownValue'] = organisationAddress;
    return map;
  }

}