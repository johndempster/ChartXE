unit Global;
{ ==================================================
  CHART - Global variables module
  (c) J. Dempster, University of Strathclyde 1996-98
  ==================================================}

interface

uses Graphics, SESLabIO ;

const
     HeaderSize = 8192 ;
     ChannelLimit = 3 ;
     MaxDACVolts = 5. ;
     MaxADCBuf = 16000 ;
     DACdt = 0.002 ;
     MinDT = 0.001 ;
     MaxDT = 1.0 ;
     EmptyFlag = 32767 ;
type

TSmallIntArray = Array[0..32767] of SmallInt ;
TADCRange = string[20] ;

{ Data record header block }
TRecHeader = record
           Status : string[8] ;
           RecType : string[4] ;
           Number : Single ;
           Time : Single ;
           dt : Single ;
           ADCVoltageRange : Single ;
           end ;

{ Data file header block }
TFileHeader = record
            FileName : string ;
            FileHandle : integer ;
            NumChannels : LongInt ;
            NumBytesInHeader : LongInt ;
            NumSamplesInFile : LongInt ;
            DataStart : LongInt ;
            dt : Single ;
            ADCVoltageRange : Array[0..ChannelLimit] of Single ;
            ADCMaxBits : Single ;
            IdentLine : string{[76]} ;
            SaveHeader : Boolean ;
            tDisplay : Single ;
            DigitalFilter : Single ;
            RMSInUse : Boolean ;
            RMSFromChannel : LongInt ;
            RMSToChannel : LongInt ;
            RMSNumPoints : LongInt ;
            HRInUse : Boolean ;
            HRFromChannel : LongInt ;
            HRToChannel : LongInt ;
            end ;

TMarkers = record
         Num : LongInt ;
         Time : array[1..50] of Single ;
         Text : array[1..50] of string{[16]} ;
         end ;

TGainChanges = record
          Num : LongInt ;
          Time : array[0..30] of Single ;
          Channel : array[0..30] of LongInt ;
          Scale : array[0..30] of Single ;
          end ;

TString4 = string[4] ;

TChannel = record
         xMin : single ;
         xMax : single ;
         yMin : single ;
         yMax : single ;
         xScale : single ;
         yScale : single ;
         Left : LongInt ;
         Right : LongInt ;
         Top : LongInt ;
         Bottom : LongInt ;
         Color : TColor ;
         TimeZero : Single ;
         ADCZero : LongInt ;
         ADCSCale : Single ;
         ADCCalibrationFactor : Single ;
         ADCCalibrationValue : Single ;
         ADCAmplifierGain : Single ;
         ADCUnits : {Tstring4} string ;
         ADCName : {TString4} string ;
         CursorIndex : LongInt ;
         CursorTime : Single ;
         CursorValue : Single ;
         DCOffset : LongInt ;
         DCOffsetV : Single ;
         end ;

TStimulator = record
          Running : Boolean ;
          Delay : Single ;
          GroupInterval : Single ;
          PulseFrequency : Single ;
          PulsesPerGroup : LongInt ;
          PulseWidth : Single ;
          RepeatPeriodmsec : LongInt ;
          TimeForNextGroup : LongInt ;
          NumDACPoints : LongInt ;
          dtDAC : Single ;

          end ;

TCursor = record
        Channel : LongInt ;
        MoveZero : Boolean ;
        Time : Single ;
        yValue : Single ;
        end ;

TIntBuf = array[0..MaxADCBuf] of SmallInt ;

TPlayBuf = record
         nPoints : LongInt ;
         x : array[0..1000] of Single ;
         YMin : array[0..ChannelLimit,0..1000] of Integer ;
         YMax : array[0..ChannelLimit,0..1000] of Integer ;
         end ;

TRMS = record
     InUse : Boolean ;
     Buf : array[0..100] of LongInt ;
     Pointer : LongInt ;
     NumAverage : LongInt ;
     Sum : Single ;
     Scale : Single ;
     FromChannel : LongInt ;
     ToChannel : LongInt ;
     yMax : Integer ;
     yMin : Integer ;
     yLast : Integer ;
     end ;

THR = record
     InUse : Boolean ;
     BeatCounter : LongInt ;
     DeadTime : LongInt ;
     LoRateLimit : LongInt ;
     Baseline : Integer ;
     Threshold : LongInt ;
     HeartRate : Integer ;
     Scale : Single ;
     MaxScale : Single ;
     FromChannel : LongInt ;
     ToChannel : LongInt ;
     yMax : Integer ;
     yMin : Integer ;
     yLast : Integer ;
     ECG : SmallInt ;
     DisplayHR : Boolean ;
     SetThreshold : Boolean ;
     MaxLevel : SmallInt ;
     ThresholdCounter : Integer ;
     PercentageThreshold : single ;
     end ;

TPageSettings = record
              FontName : string ;
              FontSize : LongInt ;
              LineThickness : LongInt ;
              ShowLines : boolean ;
              MarkerSize : LongInt ;
              ShowMarkers : boolean ;
              LeftMargin : single ;
              RightMargin : single ;
              TopMargin : single ;
              BottomMargin : single ;
              MetafileWidth : Integer ;
              MetafileHeight : Integer ;
              UseColor : boolean ;

              end ;


TSettings = record
          Resolution16bit : Boolean ;
          DisplayDuration : Single ;
          DisplayGrid : Boolean ;
          DataDirectory : string ;
          ProgDirectory : string ;
          DataFilePrefix : string ;
          DataFileIncludeDate : Boolean ;
          IniFileName : string ;
          LaboratoryInterface : Integer ;
          RecentFiles : Array[0..3] of string ;
          RecentFilesPointer : Integer ;
          NIDisableDMA : Boolean ;
          TScale : single ;
          TUnits : string ;
          Plot : TPageSettings ;
          end ;


{ Global Variables }
const
NumSamplesPerSector = 256 ;
NumBytesPerSector = 512 ;

var
   ProgName : string ;
   InterfaceAvailable : Boolean ;
   InterfaceInitialised : Boolean ;
   VersionNum : string ;
   fH : TFileHeader ;
   rH : TRecHeader ;
   Markers : TMarkers ;
   GainChanges : TGainChanges ;
   Channel : array[0..5] of TChannel ;
   Stimulator : TStimulator ;
   Curs : TCursor ;
   RMS : TRMS ;
   HR : THR ;
   MaxADCValue : Integer ;   // Maximum A/D integer value
   MinADCValue : Integer ;   // Minimum A/D integer value
   MaxDACValue : Integer ;   // Maximum D/A integer value
   MinDACValue : Integer ;   // Minimum D/A integer value

   ADC : PSmallIntArray ;
   DAC : PSmallIntArray ;
   PLayBuf : ^TPlayBuf ;
   Settings : TSettings ;
implementation

end.
