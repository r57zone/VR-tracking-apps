unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Math, ComCtrls, XPMan, CPDrv, IniFiles, IdBaseComponent,
  IdComponent, IdUDPBase, IdUDPClient, ExtCtrls;

type
  TMain = class(TForm)
    XPManifest1: TXPManifest;
    CommPortDriver: TCommPortDriver;
    IdUDPClient: TIdUDPClient;
    Label5: TLabel;
    StatusBar: TStatusBar;
    AfterClose: TTimer;
    ReadBuffer: TTimer;
    Label2: TLabel;
    Label4: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    FOVLbl: TLabel;
    AfterRun: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure CommPortDriverReceiveData(Sender: TObject; DataPtr: Pointer;
      DataSize: Cardinal);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AfterCloseTimer(Sender: TObject);
    procedure ReadBufferTimerTimer(Sender: TObject);
    procedure AfterRunTimer(Sender: TObject);
  private
    procedure WMHotKey(var Msg : TWMHotKey); message WM_HOTKEY;
    { Private declarations }
  public
    { Public declarations }
  end;

type TrackPacket = record
    x: double;
    y: double;
    z: double;
    yaw: double;
    pitch: double;
    roll: double;
end;

var
  Main: TMain;
  yaw_offset, pitch_offset, roll_offset: double;
  FOV: integer;
  Packet: TrackPacket;
  PacketBuffer, PlayerPath: string;

implementation

{$R *.dfm}

function FindWindowExtd(PartialTitle: string): HWND;
var
  hWndTemp: hWnd;
  iLenText: Integer;
  cTitletemp: array [0..254] of Char;
  sTitleTemp: string;
begin
  hWndTemp:=FindWindow(nil, nil);
  while hWndTemp <> 0 do begin
    iLenText:=GetWindowText(hWndTemp, cTitletemp, 255);
    sTitleTemp:=cTitletemp;
    sTitleTemp:=AnsiUpperCase(Copy(sTitleTemp, 1, iLenText));
    PartialTitle:=AnsiUpperCase(partialTitle);
    if Pos(partialTitle, sTitleTemp) <> 0 then
      Break;
    hWndTemp:=GetWindow(hWndTemp, GW_HWNDNEXT);
  end;
  Result:=hWndTemp;
end;

function fmod(x, y: double): double;
begin
  result:=y*frac(x/y);
end;

function MyOffset(f, f2: double): double;
begin
  Result:=fmod(f - f2, 180);
end;

procedure TMain.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
begin
  Application.Title:=Caption;

  Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0))+'Setup.ini');
  if Ini.ReadBool('Main', 'ClsVRPlayer', true) then AfterRun.Enabled:=true;
  CommPortDriver.PortName:='\\.\Com' + Ini.ReadString('Main', 'ComPort', '1');
  FOV:=Ini.ReadInteger('Main', 'FOV', 90);
  PlayerPath:=Ini.ReadString('Main', 'Path', '');
  Ini.Free;

  yaw_offset:=0;
  pitch_offset:=0;
  roll_offset:=0;

  CommPortDriver.BaudRateValue:=115200;
  CommPortDriver.DataBits:=db8BITS;
  CommPortDriver.Connect;

  if CommPortDriver.Connect=true then begin
    StatusBar.SimpleText:=' Arduino HT подключен';
    ReadBuffer.Enabled:=true;
  end else StatusBar.SimpleText:=' Arduino HT не подключен';   

  if FileExists(PlayerPath) then
    WinExec(PChar(PlayerPath), SW_SHOWNORMAL)
  else
    ShowMessage('Go Pro VR Player не найден.');

  IdUDPClient.Active:=true;

  RegisterHotKey(Main.Handle, VK_NumPad5, 0, VK_Numpad5);
end;

function FloatToJson(num: double): string;
begin
  result:=StringReplace(FloatToStr(DegToRad(num)), ',', '.', [rfIgnoreCase]);
end;

procedure TMain.CommPortDriverReceiveData(Sender: TObject;
  DataPtr: Pointer; DataSize: Cardinal);
var
  i,z: integer;
  s: string;
begin
  s:='';
  for i:=0 to DataSize - 1 do
    s:=s + (PChar(DataPtr)[i]);

  PacketBuffer:=PacketBuffer + s;
end;

procedure TMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  UnRegisterHotKey(Main.Handle, VK_NumPad5);
  CommPortDriver.Disconnect;
  ReadBuffer.Enabled:=false;
  IdUDPClient.Active:=false;
end;

procedure TMain.WMHotKey(var Msg: TWMHotKey);
begin
  if Msg.HotKey = VK_NumPad5 then begin
    yaw_offset:=packet.yaw;
    pitch_offset:=packet.pitch;
    roll_offset:=packet.roll;
  end;
end;

procedure TMain.AfterCloseTimer(Sender: TObject);
var
  WND: HWND;
begin
  WND:=FindWindowExtd('GoPro VR Player');
  if WND = 0 then Close;
end;

procedure TMain.ReadBufferTimerTimer(Sender: TObject);
var
  s: string;
begin
  if Length(PacketBuffer) > 0 then begin

    s:=Copy(PacketBuffer, 1, Pos(#13, PacketBuffer) - 1);

    delete(PacketBuffer, 1, Pos(#13, PacketBuffer) + 1);
    if Copy(s, 1, 5)='#YPR=' then begin
      Delete(s, 1, 5);
      packet.yaw:=StrToFloat(StringReplace(copy(s, 1, pos(',', s) - 1), '.', ',', [rfIgnoreCase]));

      Delete(s, 1, pos(',', s));
      packet.pitch:=StrToFloat(StringReplace(copy(s, 1, pos(',', s) - 1), '.', ',', [rfIgnoreCase]));

      Delete(s, 1, pos(',', s));
      packet.roll:=StrToFloat(StringReplace(Trim(s), '.', ',', [rfIgnoreCase]));

    end;

    IdUDPClient.Send('{"fov":'+IntToStr(FOV)+',"id":"ked","pitch":'+FloatToJson(MyOffset(packet.pitch, pitch_offset))+',"position":0,"roll":'+FloatToJson(MyOffset(packet.roll, roll_offset))+',"state":0,"url":"","yaw":'+FloatToJson(MyOffset(packet.yaw, yaw_offset) - 90)+'}');
  end;
end;

procedure TMain.AfterRunTimer(Sender: TObject);
var
  WND: HWND;
begin
  WND:=FindWindowExtd('GoPro VR Player');
  if WND <> 0 then AfterClose.Enabled:=true;
end;

end.
