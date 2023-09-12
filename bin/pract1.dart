

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

void main(List<String> arguments) {
  StudentList lst = StudentList();
  for (var i = 1; i <21 ; i++) {
    lst.addStudent(Student(i,"Familia$i", "Otchesnvo$i", "Imya$i", grade: double.parse((2.0+ Random().nextDouble()*(5.0-2.0)).toStringAsFixed(2)),group: "GR$i",age: 15 + Random().nextInt(10)));
  }
  while(true){
        print("""Выберите операцию:
        1 - Добавление студента
        2 - изменение данных студента по id
        3 - удаление студента по id
        4 - вывод студента с максимальным/минимальным баллом
        5 - вывод студентов с фильтрацией
        6 - вывод всех студентов
        7 - вывод среднего балла всех студентов
        0 - выход""");
        int num = int.parse(stdin.readLineSync()!);
        switch(num){
          case 1:
            lst.writeStudent();
          break;
          case 2: 
            try{
              print ("введите id");
              int id =int.parse(stdin.readLineSync()!);
              lst.changeStudentParameters(id);
            }
            catch(e){print("Введены неверные данные");}
          break;
          case 3:
          try{
            print ("введите id");
            int id =int.parse(stdin.readLineSync()!);
            lst.deleteStudentByID(id);
            }
            catch(e){print("Введены неверные данные");}
          break;
          case 4:
            print("Введите min или max");
            String value = stdin.readLineSync()!;
            printInfo(lst.getStudentWithHighestGrade(value));
          break;
          case 5:
            lst.printStudentsBy();
          break;
          case 6:
              lst.getStudents();
          break;
          case 7:
            print("Средний балл всех студентов: ${lst.getAverageGrade()}");
          break;
          case 0:
          exit(0);
          default:
          break;
        }
  }
    
}




void printInfo(Student student){
      print("ID: ${student.id}, Фамилия: ${student.sername}, Имя: ${student.firstname}, Отчество: ${student.middlename}, Возраст: ${student.age}, Группа:  ${student.group}, Оценка: ${student.grade}");
    }

class Student{
  late int id;
  late String sername;
  late String middlename;
  late String firstname;
  int? age =0;
  late String? group;
  late double grade;

    Student(this.id,this.sername,this.middlename,this.firstname,{required this.grade, this.group, this.age});

    
}

class StudentList{
  List<Student> students =[];
 


  void printStudentsBy(){
    print("выберите вывод студентов: 1 - по группе, 2 - по среднему баллу");
    late int type;
    try{
    type= int.parse(stdin.readLineSync()!);
    
    switch(type){
      case 1: 
      print("Введите группу: ");
      String? group = stdin.readLineSync(encoding: systemEncoding)!;
        for (var std in students) {
            if(std.group==group){ printInfo(std);}
            }
      case 2:
       print("Введите средний балл: ");
      double grade = double.parse(stdin.readLineSync()!);
       for (var std in students) {
            if(std.grade==grade) printInfo(std);
            }
      default: print("Нет такой операции"); break;
    }
    }catch(e){print("Введены неверные данные");}
  }

  void writeStudent(){
    
    bool canWrite =false;
    late String name, sername, middlename, group;
    double  grade;
    int age;
    do{
      canWrite=true;
      try{
        print("Введите имя студента");
        name = stdin.readLineSync(encoding: utf8)!;
        print("Введите фамилию студента");
        sername = stdin.readLineSync(encoding: utf8)!;
        print("Введите отчество студента");
        middlename = stdin.readLineSync()!;
        print("Введите средний балл студента");
        grade = double.parse(stdin.readLineSync(encoding: utf8)!);
        print("Введите возраст студента");
        age = int.parse(stdin.readLineSync()!);
        print("Введите группу студента");
        group = stdin.readLineSync(encoding: utf8)!;
      
        if(name.isEmpty|| sername.isEmpty||middlename.isEmpty||group.isEmpty || age.isNegative||grade<0.0){
          print("Значения заполнены неверно");
          canWrite=true;
        }else{
        Student student = Student(students.length+1, sername, middlename, name, grade: grade,group: group,age: age);
        addStudent(student);
        canWrite = false;
        }
        }catch(e){print("Введены неверные данные");}
    }
    while(canWrite);
    
  }

  void addStudent(Student student){
    students.add(student);
  }

  Student getStudentWithHighestGrade(String value){
    Student student = switch (value){
      "min"=> students.reduce((curr, next) => curr.grade < next.grade ? curr : next),
      "max"=> students.reduce((curr, next) => curr.grade > next.grade ? curr : next),
      _=>students.first
    };
    return student;
  }
  double getAverageGrade(){
   dynamic averageGrade =0 ;
    for (var student in students) {
        averageGrade += student.grade;
    }
    return averageGrade/students.length;
  }
  
  void deleteStudentByID(int id){
    try{
    students.removeWhere((element) => element.id==id);
    }
    catch(e){print("Такого id не существует");}
  }
  void changeStudentParameters(int id){
    try{
    Student student = students.where((element) => element.id==id).first;
   
    int index =  students.indexOf(student);
    bool canWrite =false;
    String name, sername, middlename, group;
    double  grade;
    int age;
    do{
      canWrite=true;
      try{
        print("Введите имя студента");
        name = stdin.readLineSync(encoding: utf8)!;
        print("Введите фамилию студента");
        sername = stdin.readLineSync(encoding: utf8)!;
        print("Введите отчество студента");
        middlename = stdin.readLineSync(encoding: utf8)!;
        print("Введите средний балл студента");
        grade = double.parse(stdin.readLineSync()!);
        print("Введите возраст студента");
        age = int.parse(stdin.readLineSync()!);
        print("Введите группу студента");
        group = stdin.readLineSync(encoding: utf8)!;
        if(name.isEmpty|| sername.isEmpty||middlename.isEmpty||group.isEmpty|| age.isNegative||age.isNaN||grade<0.0){
          print("Значения заполнены неверно");
          canWrite=true;
        }else{
          student.firstname = name;
          student.middlename = middlename;
          student.sername = sername;
          student.grade = grade;
          student.group = group;
          student.age = age;
          students.replaceRange(index , index+1, [student]);
          canWrite = false;
        }
      }catch(e){print("Введены неверные данные");}
    }
    while(canWrite);
     }
    catch(e){print("Такого id не существует");}
  }
  void getStudents(){
    for (var std in students) {
      printInfo(std);
    }
  }
}