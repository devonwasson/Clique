Clique Cloud Code API Doc

Parse server Information: 
    {
      "serverURL":"http://li-ubuntu.cloudapp.net:1337/parse",
      "appId": "hciclique",
      "masterKey": "hciclique",
      "appName": "hci-clique"
    }

===============================
Function: getOverlappingPlaces
get overlapping places, each having a list of different users you have encountered today
 Sample Request:
  {"userId": "XX"}
  
  Sample response:
   result: {
    "DanaId": [
      {"LiLi's Id": [{"startTime": "XX", "endTime": "XX"}, {"startTime": "XX", "endTime": "XX"}] },
      {"Devon's Id": [{"startTime": "XX", "endTime": "XX"}, {"startTime": "XX", "endTime": "XX"}] }
    ],
    "LibraryId": [...]
   }

==============================
Function: getOverlappingUsers
get the overlapping users, each having a list of places where you meet today
 Sample Request:
  {"userId": "XX"}
 
  Example response:
 [
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

==============================
Function: addNewTimePair 
add a new time pair to the system.
 Sample request:
  {"UserId": "XX", "placeId": "XX", "startT": "XX(in milliseconds)", "endT": "XX(in milliseconds)"}
  On success, the server will return an empty json object {}. On error, the server will return the error message

===============================
Function: getAllGeoFences
get all the geo fences

Sample Request: none
Sample Response
{
    "result": [
        {
            "location": {
                "__type": "GeoPoint",
                "latitude": 23,
                "longitude": 46
            },
            "updatedAt": "2016-03-30T04:18:02.728Z",
            "createdAt": "2016-03-30T04:17:51.991Z",
            "name": "Dana",
            "radius": 30,
            "objectId": "ltmIiKOf2K",
            "__type": "Object",
            "className": "Place"
        }
    ]
}

===============================
Functions: getAllTimePairsFromUser
get all the time pairs a user recorded

Sample Request:
{"userId": "yourId"}

Sample Output:
{
    "result": [
        {
            "userId": "vJWd1CVvex",
            "updatedAt": "2016-04-06T14:27:22.879Z",
            "createdAt": "2016-04-01T00:44:42.519Z",
            "startTime": {
                "__type": "Date",
                "iso": "2016-04-01T00:45:20.294Z"
            },
            "endTime": {
                "__type": "Date",
                "iso": "2016-04-01T00:45:22.037Z"
            },
            "overlappingPlaceId": "3SGDPnDSsE",
            "objectId": "ZzvktwiVjz",
            "__type": "Object",
            "className": "TimePair"
        }
  ]
}
