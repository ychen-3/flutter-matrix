import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matrix',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(title: 'Matrix(m*n)'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage({Key key, @required this.title}) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _mController = TextEditingController();
  //Creates a controller for an editable text field
  final TextEditingController _nController = TextEditingController();
  final width = 100.0; // 单个格子的宽度
  final height = 40.0; // 单个格子的高度
  int m = 0;
  int n = 0;
  bool isLoading = false;

  void onGenerate(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode()); //没有焦点 则隐藏键盘
    if (isLoading) return;
    isLoading = true; 
    setState(() {}); //Benachrichtigen das Framework, dass sich der interne Status dieses Objekts geändert hat.

    m = int.tryParse(_mController.value.text) ?? 0;
    n = int.tryParse(_nController.value.text) ?? 0;

    if (m == 0 || n == 0) {
      print('Bitte geben Sie eine Ganze Zahl > 0 ein!');
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Hinweis'),
            content: Text('Bitte geben Sie eine Ganze Zahl >0 ein!'), //页面上输出
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    Future.delayed(Duration(seconds: 1), () { //Creates a future, um die Berechnung nach der Verzögerung auszuführen
      isLoading = false; 
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(  //手势检测器
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),  //Matrix(m*n)
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16), //m输入框的水平内边距
                child: TextField(
                  keyboardType: TextInputType.number, //Numerische Tastatureingabe
                  controller: _mController,  //eingeben
                  inputFormatters: [ //输入的格式
                    FilteringTextInputFormatter.allow(RegExp("[0-9]")), //表示0~9十个数字按键
                  ],
                  decoration: InputDecoration(
                    labelText: 'm',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _nController, //eingeben
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                  ],
                  decoration: InputDecoration(
                    labelText: 'n',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => onGenerate(context),
                  child: Text('Rechnen'),
                ),
              ),
              !isLoading
                  ? Container(
                      height: height * m,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          // 先循环m的数量
                          children: List.generate(m, (mIndex) {
                            return Container(
                              height: height,
                              child: Row(
                                mainAxisSize: MainAxisSize.min, 
                                //大小受到了屏幕尺寸的限制
                                // 再循环n的数量
                                children: List.generate(n, (nIndex) {
                                  return Container(
                                    alignment: Alignment.center, //内容居中对齐
                                    width: width,
                                    child: Text(
                                      'v(${mIndex + 1}, ${nIndex + 1})',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  );
                                }),
                              ),
                            );
                          }),
                        ),
                      ),
                    )
                  : Container(), 
                  // !isLoading ? Container() : Container()
            ],
          ),
        ),
      ),
    );
  }
}
