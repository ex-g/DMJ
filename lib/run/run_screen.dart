import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmj/accounts/login_google.dart';
import 'package:dmj/run/run_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:dmj/home/home_screen.dart';

class RunScreen extends StatefulWidget {
  const RunScreen({super.key});

  @override
  State<RunScreen> createState() => _RunScreenState();
}

class _RunScreenState extends State<RunScreen> {
  // 파이어베이스에서 User 데이터 참조하기
  CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection("Users");

  // 여러가지 컨트롤러
  TextEditingController startStationController =
      TextEditingController(text: "");
  TextEditingController endStationController = TextEditingController(text: "");
  TextEditingController lineController = TextEditingController(text: "");
  TextEditingController startCodeController = TextEditingController(text: "");
  TextEditingController endCodeController = TextEditingController(text: "");

  // 변수 선언
  final wordbooks = ['Basic Words'];
  final lineDropBox = [
    '호선 선택',
    '1호선',
    '2호선',
    '3호선',
    '4호선',
    '5호선',
    '6호선',
    '7호선',
    '8호선',
    '9호선'
  ];
  List? stationList = [''];
  List? lineList = [''];
  List? codeList = [''];
  List<bool> visited = List.filled(99, false);
  List<num> dis = List.filled(99, 0);
  String startSearchText = "";
  String endSearchText = "";
  String lineSearchText = "";
  String line = '호선 선택';
  String startStation = '출발역';
  String endStation = '도착역';
  String wordbook = 'Basic Words';
  bool lineChecked = false;

