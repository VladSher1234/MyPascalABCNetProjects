uses CRT;

type
  Entity = class
  private
    m_health: integer;
    m_damage: integer;
    m_max_health: integer;
    m_defence: integer;
    m_name: string;
  public
    constructor Create(h: integer; dm: integer; df: integer; n: string);
    begin
      m_health := h;
      m_max_health := h;
      m_damage := dm;
      m_defence := df;
      m_name := n;
    end;
    
    procedure Print;
    begin
      println($'HP: {m_health}');
      println($'DMG: {m_damage}');
    end;
    
    procedure IncreaseMaxHP(amount: integer);
    begin
      m_max_health := m_max_health + amount;
    end;
    
    procedure IncreaseHP(amount: integer);
    begin
      m_health := Min(m_max_health, m_health + amount);
    end;
    
    procedure IncreaseDefence(amount: integer);
    begin
      m_defence := m_defence + amount;
    end;
    
    procedure IncreaseDamage(amount: integer);
    begin
      m_damage := m_damage + amount;
    end;
    
    procedure Attack(var other: Entity);
    begin
      var will_damage_for: integer := 0;
      if other.m_defence >= m_damage then
        will_damage_for := 1
      else
        will_damage_for := m_damage - other.m_defence;
      other.m_health := Max(0, other.m_health - will_damage_for);
    end;
    
    property Health: integer read m_health;
    property Damage: integer read m_damage;
    property Defence: integer read m_defence;
    property Name: string read m_name;
  end;

procedure MakewriteLn(str: string);
begin
  println(str);
  readkey();
end;

procedure Fight(lhs: Entity; rhs: Entity; var winner: Entity);
begin
  println('Битва началась!');
  println('С левой стороны: ' + lhs.Name);
  lhs.Print;
  println('С правой стороны: ' + rhs.Name);
  rhs.Print;
  var round_counter: integer := 1;
  while True do
  begin
    makewriteln($'Начался {round_counter} раунд.');
    lhs.Attack(rhs);
    println($'{lhs.Name} нанес удар! {rhs.Name}:');
    rhs.Print;
    if (rhs.Health = 0) then
    begin
      winner := lhs;
      break;
    end;
    rhs.Attack(lhs);
    println($'{rhs.Name} нанес удар! {lhs.Name}:');
    lhs.Print;
    if (lhs.Health = 0) then
    begin
      winner := rhs;
      break;
    end;
    round_counter := round_counter + 1;
  end;
end;

procedure ProtagonistFights(p: Entity; enemy: Entity);
begin
  var tmp := new Entity(0, 0, 0, '');
  Fight(p, enemy, tmp);
  if (tmp = enemy) then
  begin
    println('Ты проиграл!');
    exit;
  end;
  println('Ты выиграл!');
end;

procedure ExpectAnswer(first, second: string; var res: string);
begin
  println('Ответы: ' + first + ', ' + second);
  var input: string;
  while true do
  begin
   print('>');
    readln(input);
    if (input = first) or (input = second) then
      break;
    println('Ошибка ввода: "' + input + '"')
  end;
  if (input = first) then
    res := first
  else
    res := second
end;

label start;
var
  a: integer;
  answer: string;

