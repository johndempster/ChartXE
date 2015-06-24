object LabInterfaceSetupFrm: TLabInterfaceSetupFrm
  Left = 470
  Top = 360
  BorderStyle = bsDialog
  Caption = 'Laboratory Interface Setup'
  ClientHeight = 167
  ClientWidth = 409
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
  object Label1: TLabel
    Left = 8
    Top = 4
    Width = 108
    Height = 15
    Caption = 'Laboratory Interface'
  end
  object cbLabInterface: TComboBox
    Left = 4
    Top = 20
    Width = 401
    Height = 23
    Hint = 'Laboratory interface card used for A/D and D/A conversion'
    Style = csDropDownList
    ItemHeight = 15
    ParentShowHint = False
    ShowHint = True
    Sorted = True
    TabOrder = 0
    OnChange = cbLabInterfaceChange
  end
  object NIPanel: TPanel
    Left = 4
    Top = 46
    Width = 405
    Height = 49
    BevelOuter = bvNone
    Caption = 'NIPanel'
    TabOrder = 1
    object Label3: TLabel
      Left = 108
      Top = 2
      Width = 52
      Height = 30
      Alignment = taRightJustify
      Caption = 'A/D Input mode'
      WordWrap = True
    end
    object Label13: TLabel
      Left = 0
      Top = 2
      Width = 37
      Height = 15
      Alignment = taRightJustify
      Caption = 'Device'
    end
    object cbADCInputMode: TComboBox
      Left = 108
      Top = 18
      Width = 293
      Height = 23
      Hint = 'A/D Converter input mode'
      ItemHeight = 15
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = 'cbADCInputMode'
      OnChange = cbADCInputModeChange
    end
    object cbDeviceNumber: TComboBox
      Left = 0
      Top = 18
      Width = 101
      Height = 23
      ItemHeight = 15
      TabOrder = 1
      Text = 'cbDeviceNumber'
      OnChange = cbDeviceNumberChange
    end
  end
  object Panel1: TPanel
    Left = 4
    Top = 96
    Width = 401
    Height = 65
    BevelOuter = bvNone
    TabOrder = 2
    object edModel: TEdit
      Left = 0
      Top = 0
      Width = 401
      Height = 23
      ReadOnly = True
      TabOrder = 0
    end
    object bOK: TButton
      Left = 0
      Top = 32
      Width = 49
      Height = 25
      Caption = 'OK'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ModalResult = 1
      ParentFont = False
      TabOrder = 1
      OnClick = bOKClick
    end
    object bCancel: TButton
      Left = 56
      Top = 33
      Width = 45
      Height = 16
      Caption = 'Cancel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ModalResult = 2
      ParentFont = False
      TabOrder = 2
      OnClick = bCancelClick
    end
  end
end
