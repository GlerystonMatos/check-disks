object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Check Disks'
  ClientHeight = 668
  ClientWidth = 645
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    645
    668)
  PixelsPerInch = 96
  TextHeight = 13
  object btnVerificar: TBitBtn
    Left = 8
    Top = 8
    Width = 89
    Height = 25
    Caption = '&Verificar'
    Kind = bkRetry
    NumGlyphs = 2
    TabOrder = 0
    OnClick = btnVerificarClick
  end
  object mInfo: TMemo
    Left = 8
    Top = 39
    Width = 629
    Height = 621
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssVertical
    TabOrder = 1
  end
end
