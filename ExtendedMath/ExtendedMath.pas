unit ExtendedMath;
uses School;

// Условные обозначения:

//----------------------------------------------------------------------------
//          Раздел
//----------------------------------------------------------------------------

//    ||Подраздел||

/// Описание чего-либо (функций, констант и т. д.)

//----------------------------------------------------------------------------
//          Дроби, смешанные числа
//----------------------------------------------------------------------------

//    ||Все с дробями||

type
  /// Тип обыкновенных дробей
  Fraction = record
    /// Числитель
    num: integer;
    /// Знаменатель
    denom: integer;
    constructor(n, d: integer);
    begin
      if d = 0 then
        raise new System.Exception('Знаменатель дроби не может быть равен 0');
      var nod := School.НОД(n, d);
      num := n div nod;
      denom := d div nod;
    end;
    /// Выводит дробь
    procedure Print;
    begin
      writeln(num, '/', denom);
    end;
    
    static function operator+(f, f1: Fraction): Fraction;
    begin
      var resf: Fraction;
      if f.denom = f1.denom then begin
        resf.denom := f.denom;
        resf.num := f.num + f1.num;
        Result := resf
      end
      else begin
        (f.num, f1.num) := (f.num * f1.denom, f1.num * f.denom);
        (f.denom, f1.denom) := (f.denom * f1.denom, f1.denom * f.denom);
        resf.num := f.num + f1.num;
        resf.denom := f.denom;
        Result := resf
      end;
    end;
    
    static function operator-(f, f1: Fraction): Fraction;
    begin
      var resf: Fraction;
      if f.denom = f1.denom then begin
        resf.denom := f.denom;
        resf.num := f.num - f1.num;
        Result := resf
      end
      else begin
        (f.num, f1.num) := (f.num * f1.denom, f1.num * f.denom);
        (f.denom, f1.denom) := (f.denom * f1.denom, f1.denom * f.denom);
        resf.num := f.num - f1.num;
        resf.denom := f.denom;
        Result := resf
      end;
    end;
    
    static function operator/(f, f1: Fraction): Fraction;
    begin
      var resf: Fraction;
      resf.num := f.num * f1.denom;
      resf.denom := f.denom * f1.num;
      Result := resf
    end;    

    static function operator/(f: Fraction; i: integer): Fraction;
    begin
      Result := Fraction.Create(f.num, f.denom * i);
    end;    
  
  end;

/// Возвращает значение, равное сложению двух дробей
function AddFraction(f, f1: Fraction): Fraction;
begin
  Result := f + f1;
end;
/// Возвращает значение, равное вычитанию двух дробей
function SubstractFraction(f, f1: Fraction): Fraction;
begin
  Result := f - f1;
end;
/// Возвращает значение, равное делению двух дробей
function DivideFraction(f, f1: Fraction): Fraction;
begin
  Result := f / f1;
end;
/// Возвращает значение, равное сокращенной дроби. Если дробь не сокращаема, возвращается изначальная дробь
function ReduceFraction(f: Fraction): Fraction;
begin
  var i := 1;
  var max := max(f.num, f.denom);
  loop round(max) do
  begin
    i += 1;
    if (round(f.num) mod i = 0) and (round(f.denom) mod i = 0) then begin
      f := f / i;
      i := 1
    end
  end;
  Result := f
end;
/// Возвращает значение, равное обыкновенной дроби переведенной в десятичную
function FracToDecimal(f: Fraction): real := f.num / f.denom;
/// Возвращает максимальную дробь из f и f1
function MaxFraction(f, f1: Fraction): Fraction;
begin
  if f.denom = f1.denom then 
    if f.num > f1.num then
      Result := f
    else
      Result := f1
  else begin
    var ftemp := f;
    var f1temp := f1;
    (f.num, f1.num) := (f.num * f1.denom, f1.num * f.denom);
    (f.denom, f1.denom) := (f.denom * f1.denom, f1.denom * f.denom);
    if f.num > f1.num then
      Result := ftemp
    else
      Result := f1temp
  end;
