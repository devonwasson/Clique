var OverlappingPeople = Parse.Object.extend("OverlappingPeople");
var OverlappingPlace = Parse.Object.extend("OverlappingPlace");
var TimePair = Parse.Object.extend("TimePair");
var Place = Parse.Object.extend("Place");

/**
 * getOverlappingPlaces: get overlapping places, each having a list of different users you have encountered today
 * Sample Request:
   {"userId": "XX"}
 * 
Sample Reponse:
{
    "result": [
        {
            "placeId": "ltmIiKOf2K",
            "placeName": "Dana",
            "peopleTimePairs": [
                {
                    "userId": "ngSVSkTta0",
                    "realName": "Alice",
                    "timePairs": [
                        {
                            "startTime": {
                                "__type": "Date",
                                "iso": "2016-04-08T14:00:00.000Z"
                            },
                            "endTime": {
                                "__type": "Date",
                                "iso": "2016-04-08T15:00:00.000Z"
                            }
                        },
                        {
                            "startTime": {
                                "__type": "Date",
                                "iso": "2016-04-22T01:44:40.000Z"
                            },
                            "endTime": {
                                "__type": "Date",
                                "iso": "2016-04-22T01:45:20.000Z"
                            }
                        }
                    ]
                }
            ]
        }
    ]
}
*/

Parse.Cloud.define("getOverlappingPlaces", function(request, response) {
  myId = request.params.userId;
  results = [];
  overlappingPeopleQuery = new Parse.Query(OverlappingPeople);
  overlappingPeopleQuery.equalTo("myId", myId);
  overlappingPeopleQuery.each(function(overlappingPeopleEntry) {
    theirId = overlappingPeopleEntry.get("theirId");
    overlappingPlaceQuery = new Parse.Query(OverlappingPlace);
    overlappingPlaceQuery.equalTo("overlappingPeopleId", overlappingPeopleEntry.id);
    return overlappingPlaceQuery.each(function(overlappingPlaceEntry) {
      console.log("finished getting overlappingPlace entry");
      placeId = overlappingPlaceEntry.get("placeId");
      var placePeopleTimePairsObjectExists = false;
      var placePeopleTimePairsObject = {};

      // find the placePeopleTimePairsObject with the placeId
      for (i = 0; i < results.length; i++) {
        tempPlacePeopleTimePairsObject= results[i];
        if (placeId == tempPlacePeopleTimePairsObject["placeId"]) {
          placePeopleTimePairsObject = tempPlacePeopleTimePairsObject;
          placePeopleTimePairsObjectExists = true;
          
          console.log("placePeopleTimePairsObject exists");
          break; 
        }
      }
      
      // if the placePeopleTimePairsObject does not exist, create a new one
      var placeNamePromise = Parse.Promise.as();
      if (placePeopleTimePairsObjectExists == false) {
        results.push(placePeopleTimePairsObject);
        console.log("placePeopleTimePairsObject does not exists, creating a new one");
        // create placeId
        placePeopleTimePairsObject["placeId"] = placeId;
        // create placeName
        var placeNameQuery = new Parse.Query(Place).select(["name"]);
        placeNameQuery.equalTo("objectId", placeId);
        placeNamePromise = placeNameQuery.first().then(function(placeName) {
          console.log("getting place name");
          placePeopleTimePairsObject["placeName"] = placeName.get("name");
        }).then(function() {
          // create peopleTimePairs
          placePeopleTimePairsObject["peopleTimePairs"] = [];
        });
      }

      // Then add a new peopleTimePair object to peopleTimePairs      
      return placeNamePromise.then(function() {
        console.log("placePromise finished. Add a new peopleTimePair");
        placePeopleTimePairsObject["peopleTimePairs"].push({});
        // create a new peopleTimePair object
        var peopleTimePair = placePeopleTimePairsObject["peopleTimePairs"][placePeopleTimePairsObject["peopleTimePairs"].length - 1];
        // assign userId
        peopleTimePair["userId"] = theirId;
        // assign userName
        var userNameQuery = new Parse.Query(Parse.User).select(["realName"]);
        userNameQuery.equalTo("objectId", theirId);
        return userNameQuery.first().then(function(user) {
          console.log("got realName");
          peopleTimePair["realName"] = user.get("realName");
        }).then(function() {
          // create timePairs
          console.log("creating time pairs");
          peopleTimePair["timePairs"] = [];
          var timePairQuery = new Parse.Query(TimePair).select(["startTime", "endTime"]);
          timePairQuery.equalTo("overlappingPlaceId", overlappingPlaceEntry.id);
          return timePairQuery.each(function(timePair) {
            console.log("add new time pair");
            peopleTimePair["timePairs"].push({"startTime": timePair.get("startTime"), "endTime": timePair.get("endTime")});
          });
        });
      });
    });
  }).then(function() {
    response.success(results);
  }, function(error) {
    response.error(error);
  });
});

