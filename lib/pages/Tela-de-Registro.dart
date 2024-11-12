
import 'package:flutter/material.dart';

class NewTaskScreen extends StatefulWidget { 
  @override
  _NewTaskScreenState createState()=> _NewTaskScreenState();
  }

  class _NewTaskScreenState extends State <NewTaskScreen>{
    final _formkey = GlobalKey <FormState>()
    String taskName = "";
    String taskDescription = "";
    String recurrence = 'Diariamente';

    @override
    Widget build (BuildContext context){
      return Scaffold( 
        appBar: AppBar (title: Text("Nova Tarefa")),
        body: Padding( 
          padding: const EdgeInsets.all (16.0),
          child: Form( 
            key: _formkey,
            child: Column(
              children: [ 
                TextFormField( 
                  decoration: InputDecoration (labelText: "Nome da Tarefa"),
                  onChanged: (value){ 
                    setState ( (){ 
                      taskName= value;
                    });
                  },
                ),

                 TextFormField( 
                  decoration: InputDecoration(labelText: "Descrição"),
                  onChanged: (value){
                    setState( (){
                      taskDescription= value;
                    });
                  },
                 ),

                 DropdownButtonFormField( 
                  value: recurrence,
                  decoration: InputDecoration (labelText: "Recorrência"),
                  items: ['Diariamente', 'Semanalmente', 'Mensalmente']
                  .map ((String value){
                    return DropdownMenuItem<String>( 
                      value: value,
                      child: Text (value),
                    );
                  }).toList(),
                  onChanged: (newValue){ 
                  setState ((){ 
                    recurrence = newValue!;
                  });
                  },
                 ),

                 SizedBox (height: 20),
                 ElevatedButton ( 
                  onPressed:(){
                    if (_formkey.currentState!.validate()){ 
                      print ("Tarefa Salva!");
                    }
                  },child: Text ("Salvar Tarefa"),
                 ),
              ],

      
            ),
          ),
        ),
      );
    }
  }
 
