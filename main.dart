import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response =
      await client.get(r'https://www.potterapi.com/v1/characters?key=');

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePhotos, response.body);
}
/*Future<characters> fetchData(String id) async
{
  final response = await http.get('https://www.potterapi.com/v1/characters/'+id+r'?key=$2a$10$XWuwuqGla9l5NwhZHKbK..DAftC7lR8mgMPx6.f05a8QiT4ZqoGXC');

  if (response.statusCode == 200) 
  {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return characters.fromJson(json.decode(response.body));
  } 
  else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
*/

// A function that converts a response body into a List<Photo>.
List<Photo> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "Houses",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text("hello world"),
      ),*/
      backgroundColor: Colors.grey[200],
      body: NestedScrollView
      (
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) 
        {
          return <Widget>
          [
            SliverAppBar
            (
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar
              (
                  
                  centerTitle: true,
                  title: Text("Students",
                      style: TextStyle
                      (
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 25.0,
                        fontFamily: 'Comfortaa',
                        fontWeight: FontWeight.w500
                      )),
                      background: Container
                      (
                        color: Colors.grey[200],
                      ),

                  /*background: Image.network(
                    "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                    fit: BoxFit.cover,
                  )*/
              ),
            ),
          ];
        },
        body: FutureBuilder<List<Photo>>
        (
          future: fetchPhotos(http.Client()),
          builder: (context, snapshot) 
          {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? PhotosList(photos: snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class PhotosList extends StatelessWidget 
{  
  
  final List<Photo> photos;
  PhotosList({Key key, this.photos}) : super(key: key);
  @override
  Widget build(BuildContext context) 
  {
    return new ListView.builder
    (
      itemBuilder: (context, index) 
      {
        if(index < photos.length) 
        {
          return new ListTile
          (
            title:new Container
            (
              //margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(7.0),
              decoration: BoxDecoration
              (
                color: Colors.white,
                border: Border.all
                (
                  color: Colors.black.withOpacity(0.4),
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: 
                Center
                (
                  child: Text
                  (
                    photos[index].name,
                    style:TextStyle
                    (
                      fontSize: 25,
                      color: Colors.black.withOpacity(1),
                      fontFamily: 'Comfortaa',
                      fontWeight: FontWeight.w300
                    ),
                  ),
                ),
              ),
              onTap: () => indiHouse(context,index),
          );
        }
      },
    );
    //Initial code, use for creating a grid
    /*return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return Text(photos[index].name);
      },
    );*/
  }
  void indiHouse(BuildContext context, int index) 
  {
    // Push this page onto the stack
    Navigator.of(context).push
    (
      // MaterialPageRoute will automatically animate the screen entry, as well
      // as adding a back button to close it
      new MaterialPageRoute
      (
        builder: (context) 
        {
          return new Scaffold
          (
            backgroundColor: Colors.grey[200],
            body: NestedScrollView
            (
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) 
              {
                return <Widget>
                [
                  SliverAppBar
                  (
                    expandedHeight: 150.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar
                    (
                        
                        centerTitle: true,
                        title: Text(photos[index].name,
                            style: TextStyle
                            (
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 20.0,
                              fontFamily: 'Comfortaa',
                              fontWeight: FontWeight.w500
                            )),
                            background: Container
                            (
                              color: Colors.grey[200],
                            ),

                        /*background: Image.network(
                          "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                          fit: BoxFit.cover,
                        )*/
                    ),
                  ),
                ];
              },
              body: ListView
              (
                children: <Widget>
                [
                  ListTile
                  (
                    title:new Container
                            (
                              margin: const EdgeInsets.all(15.0),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration
                              (
                                color: Colors.white,
                                border: Border.all
                                (
                                  color: Colors.black.withOpacity(0.4),
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: 
                                 Text
                                  (
                                    'Role:  '+
                                    photos[index].role+'\n\n'
                                    +'House:  '+
                                    photos[index].house+'\n\n'
                                    +'School:  '+
                                    photos[index].school+'\n\n'
                                    +'Blood Status:  '+
                                    photos[index].bloodStatus+'\n\n'
                                    +'Species:  '+
                                    photos[index].species+'\n\n'
                                    +'Ministry of magic:  '+
                                    photos[index].ministryOfMagic.toString()+'\n\n'
                                    +'Dumbledores Army:  '+
                                    photos[index].dumbledoresArmy.toString()+'\n\n'
                                    +'Order of the Phoenix:  '+
                                    photos[index].orderOfThePhoenix.toString()+'\n\n'
                                    +'Death Eater:  '+
                                    photos[index].deathEater.toString(),
                                    style:TextStyle
                                    (
                                      fontSize: 25,
                                      color: Colors.black.withOpacity(1),
                                      fontFamily: 'Comfortaa',
                                      fontWeight: FontWeight.w300
                                    ),
                                  ),

                              ),
                  ),
                ],
              ),
              
              /*ListView.builder
              (
                
                itemBuilder: (BuildContext context,int ind)
                {
                  /*if(ind<photos[index].members.length)
                  {
                    String nme=" ";
                    Future<characters> futureData;
                    futureData = fetchData(photos[index].members[ind]);
                    FutureBuilder<characters>
                    (
                      future: futureData,
                      builder: (context, snapshot) 
                      {
                        if (snapshot.hasData) 
                        {
                          nme= snapshot.data.name;*/
                          return new ListTile
                          (
                            title:new Container
                            (
                              margin: const EdgeInsets.all(15.0),
                              //padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration
                              (
                                color: Colors.white,
                                border: Border.all
                                (
                                  color: Colors.black.withOpacity(0.4),
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: 
                                Center
                                (
                                  child: Text
                                  (
                                    photos[index].mascot+'\n',
                                    style:TextStyle
                                    (
                                      fontSize: 25,
                                      color: Colors.black.withOpacity(1),
                                      fontFamily: 'Comfortaa',
                                      fontWeight: FontWeight.w300
                                    ),
                                  ),
                                ),
                              ),
                              //onTap: () => indiHouse(context,index),
                          );
                        } 
                       /* else if (snapshot.hasError) 
                        {
                          return Text("${snapshot.error}");
                        }
                        // By default, show a loading spinner.
                        return new ListTile
                          (
                            title:new Container
                            (
                              child: CircularProgressIndicator(),
                            ),
                          );
                      },
                    );
                  }
                },*/
              ),*/
            ),
          );
        }
      )
    );  
  }
}
/*class Photo {
  String sId;
  String name;
  String mascot;
  String headOfHouse;
  String houseGhost;
  String founder;
  int iV;
  String school;
  List<String> members;
  List<String> values;
  List<String> colors;

  Photo(
      {this.sId,
      this.name,
      this.mascot,
      this.headOfHouse,
      this.houseGhost,
      this.founder,
      this.iV,
      this.school,
      this.members,
      this.values,
      this.colors});

  Photo.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    mascot = json['mascot'];
    headOfHouse = json['headOfHouse'];
    houseGhost = json['houseGhost'];
    founder = json['founder'];
    iV = json['__v'];
    school = json['school'];
    members = json['members'].cast<String>();
    values = json['values'].cast<String>();
    colors = json['colors'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['mascot'] = this.mascot;
    data['headOfHouse'] = this.headOfHouse;
    data['houseGhost'] = this.houseGhost;
    data['founder'] = this.founder;
    data['__v'] = this.iV;
    data['school'] = this.school;
    data['members'] = this.members;
    data['values'] = this.values;
    data['colors'] = this.colors;
    return data;
  }
}*/
class Photo {
  String sId;
  String name;
  String role;
  String house;
  String school;
  int iV;
  bool ministryOfMagic;
  bool orderOfThePhoenix;
  bool dumbledoresArmy;
  bool deathEater;
  String bloodStatus;
  String species;

  Photo(
      {this.sId,
      this.name,
      this.role,
      this.house,
      this.school,
      this.iV,
      this.ministryOfMagic,
      this.orderOfThePhoenix,
      this.dumbledoresArmy,
      this.deathEater,
      this.bloodStatus,
      this.species});

  Photo.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    role = json['role'];
    house = json['house'];
    school = json['school'];
    iV = json['__v'];
    ministryOfMagic = json['ministryOfMagic'];
    orderOfThePhoenix = json['orderOfThePhoenix'];
    dumbledoresArmy = json['dumbledoresArmy'];
    deathEater = json['deathEater'];
    bloodStatus = json['bloodStatus'];
    species = json['species'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['role'] = this.role;
    data['house'] = this.house;
    data['school'] = this.school;
    data['__v'] = this.iV;
    data['ministryOfMagic'] = this.ministryOfMagic;
    data['orderOfThePhoenix'] = this.orderOfThePhoenix;
    data['dumbledoresArmy'] = this.dumbledoresArmy;
    data['deathEater'] = this.deathEater;
    data['bloodStatus'] = this.bloodStatus;
    data['species'] = this.species;
    return data;
  }
}



/*import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
List<Houses> housesResponse;
Future<Houses> fetchHouses() async {
  
  final response =

    await http.get(r'https://www.potterapi.com/v1/houses/5a05e2b252f721a3cf2ea33f?key=$2a$10$XWuwuqGla9l5NwhZHKbK..DAftC7lR8mgMPx6.f05a8QiT4ZqoGXC');
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    housesResponse = (json.decode(response.body) as List).map((i)=>
    Houses.fromJson(i)).toList();
    //return Houses.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Houses');
  }
}


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Houses> futureHouses;

  @override
  void initState() {
    super.initState();
    futureHouses = fetchHouses();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Houses>(
            future: futureHouses,
            builder: (context, snapshot) {
              if (snapshot.hasData) 
              {
                return Text(snapshot.data.name);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}


class Houses {
  String sId;
  String name;
  String mascot;
  String headOfHouse;
  String houseGhost;
  String founder;
  int iV;
  String school;
  List<String> members;
  List<String> values;
  List<String> colors;

  Houses(
      {this.sId,
      this.name,
      this.mascot,
      this.headOfHouse,
      this.houseGhost,
      this.founder,
      this.iV,
      this.school,
      this.members,
      this.values,
      this.colors});

  Houses.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    mascot = json['mascot'];
    headOfHouse = json['headOfHouse'];
    houseGhost = json['houseGhost'];
    founder = json['founder'];
    iV = json['__v'];
    school = json['school'];
    members = json['members'].cast<String>();
    values = json['values'].cast<String>();
    colors = json['colors'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['mascot'] = this.mascot;
    data['headOfHouse'] = this.headOfHouse;
    data['houseGhost'] = this.houseGhost;
    data['founder'] = this.founder;
    data['__v'] = this.iV;
    data['school'] = this.school;
    data['members'] = this.members;
    data['values'] = this.values;
    data['colors'] = this.colors;
    return data;
  }
}*/
