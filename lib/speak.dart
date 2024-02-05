
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SpeakPage extends StatefulWidget {
  const SpeakPage({super.key});

  @override
  State<SpeakPage> createState() => _SpeakPageState();
}

class _SpeakPageState extends State<SpeakPage> {

  bool pressed= false;
  String word = " ";
  dynamic Image_rec = " ";
  TextEditingController textinput = TextEditingController();
  Future<http.Response> sendWordToApi() async {

    final response = await http.post(
      Uri.parse('https://conigcare.onrender.com/items/'),
      body: jsonEncode({"word":word}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // Add any additional headers here if required
      },);

    if (response.statusCode == 200) {
      print('Word sent successfully!');
      return response;
     // print('Response: ${response.body}');
    } else {
      print('Failed to send word.');
      print('Response status code: ${response.statusCode}');
    }
    return response;
  }
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;



    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: height,
            width: width,
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage("Assets/images/anastasiya-badun-KIzkKP3vk3A-unsplash.jpg"),fit: BoxFit.cover),

            ),
            child: Stack(
              children: [
                Positioned(
                  top: height*0.08,
                    left: width*0.05,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: width*0.15,
                        height: height*0.1,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black87,
                          border: Border.all(color: const Color.fromARGB(243, 116, 45, 0),width: 2.0)
                        ),
                        child: const Icon(Icons.arrow_back_outlined,color: Colors.white60,),
                      ),
                    )),
                Positioned(
                    top: height*0.2,
                    left: width*0.05,
                    child: Container(
                      width: width*0.9,
                      height: height*0.5,


                   child: pressed? Center(
                     child: FutureBuilder<http.Response>(
                       future: sendWordToApi(), // Function to fetch GIF from the API
                       builder: (context, snapshot) {
                         if (snapshot.connectionState == ConnectionState.waiting) {
                           return CircularProgressIndicator(); // Display a loading indicator
                         } else if (snapshot.hasError) {
                           return Text('Error: ${snapshot.error}');
                         } else if (snapshot.hasData) {
                           // Display the fetched GIF
                           return Image.memory(snapshot.data!.bodyBytes, gaplessPlayback: true);
                         } else {
                           return Text('No data');
                         }
                       },
                     ),
                   ):Text(""),

                      decoration: BoxDecoration(

                          color: pressed? Colors.white : Colors.black54 ,
                          border: Border.all(color: const Color.fromARGB(243, 116, 45, 0),width: 3.0)
                      ),
                )),
                Positioned(
                  top: height*0.72,
                    left:  width*0.05,
                    child:Text("ConigCare",style: TextStyle(color:Colors.white,fontSize: width*0.15,fontWeight: FontWeight.bold),)),

                Positioned(
                    top: height*0.8,
                    left:  width*0.05,
                    child: Text("Enter Text Here ",style: TextStyle(color:Colors.white,fontSize: width*0.06,fontWeight: FontWeight.normal),)),
                Positioned(
                    top: height*0.85,
                    left:  width*0.05,
                  child: Container(
                    width: width*0.9,
                    height: height*0.12,
                    child: TextFormField(            //password
                      controller: textinput,
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white24,

                        suffixIcon: GestureDetector(

                          onTap: (){
                            setState(() {
                              print(pressed.toString());
                              textinput.text != ""? pressed=true:pressed=false;
                              word = textinput.text;
                              //sendWordToApi();
                              print(pressed.toString());
                            });




                          },
                          child: Icon(
                            Icons.send,
                            color: pressed ? Colors.green: Colors.blue,
                          ),
                        ),
                        hintText: 'Type here',
                        hintStyle: const TextStyle(color: Colors.white),
                        labelText:'Say something !',
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: InputBorder.none,
                        // const OutlineInputBorder(
                        //   borderSide: BorderSide(
                        //     color: Colors.yellow,
                        //   ),
                        //   borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        // ),
                      ),
                      onSaved: (String? value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                      },
                      validator: (String? value) {
                        return (value != null && value.contains('@'))
                            ? 'Do not use the @ char.'
                            : null;
                      },
                    ),
                  ),


                ),

              ],
            ),
          ),
        ),
    );
  }
}