/**
 * getOverlappingUsers: get the overlapping users
 * Sample Request:
 * {"userId": "XX"}
 *
 * Example response:
 *[
    {
      userId: XX,
      placesTimePairs:{
        "IdOfDana": [],
        "IdOfLibrary": []
      }
    }, 
    {
      userId: XX,
      placesTimePairs: {
        "IdOfSmith": [],
        "IdOfLibrary": []
      }
    } 
  ]
 */
Parse.Cloud.define("getOverlappingUsers", function(request, response){
  var query = new Parse.Query(OverlappingPeople);
  query.equalTo("myId", request.params.userId);
  query.find().then(function(overlappingPeople) {
    //console.log("found the user");
    //console.log(overlappingPeople.length);
    result = [];
    var overlappingPeoplePromise = Parse.Promise.as();
    overlappingPeople.forEach(function(overlappingPeopleEntry){
      //console.log("each overlapping person");
      overlappingPeoplePromise = overlappingPeoplePromise.then(function() {

        result.push({});
        newResult = result[result.length - 1];
        newResult["userId"] = overlappingPeopleEntry.get("theirId");
        newResult["placesTimePairs"] = {};
        //console.log("finish each overlapping person");

        var placeQuery = new Parse.Query(OverlappingPlace);
        placeQuery.equalTo("overlappingPeopleId", overlappingPeopleEntry.id);
        
        return placeQuery.find().then(function(overlappingPlaces) {
          var overlappingPlacesPromise = Parse.Promise.as();
          overlappingPlaces.forEach(function(overlappingPlace){
            overlappingPlacesPromise = overlappingPlacesPromise.then(function() {
              //console.log("overlapping place found");
              placeId = overlappingPlace.get("placeId");
              //console.log(placeId);
              var timePairQuery = new Parse.Query(TimePair).select(["startTime", "endTime"]);
              timePairQuery.equalTo("overlappingPlaceId", overlappingPlace.id);
              return timePairQuery.find().then(function(timePairs) {
                //console.log("time pairs found");
                //console.log(placeId);
                newResult["placesTimePairs"][placeId] = timePairs;

              });                

            });
          });
          return overlappingPlacesPromise; 
        });
      });
    });
    return overlappingPeoplePromise;
  }).then(function() {
    //console.log("response");
    response.success(result);
  });
});


Parse.Cloud.define("getOverlappingUsersWithInformation", function(request, response){
  var query = new Parse.Query(OverlappingPeople);
  query.equalTo("myId", request.params.userId);
  query.find().then(function(overlappingPeople) {
    //console.log("found the user");
    //console.log(overlappingPeople.length);
    result = [];
    var overlappingPeoplePromise = Parse.Promise.as();
    overlappingPeople.forEach(function(overlappingPeopleEntry){
      //console.log("each overlapping person");
      overlappingPeoplePromise = overlappingPeoplePromise.then(function() {
        result.push({});
        newResult = result[result.length - 1];
        userId = overlappingPeopleEntry.get("theirId");
        newResult["userId"] = userId;
        userQuery = new Parse.Query(Parse.User).select(["username", "realName", "gender", "bio", "email"]);
        userQuery.equalTo("objectId", userId);
        return userQuery.first().then(function(user){
          newResult["userName"] = user.get("username");
          newResult["realName"] = user.get("realName");
          newResult["gender"] = user.get("gender");
          newResult["bio"] = user.get("bio");
          newResult["email"] = user.get("email");
        }).then(function() {
          //console.log("finish each overlapping person");
          newResult["placesTimePairs"] = {};

          var placeQuery = new Parse.Query(OverlappingPlace);
          placeQuery.equalTo("overlappingPeopleId", overlappingPeopleEntry.id);
          
          return placeQuery.find().then(function(overlappingPlaces) {
            var overlappingPlacesPromise = Parse.Promise.as();
            overlappingPlaces.forEach(function(overlappingPlace){
              overlappingPlacesPromise = overlappingPlacesPromise.then(function() {
                //console.log("overlapping place found");
                placeId = overlappingPlace.get("placeId");
                //console.log(placeId);
                var timePairQuery = new Parse.Query(TimePair).select(["startTime", "endTime"]);
                timePairQuery.equalTo("overlappingPlaceId", overlappingPlace.id);
                return timePairQuery.find().then(function(timePairs) {
                  //console.log("time pairs found");
                  //console.log(placeId);
                  newResult["placesTimePairs"][placeId] = timePairs;

                });                

              });
            });
            return overlappingPlacesPromise; 
          });
        });
      });
    });
    return overlappingPeoplePromise;
  }).then(function() {
    //console.log("response");
    response.success(result);
  });
});




