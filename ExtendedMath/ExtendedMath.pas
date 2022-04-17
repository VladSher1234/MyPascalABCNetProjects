/// Представляет расширенные математические функции
unit ExtendedMath;

uses School, PABCSystem, System.Numerics;

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
  /// Тип натурального числа
  Natural = class
  private
    /// Собственно число
    nat: BigInteger;
  public
    constructor(n: BigInteger);
    begin
      if n <= 0 then
        raise new System.Exception('Натуральное число не может быть равно или меньше нуля');
      nat := n;
    end;
    
    procedure Print;
    begin
      println(nat)
    end;
    
    static function operator+(n, n1: Natural): Natural := new Natural(n.nat + n1.nat);
    
    static function operator-(n, n1: Natural): Natural := new Natural(n.nat - n1.nat);
    
    static function operator*(n, n1: Natural): Natural := new Natural(n.nat * n1.nat);
    
    static function operator div(n, n1: Natural): Natural := new Natural(n.nat div n1.nat);
    
    static function operator mod(n, n1: Natural): Natural := new Natural(n.nat mod n1.nat);
    
    static function operator=(n, n1: Natural): Boolean := n.nat = n1.nat;
    
    static function operator>(n, n1: Natural): Boolean := n.nat > n1.nat;
    
    static function operator<(n, n1: Natural): Boolean := n.nat < n1.nat;
    
    static function operator<=(n, n1: Natural): Boolean := n.nat <= n1.nat;
    
    static function operator>=(n, n1: Natural): Boolean := n.nat >= n1.nat;
    
    static function operator<>(n, n1: Natural): Boolean := n.nat <> n1.nat;
  
  end;

type
  /// Тип обыкновенных дробей
  Fraction = class
  private
    /// Числитель
    num: Int64;
    /// Знаменатель
    denom: Int64;
  public
    constructor(n, d: Int64);
    begin
      if d = 0 then
        raise new System.Exception('Знаменатель дроби не может быть равен 0');
      if d < 0 then begin
        n *= -1;
        d *= -1;
      end;
      num := n div НОД(n, d);
      denom := d div НОД(n, d);
    end;
    /// Выводит дробь
    procedure PrintF;
    begin
      write(num);
      if (denom <> 1) then
        writeln('/', denom);
    end;
    
    static function Power(val, exp: Integer): Int64;
    begin
      Result := 1;
      loop exp do
        Result *= val
    end;
    
    static function operator+(f, f1: Fraction): Fraction := new Fraction(f.num * (НОК(f.denom, f1.denom) div f1.denom) + f1.num * (НОК(f.denom, f1.denom) div f.denom), НОК(f.denom, f1.denom));
    
    static function operator-(f, f1: Fraction): Fraction := new Fraction(f.num * (НОК(f.denom, f1.denom) div f1.denom) - f1.num * (НОК(f.denom, f1.denom) div f.denom), НОК(f.denom, f1.denom));
    
    static function operator*(f, f1: Fraction): Fraction := new Fraction(f.num * f1.num, f.denom * f1.denom);
    
    static function operator*(f: Fraction; i: Integer): Fraction := new Fraction(f.num * i, f.denom);
    
    static function operator**(f: Fraction; i: Integer): Fraction := new Fraction(Power(f.num, i), Power(f.denom, i));
    
    static function operator/(f, f1: Fraction): Fraction := new Fraction(f.num * f1.denom, f.denom * f1.num);
    
    static function operator/(f: Fraction; i: Integer): Fraction := new Fraction(f.num, f.denom * i);
    
    static function operator implicit(f: Fraction): Real := f.num / f.denom;
    
    static function operator=(f, f1: Fraction): Boolean := (f.num = f1.num) and (f.denom = f1.denom);
    
    static function operator>(f, f1: Fraction): Boolean := (f.num * (НОК(f.denom, f1.denom) / f.denom) > f1.num * (НОК(f.denom, f1.denom) / f1.denom));
    
    static function operator<(f, f1: Fraction): Boolean := (f.num * (НОК(f.denom, f1.denom) / f.denom) < f1.num * (НОК(f.denom, f1.denom) / f1.denom));
    
    static function operator<>(f, f1: Fraction): Boolean := not (f = f1);
  
  end;

//    ||Смешанные числа||