begin
  start:
  var me := new Entity(100, 0, 0, 'Ты');
  var zombie := new Entity(35, 5, 0, 'Зомби');
  var slime := new Entity(15, 2, 0, 'Слизень');
  var skeleton := new Entity(40, 4, 0, 'Скелет');
  var infected_rabbit := new Entity(20, 10, 0, 'Зараженный кролик');
  var slombie := new Entity(30, 6, 0, 'Слизомби');
  var BOS := new Entity(150, 10, 0, 'Царь зараженных кроликов');
  var BOSS := new Entity(200, 10, 0, 'Царь зараженных кроликов');
  Makewriteln('Ты решил пойти в таинственный лес, про который говорили где-то на одной из волн на старом радио. Ты пошёл в это место, и увидел заросшую тропу, по которой ты и пошел.');
  Makewriteln('Ты увидел слизня, которого ты пнул, а после нашел дубинку (+5 DMG) в сундуке.');
  me.IncreaseDamage(5);
  me.Print;
  Makewriteln('Ты пошел дальше. Дальше ты снова увидел слизня, с которым ты сразился.');
  ProtagonistFights(me, slime);
  Makewriteln('Ты пошел дальше. Дальше ты увидел зомби, с которым ты сразился.');
  ProtagonistFights(me, zombie);
  Makewriteln('Ты пошел дальше. Дальше ты снова увидел слизня, с которым ты сразился.');
  slime := new Entity(15, 2, 0, 'Слизень');
  ProtagonistFights(me, slime);
  Makewriteln('Ты пошел дальше. Дальше ты увидел странного зомби с головой слизня, с которым ты сразился.');
  ProtagonistFights(me, slombie);
  Makewriteln('С слизомби выпала куртка из слизи и какого-то мягкого металла (+2 DF).');
  me.IncreaseDefence(2);
  Makewriteln('После слизомби ты увидел вазочку, в которой лежало красное зелье. Выпить его?');
  ExpectAnswer('да', 'нет', answer);
  if answer = 'нет' then begin
    Makewriteln('Ты обошел стороной эту вазу. Тебе встретился скелет, и он тебя с легкостью убил.');
    Makewriteln('Ты умер.'); 
    exit;
  end;
  Makewriteln('Ты выпил зелье. По твоему телу сначали побегли мурашки, а потом ты начал чувствовать заживление всех ран (+100 HP).');
  me.IncreaseHP(100);
  Makewriteln('Ты пошел дальше. Дальше ты увидел скелета, с которым ты и сразился.');
  ProtagonistFights(me, skeleton);
  Makewriteln('С него выпало костяное сердце. Ты посмотрел на него, и оно исчезло, но ты почувствовал прилив сил (+50 MaxHP).');
  me.IncreaseMaxHP(50);
  me.IncreaseHP(150);
  Makewriteln('Ты пошел дальше. Дальше ты снова увидел скелета, с которым ты сразился.');
  skeleton := new Entity(40, 4, 0, 'Скелет');
  ProtagonistFights(me, skeleton);
  Makewriteln('Ты пошел дальше. Дальше ты увидел зомби, с которым ты сразился.');
  zombie := new Entity(35, 5, 0, 'Зомби');
  ProtagonistFights(me, zombie);
  Makewriteln('После зомби ты увидел железный сундук. Открыть его?');
  ExpectAnswer('да', 'нет', answer);
  if answer = 'нет' then begin
    Makewriteln('Ты обошел стороной этот металлический сундук. Тебе встретилась толпа зараженных кроликов, и они разорвали тебя.');
    Makewriteln('Ты умер.'); 
    exit;
  end;
  Makewriteln('Ты открыл сундук. В нем лежал железный меч (+10 DMG), куртка (+5 DF) и зелье лечения (+100 HP).');
  me.IncreaseDamage(5);
  me.IncreaseDefence(3);
  me.IncreaseHP(100);
  Makewriteln('Ты почувствовал странный металлический запах. Ты отодвинул сундук, и ты увидел ядрену бiмбу, которую ты взял.');
  Makewriteln('Ты пошел дальше. Дальше ты увидел зомбокролика, с которыми ты сразился.');
  ProtagonistFights(me, infected_rabbit);
  Makewriteln('Ты пошел дальше. Тебе встретился коридор, а после него ты встретил большую приоткрытую дверь. Ты вошел в нее, а там стоял огромный зараженный кролик, и тебе придется с ним сражаться...');
  Makewriteln('Бросить в босса ядрену бiмбу? ');
  ExpectAnswer('да', 'нет', answer);
  if answer = 'да' then begin
    ProtagonistFights(me, BOS);
    MakeWriteln('После такой победы ты увидел две двери. Над ними было написано "Остаться" и "Уйти". Что же выбрать?');
    ExpectAnswer('остаться', 'уйти', answer);
    if answer = 'остаться' then begin
      MakeWriteln('Ты пошел в дверь c надписью "Остаться". Войдя, ты увидел через небольшой коридор кучу золота, ты побежал к ней, но это было ловушкой, и ты упал в бездонную яму. Через месяц ты умер от голода и обезвоживания.');
      Makewriteln('Ты умер. Плохая концовка.');
      exit;
    end;
    Makewriteln('Ты пошел в дверь с надписью "Уйти". Войдя, ты вышел в свой город, потом ты пошел по улицам, дошел до своего дома, квартиры...');
    Makewriteln('Ты остался в живых. Хорошая концовка.');
    exit;
  end;
  ProtagonistFights(me, BOSS);
  MakeWriteln('После такой победы ты увидел две двери. Над ними было написано "Остаться" и "Уйти". Что же выбрать?');
  ExpectAnswer('остаться', 'уйти', answer);
  if answer = 'остаться' then begin
    MakeWriteln('Ты пошел в дверь c надписью "Остаться". Войдя, ты увидел через небольшой коридор кучу золота, но также увидел яму, у которой не было дна. Ты понял, что это ловушка, и пошел обратно. Походив, ты нашел по телом Царя зараженных кроликов крест, и ты решил его подорвать. Ты взял ядрену бiмбу, кинул на крест и убежал. Ядрена бiмба взорвалась, а под крестом была яма уже с дном. Ты спрыгнул в нее, а на дне увидел дверь. Ты в нее вошел, а это, была входной дверь в твой дом. Ты заметил, то что если выйти из двери, то будет видно твой подъезд. Странно. Ты пошел на кухню. Там тебя ждал небольшой подарок: тарелка с пельменями, и со сметанкой, как же без нее! Но после обеда твой прыжок на порядок изменился...');
    Makewriteln('Ты остался в живых, и приобрел высокий прыжок. Видимо, пельмени были из мяса зараженного кролика. Секретная концовка.');  
    exit;
  end;
  Makewriteln('Ты пошел в дверь с надписью "Уйти". Войдя, ты вышел в свой город, потом ты пошел по улицам, дошел до своего дома, квартиры...');
  Makewriteln('Ты остался в живых. Хорошая концовка.');
  exit;
end.