/**
 * addNewTimePair: add a new time pair to the system.
 * Request format:
 * {"UserId": "XX", "placeId": "XX", "startT": "XX(in milliseconds)", "endT": "XX(in milliseconds)"}
 * On success, the server will return an empty json object {}. On error, the server will return the error message
 */
Parse.Cloud.define("addNewTimePair", function(request, response){
  console.log("starting addNewTimePair function");
  myId = request.params.userId;
  placeId = request.params.placeId;
  newStartT = new Date(parseInt(request.params.startT,10));
  newEndT = new Date(parseInt(request.params.endT,10));
  // create a TimePair object from inputs
  newTP = new TimePair();
  newTP.set("userId", myId);
  newTP.set("placeId", placeId);
  newTP.set("startTime", newStartT);
  newTP.set("endTime", newEndT);

  oldTPQuery = new Parse.Query(TimePair);
  oldTPQuery.equalTo("placeId", placeId); // find the time pairs with the same place 
  oldTPQuery.doesNotExist("overlappingPlaceId"); // exclude the overlaping time pairs
  oldTPQuery.notEqualTo("userId", myId); // do not find my own time pairs
  oldTPQuery.find().then(function(oldTPs) {
    console.log("finish finding old TPs");
    oldTPsPromise = Parse.Promise.as();
    oldTPs.forEach(function(oldTP) {
      console.log("each oldTP");
      var overlappingPeopleEntryId, reverseOverlappingPeopleEntryId;
      oldTPsPromise = oldTPsPromise.then(function() {
        overlappingTP = computeOverlappingTimePair(oldTP, newTP);
        console.log("finished computing overlapping TP");
        console.log(overlappingTP);
        if (overlappingTP == null) {
          console.log("no overlap");
          return Parse.Promise.as("noOverlap"); // if there is no time overlap, return a resolved promise directly
        }
        theirId = oldTP.get("userId");
        // check if OverlappingPeople has entry with myId and theirId
        console.log("getting overlappingPeopleEntry");
        overlappingPeopleQuery = new Parse.Query(OverlappingPeople);
        overlappingPeopleQuery.equalTo("myId", myId);
        overlappingPeopleQuery.equalTo("theirId", theirId);
        return overlappingPeopleQuery.first();
      }).then(function(overlappingPeopleEntry) { // get first or create an overlappingPeopleEntry
        console.log("finished getting overlappingPeopleEntry");
        if (overlappingPeopleEntry == "noOverlap") {
          console.log("no overlap");
          return Parse.Promise.as("noOverlap"); // if there is no overlap, then just return 
        }
        if (overlappingPeopleEntry == null) { // if there is no such entry, create a new one
          console.log("creating new overlappingPeopleEntry");
          overlappingPeopleEntry = new OverlappingPeople();
          overlappingPeopleEntry.set("myId", myId);
          overlappingPeopleEntry.set("theirId", theirId);
          return overlappingPeopleEntry.save(); // note: save() might return a promise with value being the saved entry?
        } else {
          console.log("overlappingPeopleEntry already exists");
          return Parse.Promise.as(overlappingPeopleEntry); // if the entry already exists, then just return a resolved promise
        }
      }).then(function(overlappingPeopleEntry) { // get overlappingPlace
        overlappingPeopleEntryId = overlappingPeopleEntry.id;
        if (overlappingPeopleEntry == "noOverlap") {
          console.log("no overlap");
          return Parse.Promise.as("noOverlap");
        }
        console.log("getting overlappingPlaceEntry");
        overlappingPlaceQuery = new Parse.Query(OverlappingPlace);
        overlappingPlaceQuery.equalTo("overlappingPeopleId", overlappingPeopleEntryId);
        overlappingPlaceQuery.equalTo("placeId", placeId);

        return overlappingPlaceQuery.first();
      }).then(function(overlappingPlaceEntry) { // get first or create an overlappingPlaceEntry
        console.log("finished getting overlappingPlaceEntry");
        if (overlappingPlaceEntry == "noOverlap") {
          console.log("no overlap");
          return Parse.Promise.as("noOverlap");
        }
        console.log(overlappingPlaceEntry);
        if (overlappingPlaceEntry == null) {
          console.log("creating new overlappingPlaceEntry");
          overlappingPlaceEntry = new OverlappingPlace();
          overlappingPlaceEntry.set("overlappingPeopleId", overlappingPeopleEntryId);
          overlappingPlaceEntry.set("placeId", placeId);
          return overlappingPlaceEntry.save();
        } else {
          console.log("overlappingPlaceEntry already exists");
          return Parse.Promise.as(overlappingPlaceEntry);
        }
      }).then(function(overlappingPlaceEntry) { // assign the overlappingPlaceId to overlappingTP and save it
        if (overlappingPlaceEntry == "noOverlap") {
          console.log("no overlap");
          return Parse.Promise.as("noOverlap");
        }
        overlappingTP.set("overlappingPlaceId", overlappingPlaceEntry.id);
        console.log("saving overlappingTP");
        return overlappingTP.save();
      }, function(error) {
        console.log("error saving new overlappingPlaceEntry");
        console.log(error);
      }).then(function(overlappingTP) { // get reverseOverlappingPeopleEntry
        if (overlappingTP == "noOverlap") {
          console.log("no overlap")
          return Parse.Promise.as("noOverlap")
        }
        reverseOverlappingPeopleQuery = new Parse.Query(OverlappingPeople);
        reverseOverlappingPeopleQuery.equalTo("myId", theirId);
        reverseOverlappingPeopleQuery.equalTo("theirId", myId);
        return reverseOverlappingPeopleQuery.first();
      }).then(function(reverseOverlappingPeopleEntry) { // get first or create reverseOverlappingPeopleEntry
        if (reverseOverlappingPeopleEntry == "noOverlap") {
          console.log("no overlap")
          return Parse.Promise.as("noOverlap")
        }

        if (reverseOverlappingPeopleEntry == null)  {
          console.log("creating new reverseOverlappingPeopleEntry");
          reverseOverlappingPeopleEntry = new OverlappingPeople();
          reverseOverlappingPeopleEntry.set("myId", theirId);
          reverseOverlappingPeopleEntry.set("theirId", myId);
          return reverseOverlappingPeopleEntry.save();
        } else {
          console.log("reverseOverlappingPeopleEntry already exists");
          return Parse.Promise.as(reverseOverlappingPeopleEntry);
        }
      }).then(function(reverseOverlappingPeopleEntry) {
        if (reverseOverlappingPeopleEntry == "noOverlap") {
          console.log("no overlap")
          return Parse.Promise.as("noOverlap")
        }

        reverseOverlappingPeopleEntryId = reverseOverlappingPeopleEntry.id;
        console.log("getting reverseOverlappingPlaceEntry");
        reverseOverlappingPlaceQuery = new Parse.Query(OverlappingPlace);
        reverseOverlappingPlaceQuery.equalTo("overlappingPeopleId", reverseOverlappingPeopleEntry.id);
        reverseOverlappingPlaceQuery.equalTo("placeId", placeId);
        return reverseOverlappingPlaceQuery.first();
      }).then(function(reverseOverlappingPlaceEntry) {
        if (reverseOverlappingPlaceEntry == "noOverlap") {
          console.log("no overlap")
          return Parse.Promise.as("noOverlap")
        }

        console.log(reverseOverlappingPlaceEntry);
        if (reverseOverlappingPlaceEntry == null) {
          console.log("creating new reverseOverlappingPlaceEntry");
          reverseOverlappingPlaceEntry = new OverlappingPlace();
          reverseOverlappingPlaceEntry.set("overlappingPeopleId", reverseOverlappingPeopleEntryId);
          reverseOverlappingPlaceEntry.set("placeId", placeId);
          return reverseOverlappingPlaceEntry.save();
        } else {
          console.log("reverseOverlappingPlaceEntry already exists");
          return Parse.Promise.as(reverseOverlappingPlaceEntry);
        }
      }).then(function(reverseOverlappingPlaceEntry) {
        if (reverseOverlappingPlaceEntry == "noOverlap") {
          console.log("no overlap")
          return Parse.Promise.as("noOverlap")
        }
        console.log("creating reverseOverlappingTP");
        reverseOverlappingTP = new TimePair();
        reverseOverlappingTP.set("startTime", overlappingTP.get("startTime"));
        reverseOverlappingTP.set("endTime", overlappingTP.get("endTime"));
        reverseOverlappingTP.set("overlappingPlaceId", reverseOverlappingPlaceEntry.id);
        return reverseOverlappingTP.save();
      }).then(function() {
        console.log("success!");
      }, function(error) {
        console.log(error);
      }); 
    });
    return oldTPsPromise;
  }).then(function(overlappingTP){ // save the new TimePair
        console.log("saving newTP");
        return newTP.save();
  }).then(function() {
    response.success();
  }, function(error) {
    response.error("error");
  });
 
});

