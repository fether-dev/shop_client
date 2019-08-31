      import 'dart:convert';
      import 'package:ecart_client1/main.dart';
      import 'package:ecart_client1/finalpayment.dart';
      import 'package:flutter/material.dart';
      import 'package:flutter/widgets.dart';
      import 'package:http/http.dart' as http;
      import 'main1.dart';
      class Cart extends StatefulWidget {   
        int index;
        final String username;
        List list;
            Cart({this.index,this.list,this.username});
        var p_img; 
      @override
        _CartState createState() => new _CartState();
        //@override
      // _CartDetilsState createState1() => new _CartDetilsState();
        
      }
      int count;
      class _CartState extends State<Cart> {
        var response;
          Future<List> load_cart() async {
          print('Inside load_cart');
          username = username;
          //  print('FLUTTERUSERNAME'+username);  
          //fluttertest.000webhostapp.com
              response =   await http.get('http://fluttertest.000webhostapp.com/eload_cart.php?username=$username');
          // response =   await http.get('http://192.168.122.1/ecart/load_cart.php?username=$username');
          if (response.statusCode == 200) {
            print('response.body:' + response.body);
          // count=response.body.length;
          //print("count"+count.toString());
            await Future.delayed(Duration(seconds: 2));
          // print("response.body"+response.body);
          
            {
                return json.decode(response.body);
                
            }
            
          } else {
            // If that call was not successful, throw an error.
            throw Exception('Failed to load post');
            
          }  
        }
      
      
      
        @override
        
            Widget build(BuildContext context) {
                List list;
              
            return Scaffold(
              appBar: AppBar(title: Text("Cart Details"),backgroundColor: Colors.red,),
              resizeToAvoidBottomPadding: false,
            
            body: new   Container(
                height:1000.0,
                child: new Center(
                      // height: 100.0,
                //width: 150.0,
                    child:   Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                              // Padding(
              //  padding: const EdgeInsets.all(8.0),
                Expanded(
                        child: FutureBuilder<List>(
                
                  future: load_cart(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                  ///  snapshot.data.child(product_name).getValue() != null;

                    return snapshot.hasData
                        ? new ItemList(

                            list: snapshot.data,
                            //snapshot.data[0]['ototal']
                            
                          
                          )

                        
                        : new Center(
                          // child: new CircularProgressIndicator(),
                            child:  new Image.asset('asset/load1.gif',height: 100.0,width: 50.0,),

                          );
                          
                  },
                  
                      
                
                ),
        
                      
                ),

                    
              new RaisedButton(
                        child: new Text("Make Payment", textAlign: TextAlign.center,
                        style: new TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),),
                        color: Colors.lightBlue,
                            onPressed: (){
                          
                      Navigator.of(context).push(
                    
                          new MaterialPageRoute(
                              builder: (BuildContext context)=>new Cartupdate(
                              list :list,
                              //index:i,
                              ),
                            
                  )
                        );
                        },)
                      ],
                      
                )

                )
            
              
                  ),

            );
          }
      }
        
        
      class ItemList extends StatefulWidget {
            List list;
            int index; 
        

          ItemList({this.list,this.index});

        @override
        ItemListState createState() => ItemListState();
        //_ItemListState createState() => _ItemListState();

      }
      
      //class _ItemListState extends State<ItemList>  {
      class ItemListState extends State<ItemList>  {
      int cart_count;

        int index;
            String order_id;
      String id;


              void delete_cart(i){
      // var url="http://192.168.122.1/ecart/delete_cart.php";
      var url="http://fluttertest.000webhostapp.com/edelete_cart.php";

        print('id'+widget.list[i]['id']);
          print('uname'+username);
          http.post(url, body: {
        //"id"   : list[]['id'],
      "id" : widget.list[i]['id'],
      "username"  : username

          });
        setState(() {
                    widget.list.removeAt(i);
                  });
              }

          void gocart(){
                  Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (BuildContext context)=> new Cart(),
                  )
                );
              }
        void confirm (i){
        AlertDialog alertDialog = new AlertDialog(
          content: new Text("Are You sure want to delete '${widget.list[i]['product_name']}'"),
          actions: <Widget>[
            new RaisedButton(
              child: new Text("OK DELETE!",style: new TextStyle(color: Colors.black),),
              color: Colors.blue,
              onPressed: (){
                
                          delete_cart(i);
              
              },
            ),
            new RaisedButton(
              
              child: new Text("CANCEL",style: new TextStyle(color: Colors.black)),
              color: Colors.blueAccent[200],
              onPressed: ()=> Navigator.pop(context),
            ),
          ],
        );
        showDialog(context: context, child: alertDialog);
      }
      /* */
        /*Future<String> insert_cart() async {
                
      print("inside insert_cart");
        //var url="http://192.168.122.1/ecart/insert_cart.php";
            //var url="http://fluttertest.000webhostapp.com/eusercreation.php";
          final response = await http.post("http://fluttertest.000webhostapp.com/einsert_cart.php", body: {

        //  final response = await http.post("http://192.168.122.1/ecart/insert_cart.php", body: {
            "id" : widget.list[widget.index]['id'],
            "product_name" : widget.list[widget.index]['product_name'],
            "product_price" : widget.list[widget.index]['product_price'],
              "username"  : username,
              "img_name" :  widget.list[widget.index]['img_name'],

          });
      
      print('response.body'+ response.body);
      
        if(response.body =="\nduplicate\n"){
          print('hello');
            setState(() {
                msg="Already in cart";
              // Navigator.pushReplacementNamed(context, '/cart');
              });
        }
        else{
          print('hai');
          setState(() {
              msg="Added";
                //msg="Product already in cart";
                //    Navigator.pushReplacementNamed(context, '/cart');
                  Navigator.of(context).push(
                    
                          new MaterialPageRoute(
                              builder: (BuildContext context)=>new Cart(
                            
                              ),
                            
                  )
                        );
              });

        }
        return response.body;

        }*/    List data=[];
        Future update_cart(int i) async {
            print("inside update_cart");   

              print('id'+widget.list[i]['id']);
          print('uname'+username);
          print('controllerqty'+ widget.list[i]['qty']);
          print('price'+widget.list[i]['product_price']);
      //print(PRICE*QTY);
      //var res = QTY * PRICE; 
      //print(res);
      //print("qty_total: ${res.toString()}");
      //Text("Total : Rs${res}",style: new TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),);

      // var url="http://192.168.122.1/ecart/update_cart.php";

      final response = await http.post("http://fluttertest.000webhostapp.com/eupdate_cart.php", body: {
            "id" : widget.list[i]['id'],
            "qty" : widget.list[i]['qty'],
            "product_price" : widget.list[i]['product_price'],
            "username"  : username
          });
        this.setState(() {
              data = json.decode(response.body);
            });
            print(data[i]["qty_total"]);
                return "Success!";  

          /*Map mapRes = json.decode(response.body);
          print('Response from server: $mapRes');
          setState(() {
          listRoute = mapRes['listroute'];
          });*/
        /*var url="http://fluttertest.000webhostapp.com/eupdate_cart.php";
        
          http.post(url, body: {
            "id" : widget.list[i]['id'],
            "qty" : widget.list[i]['qty'],
            "product_price" : widget.list[i]['product_price'],
            "username"  : username
            
          });*/
        print('response.body'+ response.body);
        return response.body;

        }
      void initState() {
          super.initState();
        update_cart(index);
      }
        Widget build(BuildContext context) {
        // final items = List<String>.generate(widget.list.length, (i) => "Item $i");
          // new Container(
              return new   ListView.builder(
                  //scrollDirection: Axis.vertical,
                //     shrinkWrap: true,
                        itemCount: widget.list == null ? 0 : widget.list.length,
                itemBuilder: (context, i) {
                        return new Container(  
                          // width: 550.0,
                          // height: 200.0,
                          // padding: const EdgeInsets.all(10.0),
                    child:         new SingleChildScrollView(
                            child: new GestureDetector(
                            /* onTap: () {
                              //  print("hai"+i.toString());
                                Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (BuildContext context) => new Cart(
                                        list: widget.list,
                                        index: i,
                                      )));
                              },*/
                            
                              child: new Card(
                                  //   color: Colors.amber,
                                child: new ListTile(
                                  
                                //  isThreeLine: true,
                                
                                  title: 
                              
                                  Text("${widget.list[i]['product_name']}",style: new TextStyle(fontSize: 15.0,color:Colors.blue,fontWeight: FontWeight.bold),),
                              //  trailing: Text("Price : Rs${widget.list[i]['total']}",style: new TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                
                                  
                              leading: 
                                              CircleAvatar(
                                      radius: 20.0,
                                      //minRadius: 10.0,
                                    //maxRadius: 20.0,
                                      backgroundImage:
                                        NetworkImage("http://fluttertest.000webhostapp.com/upload/${widget.list[i]['img_name']}"),
                                        //  NetworkImage("http://192.168.122.1/ecart/upload/${widget.list[i]['img_name']}"),
                                      backgroundColor: Colors.transparent,
                                    ),

                              
                                  
                      subtitle  :   
          new Row(
              children: <Widget>[

          int.tryParse(widget.list[i]['qty']) > 1 ? 
          new IconButton(icon: new Icon(Icons.remove),onPressed: ()=>setState((){
            var j = int.tryParse(widget.list[i]['qty']);
                    j--;
                    widget.list[i]['qty']=j.toString();
                                
                    update_cart(i);
                
          }),): new IconButton(icon: new Icon(Icons.remove_shopping_cart),onPressed: (){},),
                        new Text('${widget.list[i]['qty']}',style: new TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                    
                  new IconButton(icon: new Icon(Icons.add),onPressed: ()=>setState((){
            var j = int.tryParse(widget.list[i]['qty']);
                    j++;
                    widget.list[i]['qty']=j.toString();

                      update_cart(i);
                    
          }),),    
                    
        /*listRoute.length == 0
              ? 
              new Container( child: Text("hai"),)
              : new ListView(
                  children: listRoute
                      .map((route) => new ListTile(
                        
                          subtitle: new Text(route['qty_total'])))
                      .toList(),
                  ),*/
                  // Text("${data[i]['qty_total']}"),
                  // Text("${widget.list[i]['qty']} * ${widget.list[i]['product_price']} = ${data[i]['qty_total']}"),  
                  //  Text("${widget.list[i]['qty']} * ${widget.list[i]['product_price']} = ${data[i]["qty_total"]} "),  
                    //print(data[i]["qty_total"]),
                  /* new GridView.builder(
                                            shrinkWrap: true,                
                                            scrollDirection: Axis.vertical,
                                          itemCount: data.length,
                                            gridDelegate:
                                                new SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 1),
                                            itemBuilder: (BuildContext context, int i) {
                                                                                  return new Container(
                                                  
                                                
                                                    child: new Container(
                                                                                    
                                                        child: new Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: <Widget>[
                                                          new Container(                                       
                                                          
                                                          child: Column(
                                                            children: <Widget>[
                                                              Text("${data[i]['qty_total']}",  
                                                  style:new TextStyle(fontSize: 10.0,color:Colors.redAccent, fontWeight: FontWeight.bold,),), 
                                                
                                                            ],
                                                          )
                                                        
                                                        ),

                                              
                                                          
                                                        ],) 
                                                
                                  
                                                    ),
                                          
                                                
                                                  
                                                  
                                                );
                                                
                                            
                                            },
                    ),*/
              InkResponse(
                              
                          child:                       
                            Icon(Icons.delete_outline,color: Colors.red,),
                            onTap: (){         
                              //  confirm(i);
                                  delete_cart(i);
                  
                          },

                    ),
        
      
        
        
          
            
              ],
            ),
      
                      ),
                    
                    ),
                            ),
                  ),
                
                );  
              // );
              },
              
            
            );
        // );
          
          }

        
      }
      