type
  /// Тип смешанных чисел
  MixNumber = class
  private
    /// Целая часть
    mix: Int64;
    /// Дробная часть
    frac: Fraction;
  public
    constructor(m: Int64; f: Fraction);
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
      frac.PrintF
    end;
    
    /// Возвращает значение, равное смешанному числу, переведенное в обыкновенную дробь
    function ToFraction: Fraction := new Fraction(mix * frac.denom + frac.num, frac.denom);
    
    static function operator+(m, m1: MixNumber): MixNumber := new MixNumber(0, m.ToFraction + m1.ToFraction); 
    
    static function operator-(m, m1: MixNumber): MixNumber := new MixNumber(0, m.ToFraction - m1.ToFraction); 
    
    static function operator*(m, m1: MixNumber): MixNumber := new MixNumber(0, m.ToFraction * m1.ToFraction); 
    
    static function operator/(m, m1: MixNumber): MixNumber := new MixNumber(0, m.ToFraction / m1.ToFraction); 
    
    static function operator**(m: MixNumber; i: Integer): MixNumber := new MixNumber(0, m.ToFraction ** i);
    
    static function operator implicit(m: MixNumber): Real := m.mix + Real(m.frac);
    
    static function operator=(m, m1: MixNumber): Boolean := m.ToFraction = m1.ToFraction;
    
    static function operator>(m, m1: MixNumber): Boolean := m.ToFraction > m1.ToFraction;
    
    static function operator<(m, m1: MixNumber): Boolean := m.ToFraction < m1.ToFraction;
    
    static function operator<>(m, m1: MixNumber): Boolean := not (m = m1);
  
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
  /// Минимальное значение типа Integer
  MinInt = Integer.MinValue;
  /// Максимальное значение типа BigInteger
  MaxBigInt = Real.PositiveInfinity;
  /// Минимальное значение типа BigInteger
  MinBigInt = Real.NegativeInfinity;

//----------------------------------------------------------------------------
//          Простые функции
//----------------------------------------------------------------------------

/// Возвращает значение 2 в степени a
function PowerOfTwo(a: Integer): Real := 2 ** a;
/// Возвращает значение 10 в степени a
function PowerOfTen(a: Integer): Real := 10 ** a;
/// Возвращает значение прибавления чисел a и b
function Add(a, b: Integer): Integer := a + b;
/// Возвращает значение убавления чисел a и b
function Substract(a, b: Integer): Integer := a - b;
/// Возвращает значение умножения чисел a и b
function Multiple(a, b: Integer): Integer := a * b;
/// Возвращает значение деления чисел a и b
function Divide(a, b: Integer): Real := a / b;
/// Возвращает значение квадрата a
function Square(a: Integer): Real := a ** 2;
/// Возвращает значение куба a
function Cube(a: Integer): Real := a ** 3;
/// Возвращает значение деления чисел 1 на a
function OneDivideByNumber(a: Integer): Real := 1 / a;
/// Возвращает значение, равное a в степени a
function Shepower(a: Integer): BigInteger;
begin
  Result := 1;
  loop a do
    Result *= a
end;
/// Возвращает максимальное значение из a, b, c
function Max3(a, b, c: Integer): Integer;
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
function IsPrime(a: Integer): Boolean;
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
function IsNegative(a: Integer): Boolean;
begin
  if a < 0 then
    Result := True
  else
    Result := False
end;

//    ||Проверка с дробью||

/// Возвращает True, если дробь правильная, иначе возвращает False
function FractionIsProper(f: Fraction): Boolean;
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
function Factorial(a: Integer): BigInteger;
begin
  Result := 1;
  for var i := 1 to a do
    Result *= i
end;
/// Возвращает значение суперфакториала a
function Superfactorial(a: Integer): BigInteger;
begin
  Result := 1;
  for var i := 1 to a do
    Result *= Factorial(i)
end;
/// Возвращает значение нечетнориала a
function Oddorial(a: Integer): BigInteger;
begin
  Result := 1;
  for var i := 1 to a step 2 do
    Result *= i
end;
/// Возвращает значение четнориала a
function Evenorial(a: Integer): BigInteger;
begin
  Result := 1;
  for var i := 2 to a step 2 do
    Result *= i
end;
/// Возвращает значение праймориала a
function Primorial(a: Integer): BigInteger;
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

/// Возвращает значение корня n-ной степени из a
function NRoot(n: Integer; a: Real): Real;
begin
  if n = 0 then
    raise new Exception('Нельзя найти нулевой корень');
  if a = 0.0 then
    NRoot := 0.0
  else 
  if a > 0.0 then
    NRoot := Exp(Ln(a) / n)
  else
    NRoot := -Exp(Ln(-a) / n)
