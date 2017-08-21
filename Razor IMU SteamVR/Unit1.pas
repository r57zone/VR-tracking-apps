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
    ReadBufferTimer: TTimer;
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
  YawOffset, PitchOffset, RollOffset: double;
  YawBuff, PitchBuff, RollBuff: double;
  FOV: integer;
  Packet: TrackPacket;
  PacketBuffer: string;

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
  if Ini.ReadBool('Main', 'ClsSteamVR', true) then AfterRun.Enabled:=true;
  CommPortDriver.PortName:='\\.\Com' + Ini.ReadString('Main', 'ComPort', '1');
  Ini.Free;

  YawOffset:=0;
  PitchOffset:=0;
  RollOffset:=0;

  CommPortDriver.BaudRateValue:=115200;
  CommPortDriver.DataBits:=db8BITS;
  CommPortDriver.Connect;

  if CommPortDriver.Connect=true then begin
    StatusBar.SimpleText:=' Arduino подключен';
    ReadBufferTimer.Enabled:=true;
  end else StatusBar.SimpleText:=' Arduino не подключен';

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

  Label4.Caption:=IntToStr(Round(MyOffset(packet.yaw, YawOffset))) + ' ' +
  IntToStr(Round(MyOffset(packet.pitch, PitchOffset))) + ' ' +
  IntToStr(Round(MyOffset(packet.roll, RollOffset)));
end;

procedure TMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  UnRegisterHotKey(Main.Handle, VK_NumPad5);
  CommPortDriver.Disconnect;
  ReadBufferTimer.Enabled:=false;
  IdUDPClient.Active:=false;
end;

procedure TMain.WMHotKey(var Msg: TWMHotKey);
begin
  if Msg.HotKey = VK_NumPad5 then begin
    YawOffset:=YawBuff;
    PitchOffset:=PitchBuff;
    RollOffset:=RollBuff;
  end;
end;

procedure TMain.AfterCloseTimer(Sender: TObject);
var
  WND: HWND;
begin
  WND:=FindWindowExtd('Headset Window');
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
      YawBuff:=StrToFloat(StringReplace(copy(s, 1, pos(',', s) - 1), '.', ',', [rfIgnoreCase]));

      Delete(s, 1, pos(',', s));
      PitchBuff:=StrToFloat(StringReplace(copy(s, 1, pos(',', s) - 1), '.', ',', [rfIgnoreCase]));

      Delete(s, 1, pos(',', s));
      RollBuff:=StrToFloat(StringReplace(Trim(s), '.', ',', [rfIgnoreCase]));

    end;

    Label4.Caption:=IntToStr(Round(YawBuff)) + ' ' + IntToStr(Round(PitchBuff)) + ' ' + IntToStr(Round(RollBuff));
    Label5.Caption:=IntToStr(Round(MyOffset(YawBuff, YawOffset))) + ' ' + IntToStr(Round(MyOffset(PitchBuff, PitchOffset))) + ' ' + IntToStr(Round(MyOffset(RollBuff, RollOffset)));
    Label6.Caption:=IntToStr(Round(YawOffset)) + ' ' + IntToStr(Round(PitchOffset)) + ' ' + IntToStr(Round(RollOffset));

    Packet.Yaw:=MyOffset(RollBuff, RollOffset);
    Packet.Pitch:=MyOffset(YawBuff, YawOffset) * -1;
    Packet.roll:=MyOffset(PitchBuff, PitchOffset) * -1;

    IdUDPClient.SendBuffer(Packet, SizeOf(packet));
  end;
end;

procedure TMain.AfterRunTimer(Sender: TObject);
var
  WND: HWND;
begin
  WND:=FindWindowExtd('Headset Window');
  if WND <> 0 then AfterClose.Enabled:=true;
end;

end.
