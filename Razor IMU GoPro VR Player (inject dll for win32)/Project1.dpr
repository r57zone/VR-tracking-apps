library Project1;

uses
  SysUtils, Classes, Fake, CPDrv, IdBaseComponent, IdComponent, IdUDPBase, IdUDPClient, Math, Windows, Messages, Forms, IniFiles;

type
  TCommPortDrv = class
  private
    CommPortDriver: TCommPortDriver;
  procedure CommPortDriverReceiveData(Sender: TObject; DataPtr: Pointer;
      DataSize: Cardinal);
  public
  constructor Create; reintroduce;
  destructor Destroy; override;
  end;

type
  TUDPClient = class
  private
    IdUDPClient: TIdUDPClient;
  public
  procedure Send(AData: string);
  constructor Create; reintroduce;
  destructor Destroy; override;
end;

type TrackingPacket = record
    x: double;
    y: double;
    z: double;
    yaw: double;
    pitch: double;
    roll: double;
end;

var
  Packet: TrackingPacket;
  PacketBuffer: string;
  YawOffset, PitchOffset, RollOffset: double;
  CommPortNum, FOV: integer;
  hTimer: THandle;
  UDPClient: TUDPClient;
  CommPortDrv: TCommPortDrv;

{$R *.res}

function fmod(x, y: double): double;
begin
  result:=y * frac(x / y);
end;

function MyOffset(f, f2: double): double;
begin
  Result:=fmod(f - f2, 180);
end;

{ TCommPortDrv }

procedure TCommPortDrv.CommPortDriverReceiveData(Sender: TObject;
  DataPtr: Pointer; DataSize: Cardinal);
var
  i: integer;
  s: string;
begin
  s:='';
  for i:=0 to DataSize - 1 do
    s:=s + (PChar(DataPtr)[i]);

  PacketBuffer:=PacketBuffer + s;
end;

constructor TCommPortDrv.Create;
begin
  CommPortDriver:=TCommPortDriver.Create(nil);
  CommPortDriver.BaudRateValue:=115200;
  CommPortDriver.PortName:='\\.\Com' + IntToStr(CommPortNum);
  CommPortDriver.DataBits:=db8BITS;
  CommPortDriver.OnReceiveData:=CommPortDriverReceiveData;
  CommPortDriver.Connect;
end;

destructor TCommPortDrv.Destroy;
begin
  CommPortDriver.Free;
  inherited destroy;
end;

{ TUDPServer }

procedure TUDPClient.Send(AData: string);
begin
  idUDPClient.Send(AData);
end;

constructor TUDPClient.Create;
begin
  idUDPClient:=tIdUDPClient.create(nil);
  idUDPClient.Port:=7755;
  idUDPClient.BufferSize:=8192;
  idUDPClient.BroadcastEnabled:=false;
  IdUDPClient.Active:=true;
end;

destructor TUDPClient.Destroy;
begin
  IdUDPClient.Active:=false;
  IdUDPClient.free;
  inherited destroy;
end;

function FloatToJson(num: double): string;
begin
  result:=StringReplace(FloatToStr(DegToRad(num)), ',', '.', [rfIgnoreCase]);
end;

procedure ReadBuffer(wnd: HWND; uMsg: UINT; idEvent: UINT; dwTime: DWORD); stdcall;
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

    UDPClient.Send('{"fov":'+IntToStr(FOV)+',"id":"ked","pitch":'+FloatToJson(MyOffset(Packet.Pitch, PitchOffset))+',"position":0,"roll":'+FloatToJson(MyOffset(Packet.Roll, RollOffset))+',"state":0,"url":"","yaw":'+FloatToJson(MyOffset(Packet.Yaw, YawOffset) - 90)+'}');
  end;

  if GetAsyncKeyState(VK_NUMPAD5) <> 0 then begin
    YawOffset:=Packet.Yaw;
    PitchOffset:=Packet.Pitch;
    RollOffset:=Packet.Roll;
  end;
end;

procedure DllMain(Reason: integer);
begin
  case Reason of
    DLL_PROCESS_DETACH:
      begin
        KillTimer(0, hTimer);
        CommPortDrv.Free;
        UDPClient.Free;
      end;
  end;
end;

var
  Ini: TIniFile;
begin
  DllProc:=@DllMain;
  DllProc(DLL_PROCESS_ATTACH);

  hTimer:=SetTimer(0, 0, 0, @ReadBuffer);

  Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0))+'Setup.ini');
  CommPortNum:=Ini.ReadInteger('Main', 'ComPort', 1);
  FOV:=Ini.ReadInteger('Main', 'FOV', 90);
  Ini.Free;

  YawOffset:=0;
  PitchOffset:=0;
  RollOffset:=0;
  CommPortDrv:=TCommPortDrv.Create;
  UDPClient:=TUDPClient.Create;
end.
 