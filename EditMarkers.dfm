object EditMarkersFrm: TEditMarkersFrm
  Left = 270
  Top = 219
  BorderStyle = bsDialog
  Caption = 'Edit Markers '
  ClientHeight = 241
  ClientWidth = 198
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object bOK: TButton
    Left = 8
    Top = 216
    Width = 49
    Height = 20
    Caption = 'OK'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ModalResult = 1
    ParentFont = False
    TabOrder = 0
    OnClick = bOKClick
  end
  object bCancel: TButton
    Left = 64
    Top = 216
    Width = 49
    Height = 18
    Caption = 'Cancel'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ModalResult = 2
    ParentFont = False
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 193
    Height = 209
    Caption = ' Markers '
    TabOrder = 2
    object Table: TStringGrid
      Left = 8
      Top = 16
      Width = 177
      Height = 161
      ColCount = 2
      DefaultColWidth = 74
      DefaultRowHeight = 20
      FixedCols = 0
      RowCount = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      ParentFont = False
      TabOrder = 0
    end
    object bDeleteMarker: TButton
      Left = 8
      Top = 182
      Width = 97
      Height = 18
      Caption = 'Delete Marker'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = bDeleteMarkerClick
    end
  end
end