end;

//    ||Смешанные числа||

type
  /// Тип смешанных чисел
  MixNumber = record
    /// Целая часть
    mix: integer;
    /// Числитель
    num: integer;
    /// Знаменатель
    denom: integer;
    constructor(m: integer; n, d: integer);
    begin
      mix := m;
      num := n;
      denom := d;
    end;
    /// Выводит смешанное число
    procedure Print;
    begin
      if num = 0 then
        println(mix)
      else
      if mix = 0 then
        println(num, '/', denom)
      else
        println(mix, num + '/' + denom)
    end;
  end;


/// Возвращает значение, равное смешанному числу переведенной в десятичное
function MixNumToDecimal(m: MixNumber): real := m.mix + m.num / m.denom;
/// Возвращает значение, равное дроби, переведенное в смешанное число
function FracToMixNum(f: Fraction): MixNumber;
begin
  var m := new MixNumber(round(f.num) div round(f.denom), round(f.num) mod round(f.denom), f.denom);
  Result := m
end;
/// Возвращает значение, равное смешанному числу, переведенное в обыкновенную дробь
function MixNumToFrac(m: MixNumber): Fraction;
begin
  var f := new Fraction(m.mix * m.denom + m.num, m.denom);
  Result := f
end;
/// Возвращает значение, равное сокращенному смешанному числу. Если смешанное число не сокращаемо, возвращается изначальное смешанное число.
function ReduceMixNumber(m: MixNumber): MixNumber;
begin
  var i := 1;
  var max: real;
  if m.num > m.denom then
    max := m.num
  else
    max := m.denom;
  loop round(max) do
  begin
    i += 1;
    if (round(m.num) mod i = 0) and (round(m.denom) mod i = 0) then begin
      m.num := m.num div i;
      m.denom := m.denom div i;
      i := 1
    end
  end;
  m.mix := m.mix;
  Result := m
end;
/// Возвращает значение, равное сложению двух смешанных чисел
function AddMixNumber(m, m1: MixNumber): MixNumber;
begin
  var resf: MixNumber;
  if m.denom = m1.denom then begin
    resf.mix := m.mix + m1.mix;
    resf.denom := m.denom;
    resf.num := m.num + m1.num;
    var resm := MixNumToFrac(resf);
    Result := FracToMixNum(resm);
  end
  else begin
    resf.mix := m.mix + m1.mix;
    (m.num, m1.num) := (m.num * m1.denom, m1.num * m.denom);
    (m.denom, m1.denom) := (m.denom * m1.denom, m1.denom * m.denom);
    resf.num := m.num + m1.num;
    resf.denom := m.denom;
    var resm := MixNumToFrac(resf);
    Result := FracToMixNum(resm);
  end;
end;
/// Возвращает значение, равное вычитанию двух смешанных чисел
function SubstractMixNumber(m, m1: MixNumber): MixNumber;
begin
  var resf: MixNumber;
  if m.denom = m1.denom then begin
    resf.mix := m.mix - m1.mix;
    resf.denom := m.denom;
    resf.num := m.num - m1.num;
    var resm := MixNumToFrac(resf);
    Result := FracToMixNum(resm);
  end
  else begin
    resf.mix := m.mix - m1.mix;
    (m.num, m1.num) := (m.num * m1.denom, m1.num * m.denom);
    (m.denom, m1.denom) := (m.denom * m1.denom, m1.denom * m.denom);
    resf.num := m.num - m1.num;
    resf.denom := m.denom;
    var resm := MixNumToFrac(resf);
    Result := FracToMixNum(resm);
  end;
end;
/// Возвращает значение, равное умножению двух смешанных чисел
function MultipleMixNumber(m, m1: MixNumber): MixNumber;
begin
  var (f, f1) := (MixNumToFrac(m), MixNumToFrac(m1));
  var resf := new Fraction(f.num * f1.num, f.denom * f1.denom);
  Result := FracToMixNum(resf)
