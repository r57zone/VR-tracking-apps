object Main: TMain
  Left = 195
  Top = 124
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Razor IMU VR Player'
  ClientHeight = 100
  ClientWidth = 242
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label5: TLabel
    Left = 104
    Top = 32
    Width = 24
    Height = 13
    Caption = '0 0 0'
  end
  object Label2: TLabel
    Left = 8
    Top = 32
    Width = 81
    Height = 13
    Caption = 'Offset ('#1089#1086' '#1089#1084#1077#1097')'
  end
  object Label4: TLabel
    Left = 104
    Top = 8
    Width = 24
    Height = 13
    Caption = '0 0 0'
  end
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 51
    Height = 13
    Caption = #1048#1089#1093#1086#1076#1085#1099#1077
  end
  object Label3: TLabel
    Left = 8
    Top = 56
    Width = 28
    Height = 13
    Caption = 'Offset'
  end
  object Label6: TLabel
    Left = 104
    Top = 56
    Width = 24
    Height = 13
    Caption = '0 0 0'
  end
  object FOVLbl: TLabel
    Left = 8
    Top = 80
    Width = 39
    Height = 13
    Caption = 'FOV: 90'
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 81
    Width = 242
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object XPManifest1: TXPManifest
    Left = 176
    Top = 8
  end
  object CommPortDriver: TCommPortDriver
    Port = pnCustom
    PortName = '\\.\COM3'
    BaudRate = brCustom
    OnReceiveData = CommPortDriverReceiveData
    Left = 144
    Top = 8
  end
  object IdUDPClient: TIdUDPClient
    Port = 7755
    Left = 208
    Top = 40
  end
  object AfterClose: TTimer
    Enabled = False
    Interval = 100
    OnTimer = AfterCloseTimer
    Left = 176
    Top = 40
  end
  object ReadBuffer: TTimer
    Enabled = False
    Interval = 1
    OnTimer = ReadBufferTimerTimer
    Left = 208
    Top = 8
  end
  object AfterRun: TTimer
    Enabled = False
    Interval = 100
    OnTimer = AfterRunTimer
    Left = 144
    Top = 40
  end
end
