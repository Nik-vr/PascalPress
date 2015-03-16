unit main;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, httpdefs, fpHTTP, fpWeb, fphtml;

type

  { TFPWebModule1 }

  TFPWebModule1 = class(TFPWebModule)
    procedure DataModuleRequest(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: Boolean);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FPWebModule1: TFPWebModule1;
  WWW: string;

implementation

{$R *.lfm}

{ TFPWebModule1 }

// Базовая функция (выполняется каждый раз при обращении к скрипту)
procedure TFPWebModule1.DataModuleRequest(Sender: TObject; ARequest: TRequest; AResponse: TResponse; var Handled: Boolean);

 // вывод в текст страницы (просто для удобства)
 function echo(str: string): boolean;
 begin
   AResponse.Contents.Add(str);
 end;

var
  i: integer;
   lData: String;
begin
 // задаём тип контента - текст/html (для графики могут понадобиться другие типы)
 AResponse.ContentType := 'text/html;charset=utf-8';

 // корневой каталог сервера
 WWW:=ExtractFilePath(ParamStr(0));


 //echo(ARequest.QueryFields[0]);

 // если нет параметров (т.е. загружается главная страница сайта)
 if (ARequest.QueryFields.Count<=0) or (ARequest.QueryFields[0]='/') then
  begin
    // грузим index.html
    echo(WWW+'/index.html');
    AResponse.Contents.LoadFromFile(WWW+'/index.html');
  end
 // иначе - разбираем параметры
 else
  begin
   // параметры URL (ЧПУ вида mysite.ru/1/2/3) дадут 1 параметр вида /1/2/3)
   // использовать в запросах ? нельзя - всё, что идёт после него, отрезается
   for i:=0 to ARequest.QueryFields.Count-1 do
    begin
     // если есть файл с именем, равным имени ключа, грузим его целиком
     if FileExists(WWW+ARequest.QueryFields[i])
      then AResponse.Contents.LoadFromFile(WWW+ARequest.QueryFields[i]);
    end;
  end;

  //
  echo('!'+ARequest.ContentFields.Values['author']);
  echo('!'+ARequest.ContentFields.Values['email']);
  echo('!'+ARequest.ContentFields.Values['comment']);

  // типа закончили формирование ответа
  Handled := True;
end;

initialization
  RegisterHTTPModule('TFPWebModule1', TFPWebModule1);
end.

