import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.getTextTheme('Jua'),
      ),
      home: HomePage(),
    );
  }
}

/// 버킷 클래스
class Bucket {
  String job; // 할 일
  bool isDone;
  bool isCompleted;

  Bucket(this.job, this.isDone, {this.isCompleted = false}); // 생성자
}

/// 홈 페이지
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Bucket> bucketList = []; // 전체 버킷리스트 목록

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("버킷 리스트"),
        backgroundColor: Colors.brown,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => CheckPage(bucketList: bucketList)),
              );
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: Column(
        children: [
          Image.network(
            'https://media.istockphoto.com/id/1133968850/ko/%EC%82%AC%EC%A7%84/%EC%83%88-%ED%95%B4-%ED%95%B4%EC%83%81%EB%8F%84-%EA%B0%9C%EB%85%90%EC%9E%85%EB%8B%88%EB%8B%A4.jpg?s=1024x1024&w=is&k=20&c=G830XEFK-v7vC-rxrtWNpESCxxsklfe1vaX7owdYZD4=',
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 20),
          Expanded(
            child: bucketList.isEmpty
                ? Center(
                    child: Text(
                      "버킷 리스트를 작성해 주세요.",
                      style: TextStyle(
                        fontSize: 35,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: bucketList.length,
                    itemBuilder: (context, index) {
                      Bucket bucket = bucketList[index];

                      return ListTile(
                        title: Text(
                          bucket.job,
                          style: TextStyle(
                            fontSize: 30,
                            color: bucket.isDone
                                ? Color.fromARGB(255, 2, 107, 25)
                                : Colors.black,
                            decoration: bucket.isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            CupertinoIcons.delete,
                            color: Color.fromARGB(255, 160, 15, 4),
                          ),
                          onPressed: () {
                            showDeleteDialog(context, index);
                          },
                        ),
                        leading: IconButton(
                          icon: Icon(Icons.check_box),
                          onPressed: () {
                            setState(() {
                              bucket.isDone = !bucket.isDone;
                              if (bucket.isDone) {
                                Bucket completedBucket =
                                    bucketList.removeAt(index);
                                completedBucket.isCompleted = true;
                                bucketList.add(completedBucket);
                              }
                            });
                          },
                          color: bucket.isDone
                              ? Color.fromARGB(255, 2, 121, 6)
                              : Colors.brown,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        onPressed: () async {
          // + 버튼 클릭시 버킷 생성 페이지로 이동
          String? job = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CreatePage()),
          );
          if (job != null) {
            setState(() {
              Bucket newBucket = Bucket(job, false);
              bucketList.add(newBucket); // 버킷 리스트에 추가
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("정말로 삭제하시겠습니까?"),
          actions: [
            // 확인 버튼
            TextButton(
              onPressed: () {
                setState(() {
                  // index에 해당하는 항목 삭제
                  bucketList.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: Text(
                "확인",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            // 취소 버튼
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "취소",
                style: TextStyle(color: Colors.pink),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CheckPage extends StatefulWidget {
  final List<Bucket> bucketList;

  const CheckPage({Key? key, required this.bucketList}) : super(key: key);

  @override
  State<CheckPage> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  @override
  Widget build(BuildContext context) {
    List<Bucket> complitedBucketList =
        widget.bucketList.where((bucket) => bucket.isDone).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "완료된 버킷리스트",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 2, 107, 25),
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.chevron_back,
            color: Colors.white, // 아이콘 버튼의 색상 지정
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: Image.network(
              'https://www.shutterstock.com/image-illustration/isometric-3d-illustration-on-blue-600w-1800922156.jpg',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: complitedBucketList.isEmpty
                ? Center(
                    child: Text(
                      "완료된 버킷리스트가 없습니다.",
                      style: TextStyle(
                        fontSize: 35,
                        color: Color.fromARGB(255, 2, 107, 25), // 폰트 크기 조정
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: complitedBucketList.length,
                    itemBuilder: (context, index) {
                      Bucket bucket = complitedBucketList[index];
                      return ListTile(
                        title: Text(
                          bucket.job,
                          style: TextStyle(
                            fontSize: 30,
                            color: Color.fromARGB(255, 2, 107, 25),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// 버킷 생성 페이지
class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  // TextField의 값을 가져올 때 사용합니다.
  TextEditingController textController = TextEditingController();
  // 경고 메세지
  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("버킷리스트 작성"),
        backgroundColor: Colors.brown,
        // 뒤로가기 버튼
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.chevron_back,
            color: Colors.white, // 아이콘 버튼의 색상 지정
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 텍스트 입력창
            TextField(
              controller: textController, // 연결해 줍니다.
              autofocus: true,
              decoration: InputDecoration(
                hintText: "하고 싶은 일을 입력하세요",
                errorText: error,
              ),
            ),
            SizedBox(height: 32),
            // 추가하기 버튼
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.brown), // 버튼의 배경색
                ),
                child: Text(
                  "추가하기",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onPressed: () {
                  // 추가하기 버튼 클릭시
                  String job = textController.text; // 값 가져오기

                  if (job.isEmpty) {
                    setState(() {
                      error = "내용을 입력해주세요."; // 내용이 없는 경우 에러 메세지
                    });
                  } else {
                    setState(() {
                      error = null; // 내용이 있는 경우 에러 메세지 숨기기
                    });
                    Navigator.pop(context, job); // job 변수를 반환하며 화면을 종료합니다.
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
