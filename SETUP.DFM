�
 TSETUPDLG 0  TPF0	TSetupDlgSetupDlgLeft�Top� BorderStylebsDialogCaptionSetupClientHeightClientWidth�Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold OldCreateOrder	PositionpoScreenCenterOnShowFormShowPixelsPerInch`
TextHeight TTabbedNotebookTabbedNotebook1LeftTopWidth�Height� 	PageIndex
TabsPerRowTabFont.CharsetDEFAULT_CHARSETTabFont.Color	clBtnTextTabFont.Height�TabFont.NameMS Sans SerifTabFont.Style TabOrder OnChangeTabbedNotebook1Change TTabPage LeftTopCaptionBasic 	TGroupBox	GroupBox1LeftTop WidthqHeight� Caption Record Settings TabOrder  TLabellbNumChannelsLeftTopWidthMHeightCaptionNo. Channels  TLabellbSamplingIntervalLeftToppWidthcHeightCaptionSampling Interval  TLabelLabel4LeftTop@WidthXHeightCaptionDigital LP Filter  TValidatedEditedNumChannelsLeftTop WidthIHeight
OnKeyPressedNumChannelsKeyPressText 1 Value       ��?LoLimit       ��?HiLimit       �@Scale       ��?NumberFormat%.f  TValidatedEditedSamplingIntervalLeftTop� WidthIHeightText 1.0 msValue     o��?LoLimit     o��?HiLimit       �@Scale       �@UnitsmsNumberFormat%.1f  TEditedDigitalFilterLeftTopPWidth9HeightTabOrderTextedDigitalFilter  TUpDownudFilterFactorLeftBTopMWidthHeightMinMax
PositionTabOrderOnClickudFilterFactorClick   	TGroupBoxChannelsLeftxTop WidthHeight� Caption Channel Settings TabOrder TLabelLabel5LeftTopWidth� HeightCaptionA/D  Converter Voltage Range  TLabelLabel6LeftTop8WidthaHeightCaptionCalibration Table  TStringGridChannelTableLeftTopHWidth� HeightiDefaultColWidth(DefaultRowHeightRowCountFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial Narrow
Font.Style 
ParentFont
ScrollBarsssNoneTabOrder 
RowHeights   	TComboBoxcbADCVoltageRangeLeftTop WidthyHeightStylecsOwnerDrawFixed
ItemHeightTabOrder  TPanelChColor0Left� TopXWidthHeight
BevelOuterbvNoneBorderStylebsSingleCaption TabOrderOnClickChColor0Click
OnDblClickChColor0DblClick  TPanelChColor1Left� ToppWidthHeight
BevelOuterbvNoneBorderStylebsSingleCaption TabOrderOnClickChColor0Click
OnDblClickChColor0Click  TPanelChColor2Left� Top� WidthHeight
BevelOuterbvNoneBorderStylebsSingleCaption TabOrderOnClickChColor0Click
OnDblClickChColor0Click  TPanelChColor3Left� Top� WidthHeight
BevelOuterbvNoneBorderStylebsSingleCaption TabOrderOnClickChColor0Click
OnDblClickChColor0Click    TTabPage LeftTopCaptionCED1902 	TGroupBoxCED1902GroupLeftTop Width{Height� TabOrder  TLabelLabel11Left(Top� Width8HeightCaption	Com. Port  	TCheckBoxckCED1902InUseLeftTopWidth� HeightCaptionCED 1902 availableTabOrder OnClickckCED1902InUseClick  	TComboBoxcbCED1902ComPortLefthTop� WidthQHeightStylecsDropDownList
ItemHeightTabOrderOnChangecbCED1902ComPortChange  TEditedCED1902TypeLeft� TopWidth� HeightFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFontReadOnly	TabOrder  	TGroupBoxInputGrpLeftTop(Width� HeightqCaption Input TabOrder TLabelLabel8LeftTop(WidthOHeightCaptionAmplifier Gain  TLabelLabel1Left TopTWidth8HeightCaption	DC Offset  	TComboBoxcbCED1902InputLeftTopWidth� HeightStylecsOwnerDrawFixed
ItemHeightTabOrder OnChangecbCED1902InputChange  	TComboBoxcbCED1902GainLeftTop8Width� HeightStylecsOwnerDrawFixed
ItemHeightTabOrderOnChangecbCED1902GainChange  TValidatedEdit
edDCOffsetLeft`TopTWidthIHeight
OnKeyPressedDCOffsetKeyPressText 0 mVLoLimit     ���b�HiLimit     ���b@Scale       ��?UnitsmVNumberFormat%.3g   	TGroupBox	FilterGrpLeft� Top(Width� Height� Caption	 Filters TabOrder TLabelLabel9Left
TopWidth;HeightCaption	Low Pass   TLabelLabel10LeftTop>Width:HeightCaption	High Pass  	TComboBoxcbCED1902LPFilterLeftTop Width� HeightStylecsDropDownList
ItemHeightTabOrder   	TComboBoxcbCED1902HPFilterLeftTopNWidth� HeightStylecsDropDownList
ItemHeightTabOrder  	TCheckBoxckCED1902NotchFilterLeftToplWidth� HeightCaption50Hz Notch FilterTabOrder  	TCheckBoxckCED1902ACCoupledLeftTop� WidthqHeightCaption
AC CoupledTabOrder     TTabPage LeftTopCaptionSpecial 	TGroupBoxRMSGroupLeftTop Width� Height� Caption RMS Channel TabOrder  TLabelLabel3LeftTop0Width1HeightCaptionGet from  TLabelLabel13LeftTop`Width-HeightCaptionStore in  TLabelLabel14LeftTop� WidthMHeightCaptionPoints Avrgd.  	TComboBoxcbRMSFromChannelLeftTop@WidthiHeight
ItemHeightTabOrder TextcbRMSFromChannelOnChangecbRMSFromChannelChange  	TComboBoxcbRMSToChannelLeftToppWidthiHeight
ItemHeightTabOrderTextcbRMSToChannelOnChangecbRMSToChannelChange  	TCheckBox
ckRMSInUseLeftTopWidthIHeightCaptionIn UseTabOrder  TValidatedEditedRMSNumPointsLeftTop� WidthAHeightText 1 Value       ��?LoLimit       ��?HiLimit     ���b@Scale       ��?NumberFormat%.f   	TGroupBoxHeartrateGrpLeft� Top Width� Height� Caption Heart Rate Channel TabOrder TLabelLabel15LeftTop0Width1HeightCaptionGet from  TLabelLabel16LeftTopXWidth-HeightCaptionStore in  TLabelLabel18Left� TopWidthQHeight)AutoSizeCaptionR Wave detection thresholdWordWrap	  TLabelLabel17Left� Top� Width@HeightCaption
Scale Max.  	TCheckBox	ckHRinUseLeftTopWidthIHeightCaptionIn UseTabOrder   	TComboBoxcbHRFromChannelLeftTop@WidthiHeight
ItemHeightTabOrderTextcbRMSFromChannelOnChangecbHRFromChannelChange  	TComboBoxcbHRToChannelLeftTophWidthiHeight
ItemHeightTabOrderTextcbRMSToChannelOnChangecbHRToChannelChange  TRadioGroupRadioGroup1LeftTop� WidthqHeight9Caption Display mode TabOrder  TRadioButtonrbDisplayRRLeftTop� WidthaHeight	CaptionR-R IntervalTabOrderOnClickrbDisplayRRClick  TRadioButtonrbDisplayHRLeftTop� WidthYHeight	Caption
Heart RateChecked	TabOrderTabStop	OnClickrbDisplayHRClick  TValidatedEditedHRMaxScaleLeft� Top� WidthAHeightText 0 LoLimit     ���b�HiLimit     ���b@Scale       ��?NumberFormat%g  TValidatedEditedHRThresholdLeft� Top@WidthAHeightText 0.0 %LoLimit     ���b�HiLimit       �@Scale       ��?Units%NumberFormat%.1f     TButtonbOKLeftTop� Width9HeightCaptionOKFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.StylefsBold ModalResult
ParentFontTabOrderOnClickbOKClick  TButtonButton1LeftHTop� Width9HeightCaptionCancelFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.StylefsBold ModalResult
ParentFontTabOrderOnClickbOKClick  TColorDialogColorDialog1Left� Top�    