end;
/// Возвращает значение, равное делению двух смешанных чисел
function DivideMixNumber(m, m1: MixNumber): MixNumber;
begin
  var (f, f1) := (MixNumToFrac(m), MixNumToFrac(m1));
  var resf := new Fraction(f.num * f1.denom, f.denom * f1.num);
  Result := FracToMixNum(resf)
end;
/// Возвращает максимальное смешанное число из m и m1
function MaxMixNumber(m, m1: MixNumber): MixNumber;
begin
  var f := MixNumToFrac(m);
  var f1 := MixNumToFrac(m1);
  if f.denom = f1.denom then 
    if f.num > f1.num then
      Result := FracToMixNum(f)
    else
      Result := FracToMixNum(f1)
  else begin
    var ftemp := f;
    var f1temp := f1;
    (f.num, f1.num) := (f.num * f1.denom, f1.num * f.denom);
    (f.denom, f1.denom) := (f.denom * f1.denom, f1.denom * f.denom);
    if f.num > f1.num then
      Result := FracToMixNum(ftemp)
    else
      Result := FracToMixNum(f1temp)
  end;
end;

//----------------------------------------------------------------------------
//          Константы
//----------------------------------------------------------------------------

const
  /// Константа Фи
  Fi = 1.618033988749894;
  /// Константа корня из двух
  Sqr2 = 1.414213562373095;
  /// Константа, равная скорости света (м/с)
  SpeedOfLight = 299792458;
  /// Константа, равная скорости звука в сухом воздухе при темп. 20 градусов (м/с)
  SpeedOfSound = 343;
  /// Минимальное значение типа integer
  MinInt = Integer.MinValue;
  /// Максимальное значение типа BigInteger
  MaxBigInt = Real.PositiveInfinity;
  /// Минимальное значение типа BigInteger
  MinBigInt = Real.NegativeInfinity;

//----------------------------------------------------------------------------
//          Простые функции
//----------------------------------------------------------------------------

/// Возвращает значение 2 в степени a
function PowerOfTwo(a: integer): real := 2 ** a;
/// Возвращает значение 10 в степени a
function PowerOfTen(a: integer): real := 10 ** a;
/// Возвращает значение прибавления чисел a и b
function Add(a, b: integer): integer := a + b;
/// Возвращает значение убавления чисел a и b
function Substract(a, b: integer): integer := a - b;
/// Возвращает значение умножения чисел a и b
function Multiple(a, b: integer): integer := a * b;
/// Возвращает значение деления чисел a и b
function Divide(a, b: integer): real := a / b;
/// Возвращает значение квадрата a
function Square(a: integer): real := a ** 2;
/// Возвращает значение куба a
function Cube(a: integer): real := a ** 3;
/// Возвращает значение деления чисел 1 на a
function OneDivideByNumber(a: integer): real := 1 / a;
/// Возвращает значение, равное a в степени a
function Shepower(a: integer): biginteger;
begin
  Result := 1;
  loop a do
    Result *= a
end;
/// Возвращает максимальное значение из a, b, c
function Max3(a, b, c: integer): integer;
begin
  if (a > b) and (a > c) then Result := a;
  if (b > a) and (b > c) then Result := b;
  if (c > a) and (c > b) then Result := c
end;

//----------------------------------------------------------------------------
//          Функции на проверку чего либо в числе
//----------------------------------------------------------------------------

//    ||Проверка с числом||

/// Возвращает True, если число простое, иначе возвращает False
function IsPrime(a: integer): boolean;
begin
  if a < 2 then
    Result := False;
  for var i := 2 to round(sqrt(a)) do
  begin
    if a mod i = 0 then begin
      Result := False;
      break
    end;
    if i = round(sqrt(a)) then
      Result := True
  end
