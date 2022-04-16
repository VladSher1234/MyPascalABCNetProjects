uses ExtendedMath;

type
  Square = record
    length: real;
  end;


begin
  {var a := ReadInteger('Введи радиус круга:');
  println('Его площадь:', AreaOfCircle(a));
  println(OneDivideByNumber(a));
  var b := ReadReal('Введи радиус шара:');
  println('Его объем:', VolumeOfBall(b));
  var f := new MixNumber(3, 3, 4);
  var f1 := new MixNumber(3, 1, 3);
  MaxMixNumber(f, f1).Print;}
  var f := new Fraction(1, 0);
  var f1 := new Fraction(1, 2);
  ReduceFraction(f + f1).Print
end.