import 'package:carebridge/main.dart';
import 'package:carebridge/services.dart';
import 'package:mongo_dart/mongo_dart.dart';

login(email, password) async{
  try {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var collection = db.collection('accounts');
    var value = await collection.findOne(where.eq('email', email).eq('password', password));
    if (value == null) {
      return false;
    } else {
      data = value;
      return true;
    }
  } catch (e) {
    return false;
  }
}

signup(name, email, phone, type,password) async{
  try {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var collection = db.collection('accounts');
    var value = await collection.findOne(where.eq('email', email));
    if (value == null) {
      data = {'name': name,'email': email,'phone': phone,'type': type,'password': password,"status": "free","location":""};
      await collection.insert(data);
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

bookPatient() async{
  try {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var accounts = db.collection('accounts');
    var bookings = db.collection('bookings');
    var value = await accounts.findOne(where.eq("type", "User").eq('status', "searching"));
    if (value != null) {
      var upd = {'caretakerName':data["name"], "caretakerEmail":data["email"] ,'caretakerPhone':data["phone"] ,'email': value['email'], 'name': value['name'], 'phone': value['phone'], 'location': value['location'], 'otp': generateOtp(), 'status': "unverified"};
      await bookings.insert(upd);
      bookingData = upd;
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

EnableCaretakerSearch() async{
  try {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var collection = db.collection('accounts');
    var location = await determinePosition();
    location = "${location.latitude},${location.longitude}";
    var value = await collection.findOne(where.eq("email", data["email"]));
    if (value != null) {
      collection.updateOne(value, modify.set("status", "searching").set("location", location));
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

LookForBookings(accType) async{
  try {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var collection = db.collection('bookings');
    var value = accType == "Caretaker" ? await collection.findOne(where.eq('caretakerEmail', data['email']).eq('status', "unverified")) : await collection.findOne(where.eq('email', data['email']).eq('status', "unverified"));
    if (value != null) {
      bookingData = value;
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

cancelBooking() async{
  try {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var bookings = db.collection('bookings');
    var collection = db.collection('accounts');
    var value = await collection.findOne({"email":bookingData["email"]});    
    if (value != null) {
      if (data["type"] == "User") {
        collection.updateOne({"email":data["email"]}, modify.set("status", "free"));
      }
      bookings.deleteOne(where.eq('email', bookingData['email']).eq("otp", bookingData["otp"]).eq("status", "unverified"));
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

verify_otp(otp) async {
  try {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var collection = db.collection('bookings');
    var value = await collection.findOne(where.eq('email', bookingData['email']).eq('otp', otp));
    var value2 = await collection.findOne({"email":bookingData["email"]});    
    if (value2 != null) collection.updateOne({"email":bookingData["email"]}, modify.set("status", "free"));
    if (value != null) {
      collection.updateOne(value,modify.set("status", "verified"));
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

check_if_not_cancelled() async {
  try {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var collection = db.collection('bookings');
    var value = await collection.findOne(where.eq('email', bookingData['email']).eq('otp', bookingData["otp"]).eq("status", "unverified"));
    if (value != null) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}