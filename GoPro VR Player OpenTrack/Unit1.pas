unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdUDPBase, IdUDPServer, StdCtrls, IdSocketHandle,
  IdUDPClient, Math, ComCtrls, XPMan, IniFiles;

type
  TForm1 = class(TForm)
    IdUDPServer1: TIdUDPServer;
    IdUDPClient1: TIdUDPClient;
    Label1: TLabel;
    Label2: TLabel;
    TrackBar: TTrackBar;
    Label3: TLabel;
    XPManifest1: TXPManifest;
    procedure IdUDPServer1UDPRead(Sender: TObject; AData: TStream;
      ABinding: TIdSocketHandle);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TrackBarChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type OpenTrackPacket = record
    x: double;
    y: double;
    z: double;
    yaw: double;
    pitch: double;
    roll: double;
end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function FloatToJson(num: double): string;
begin
  result:=FormatFloat('0.000',(DegToRad(num)));
  result:=StringReplace(result, ',', '.', [rfIgnoreCase]);
end;

procedure TForm1.IdUDPServer1UDPRead(Sender: TObject; AData: TStream;
  ABinding: TIdSocketHandle);
var
  Packet: OpenTrackPacket;
begin
  Adata.Read(packet, SIZEOF(packet));

  Label1.Caption:=IntToStr(Round(packet.yaw)) + ' ' + IntToStr(Round(packet.pitch)) + ' ' + IntToStr(Round(packet.roll));
  Label2.Caption:=FloatToJson(packet.yaw) + ' ' + FloatToJson(packet.pitch) + ' ' + FloatToJson(packet.roll);

  IdUDPClient1.Send('{"fov":'+IntToStr(TrackBar.Position)+',"id":"ked","pitch":'+FloatToJson(packet.pitch)+',"position":0,"roll":'+FloatToJson(packet.roll)+',"state":0,"url":"","yaw":'+FloatToJson(packet.yaw)+'}');
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
begin
  Application.Title:=Caption;
  Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0))+'Setup.ini');
  TrackBar.Position:=Ini.ReadInteger('Main', 'FOV', 90);
  Ini.Free;
  IdUDPServer1.Active:=true;
  IdUDPClient1.Active:=true;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  IdUDPServer1.Active:=false;
  IdUDPClient1.Active:=false;
end;

procedure TForm1.TrackBarChange(Sender: TObject);
var
  Ini: TIniFile;
begin
  Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0))+'Setup.ini');
  Ini.WriteInteger('Main', 'FOV', TrackBar.Position);
  Ini.Free;
  Label3.Caption:='FOV: ' + IntToStr(TrackBar.Position);
end;

end.
