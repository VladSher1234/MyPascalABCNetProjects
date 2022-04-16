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
      if (d < 0) then begin
        n *= -1;
        d *= -1;
      end;
      var nod := School.НОД(n, d);
      num := n div nod;
      denom := d div nod;
    end;
    /// Выводит дробь
    procedure Print;
    begin
      write(num);
      if (denom <> 1) then
        writeln('/', denom);
    end;
    
    static function operator+(f, f1: Fraction): Fraction;
    begin
      var nok := School.НОК(f.denom, f1.denom);
      Result := new Fraction(f.num * (nok div f1.denom) + f1.num * (nok div f.denom), nok)
    end;
    
    static function operator-(f, f1: Fraction): Fraction;
    begin
      var nok := School.НОК(f.denom, f1.denom);
      Result := new Fraction(f.num * (nok div f1.denom) - f1.num * (nok div f.denom), nok)
    end;
    
    static function operator*(f, f1: Fraction): Fraction := new Fraction(f.num * f1.num, f.denom * f1.denom);
    
    static function operator*(f: Fraction; i: integer): Fraction := new Fraction(f.num * i, f.denom);
    
    static function operator/(f, f1: Fraction): Fraction := new Fraction(f.num * f1.denom, f.denom * f1.num);
    
    static function operator/(f: Fraction; i: integer): Fraction := new Fraction(f.num, f.denom * i);
    
    static function operator implicit(f: Fraction): real := f.num / f.denom;
    
    static function operator=(f, f1: Fraction): boolean := (f.num = f1.num) and (f.denom = f1.denom);

    static function operator>(f, f1: Fraction): boolean;
    begin
      var nok := School.НОК(f.denom, f1.denom);
      Result := (f.num * (nok / f.denom) > f1.num * (nok / f1.denom))
    end;
    
    static function operator<(f, f1: Fraction): boolean;
    begin
      var nok := School.НОК(f.denom, f1.denom);
      Result := (f.num * (nok / f.denom) < f1.num * (nok / f1.denom))
    end;
    
    static function operator<>(f, f1: Fraction): boolean := not (f = f1);
    
  end;

//    ||Смешанные числа||

type
  /// Тип смешанных чисел
  MixNumber = record
    /// Целая часть
    mix: integer;
    /// Дробная часть
    frac: Fraction;
    constructor(m: integer; f: Fraction);
    begin
      if (f.num < 0) then begin
        m *= -1;
        f.num *= -1;
      end;
      mix := m + f.num div f.denom;
      frac := new Fraction(f.num mod f.denom, f.denom)
    end;
    /// Выводит смешанное число
    procedure PrintM;
    begin
      if mix <> 0 then
        print(mix);
      frac.Print
    end;
    
    /// Возвращает значение, равное смешанному числу, переведенное в обыкновенную дробь
    function ToFraction: Fraction := new Fraction(mix * frac.denom + frac.num, frac.denom);
    
    static function operator+(m, m1: MixNumber): MixNumber:= new MixNumber(0, m.ToFraction + m1.ToFraction); 

    static function operator-(m, m1: MixNumber): MixNumber:= new MixNumber(0, m.ToFraction - m1.ToFraction); 

    static function operator*(m, m1: MixNumber): MixNumber:= new MixNumber(0, m.ToFraction * m1.ToFraction); 
    
    static function operator/(m, m1: MixNumber): MixNumber:= new MixNumber(0, m.ToFraction / m1.ToFraction); 
    
    static function operator implicit(m: MixNumber): real := m.mix + real(m.frac);
    
    static function operator=(m, m1: MixNumber): boolean := m.ToFraction = m1.ToFraction;
    
    static function operator>(m, m1: MixNumber): boolean := m.ToFraction > m1.ToFraction;
    
    static function operator<(m, m1: MixNumber): boolean := m.ToFraction < m1.ToFraction;
    
    static function operator<>(m, m1: MixNumber): boolean := not (m = m1);

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