  // 호선 정보
  var lineInfo = [
    {
      "stationList": {
        1: [
          '소요산',
          '동두천',
          '보산',
          '동두천중앙',
          '지행',
          '덕정',
          '덕계',
          '양주',
          '녹양',
          '가능',
          '의정부',
          '회룡',
          '망월사',
          '도봉산',
          '도봉',
          '방학',
          '창동',
          '녹천',
          '월계',
          '광운대',
          '석계',
          '신이문',
          '외대앞',
          '회기',
          '청량리',
          '제기동',
          '신설동',
          '동묘앞',
          '동대문',
          '종로5가',
          '종로3가',
          '종각',
          '시청',
          '서울역',
          '남영',
          '용산',
          '노량진',
          '대방',
          '신길',
          '영등포',
          '신도림',
          '구로',
          '구일',
          '개봉',
          '오류동',
          '온수',
          '역곡',
          '소사',
          '부천',
          '중동',
          '송내',
          '부개',
          '부평',
          '백운',
          '동암',
          '간석',
          '주안',
          '도화',
          '제물포',
          '도원',
          '동인천',
          '인천',
          '가산디지털단지',
          '독산',
          '금천구청',
          '석수',
          '관악',
          '안양',
          '명학',
          '금정',
          '군포',
          '당정',
          '의왕',
          '성균관대',
          '화서',
          '수원',
          '세류',
          '병점',
          '세마',
          '오산대',
          '오산',
          '진위',
          '송탄',
          '서정리',
          '평택지제',
          '평택',
          '성환',
          '직산',
          '두정',
          '천안',
          '봉명',
          '쌍용',
          '아산',
          '탕정',
          '배방',
          '온양온천',
          '신창',
          '광명',
          '서동탄'
        ],
        2: [
          '시청',
          '을지로입구',
          '을지로3가',
          '을지로4가',
          '동대문역사문화공원',
          '신당',
          '상왕십리',
          '왕십리',
          '한양대',
          '뚝섬',
          '성수',
          '건대입구',
          '구의',
          '강변',
          '잠실나루',
          '잠실',
          '잠실새내',
          '종합운동장',
          '삼성',
          '선릉',
          '역삼',
          '강남',
          '교대',
          '서초',
          '방배',
          '사당',
          '낙성대',
          '서울대입구',
          '봉천',
          '신림',
          '신대방',
          '구로디지털단지',
          '대림',
          '신도림',
          '문래',
          '영등포구청',
          '당산',
          '합정',
          '홍대입구',
          '신촌',
          '이대',
          '아현',
          '충정로',
          '용답',
          '신답',
          '용두',
          '신설동',
          '도림천',
          '양천구청',
          '신정네거리',
          '까치산'
        ],
        3: [
          '대화',
          '주엽',
          '정발산',
          '마두',
          '백석',
          '대곡',
          '화정',
          '원당',
          '원흥',
          '삼송',
          '지축',
          '구파발',
          '연신내',
          '불광',
          '녹번',
          '홍제',
          '무악재',
          '독립문',
          '경복궁',
          '안국',
          '종로3가',
          '을지로3가',
          '충무로',
          '동대입구',
          '약수',
          '금호',
          '옥수',
          '압구정',
          '신사',
          '잠원',
          '고속터미널',
          '교대',
          '남부터미널',
          '양재',
          '매봉',
          '도곡',
          '대치',
          '학여울',
          '대청',
          '일원',
          '수서',
          '가락시장',
          '경찰병원',
          '오금'
        ],
        4: [
          '진접',
          '오남',
          '별내별가람',
          '당고개',
          '상계',
          '노원',
          '창동',
          '쌍문',
          '수유',
          '미아',
          '미아사거리',
          '길음',
          '성신여대입구',
          '한성대입구',
          '혜화',
          '동대문',
          '동대문역사문화공원',
          '충무로',
          '명동',
          '회현',
          '서울',
          '숙대입구',
          '삼각지',
          '신용산',
          '이촌',
          '동작',
          '총신대입구',
          '사당',
          '남태령',
          '선바위',
          '경마공원',
          '대공원',
          '과천',
          '정부과천청사',
          '인덕원',
          '평촌',
          '범계',
          '금정',
          '산본',
          '수리산',
          '대야미',
          '반월',
          '상록수',
          '한대앞',
          '중앙',
          '고잔',
          '초지',
          '안산',
          '신길온천',
          '정왕',
          '오이도'
        ],
        5: [
          '방화',
          '개화산',
          '김포공항',
          '송정',
          '마곡',
          '발산',
          '우장산',
          '화곡',
          '까치산',
          '신정',
          '목동',
          '오목교',
          '양평',
          '영등포구청',
          '영등포시장',
          '신길',
          '여의도',
          '여의나루',
          '마포',
          '공덕',
          '애오개',
          '충정로',
          ' 서대문',
          '광화문',
          '종로3가',
          '을지로4가',
          '동대문역사문화공원',
          '청구',
          '신금호',
          '행당',
          '왕십리',
          '마장',
          '답십리',
          '장한평',
          '군자',
          '아차산',
          '광나루',
          '천호',
          '강동',
          '길동',
          '굽은다리',
          '명일',
          '고덕',
          '상 일동',
          '강일',
          '미사',
          '하남풍산',
          '하남시청',
          '하남검단산',
          '둔촌동',
          '올림픽공원',
          '방이',
          '오금',
          '개롱',
          '거여',
          '마천'
        ],
        6: [
          '응암',
          '역촌',
          '불광',
          '독바위',
          '연신내',
          '구산',
          '새절',
          '증산',
          '디지털미디어시티',
          '월드컵경기장',
          '마포구청',
          '망원',
          '합정',
          '상수',
          '광흥창',
          '대흥',
          '공덕',
          '효창공원앞',
          '삼각지',
          '녹사평',
          '이태원',
          '한강진',
          '버티고개',
          '약수',
          '청구',
          '신당',
          '동묘앞',
          '창신',
          '보문',
          '안암',
          '고려대',
          '월곡',
          '상월곡',
          '돌곶이',
          '석계',
          '태릉입구',
          '화 랑대',
          '봉화산',
          '신내'
        ],
        7: [
          '장암',
          '도봉산',
          '수락산',
          '마들',
          '노원',
          '중계',
          '하계',
          '공릉',
          ' 태릉입구',
          '먹골',
          '중화',
          '상봉',
          '면목',
          '사가정',
          '용마산',
          '중곡',
          '군자',
          '어린이대공원',
          '건대입구',
          '뚝섬유원지',
          '청담',
          '강남구청',
          '학동',
          '논현',
          '반포',
          '고속터미널',
          '내방',
          '이수',
          '남성',
          '숭실대입 구',
          '상도',
          '장승배기',
          '신대방삼거리',
          '보라매',
          '신풍',
          '대림',
          '남 구로',
          '가산디지털단지',
          '철산',
          '광명사거리',
          '천왕',
          '온수',
          '까치울',
          '부천종합운동장',
          '춘의',
          '신중동',
          '부천시청',
          '상동',
          '삼산체육관',
          '굴포천',
          '부평구청',
          '산곡',
          '석남'
        ],
        8: [
          '암사',
          '천호',
          '강동구청',
          '몽촌토성',
          '잠실',
          '석촌',
          '송파',
          '가락 시장',
          '문정',
          '장지',
          '복정',
          '남위례',
          '산성',
          '남한산성입구',
          '단대 오거리',
          '신흥',
          '수진',
          '모란'
        ],
        9: [
          '개화',
          '김포공항',
          '공항시장',
          '신방화',
          '마곡나루',
          '양천향교',
          '가 양',
          '증미',
          '등촌',
          '염창',
          '신목동',
          '선유도',
          '당산',
          '국회의사당',
          '여의도',
          '샛강',
          '노량진',
          '노들',
          '흑석',
          '동작',
          '구반포',
          '신반포',
          '고속터미널',
          '사평',
          '신논현',
          '언주',
          '선정릉',
          '삼성중앙',
          '봉은사',
          '종합운동장',
          '삼전',
          '석촌고분',
          '석촌',
          '송파나루',
          '한성백제',
          '올림픽공원',
          '둔촌오륜',
          '중앙보훈병원'
        ]
      },
      "lineList": {
        1: List.filled(99, '1'),
        2: List.filled(51, '2'),
        3: List.filled(45, '3'),
        4: List.filled(51, '4'),
        5: List.filled(57, '5'),
        6: List.filled(40, '6'),
        7: List.filled(54, '7'),
        8: List.filled(19, '8'),
        9: List.filled(39, '9')
      },
      "codeList": {
        1: [
          '0',
          '1',
          '2',
          '3',
          '4',
          '5',
          '6',
          '7',
          '8',
          '9',
          '10',
          '11',
          '12',
          '13',
          '14',
          '15',
          '16',
          '17',
          '18',
          '19',
          '20',
          '21',
          '22',
          '23',
          '24',
          '25',
          '26',
          '27',
          '28',
          '29',
          '30',
          '31',
          '32',
          '33',
          '34',
          '35',
          '36',
          '37',
          '38',
          '39',
          '40',
          '41',
          '42',
          '43',
          '44',
          '45',
          '46',
          '47',
          '48',
          '49',
          '50',
          '51',
          '52',
          '53',
          '54',
          '55',
          '56',
          '57',
          '58',
          '59',
          '60',
          '61',
          '62',
          '63',
          '64',
          '65',
          '66',
          '67',
          '68',
          '69',
          '70',
          '71',
          '72',
          '73',
          '74',
          '75',
          '76',
          '77',
          '78',
          '79',
          '80',
          '81',
          '82',
          '83',
          '84',
          '85',
          '86',
          '87',
          '88',
          '89',
          '90',
          '91',
          '92',
          '93',
          '94',
          '95',
          '96',
          '97',
          '98',
          '99'
        ],
        2: [
          '0',
          '1',
          '2',
          '3',
          '4',
          '5',
          '6',
          '7',
          '8',
          '9',
          '10',
          '11',
          '12',
          '13',
          '14',
          '15',
          '16',
          '17',
          '18',
          '19',
          '20',
          '21',
          '22',
          '23',
          '24',
          '25',
          '26',
          '27',
          '28',
          '29',
          '30',
          '31',
          '32',
          '33',
          '34',
          '35',
          '36',
          '37',
          '38',
          '39',
          '40',
          '41',
          '42',
          '43',
          '44',
          '45',
          '46',
          '47',
          '48',
          '49',
          '50',
          '51'
        ],
        3: [
          '0',
          '1',
          '2',
          '3',
          '4',
          '5',
          '6',
          '7',
          '8',
          '9',
          '10',
          '11',
          '12',
          '13',
          '14',
          '15',
          '16',
          '17',
          '18',
          '19',
          '20',
          '21',
          '22',
          '23',
          '24',
          '25',
          '26',
          '27',
          '28',
          '29',
          '30',
          '31',
          '32',
          '33',
          '34',
          '35',
          '36',
          '37',
          '38',
          '39',
          '40',
          '41',
          '42',
          '43',
          '44'
        ],
        4: [
          '0',
          '1',
          '2',
          '3',
          '4',
          '5',
          '6',
          '7',
          '8',
          '9',
          '10',
          '11',
          '12',
          '13',
          '14',
          '15',
          '16',
          '17',
          '18',
          '19',
          '20',
          '21',
          '22',
          '23',
          '24',
          '25',
          '26',
          '27',
          '28',
          '29',
          '30',
          '31',
          '32',
          '33',
          '34',
          '35',
          '36',
          '37',
          '38',
          '39',
          '40',
          '41',
          '42',
          '43',
          '44',
          '45',
          '46',
          '47',
          '48',
          '49',
          '50'
        ],
        5: [
          '0',
          '1',
          '2',
          '3',
          '4',
          '5',
          '6',
          '7',
          '8',
          '9',
          '10',
          '11',
          '12',
          '13',
          '14',
          '15',
          '16',
          '17',
          '18',
          '19',
          '20',
          '21',
          '22',
          '23',
          '24',
          '25',
          '26',
          '27',
          '28',
          '29',
          '30',
          '31',
          '32',
          '33',
          '34',
          '35',
          '36',
          '37',
          '38',
          '39',
          '40',
          '41',
          '42',
          '43',
          '44',
          '45',
          '46',
          '47',
          '48',
          '49',
          '50',
          '51',
          '52',
          '53',
          '54',
          '55',
          '56'
        ],
        6: [
          '0',
          '1',
          '2',
          '3',
          '4',
          '5',
          '6',
          '7',
          '8',
          '9',
          '10',
          '11',
          '12',
          '13',
          '14',
          '15',
          '16',
          '17',
          '18',
          '19',
          '20',
          '21',
          '22',
          '23',
          '24',
          '25',
          '26',
          '27',
          '28',
          '29',
          '30',
          '31',
          '32',
          '33',
          '34',
          '35',
          '36',
          '37',
          '38',
          '39',
          '40'
        ],
        7: [
          '0',
          '1',
          '2',
          '3',
          '4',
          '5',
          '6',
          '7',
          '8',
          '9',
          '10',
          '11',
          '12',
          '13',
          '14',
          '15',
          '16',
          '17',
          '18',
          '19',
          '20',
          '21',
          '22',
          '23',
          '24',
          '25',
          '26',
          '27',
          '28',
          '29',
          '30',
          '31',
          '32',
          '33',
          '34',
          '35',
          '36',
          '37',
          '38',
          '39',
          '40',
          '41',
          '42',
          '43',
          '44',
          '45',
          '46',
          '47',
          '48',
          '49',
          '50',
          '51',
          '52'
        ],
        8: [
          '0',
          '1',
          '2',
          '3',
          '4',
          '5',
          '6',
          '7',
          '8',
          '9',
          '10',
          '11',
          '12',
          '13',
          '14',
          '15',
          '16',
          '17',
          '18',
          '19'
        ],
        9: [
          '0',
          '1',
          '2',
          '3',
          '4',
          '5',
          '6',
          '7',
          '8',
          '9',
          '10',
          '11',
          '12',
          '13',
          '14',
          '15',
          '16',
          '17',
          '18',
          '19',
          '20',
          '21',
          '22',
          '23',
          '24',
          '25',
          '26',
          '27',
          '28',
          '29',
          '30',
          '31',
          '32',
          '33',
          '34',
          '35',
          '36',
          '37',
          '38',
          '39'
        ]
      },
      "bfsList": {
        1: [
          [1], // 소요산 / 0
          [0, 2],
          [1, 3],
          [2, 4],
          [3, 5],
          [4, 6],
          [5, 7],
          [6, 8],
          [7, 9],
          [8, 10],
          [9, 11], // 10
          [10, 12],
          [11, 13],
          [12, 14],
          [13, 15],
          [14, 16],
          [15, 17],
          [16, 18],
          [17, 19],
          [18, 20],
          [19, 21],
          [20, 22],
          [21, 23],
          [22, 24],
          [23, 25],
          [24, 26],
          [25, 27],
          [26, 28],
          [27, 29],
          [28, 30],
          [29, 31],
          [30, 32],
          [31, 33],
          [32, 34],
          [33, 35],
          [34, 36],
          [35, 37],
          [36, 38],
          [37, 39],
          [38, 40],
          [39, 41], // 신도림
          [40, 42, 62], // 구로
          [41, 43],
          [42, 44],
          [43, 45],
          [44, 46],
          [45, 47],
          [46, 48],
          [47, 49],
          [48, 50],
          [49, 51], // 50
          [50, 52],
          [51, 53],
          [52, 54],
          [53, 55],
          [54, 56],
          [55, 57],
          [56, 58],
          [57, 59],
          [58, 60],
          [59, 61], // 60
          [60], // 인천
          [41, 63], // 가산디지털단지
          [62, 64],
          [63, 65, 97], // 금천구청 / 97은 광명
          [64, 66],
          [65, 67],
          [66, 68],
          [67, 69],
          [68, 70],
          [69, 71],
          [70, 72],
          [71, 73],
          [72, 74],
          [73, 75],
          [74, 76],
          [75, 77],
          [76, 78, 98], // 병점 / 98은 서동탄
          [77, 79],
          [78, 80],
          [79, 81],
          [80, 82],
          [81, 83],
          [82, 84],
          [83, 85],
          [84, 86],
          [85, 87],
          [86, 88],
          [87, 89],
          [88, 90],
          [89, 91],
          [90, 92],
          [91, 93],
          [92, 94],
          [93, 95],
          [94, 96],
          [95], // 신창
          [64], // 광명
          [77] // 서동탄
        ],
        2: [
          [1, 42], // 시청 / 0
          [0, 2],
          [1, 3],
          [2, 4],
          [3, 5],
          [4, 6],
          [5, 7],
          [6, 8],
          [7, 9],
          [8, 10],
          [9, 11, 43], // 성수: 10
          [10, 12],
          [11, 13],
          [12, 14],
          [13, 15],
          [14, 16],
          [15, 17],
          [16, 18],
          [17, 19],
          [18, 20],
          [19, 21], // 역삼: 20
          [20, 22],
          [21, 23],
          [22, 24],
          [23, 25],
          [24, 26],
          [25, 27],
          [26, 28],
          [27, 29],
          [28, 30],
          [29, 31], // 신대방: 30
          [30, 32],
          [31, 33], // 대림: 32
          [32, 34, 47], // 신도림: 33
          [33, 35], // 문래: 34
          [34, 36],
          [35, 37],
          [36, 38],
          [37, 39],
          [38, 40],
          [39, 41], // 이대: 40
          [40, 42],
          [0, 41], // 충정로: 42
          [10, 44], // 용답: 43
          [43, 45], // 신답: 44
          [44, 46],
          [45], // 신설동: 46
          [33, 48], // 도림천: 47
          [47, 49],
          [48, 50],
          [49, 51],
          [50] // 까치산: 51
        ],
        3: [
          [1], // 대화
          [0, 2],
          [1, 3],
          [2, 4],
          [3, 5],
          [4, 6],
          [5, 7],
          [6, 8],
          [7, 9],
          [8, 10],
          [9, 11], // 지축: 10
          [10, 12],
          [11, 13],
          [12, 14],
          [13, 15],
          [14, 16],
          [15, 17],
          [16, 18],
          [17, 19],
          [18, 20],
          [19, 21], // 종로3가: 20
          [20, 22],
          [21, 23],
          [22, 24],
          [23, 25],
          [24, 26],
          [25, 27],
          [26, 28],
          [27, 29],
          [28, 30],
          [29, 31], // 고속터미널: 30
          [30, 32],
          [31, 33],
          [32, 34],
          [33, 35],
          [34, 36],
          [35, 37],
          [36, 38],
          [37, 39],
          [38, 40],
          [39, 41], // 수서: 40
          [40, 42],
          [41, 43],
          [42] // 오금
        ],
        4: [
          [1], // 진접
          [0, 2],
          [1, 3],
          [2, 4],
          [3, 5],
          [4, 6],
          [5, 7],
          [6, 8],
          [7, 9],
          [8, 10],
          [9, 11], // 미아: 10
          [10, 12],
          [11, 13],
          [12, 14],
          [13, 15],
          [14, 16],
          [15, 17],
          [16, 18],
          [17, 19],
          [18, 20],
          [19, 21], // 회현: 20
          [20, 22],
          [21, 23],
          [22, 24],
          [23, 25],
          [24, 26],
          [25, 27],
          [26, 28],
          [27, 29],
          [28, 30],
          [29, 31], // 선바위: 30
          [30, 32],
          [31, 33],
          [32, 34],
          [33, 35],
          [34, 36],
          [35, 37],
          [36, 38],
          [37, 39],
          [38, 40],
          [39, 41], // 수리산: 40
          [40, 42],
          [41, 43],
          [42, 44],
          [43, 45],
          [44, 46],
          [45, 47],
          [46, 48],
          [47, 49],
          [48, 50],
          [49, 51], // 정왕: 50
          [50] // 오이도
        ],
        5: [
          [1], // 방화
          [0, 2],
          [1, 3],
          [2, 4],
          [3, 5],
          [4, 6],
          [5, 7],
          [6, 8],
          [7, 9],
          [8, 10],
          [9, 11], // 목동: 10
          [10, 12],
          [11, 13],
          [12, 14],
          [13, 15],
          [14, 16],
          [15, 17],
          [16, 18],
          [17, 19],
          [18, 20],
          [19, 21], // 애오개: 20
          [20, 22],
          [21, 23],
          [22, 24],
          [23, 25],
          [24, 26],
          [25, 27],
          [26, 28],
          [27, 29],
          [28, 30],
          [29, 31], // 왕십리: 30
          [30, 32],
          [31, 33],
          [32, 34],
          [33, 35],
          [34, 36],
          [35, 37],
          [36, 38],
          [37, 39, 49], // 강동: 38
          [38, 40],
          [39, 41], // 굽은다리: 40
          [40, 42],
          [41, 43],
          [42, 44],
          [43, 45],
          [44, 46],
          [45, 47],
          [46, 48],
          [47, 49], // 하남검단산: 48
          [48, 50], // 둔촌동: 49
          [49, 51],
          [50, 52],
          [51, 53],
          [52, 54],
          [53, 55],
          [54] // 마천
        ],
        6: [
          [1, 6], // 응암 / 0
          [0, 2],
          [1, 3],
          [2, 4],
          [3, 5],
          [4, 6], // 구산
          [1, 7], // 새절: 6
          [6, 8],
          [7, 9],
          [8, 10],
          [9, 11, 44], // 마포구청: 10
          [10, 12],
          [11, 13],
          [12, 14],
          [13, 15],
          [14, 16],
          [15, 17],
          [16, 18],
          [17, 19],
          [18, 20],
          [19, 21], // 이태원: 20
          [20, 22],
          [21, 23],
          [22, 24],
          [23, 25],
          [24, 26],
          [25, 27],
          [26, 28],
          [27, 29],
          [28, 30],
          [29, 31], // 고려대: 30
          [30, 32],
          [31, 33],
          [32, 34],
          [33, 35],
          [34, 36],
          [35, 37],
          [36, 38],
          [37, 39] // 신내: 38
        ],
        7: [
          [1], // 장암
          [0, 2],
          [1, 3],
          [2, 4],
          [3, 5],
          [4, 6],
          [5, 7],
          [6, 8],
          [7, 9],
          [8, 10],
          [9, 11], // 중화: 10
          [10, 12],
          [11, 13],
          [12, 14],
          [13, 15],
          [14, 16],
          [15, 17],
          [16, 18],
          [17, 19],
          [18, 20],
          [19, 21], // 청담: 20
          [20, 22],
          [21, 23],
          [22, 24],
          [23, 25],
          [24, 26],
          [25, 27],
          [26, 28],
          [27, 29],
          [28, 30],
          [29, 31], // 상도: 30
          [30, 32],
          [31, 33],
          [32, 34],
          [33, 35],
          [34, 36],
          [35, 37],
          [36, 38],
          [37, 39],
          [38, 40],
          [39, 41], // 천왕: 40
          [40, 42],
          [41, 43],
          [42, 44],
          [43, 45],
          [44, 46],
          [45, 47],
          [46, 48],
          [47, 49],
          [48, 50],
          [49, 51], // 부평구청: 50
          [50, 52],
          [51] // 석남
        ],
        8: [
          [1], // 암사 / 0
          [0, 2],
          [1, 3],
          [2, 4],
          [3, 5],
          [4, 6],
          [5, 7],
          [6, 8],
          [7, 9],
          [8, 10],
          [9, 11], // 복정: 10
          [10, 12],
          [11, 13],
          [12, 14],
          [13, 15],
          [14, 16],
          [15, 17],
          [16] // 모란
        ],
        9: [
          [1], // 개화 / 0
          [0, 2],
          [1, 3],
          [2, 4],
          [3, 5],
          [4, 6],
          [5, 7],
          [6, 8],
          [7, 9],
          [8, 10],
          [9, 11], // 신목동: 10
          [10, 12],
          [11, 13],
          [12, 14],
          [13, 15],
          [14, 16],
          [15, 17],
          [16, 18],
          [17, 19],
          [18, 20],
          [19, 21], // 구반포: 20
          [20, 22],
          [21, 23],
          [22, 24],
          [23, 25],
          [24, 26],
          [25, 27],
          [26, 28],
          [27, 29],
          [28, 30],
          [29, 31], // 삼전: 30
          [30, 32],
          [31, 33],
          [32, 34],
          [33, 35],
          [34, 36],
          [35, 37],
          [36, 38],
          [37] // 중앙보훈병원
        ]
      }
    },
  ];