end;
/// Возвращает True, если число отрицательное, иначе возвращает False
function IsNegative(a: integer): boolean;
begin
  if a < 0 then
    Result := True
  else
    Result := False
end;

//    ||Проверка с дробью||

/// Возвращает True, если дробь правильная, иначе возвращает False
function FractionIsProper(f: Fraction): boolean;
begin
  if f.denom <= f.num then
    Result := False
  else
    Result := True
end;

//----------------------------------------------------------------------------
//          Функции, работающие по определенной формуле
//----------------------------------------------------------------------------

//    ||Факториалы||

/// Возвращает значение факториала a
function Factorial(a: integer): biginteger;
begin
  Result := 1;
  for var i := 1 to a do
    Result := Result * i
end;
/// Возвращает значение суперфакториала a
function Superfactorial(a: integer): biginteger;
begin
  Result := 1;
  for var i := 1 to a do
    Result := Result * Factorial(i)
end;
/// Возвращает значение нечетнориала a
function Oddorial(a: integer): biginteger;
begin
  Result := 1;
  for var i := 1 to a step 2 do
    Result := Result * i
end;
/// Возвращает значение четнориала a
function Evenorial(a: integer): biginteger;
begin
  Result := 1;
  for var i := 2 to a step 2 do
    Result := Result * i
end;
/// Возвращает значение праймориала a
function Primorial(a: integer): biginteger;
begin
  Result := 1;
  for var p := 1 to a do
    for var i := 2 to Round(sqrt(p)) do
    begin
      if p mod i = 0 then break;
      if i = Round(Sqrt(p)) then 
        Result *= p
    end;
  Result *= 2;
end;

//    ||Все остальное||

/// Возвращает значение среднего арифметического из a и b
function ArithmeticMean(a, b: integer): real := (a + b) / 2;
/// Возвращает значение среднего арифметического из a, b и c
function ArithmeticMean3(a, b, c: integer): real := (a + b + c) / 3;
/// Возвращает значение среднего арифметического из a, b, c и d
function ArithmeticMean4(a, b, c, d: integer): real := (a + b + c + d) / 4;
/// Возвращает значение площади окружности
function AreaOfCircle(r: real): real := Pi * r ** 2;
/// Возвращает значение пути, равному скорость множить на время
function S(V, t: real): real := V * t;
/// Возвращает значение скорости, равной пути делить на время
function V(S, t: real): real := S / t;
/// Возвращает значение времени, равно пути делить на скорость
function t(S, V: real): real := S / V;
/// Возвращает значение, равное длине окружности
function Circumference(d: real): real := Pi * d;
/// Возвращает значение, равное периметру прямоугольника
function PerimeterOfRectangle(a, b: real): real := (a + b) * 2;
/// Возвращает значение, равное периметру квадрата
function PerimeterOfSquare(a: real): real := a * 4;
/// Возвращает значение, равное площади прямоугольника
function AreaOfRectangle(a, b: real): real := a * b;
/// Возвращает значение, равное объему шара
function VolumeOfBall(r: real): real := 4 / 3 * Pi * r ** 3;
/// Возвращает значение, равное площади поверхности шара
function AreaSurfaceOfBall(r: real): real := 4 * Pi * r ** 2;
/// Возвращает значение, равное площади поверхности куба
function AreaSurfaceOfCube(a: real): real := 6 * a ** 2;
/// Возвращает значение, равное объему прямоуголного параллелепипеда
function VolumeOfRectangularCuboid(a, b, c: real): real := a * b * c;
/// Возвращает значение, равное площади поверхности прямоуголного параллелепипеда
function SurfaceAreaOfRectangularCuboid(a, b, c: real): real := 2 * (a * b + b * c + a * c);
/// Возвращает значение, равное периметру поверхности прямоуголного параллелепипеда
function PerimeterOfRectangularCuboid(a, b, c: real): real := 4 * (a + b + c);
/// Возвращает значение, равное скорости против течения реки, зная скорость собственную и течения реки
function VПрТеч(VСобств, VТечРеки: real): real := VСобств - VТечРеки;
/// Возвращает значение, равное скорости по течения реки, зная скорость собственную и течения реки
function VПоТеч(VСобств, VТечРеки: real): real := VСобств + VТечРеки;
/// Возвращает значение, равное скорости собственной, зная скорость против и по течению реки
function VСобств(VПрТеч, VПоТеч: real): real := (VПрТеч + VПоТеч) / 2;
/// Возвращает значение, равное скорости течения, зная скорость против и по течению реки
function VТеч(VПрТеч, VПоТеч: real): real := (VПрТеч - VПоТеч) / 2;