end;
/// Возвращает значение среднего арифметического из a и b
function ArithmeticMean(a, b: Integer): Real := (a + b) / 2;
/// Возвращает значение среднего арифметического из a, b и c
function ArithmeticMean3(a, b, c: Integer): Real := (a + b + c) / 3;
/// Возвращает значение среднего арифметического из a, b, c и d
function ArithmeticMean4(a, b, c, d: Integer): Real := (a + b + c + d) / 4;
/// Возвращает значение площади окружности
function AreaOfCircle(r: Real): Real := Pi * r ** 2;
/// Возвращает значение пути, равному скорость множить на время
function S(V, t: Real): Real := V * t;
/// Возвращает значение скорости, равной пути делить на время
function V(S, t: Real): Real := S / t;
/// Возвращает значение времени, равно пути делить на скорость
function t(S, V: Real): Real := S / V;
/// Возвращает значение, равное длине окружности
function Circumference(d: Real): Real := Pi * d;
/// Возвращает значение, равное периметру прямоугольника
function PerimeterOfRectangle(a, b: Real): Real := (a + b) * 2;
/// Возвращает значение, равное периметру квадрата
function PerimeterOfSquare(a: Real): Real := a * 4;
/// Возвращает значение, равное площади прямоугольника
function AreaOfRectangle(a, b: Real): Real := a * b;
/// Возвращает значение, равное объему шара
function VolumeOfBall(r: Real): Real := 4 / 3 * Pi * r ** 3;
/// Возвращает значение, равное площади поверхности шара
function AreaSurfaceOfBall(r: Real): Real := 4 * Pi * r ** 2;
/// Возвращает значение, равное площади поверхности куба
function AreaSurfaceOfCube(a: Real): Real := 6 * a ** 2;
/// Возвращает значение, равное объему прямоуголного параллелепипеда
function VolumeOfRectangularCuboid(a, b, c: Real): Real := a * b * c;
/// Возвращает значение, равное площади поверхности прямоуголного параллелепипеда
function SurfaceAreaOfRectangularCuboid(a, b, c: Real): Real := 2 * (a * b + b * c + a * c);
/// Возвращает значение, равное периметру поверхности прямоуголного параллелепипеда
function PerimeterOfRectangularCuboid(a, b, c: Real): Real := 4 * (a + b + c);
/// Возвращает значение, равное скорости против течения реки, зная скорость собственную и течения реки
function VПрТеч(VСобств, VТечРеки: Real): Real := VСобств - VТечРеки;
/// Возвращает значение, равное скорости по течения реки, зная скорость собственную и течения реки
function VПоТеч(VСобств, VТечРеки: Real): Real := VСобств + VТечРеки;
/// Возвращает значение, равное скорости собственной, зная скорость против и по течению реки
function VСобств(VПрТеч, VПоТеч: Real): Real := (VПрТеч + VПоТеч) / 2;
/// Возвращает значение, равное скорости течения, зная скорость против и по течению реки
function VТеч(VПрТеч, VПоТеч: Real): Real := (VПрТеч - VПоТеч) / 2;

//----------------------------------------------------------------------------
//          Процедуры, выводящие последовательности
//----------------------------------------------------------------------------

//    ||Рекурсивные последовательности||

// Не убирать всю эту хрень! Без нее ничего не работает! Граница начинается
/// Что то делает
function Iterate<T>(first, second, third: T; next: (T,T,T)-> T): sequence of T;
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
function SeqWhile<T>(first, second, third: T; next: (T,T,T) -> T; pred: T-> Boolean): sequence of T := Iterate(first, second, third, next).TakeWhile(pred);
// Граница заканчивается. Дальше все можете
/// Выводит простейшую последовательность 1, 2, 3, 4... до n
procedure SequenceOfPlus1(n: Integer);
begin
  SeqWhile(0, x -> x + 1, x -> x < n).Print;
end;
/// Выводит числа Фибонначи до n
procedure SequenceOfFibonacci(n: Integer);
begin
  SeqWhile(0, 1, (x, y) -> x + y, x -> x < n).Print;
end;
/// Выводит числа Люка до n
procedure SequenceOfLucas(n: Integer);
begin
  SeqWhile(2, 1, (x, y) -> x + y, x -> x < n).Print;
end;
/// Выводит числа трибоначчи до n
procedure SequenceOfTribonacci(n: Integer);
begin
  SeqWhile(0, 0, 1, (x, y, z) -> x + y + z, x -> x < n).Print;
end;
/// Выводит степени двойки до n
procedure SequenceOfPower2(n: Integer);
begin
  SeqWhile(1, x -> x * 2, x -> x < n).Print;
end;
/// Выводит степени десятки до n
procedure SequenceOfPower10(n: Integer);
begin
  SeqWhile(1, x -> x * 10, x -> x < n).Print;
end;

//    ||Нерекурсивные последовательности||

/// Выводит простые числа до n
procedure SequenceOfPrimes(n: Integer);
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
procedure SequenceOfMersenne(n: Integer);
begin
  for var i := 1 to n do
  begin
    if 2 ** i - 1 >= n then break;
    print(2 ** i - 1)
  end
end;
/// Выводит числа Вудала до n
procedure SequenceOfWoodall(n: Integer);
begin
  for var i := 1 to n do
  begin
    if i * 2 ** i - 1 >= n then break;
    print(i * 2 ** i - 1)
  end
end;
/// Выводит числа Ферма до n
procedure SequenceOfFermat(n: Integer);
begin
  for var i := 1 to n do
  begin
    if 2 ** 2 ** i + 1 >= n then break;
    print(2 ** 2 ** i + 1)
  end
end;
/// Выводит последовательность n * n до n
procedure SequenceOfNTimesN(n: Integer);
begin
  for var i := 1 to n do
  begin
    if i * i >= n then break;
    print(i * i)
  end
end;
end.