  // 구글 로그인 (Android & IOS)
  // Future<UserCredential> signInWithGoogle() async {
  //   print("hi");
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication? googleAuth =
  //       await googleUser?.authentication;

  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );

  //   final user = await FirebaseAuth.instance.signInWithCredential(credential);

  //   // 처음이면 계정 만들기, 아니면 패스
  //   var userLastLoginTime = user.user!.metadata.lastSignInTime;
  //   var userCreationTime = user.user!.metadata.creationTime;

  //   if (userLastLoginTime == userCreationTime) {
  //     collectionReference.doc(user.user?.uid).set({
  //       "username": "${user.user?.displayName}",
  //       "id": user.user?.uid,
  //       "character": "basic",
  //       "money": 0,
  //       "basicTurn": 1
  //     });

  //     collectionReference
  //         .doc(user.user?.uid)
  //         .collection("dayStamp")
  //         .doc("1")
  //         .set({"date": "start"});

  //     for (var i = 1; i < 7; i++) {
  //       collectionReference
  //           .doc(user.user?.uid)
  //           .collection('closet')
  //           .doc('top$i')
  //           .set({
  //         "isChecked": false,
  //         "name": "top$i",
  //         "own": false,
  //         "price": i * 10000,
  //       });
  //     }
  //   }

  //   return user;
  // }

  @override
  Widget build(BuildContext context) {
    // 역 간 거리 구하기 bfs 알고리즘
    int bfs(line, start, end, visited, dis) {
      // print("시작역: $start, 도착역: $end");
      var queue = ListQueue();
      queue.add(start);
      visited[start] = true;

      while (queue.isNotEmpty) {
        if (visited[end] == true) {
          break;
        }
        // print("큐: $queue\n거리: $dis");
        var v = queue.removeFirst();
        for (var i in line[v]) {
          if (!visited[i]) {
            queue.add(i);
            visited[i] = true;
            dis[i] = dis[v] + 1;
          }
        }
      }
      return dis[end];
    }

    // 미디어쿼리
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          "RUN",
          style: TextStyle(
            color: Theme.of(context).colorScheme.background,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "로그인 후 학습을 시작해보세요!",
                          style: TextStyle(
                              color: Theme.of(context)
                                  .appBarTheme
                                  .backgroundColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LogIn()));
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context)
                                      .appBarTheme
                                      .backgroundColor)),
                          child: const Text(
                            "로그인",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  var userId = snapshot.data!.uid;
                  return Column(
                    children: [
                      StreamBuilder(
                        stream: collectionReference.doc(userId).snapshots(),
                        builder: ((context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Text("-");
                          } else {
                            var money = snapshot.data!.data()!['money'];
                            var basicTurn = snapshot.data!.data()!['basicTurn'];
                            return StreamBuilder(
                              stream: collectionReference
                                  .doc(userId)
                                  .collection("runCard")
                                  .orderBy("timestamp")
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<
                                          QuerySnapshot<Map<String, dynamic>>>
                                      snapshot) {
                                if (!snapshot.hasData) {
                                  return const Text("-");
                                } else {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  final docs = snapshot.data!.docs;
                                  return SizedBox(
                                    height: height * 0.7,
                                    child: ListView.separated(
                                      padding: const EdgeInsets.all(20),
                                      itemCount: docs.length,
                                      shrinkWrap: true,
                                      separatorBuilder: (context, index) =>
                                          const Divider(
                                        height: 20.0,
                                      ),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return LineCard(
                                            icon: Icons.location_on,
                                            startStation: docs[index]
                                                ['startStation'],
                                            endStation: docs[index]
                                                ['endStation'],
                                            count: docs[index]['count'],
                                            turn: docs[index]['turn'],
                                            wordbook: docs[index]['wordbook'],
                                            title:
                                                "${docs[index]['startStation']} - ${docs[index]['endStation']}",
                                            userId: userId,
                                            money: money,
                                            basicTurn: basicTurn);
                                      },
                                    ),
                                  );
                                }
                              },
                            );
                          }
                        }),
                      ),

                      // 단어가 9개 이상인 단어장만 띄우기
                      StreamBuilder(
                        stream: collectionReference
                            .doc(userId)
                            .collection("userWordbook")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Text("-");
                          } else {
                            final docs = snapshot.data!.docs;

                            for (var doc in docs) {
                              if (doc.data()['count'] >= 9) {
                                wordbooks.add(doc.data()['title']);
                              }
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else {
                              return Container();
                            }
                          }
                        },
                      ),
                      FloatingActionButton(
                        onPressed: () => showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return AlertDialog(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    title: Text(
                                      '새로운 경로',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .appBarTheme
                                              .backgroundColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: SizedBox(
                                      height: 500,
                                      width: 200,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          const Text(
                                            "역은 같은 호선 내에서만 선택 가능합니다.",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.blueAccent),
                                          ),
                                          // 단어장 드롭박스
                                          DropdownButton(
                                            value: wordbook,
                                            items: wordbooks.map((String item) {
                                              return DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(item),
                                              );
                                            }).toList(),
                                            onChanged: (dynamic value) {
                                              setState(() {
                                                wordbook = value;
                                              });
                                            },
                                          ),
                                          // 호선 선택 드롭박스
                                          DropdownButton(
                                              value: line,
                                              items: lineDropBox
                                                  .map((String item) {
                                                return DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(item),
                                                );
                                              }).toList(),
                                              onChanged: (dynamic value) {
                                                setState(
                                                  () {
                                                    line = value;
                                                    lineSearchText = value[0];
                                                    var intValue =
                                                        int.parse(value[0]);
                                                    startStationController
                                                        .text = "";
                                                    endStationController.text =
                                                        "";

                                                    stationList = lineInfo[0]
                                                            ['stationList']![
                                                        intValue];
                                                    lineList = lineInfo[0]
                                                        ['lineList']![intValue];
                                                    codeList = lineInfo[0]
                                                        ['codeList']![intValue];
                                                  },
                                                );
                                              }),
                                          Row(
                                            children: [
                                              // 출발역 검색
                                              Flexible(
                                                flex: 5,
                                                child: SizedBox(
                                                  height: 200,
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: TextField(
                                                          controller:
                                                              startStationController,
                                                          decoration:
                                                              const InputDecoration(
                                                                  hintText:
                                                                      "출발역",
                                                                  border:
                                                                      OutlineInputBorder()),
                                                          onChanged: (value) {
                                                            setState(
                                                              () {
                                                                startSearchText =
                                                                    value;
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: ListView.builder(
                                                          itemCount:
                                                              stationList!
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            if (startSearchText
                                                                    .isNotEmpty &&
                                                                !stationList![
                                                                        index]
                                                                    .toLowerCase()
                                                                    .contains(
                                                                        startSearchText
                                                                            .toLowerCase())) {
                                                              return const SizedBox
                                                                  .shrink();
                                                            } else if (lineSearchText
                                                                    .isNotEmpty &&
                                                                !lineList![
                                                                        index]
                                                                    .contains(
                                                                        lineSearchText)) {
                                                              return const SizedBox();
                                                            } else {
                                                              return GestureDetector(
                                                                onTap: () {
                                                                  startStationController
                                                                          .text =
                                                                      stationList![
                                                                          index];
                                                                  startCodeController
                                                                          .text =
                                                                      codeList![
                                                                          index];
                                                                },
                                                                child: Card(
                                                                  elevation: 3,
                                                                  shape: const RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(Radius.elliptical(
                                                                              20,
                                                                              20))),
                                                                  child:
                                                                      ListTile(
                                                                    title:
                                                                        Column(
                                                                      children: [
                                                                        Text(lineList![
                                                                            index]),
                                                                        Text(stationList![
                                                                            index]),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 5,
                                                child: SizedBox(
                                                  height: 200,
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: TextField(
                                                          controller:
                                                              endStationController,
                                                          decoration:
                                                              const InputDecoration(
                                                                  hintText:
                                                                      "도착역",
                                                                  border:
                                                                      OutlineInputBorder()),
                                                          onChanged: (value) {
                                                            setState(
                                                              () {
                                                                endSearchText =
                                                                    value;
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: ListView.builder(
                                                          itemCount:
                                                              stationList!
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            if (endSearchText
                                                                    .isNotEmpty &&
                                                                !stationList![
                                                                        index]
                                                                    .toLowerCase()
                                                                    .contains(
                                                                        endSearchText
                                                                            .toLowerCase())) {
                                                              return const SizedBox
                                                                  .shrink();
                                                            } else if (lineSearchText
                                                                    .isNotEmpty &&
                                                                !lineList![
                                                                        index]
                                                                    .contains(
                                                                        lineSearchText)) {
                                                              return const SizedBox();
                                                            } else {
                                                              return GestureDetector(
                                                                onTap: () {
                                                                  endStationController
                                                                          .text =
                                                                      stationList![
                                                                          index];
                                                                  endCodeController
                                                                          .text =
                                                                      codeList![
                                                                          index];
                                                                },
                                                                child: Card(
                                                                  elevation: 3,
                                                                  shape: const RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(Radius.elliptical(
                                                                              20,
                                                                              20))),
                                                                  child:
                                                                      ListTile(
                                                                    title:
                                                                        Column(
                                                                      children: [
                                                                        Text(lineList![
                                                                            index]),
                                                                        Text(stationList![
                                                                            index]),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('취소'),
                                        onPressed: () {
                                          wordbook = "Basic Words";
                                          line = "호선 선택";
                                          lineSearchText = "";
                                          lineController.text = "";
                                          startStationController.text = "";
                                          endStationController.text = "";
                                          stationList = [''];
                                          lineList = [''];
                                          codeList = [''];
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('추가'),
                                        onPressed: () {
                                          var intLine = int.parse(line[0]);

                                          // print("호선 : $intLine");
                                          String newName =
                                              "${startStationController.text} - ${endStationController.text} - $wordbook";

                                          int count = bfs(
                                              lineInfo[0]['bfsList']![intLine],
                                              int.parse(
                                                  startCodeController.text),
                                              int.parse(endCodeController.text),
                                              visited,
                                              dis);

                                          print("역 개수: $count");

                                          int turn = 0;
                                          if (count <= 4) {
                                            turn = 1;
                                          } else {
                                            turn = (count / 4).floor();
                                          }
                                          setState(() {
                                            collectionReference
                                                .doc(userId)
                                                .collection("runCard")
                                                .doc(newName)
                                                .set(
                                              {
                                                "startStation":
                                                    startStationController.text,
                                                "endStation":
                                                    endStationController.text,
                                                "wordbook": wordbook,
                                                "count": "${turn * 9}개",
                                                "turn": "$turn턴",
                                                "timestamp": DateTime.now()
                                              },
                                            );
                                          });
                                          wordbook = "Basic Words";
                                          line = "호선 선택";
                                          lineSearchText = "";
                                          lineController.text = "";
                                          startStationController.text = "";
                                          endStationController.text = "";
                                          stationList = [''];
                                          lineList = [''];
                                          codeList = [''];

                                          print(startStationController.text);

                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }),
                        backgroundColor:
                            Theme.of(context).appBarTheme.backgroundColor,
                        hoverColor: Theme.of(context).highlightColor,
                        child: const Icon(Icons.add),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
