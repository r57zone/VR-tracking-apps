object Form1: TForm1
  Left = 192
  Top = 123
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Go Pro VR Player OpenTrack'
  ClientHeight = 119
  ClientWidth = 258
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
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 24
    Height = 13
    Caption = '0 0 0'
  end
  object Label2: TLabel
    Left = 8
    Top = 32
    Width = 24
    Height = 13
    Caption = '0 0 0'
  end
  object Label3: TLabel
    Left = 8
    Top = 56
    Width = 39
    Height = 13
    Caption = 'FOV: 90'
  end
  object TrackBar: TTrackBar
    Left = 8
    Top = 80
    Width = 249
    Height = 33
    Max = 120
    Min = 80
    Frequency = 5
    Position = 90
    TabOrder = 0
    OnChange = TrackBarChange
  end
  object IdUDPServer1: TIdUDPServer
    Bindings = <>
    DefaultPort = 4242
    OnUDPRead = IdUDPServer1UDPRead
    Left = 112
    Top = 8
  end
  object IdUDPClient1: TIdUDPClient
    Host = '127.0.0.1'
    Port = 7755
    Left = 144
    Top = 8
  end
  object XPManifest1: TXPManifest
    Left = 176
    Top = 8
  end
end