//----------------------------------------------------------------------------
//          Процедуры, выводящие последовательности
//----------------------------------------------------------------------------

//    ||Рекурсивные последовательности||

// Не убирать всю эту хрень! Без нее ничего не работает! Граница начинается
/// Что то делает
function Iterate<T>(first, second, third: T; next: (T,T,T)->T): sequence of T;
begin
  yield first;
  yield second;
  yield third;
  while True do
  begin
    var nxt := next(first, second, third);
    yield nxt;
    first := second;
    second := third;
    third := nxt;
  end;
end;
/// Тоже что то делает
function SeqWhile<T>(first, second, third: T; next: (T,T,T) ->T; pred: T->boolean): sequence of T;
begin
  Result := Iterate(first, second, third, next).TakeWhile(pred);
end;
// Граница заканчивается. Дальше все можете
/// Выводит простейшую последовательность 1, 2, 3, 4... до n
procedure SequenceOfPlus1(n: integer);
begin
  SeqWhile(0, x -> x + 1, x -> x < n).Print;
end;
/// Выводит числа Фибонначи до n
procedure SequenceOfFibonacci(n: integer);
begin
  SeqWhile(0, 1, (x, y) -> x + y, x -> x < n).Print;
end;
/// Выводит числа Люка до n
procedure SequenceOfLucas(n: integer);
begin
  SeqWhile(2, 1, (x, y) -> x + y, x -> x < n).Print;
end;
/// Выводит числа трибоначчи до n
procedure SequenceOfTribonacci(n: integer);
begin
  SeqWhile(0, 0, 1, (x, y, z) -> x + y + z, x -> x < n).Print;
end;
/// Выводит степени двойки до n
procedure SequenceOfPower2(n: integer);
begin
  SeqWhile(1, x -> x * 2, x -> x < n).Print;
end;
/// Выводит степени десятки до n
procedure SequenceOfPower10(n: integer);
begin
  SeqWhile(1, x -> x * 10, x -> x < n).Print;
end;

//    ||Нерекурсивные последовательности||

/// Выводит простые числа до n
procedure SequenceOfPrimes(n: integer);
begin
  for var p := 1 to n do
    for var i := 2 to Round(sqrt(p)) do
    begin
      if p = 2 then Print(p);
      if p mod i = 0 then break;
      if i = Round(sqrt(p)) then Print(p)
    end;
end;
/// Выводит числа Мерсенна до n
procedure SequenceOfMersenne(n: integer);
begin
  for var i := 1 to n do
  begin
    if 2 ** i - 1 >= n then break;
    print(2 ** i - 1)
  end
end;
/// Выводит числа Вудала до n
procedure SequenceOfWoodall(n: integer);
begin
  for var i := 1 to n do
  begin
    if i * 2 ** i - 1 >= n then break;
    print(i * 2 ** i - 1)
  end
end;
/// Выводит числа Ферма до n
procedure SequenceOfFermat(n: integer);
begin
  for var i := 1 to n do
  begin
    if 2 ** 2 ** i + 1 >= n then break;
    print(2 ** 2 ** i + 1)
  end
end;
/// Выводит последовательность n * n до n
procedure SequenceOfNTimesN(n: integer);
begin
  for var i := 1 to n do
  begin
    if i * i >= n then break;
    print(i * i)
  end
end;
end.