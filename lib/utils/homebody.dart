import 'package:flutter/material.dart';
import 'package:notodo/models/noto_items.dart';
import 'package:notodo/utils/databaseClient.dart';

class noToDoScreen extends StatefulWidget {
  @override
  _noToDoScreenState createState() => _noToDoScreenState();
}

class _noToDoScreenState extends State<noToDoScreen> {
  final List<NoDoItem> _noDoItem = <NoDoItem>[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _readNoDoList();
  }

  var _itemNameController = new TextEditingController();
  var db = new DatabaseHelper();
  void _handleSubmit(String text) async {
    _itemNameController.clear();
    NoDoItem noDoItem1 = new NoDoItem(text, DateTime.now().toIso8601String());
    Navigator.of(context).pop(context);
    int reply = await db.saveItem(noDoItem1);
    print("Item Saved Id : $reply");
    NoDoItem addItem = await db.getItem(reply);
    setState(() {
      _noDoItem.insert(0, addItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
              itemCount: _noDoItem.length,
              padding: new EdgeInsets.all(8.0),
              reverse: false,
              itemBuilder: (_, int index) {
                return new Card(
                  color: Colors.white10,
                  child: new ListTile(
                    title: _noDoItem[index],
                    onLongPress: () {
                      _updateItem(_noDoItem[index], index);
                    },
                    trailing: new Listener(
                      key: new Key(_noDoItem[index].itemName),
                      child: new Icon(
                        Icons.remove_circle,
                        color: Colors.redAccent,
                      ),
                      onPointerDown: (pointerEvent) {
                        _deleteNoDo(_noDoItem[index].id, index);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          new Divider(
            height: 1.0,
          )
        ],
      ),
      backgroundColor: Colors.grey.shade900,
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: _showFormDialog,
        tooltip: "Add Item",
        child: new Icon(Icons.add),
      ),
    );
  }

  void _showFormDialog() {
    var alert = new AlertDialog(
      content: new Row(
        children: <Widget>[
          new Expanded(
            child: new TextField(
              controller: _itemNameController,
              autofocus: true,
              decoration: new InputDecoration(
                labelText: "Item",
                hintText: "Dont do this",
                icon: new Icon(Icons.note_add),
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            _handleSubmit(_itemNameController.text);
            _itemNameController.clear();
          },
          child: Text("Save"),
        ),
        new FlatButton(
          onPressed: () {
            _itemNameController.clear();
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  _readNoDoList() async {
    List items = await db.getItems();
    items.forEach((item) {
      //NoDoItem noDoItem1 = NoDoItem.map(item);
      setState(() {
        _noDoItem.add(NoDoItem.map(item));
      });
      // print("Items are : ${noDoItem1.itemName} ");
    });
  }

  void _deleteNoDo(int id, int index) async {
    //debugPrint("DeletedITEM!");
    int a = await db.deleteItem(id);
    setState(() {
      _noDoItem.removeAt(index);
    });
  }

  void _updateItem(NoDoItem noDoItem, int index) async {
    var alert = new AlertDialog(
      title: new Text("Update Item"),
      content: new Row(
        children: <Widget>[
          new Expanded(
            child: new TextField(
              controller: _itemNameController,
              autofocus: true,
              decoration: new InputDecoration(
                labelText: "Item",
                hintText: "Dont do this",
                icon: new Icon(Icons.system_update_alt),
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () async {
            NoDoItem newItemUpdated = NoDoItem.fromMap({
              "itemName": _itemNameController.text,
              "dateCreated": DateTime.now().toIso8601String(),
              "id": noDoItem.id
            });
            _handleSubmittedItem(index, noDoItem);
            await db.updateItem(newItemUpdated);
            setState(() {
              _readNoDoList();
            });
            _itemNameController.clear();
            Navigator.of(context).pop(context);
            
          },
          child: new Text("Update"),
        ),
        new FlatButton(
          onPressed: () {
            _itemNameController.clear();
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handleSubmittedItem(int index, NoDoItem noDoItem) {
    setState(() {
      _noDoItem.removeWhere((element) {
        _noDoItem[index].itemName == noDoItem.itemName;
      });
    });
  }
}