function computeOverlappingTimePair(oldTP, newTP) {
  oldStartT = oldTP.get("startTime");
  oldEndT = oldTP.get("endTime");
  newStartT = newTP.get("startTime");
  newEndT = newTP.get("endTime");

  if (oldStartT > newEndT || oldEndT < newStartT) { // if there is no overlap, return null
    return null;
  }

  resultStartT = oldStartT < newStartT ? new Date(newStartT) : new Date(oldStartT);
  resultEndT = oldEndT < newEndT ? new Date(oldEndT) : new Date(newEndT);
  overlappingTP = new TimePair();
  overlappingTP.set("startTime", resultStartT);
  overlappingTP.set("endTime", resultEndT);
  return overlappingTP; // still need to set the overlappingPlaceId field of overlappingTP though!
}



Parse.Cloud.define("getAllGeoFences", function(request, response) {
  var Place = Parse.Object.extend("Place");
  var query = new Parse.Query(Place).select(["name", "location", "radius"]);
  query.find({
    success: function(results) {
      response.success(results);
    },
    error: function(error) {
      response.error("places lookup failed");
    }
  });
});


/*
 * Before Save functions
 */
Parse.Cloud.beforeSave(Parse.User, function(request, response){
  if (!request.object.isNew()) { // updating existing user
    // right now for simplicity just let it pass. Later on we need to check for authentication
    response.success();
      
  } else { // creating new user
    if (!request.object.get("username") || 
        !request.object.get("password") ||
        !request.object.get("email")) {
      response.error("username, password and email cannot be empty!");
    } else {
      var query1 = new Parse.Query(Parse.User);
      query1.equalTo("username", request.object.get("username"));
      query1.first({
        success: function(object) {
          if (object) {
            response.error("username is already in use!");
          } else {
            var query2 = new Parse.Query(Parse.User);
            query2.equalTo("email", request.object.get("email"));
            query2.first({
              success: function(object) {
                if (object) {
                  response.error("email is already in use!");   
                } else {
                  response.success();
                }
              },
              error: function(error) {
                response.error("error getting email");
              }
            });
          }

        },
        error: function(error) {
          response.error("error getting username");
        }
      });
    }
  }
});

Parse.Cloud.beforeSave("TimePair", function(request, response) {
  if (!request.object.get("startTime") || !request.object.get("endTime")) {
    response.error("startTime, endTime cannot be empty!");
  } else if (request.object.get("startTime") > request.object.get("endTime")) {
    response.error("startTime needs to be before endTime!");
  } else {
    response.success();
  }
});

Parse.Cloud.define("getAllTimePairsFromUser", function (request, response){
  var query1 = new Parse.Query(Parse.User);
  query1.equalTo("objectID", request.params.userId);
  query1.first({
    success: function(object){
      var TimePair = Parse.Object.extend("TimePair");
      var query2 = new Parse.Query(TimePair);
      query2.equalTo("userId", request.params.userId);
      query2.find({
        success: function(object){
          response.success(object);
        },
        error: function(object){
          repsonse.error("ID not found");
        }
      });
    },
    error: function(error){
      response.error("User does not exist");
    }
  });
});
