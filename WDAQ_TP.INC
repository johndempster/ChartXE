(*************************************************************************
 *
 *    NI-DAQ Windows - Function Prototypes
 *    Copyright    (C) National Instruments 1994.
 *
 *************************************************************************)

(*  The following type declaration is required to define *
 *    the double pointer type used in these functions.   *)
type
	   PDouble = ^Double;

function A2000_Calibrate (
         device, 
         saveNewValues, 
         calMethod, 
         channel : 		Integer;
         extRefVoltage : 	Double) : 
integer; far; external 'nidaq';

function A2000_Config (
         device, 
 	   sampClkSrc, 
	   sampClkDrv, 
	   dither : 		Integer) : 
integer; far; external 'nidaq';

function A2150_Calibrate (
	   device, 
	   ref0, 
	   ref1 : 			Integer) : 
integer; far; external 'nidaq';

function AI_Check (
	   device : 		Integer; 
     var status, 
	   value :  		Integer) : 
integer; far; external 'nidaq';

function AI_Clear (
	   device : 		Integer) : 
integer; far; external 'nidaq';

function AI_Configure (
	   device, 
	   chan, 
	   inputMode, 
	   inputRange, 
	   polarity, 
	   driveAIS : 		Integer) : 
integer; far; external 'nidaq';

function AI_Mux_Config (
	   device, 
	   numMuxBrds : 		Integer) : 
integer; far; external 'nidaq';

function AI_Read (
	   device, 
	   chan, 
	   gain : 			Integer; 
     var value : 			Integer) :
integer; far; external 'nidaq';

function AI_Read_Scan (
	   device : 		Integer; 
	   reading : 		PInteger) : 
integer; far; external 'nidaq';

function AI_Setup (
	   device, 
	   chan, 
	   gain : 			Integer) : 
integer; far; external 'nidaq';

function AI_VRead (
	   device, 
	   chan, 
	   gain : 			Integer; 
     var volts : 			Double) :
integer; far; external 'nidaq';

function AI_VRead_Scan (
	   device : 		Integer; 
	   reading : 		PDouble) : 
integer; far; external 'nidaq';

function AI_VScale (
	   device, 
	   chan, 
	   gain : 			Integer; 
	   gainAdjust, 
	   offset :			Double; 
	   reading : 		Integer; 
     var voltage : 		Double) : 
integer; far; external 'nidaq';

function Align_DMA_Buffer (
	   device, 
	   resource : 		Integer; 
	   buffer : 		Pointer;
	   cnt, 
	   bufSize : 		Longint; 
     var alignIndex : 		Longint) : 
integer; far; external 'nidaq';

function AO_Calibrate (
	   device, 
	   operation, 
	   EEPROMloc : 		Integer) : 
integer; far; external 'nidaq';

function AO_Change_Parameter (
	   device, 
	   channel : 		Integer; 
	   paramID, 
	   paramValue : 		Longint) : 
integer; far; external 'nidaq';

function AO_Configure (
	   device, 
	   chan, 
	   outputPolarity, 
	   intOrExtRef : 		Integer;
	   refVoltage : 		Double; 
	   updateMode : 		Integer) : 
integer; far; external 'nidaq';

function AO_Update (
	   device : 		Integer) : 
integer; far; external 'nidaq';

function AO_VScale (
	   device, 
	   chan : 			Integer; 
	   voltage : 		Double; 
     var value : 			Integer) : 
integer; far; external 'nidaq';

function AO_VWrite (
	   device, 
	   chan : 			Integer; 
	   voltage : 		Double) : 
integer;far; external 'nidaq';

function AO_Write (
	   device, 
	   chan, 
	   value : 			Integer) : 
integer; far; external 'nidaq';

function Calibrate_1200 (
	   device, 
	   calOP, 
	   saveNewCal, 
	   EEPROMloc, 
	   calRefChan,
	   grndRefChan, 
	   DAC0chan, 
	   DAC1chan : 		Integer; 
	   calRefVolts, 
	   gain : 			Double) : 
integer; far; external 'nidaq';

function Calibrate_E_Series (
	   device : 		Integer; 
	   calOP, 
	   setofCalConst : 	Longint;
	   calRefVolts : 		Double) : 
integer; far; external 'nidaq';

function Config_Alarm_Deadband (
	   device, 
	   mode : 			Integer; 
	   chanStr : 		PChar;
 	   trigLvl, 
	   deadbandWidth : 	Double; 
	   handle, 
	   alarmOnMsg, 
	   alarmOffMsg : 		Integer;
         callbackAddr : 	Longint) : 
integer; far; external 'nidaq';

function Config_ATrig_Event_Message (
	   device, 
	   mode : 			Integer; 
	   chanStr :		PChar; 
	   trigLvl, 
	   winSize : 		Double; 
	   trigSlope : 		Integer; 
	   skipCnt, 
	   preTrigScans,
         postTrigScans : 	Longint; 
	   handle, 
	   msg : 			Integer; 
	   callBackAddr : 	Longint) : 
integer; far; external 'nidaq';

function Config_DAQ_Event_Message (
	   device, 
	   mode : 			Integer; 
	   chanStr : 		PChar;
	   DAQEvent : 		Integer; 
	   trigVal0, 
	   trigVal1 : 		Longint; 
	   skipCnt, 
         preTrigScans,
 	   postTrigScans : 	Longint; 
	   handle, 
	   msg : 			Integer; 
	   callBackAddr : 	Longint) : 
integer; far; external 'nidaq';

function Configure_HW_Analog_Trigger (
	   device : 		Integer; 
         onOrOff : 		Longint;
         lowValue, 
         highValue : 		Longint; 
	   mode, 
	   trigSource : 		Longint) : 
integer; far; external 'nidaq';

function CTR_Config (
	   device, 
	   ctr, 
	   edgeMode, 
	   gateMode, 
	   outType, 
	   outPolarity : 		Integer) : 
integer; far; external 'nidaq';

function CTR_EvCount (
	   device, 
	   ctr, 
	   timebase, 
	   cont : 			Integer) : 
integer; far; external 'nidaq';

function CTR_EvRead (
	   device, 
	   ctr : 			Integer; 
     var overflow : 		Integer; 
     var counts : 		Word) : 
integer; far; external 'nidaq';

function CTR_FOUT_Config (
	   device, 
	   FOUT, 
	   mode, 
	   timebase, 
	   division : 		Integer) : 
integer; far; external 'nidaq';

function CTR_Period (
	   device, 
	   ctr, 
	   timebase : 		Integer) : 
integer; far; external 'nidaq';

function CTR_Pulse (
	   device, 
	   ctr, 
	   timebase : 		Integer; 
	   delay, 
	   pulseWidth : 		Word) : 
integer; far; external 'nidaq';

function CTR_Rate (
	   freq, 
	   duty : 			Double; 
     var timebase : 		Integer; 
     var period1,
         period2 : 		Word) : 
integer; far; external 'nidaq';

function CTR_Reset (
	   device, 
	   ctr, 
	   outState : 		Integer) : 
integer; far; external 'nidaq';

function CTR_Restart (
	   device, 
	   ctr : 			Integer) : 
integer; far; external 'nidaq';

function CTR_Simul_Op (
	   device, 
	   numCtrs : 		Integer; 
	   ctrList : 		PInteger; 
	   mode : 			Integer) : 
integer; far; external 'nidaq';

function CTR_Square (
	   device, 
	   ctr, 
	   timebase : 		Integer; 
	   period1, 
	   period2 : 		Word) : 
integer; far; external 'nidaq';

function CTR_State (
	   device, 
	   ctr : 			Integer; 
     var outState : 		Integer) : 
integer; far; external 'nidaq';

function CTR_Stop (
	   device, 
	   ctr : 			Integer) : 
integer; far; external 'nidaq';

function DAQ_Check (
	   device : 		Integer; 
     var status : 		Integer; 
     var retrieved : 		Longint) : 
integer; far; external 'nidaq';

function DAQ_Clear (
	   device : 		Integer) : 
integer; far; external 'nidaq';

function DAQ_Config (
	   device, 
	   startTrig, 
	   extConv : 		Integer) : 
integer; far; external 'nidaq';

function DAQ_DB_Config (
	   device, 
	   dbMode : 		Integer) : 
integer; far; external 'nidaq';

function DAQ_DB_HalfReady (
	   device : 		Integer; 
     var halfReady, 
	   status : 		Integer) : 
integer; far; external 'nidaq';

function DAQ_DB_StrTransfer (
	   device : 		Integer; 
	   buffer : 		PChar; 
     var ptsTfr : 		Longint; 
     var status : 		Integer) : 
integer; far; external 'nidaq';

function DAQ_DB_Transfer (
	   device : 		Integer; 
	   hbuffer : 		Pointer; 
     var ptsTfr : 		Longint; 
     var status : 		Integer) : 
integer; far; external 'nidaq';

function DAQ_Monitor (
	   device, 
	   chan, 
	   seq : 			Integer; 
	   monitorCnt : 		Longint;
         monitorBuf : 		Pointer; 
     var newestIndex : 		Longint; 
     var status : 		Integer) : 
integer; far; external 'nidaq';

function DAQ_Op (
	   device, 
	   chan, 
	   gain : 			Integer; 
	   buffer : 		Pointer; 
	   cnt :			Longint; 
	   sampleRate : 		Double) : 
integer; far; external 'nidaq';

function DAQ_Rate (
	   rate : 			Double; 
	   units : 			Integer; 
     var timebase : 		Integer;
     var sampleInt : 		Word) : 
integer; far; external 'nidaq';

function DAQ_Start (
	   device, 
	   chan, 
	   gain : 			Integer; 
	   buffer : 		Pointer; 
	   cnt : 			Longint; 
	   timebase : 		Integer; 
	   sampInt : 		Word) : 
integer; far; external 'nidaq';

function DAQ_StopTrigger_Config (
	   device, 
	   preTrig : 		Integer; 
	   preTrigCnt : 		Longint) : 
integer; far; external 'nidaq';

function DAQ_to_Disk (
	   device, 
	   chan, 
	   gain : 			Integer; 
	   fileName : 		PChar; 
	   cnt : 			Longint; 
	   sampleRate : 		Double; 
	   concat : Integer) : 
integer; far; external 'nidaq';

function DAQ_VScale (
	   device, 
	   chan, 
	   gain : 			Integer; 
	   gainAdjust, 
	   offset :			Double; 
	   cnt : 			Longint; 
	   binArray : 		PInteger; 
	   voltArray : 		PDouble) : 
integer; far; external 'nidaq';

function DIG_Block_Check (
	   device, 
	   grp : 			Integer; 
     var remaining : 		Longint) : 
integer; far; external 'nidaq';

function DIG_Block_Clear (
	   device, 
	   grp : 			Integer) : 
integer; far; external 'nidaq';

function DIG_Block_In (
	   device, 
	   grp : 			Integer; 
	   buffer : 		Pointer; 
	   cnt : 			Longint) : 
integer; far; external 'nidaq';

function DIG_Block_Out (
	   device, 
	   grp : 			Integer; 
	   buffer : 		Pointer; 
	   cnt :			Longint) : 
integer; far; external 'nidaq';

function DIG_Block_PG_Config (
	   device, 
	   grp, 
	   PGmode, 
	   reqSource, 
	   timebase : 		Integer; 
	   interval : 		Word; 
	   externalGate : 	Integer) : 
integer; far; external 'nidaq';

function DIG_DB_Config (
	   device, 
	   grp, 
	   DBMode, 
	   oldDataStop, 
	   partialTransfer : 	Integer) : 
integer; far; external 'nidaq';

function DIG_DB_HalfReady (
	   device, 
	   grp : 			Integer; 
     var halfReady : 		Integer) : 
integer; far; external 'nidaq';

function DIG_DB_StrTransfer (
	   device, 
	   grp : 			Integer; 
	   halfBuffer : 		PChar;
	   ptsTfr : 		Longint) : 
integer; far; external 'nidaq';

function DIG_DB_Transfer (
	   device, 
	   grp : 			Integer; 
	   halfBuffer : 		Pointer;
 	   ptsTfr : 		Longint) : 
integer; far; external 'nidaq';

function DIG_Grp_Config (
	   device, 
  	   grp, 
	   grpsize, 
	   port, 
	   direction : 		Integer) : 
integer; far; external 'nidaq';

function DIG_Grp_Mode (
	   device, 
	   grp, 
	   sigType, 
 	   edge, 
	   reqpol, 
	   ackpol, 
	   settleTime : 		Integer) : 
integer; far; external 'nidaq';

function DIG_Grp_Status (
	   device, 
	   grp : 			Integer; 
     var status : 		Integer) :
integer; far; external 'nidaq';

function DIG_In_Grp (
	   device, 
	   grp : 			Integer; 
     var grp_pat : 		Integer) : 
integer; far; external 'nidaq';

function DIG_In_Line (
	   device, 
	   port, 
	   linenum : 		Integer; 
     var status : 		Integer) : 
integer; far; external 'nidaq';

function DIG_In_Port (
	   device, 
	   port : 			Integer; 
     var pattern : 		Integer) :
integer; far; external 'nidaq';

function DIG_Line_Config (
	   device, 
	   port, 
	   linenum, 
	   direction : 		Integer) :
integer; far; external 'nidaq';

function DIG_Out_Grp (
	   device, 
	   grp, 
	   grp_pat : 		Integer) : 
integer; far; external 'nidaq';

function DIG_Out_Line (
	   device, 
	   port, 
	   linenum, 
	   status : 		Integer) : 
integer; far; external 'nidaq';

function DIG_Out_Port (
	   device, 
	   port, 
	   pattern : 		Integer) : 
integer; far; external 'nidaq';

function DIG_Prt_Config (
	   device, 
	   port, 
	   latch_mode, 
	   direction : 		Integer) : 
integer; far; external 'nidaq';

function DIG_Prt_Status (
	   device, 
	   port : 			Integer; 
     var status : 		Integer) : 
integer; far; external 'nidaq';

function DIG_SCAN_Setup (
	   device, 
	   grp, 
	   numPorts : 		Integer; 
	   portList : 		PInteger;
	   direction : 		Integer) : 
integer; far; external 'nidaq';

function DSP2200_Calibrate (
	   device, 
	   mode, 
	   ADCref : 		Integer) : 
integer; far; external 'nidaq';

function DSP2200_Config (
	   device, 
	   aitranslate, 
	   aotranslate, 
	   demux : 			Integer) : 
integer; far; external 'nidaq';

function Get_DAQ_Device_Info (
	   device : 		Integer; 
	   infoType : 		Longint; 
     var infoVal : 		Longint) : 
integer; far; external 'nidaq';

function Get_DAQ_Event (
	   timeOut : 		Longint; 
     var handle, 
	   msg, 
         wParam : 		Integer;
     var lParam : 		Longint) : 
integer; far; external 'nidaq';

function Get_NI_DAQ_Version (
     var version : 		Longint) : 
integer; far; external 'nidaq';

function GPCTR_Change_Parameter (
	   device : 		Integer; 
	   gpCounterNumber, 
	   paramID,
	   paramValue : 		Longint) : 
integer; far; external 'nidaq';

function GPCTR_Config_Buffer (
	   device : 		Integer; 
	   gpCounterNumber, 
	   reserved,
	   numPoints : 		Longint; 
	   buffer : 		Pointer) : 
integer; far; external 'nidaq';

function GPCTR_Control (
	   device : 		Integer; 
	   gpCounterNumber, 
	   action : 		Longint) : 
integer; far; external 'nidaq';

function GPCTR_Set_Application (
	   device : 		Integer; 
	   gpCounterNumber, 
	   application : 		Longint) : 
integer; far; external 'nidaq';

function GPCTR_Watch (
	   device : 		Integer; 
	   gpCounterNumber, 
	   watchID : 		Longint;
     var watchValue : 		Longint) : 
integer; far; external 'nidaq';

function ICTR_Read (
	   device, 
	   counter : 		Integer; 
     var count : 			Word) : 
integer; far; external 'nidaq';

function ICTR_Reset (
	   device, 
	   counter, 
	   state : 			Integer) : 
integer; far; external 'nidaq';

function ICTR_Setup (
	   device, 
	   counter, 
	   mode : 			Integer; 
	   cnt : 			Word; 
	   binBCD : 		Integer) : 
integer; far; external 'nidaq';

function Init_DA_Brds (
	   device : 		Integer; 
     var brdCode : 		Integer) : 
integer; far; external 'nidaq';

function Lab_ISCAN_Check (
	   device : 		Integer; 
     var status : 		Integer; 
     var retrieved : 		Longint; 
	   finalScanOrder : 	PInteger) : 
integer; far; external 'nidaq';

function Lab_ISCAN_Op (
	   device, 
	   numChans, 
	   gain : 			Integer; 
	   buffer : 		Pointer;
	   cnt : 			Longint; 
	   sampleRate, 
	   scanRate : 		Double; 
	   finalScanOrder : 	PInteger) : 
integer; far; external 'nidaq';

function Lab_ISCAN_Start (
	   device, 
	   numChans, 
	   gain : 			Integer; 
	   buffer : 		Pointer;
	   cnt : 			Longint; 
	   timebase : 		Integer; 
	   sampleInt, 
	   scanInt : 		Word) : 
integer; far; external 'nidaq';

function Lab_ISCAN_to_Disk (
	   device, 
	   numChans, 
	   gain : 			Integer; 
	   fileName : 		PChar; 
	   cnt : 			Longint; 
	   sampleRate, 
	   scanRate : 		Double; 
	   concat : 		Integer) : 
integer; far; external 'nidaq';

function LPM16_Calibrate (
	   device : 		Integer) : 
integer; far; external 'nidaq';

function MAI_Arm (
	   device, 
	   onOff : 			Integer) : 
integer; far; external 'nidaq';

function MAI_Clear (
	   device : 		Integer) : 
integer; far; external 'nidaq';

function MAI_Coupling (
	   device, 
	   numChans : 		Integer; 
	   coupling : 		PInteger) : 
integer; far; external 'nidaq';

function MAI_Read (
	   device : 		Integer; 
	   reading : 		PInteger) : 
integer; far; external 'nidaq';

function MAI_Scale (
	   device : 		Integer; 
	   numScans : 		Longint; 
	   values : 		PInteger;
	   volts : 			PDouble) : 
integer; far; external 'nidaq';

function MAI_Setup (
	   device, 	
  	   numChans : 		Integer; 
	   chanList, 
	   gainList : 		PInteger;
	   muxInterval : 		Word; 
	   timebase, 
	   muxMode : 		Integer) : 
integer; far; external 'nidaq';

function Master_Slave_Config (
	   device, 
	   numSlaves : 		Integer; 
	   saveList : 		PInteger) : 
integer; far; external 'nidaq';

function MDAQ_Check (
	   device, 
	   fullCheck : 		Integer; 
     var acqDone : 		Integer;
     var framesDone, 
	   scansDone : 		Longint) : 
integer; far; external 'nidaq';

function MDAQ_Clear (
	   device : 		Integer) : 
integer; far; external 'nidaq';

function MDAQ_Get (
	   device, 
	   scansOrFrames, 
	   getOrTap : 		Integer; 
	   numToGet, 
	   startFrame, 
	   startScan : 		Longint; 
	   timeout : 		Longint; 
	   getBuffer : 		Pointer;
     var numGotten, 
	   lastFrame, 
	   lastScan : 		Longint; 
     var acqDone : 		Integer) :
integer; far; external 'nidaq';

function MDAQ_ScanRate (
	   device : 		Integer; 
	   interval : 		Word; 
	   timebase : 		Integer) : 
integer; far; external 'nidaq';

function MDAQ_Setup (
	   device : 		Integer; 
	   bufferSize : 		Longint; 
	   scansOrFrames : 	Integer; 
	   preTrigScans, 
	   postTrigScans : 	Longint; 
	   acqBuffer : 		Pointer) : 
integer; far; external 'nidaq';

function MDAQ_Start (
	   device : 		Integer; 
	   numTriggers : 		Longint) : 
integer; far; external 'nidaq';

function MDAQ_Stop (
	   device : 		Integer) : 
integer; far; external 'nidaq';

function MDAQ_StrGet (
	   device, 
	   scansOrFrames, 
	   getOrTap : 		Integer; 
	   numToGet,
	   startFrame, 
	   startScan : 		Longint; 
	   timeout : 		Longint; 
	   getBuffer : 		PChar;
     var numGotten, 
	   lastFrame, 
	   lastScan : 		Longint; 
     var acqDone : 		Integer) :
integer; far; external 'nidaq';

function MDAQ_Trig_Delay (
	   device : 		Integer; 
	   postTrigDelay : 	Word; 
	   timebase : 		Integer) : 
integer; far; external 'nidaq';

function MDAQ_Trig_Select (
	   device, 
	   dTrigMode, 
	   dEdge, 
	   aTrigMode, 
	   aSlope,
	   aLevel, 
	   aTrigChan : 		Integer) : 
integer; far; external 'nidaq';

function MIO_Calibrate (
	   device, 
	   calOP, 
	   saveNewCal, 
	   EEPROMloc, 
	   CalRefChan,
	   DAC0Chan, 
	   DAC1Chan : 		Integer; 
	   calRefVolts : 		Double; 
	   refLoc : 		Integer) :
integer; far; external 'nidaq';

function MIO_Config (
	   device, 
	   dither, 
	   useAMUX : 		Integer) : 
integer; far; external 'nidaq';

function NI_DAQ_Mem_Alloc (
     var handle : 		Integer; 
	   elementSize : 		Integer;
	   numElements : 		Longint; 
	   memType, 
	   memSource : 		Integer) : 
integer; far; external 'nidaq';

function NI_DAQ_Mem_Attributes (
	   handle : 		Integer; 
     var elementSize : 		Integer;
     var numElements : 		Longint; 
     var lockCnt, 
	   memType, 
	   memSource : 		Integer) :
integer; far; external 'nidaq';

function NI_DAQ_Mem_Copy (
	   handle : 		Integer; 
	   buffer : 		Pointer; 
	   startIndex,
	   numEl : 			Longint; 
	   CopyDirection : 	Integer) : 
integer; far; external 'nidaq';

function NI_DAQ_Mem_Free (
	   handle : 		Integer) : 
integer; far; external 'nidaq';

function NI_DAQ_Mem_Lock (
	   handle : 		Integer; 
     var address : 		Longint) : 
integer; far; external 'nidaq';

function NI_DAQ_Mem_Unlock (
	   handle : 		Integer) : 
integer; far; external 'nidaq';

function Peek_DAQ_Event (
	   timeOut : 		Longint; 
     var handle, 
	   msg, 
	   wParam : 		Integer;
     var lParam : 		Longint) : 
integer; far; external 'nidaq';

function REG_Level_Read (
	   device, 
	   registerIndex : 	Integer; 
     var registerValue : 	Longint) : 
integer; far; external 'nidaq';

function REG_Level_Write (
	   device, 
	   registerIndex : 	Integer; 
	   bitsAffected, 
	   bitSettings : 		Longint; 
     var registerValue : 	Longint) : 
integer; far; external 'nidaq';

function RTSI_Clear (
	   device : 		Integer) : 
integer; far; external 'nidaq';

function RTSI_Clock (
	   device, 
	   connect, 
	   direction : 		Integer) : 
integer; far; external 'nidaq';

function RTSI_Conn (
	   device, 
	   brdSignal, 
	   busLine, 
	   direction : 		Integer) :
integer; far; external 'nidaq';

function RTSI_DisConn (
	   device, 
	   brdSignal, 
	   busLine : 		Integer) : 
integer; far; external 'nidaq';

function SC_2040_Config (
	   device, 
	   channel, 
	   sc2040Gain : 		Integer) : 
integer; far; external 'nidaq';

function SCAN_Demux (
	   buffer : 		PInteger; 
	   cnt : 			Longint; 
	   numChans, 
	   muxMode : 		Integer) : 
integer; far; external 'nidaq';

function SCAN_Op (
	   device, 
	   numChans : 		Integer; 
	   chans, 
	   gains : 			PInteger;
	   buffer : 		Pointer; 
	   cnt : 			Longint; 
	   sampleRate, 
	   scanRate : 		Double) : 
integer; far; external 'nidaq';

function SCAN_Sequence_Demux (
	   numChans : 		Integer; 
	   chanVector : 		PInteger;
	   bufferSize : 		Longint; 
	   buffer : 		PInteger; 
	   samplesPerSequence : Integer;
	   scanSequenceVector : PInteger; 
	   samplesPerChanVector : PLongint) : 
integer; far; external 'nidaq';

function SCAN_Sequence_Retrieve (
	   device, 
	   samplesPerSequence : Integer;
	   scanSequenceVector : PInteger) : 
integer; far; external 'nidaq';

function SCAN_Sequence_Setup (
	   device, 
	   numChans : 		Integer; 
	   chanVector, 
	   gainVector,
	   scanRateDivVector : 	PInteger; 
     var scansPerSequence, 
	   samplesPerSequence : Integer) : 
integer; far; external 'nidaq';

function SCAN_Setup (
	   device, 
	   num_chans : 		Integer; 
	   chans, 
	   gains : 			PInteger) : 
integer; far; external 'nidaq';

function SCAN_Start (
	   device : 		Integer; 
	   buffer : 		Pointer; 
	   cnt : 			Longint;
	   tb1 : 			Integer; 
	   si1 : 			Word; 
	   tb2 : 			Integer; 
	   si2 : 			Word) : 
integer; far; external 'nidaq';

function SCAN_to_Disk (
	   device, 
	   numChans : 		Integer; 
	   chans, 
	   gains : 			PInteger;
	   fileName : 		PChar; 
	   cnt : 			Longint; 
	   sampleRate, 
	   scanRate : 		Double; 
	   concat : 		Integer) : 
integer; far; external 'nidaq';

function SCXI_AO_Write (
	   chassisID, 
	   module, 
	   DACchannel, 
	   rangeCode, 
	   opCode : 		Integer; 
	   voltCurrentData : 	Double; 
	   binaryDat : 		Integer; 
     var binaryWritten : 	Integer) : 
integer; far; external 'nidaq';

function SCXI_Cal_Constants (
	   chassisID, 
	   module, 
	   SCXIchannel, 
	   operation, 
	   calArea, 
	   rangeCode : 		Integer; 
	   SCXIgain : 		Double; 
	   DAQdevice, 
	   DAQchannel,
	   DAQgain : 		Integer; 
	   TBgain, 
	   volt1, 
	   binary1, 
	   volt2, 
	   binary2 : 		Double; 
     var binEEprom1, 
	   binEEprom2 : 		Double) : 
integer; far; external 'nidaq';

function SCXI_Calibrate_Setup (
	   chassisID, 
	   module, 
	   calOp : 			Integer) : 
integer; far; external 'nidaq';

function SCXI_Change_Chan (
	   chassisID, 
	   module, 
	   chan : 			Integer) : 
integer; far; external 'nidaq';

function SCXI_Configure_Filter (
	   chassisID, 
	   module, 
	   channel, 
	   filterMode : 		Integer; 
	   freq : 			Double; 
	   cutoffDivDown, 
	   outClkDivDown : 	Word; 
     var actFreq : 		Double) : 
integer; far; external 'nidaq';

function SCXI_Get_Chassis_Info (
	   chassisID : 		Integer; 
     var chassisType, 
   	   address,
 	   commMode, 
	   commPath, 
	   numSlots : 		Integer) : 
integer; far; external 'nidaq';

function SCXI_Get_Module_Info (
	   chassisID, 
	   device : 		Integer; 
     var modulePresent : 	Longint; 
     var opMode, 
	   DAQdevice : 		Integer) : 
integer; far; external 'nidaq';

function SCXI_Get_State (
	   chassisID, 
	   module, 
	   port, 
	   channel : 		Integer; 
     var data : 			Longint) : 
integer; far; external 'nidaq';

function SCXI_Get_Status (
	   chassisID, 
	   module, 
	   wait : 			Integer; 
     var data : 			Longint) : 
integer; far; external 'nidaq';

function SCXI_Load_Config (
	   chassisID : 		Integer) : 
integer; far; external 'nidaq';

function SCXI_MuxCtr_Setup (
	   device, 
	   enable, 
	   scanDiv : 		Integer; 
	   muxCtrVal : 		Word) : 
integer; far; external 'nidaq';

function SCXI_Reset (
	   chassisID, 
	   moduleSlot : 		Integer) : 
integer; far; external 'nidaq';

function SCXI_Scale (
	   chassisID, 
	   module, 
	   SCXIchannel : 		Integer; 
	   SCXIgain,
	   TBgain : 		Double; 
	   DAQdevice, 
	   DAQchannel, 
	   DAQgain : 		Integer; 
	   numPoints : 		Longint; 
	   binArray : 		PInteger; 
	   voltArray : 		PDouble) : 
integer; far; external 'nidaq';

function SCXI_SCAN_Setup (
	   chassisID, 
	   numModules : 		Integer; 
	   modules, 
	   numChans,
	   startChans : 		PInteger; 
	   DAQdevice, 
	   modeFlag : 		Integer) : 
integer; far; external 'nidaq';

function SCXI_Set_Config (
	   chassisID, 
	   chassisType, 
	   address, 
	   commMode, 
	   slotOrCOMM,
	   numSlots : 		Integer; 
	   moduleTypes : 		PLongint; 
	   opModes, 
	   DAQdevices : 		PInteger) : 
integer; far; external 'nidaq';

function SCXI_Set_Gain (
	   chassisID, 
	   module, 
	   channel : 		Integer; 
	   gain : 			Double) : 
integer; far; external 'nidaq';

function SCXI_Set_Input_Mode (
	   chassisID, 
	   module, 
	   inputMode : 		Integer) :
integer; far; external 'nidaq';

function SCXI_Set_State (
	   chassisID, 
	   module, 
	   port, 
	   channel : 		Integer; 
	   data : 			Longint) : 
integer; far; external 'nidaq';

function SCXI_Single_Chan_Setup (
	   chassisID, 
	   module, 
	   chan, 
	   DAQdevice : 		Integer) : 
integer; far; external 'nidaq';

function SCXI_Track_Hold_Control (
	   chassisID, 
	   module, 
	   state, 
	   DAQdevice :		Integer) : 
integer; far; external 'nidaq';

function SCXI_Track_Hold_Setup (
	   chassisID, 
	   module, 
	   mode, 
	   source, 
	   send,
	   holdCnt, 
	   DAQdevice : 		Integer) : 
integer; far; external 'nidaq';

function Select_Signal (
	   device : 		Integer; 
	   signal, 
	   source, 
	   sourceSpec :		Longint) : 
integer; far; external 'nidaq';

function Set_DAQ_Device_Info (
	   device : 		Integer; 
	   infoType, 
	   infoVal : 		Longint) : 
integer; far; external 'nidaq';

function Timeout_Config (
	   device : 		Integer; 
	   numTicks : 		Longint) : 
integer; far; external 'nidaq';

function Trigger_Window_Config(
	   device, 
	   mode : 			Integer; 
	   windowSize : 		Word) : 
integer; far; external 'nidaq';

function WFM_Chan_Control (
	   device, 
	   channel, 
	   operation : 		Integer) : 
integer; far; external 'nidaq';

function WFM_Check (
	   device, 
	   channel : 		Integer; 
     var status : 		Integer; 
     var pointsDone, 
	   itersDone : 		Longint) : 
integer; far; external 'nidaq';

function WFM_ClockRate (
	   device, 
	   group, 
	   whichClock, 
	   timebase : 		Integer;
	   updateInterval : 	Longint; 
	   mode : 			Integer) : 
integer; far; external 'nidaq';

function WFM_DB_Config (
	   device, 
	   numChans : 		Integer; 
	   chanVect : 		PInteger;
	   DBMode, 
	   oldDataStop, 
	   partialTransfer : 	Integer) : 
integer; far; external 'nidaq';

function WFM_DB_HalfReady (
	   device, 
	   numChans : 		Integer; 
	   chanVect : 		PInteger;
     var halfReady : 		Integer) : 
integer; far; external 'nidaq';

function WFM_DB_Transfer (
	   device, 
	   numChans : 		Integer; 
	   chanVect : 		PInteger;
	   buffer : 		Pointer; 
	   count : 			Longint) : 
integer; far; external 'nidaq';

function WFM_DB_StrTransfer (
	   device, 
	   numChans : 		Integer; 
	   chanVect : 		PInteger;
	   strBuffer : 		PChar; 
	   count : 			Longint) : 
integer; far; external 'nidaq';

function WFM_From_Disk (
	   device, 
	   numChans : 		Integer; 
	   chanVect : 		PInteger;
	   fileName : 		PChar; 
	   startPts, 
	   endPts, 
	   iterations : 		Longint; 
	   rate : 			Double) : 
integer; far; external 'nidaq';

function WFM_Group_Control (
	   device, 
	   group, 
	   operation : 		Integer) : 
integer; far; external 'nidaq';

function WFM_Group_Setup (
	   device, 
	   numChans : 		Integer; 
	   chanVect : 		PInteger;
	   group : 			Integer) : 
integer; far; external 'nidaq';

function WFM_Load (
	   device, 
	   numChans : 		Integer; 
	   chanVect : 		PInteger; 
	   buffer : 		Pointer; 
	   count, 
	   iterations : 		Longint; 
	   mode : 			Integer) : 
integer; far; external 'nidaq';

function WFM_Op (
	   device, 
	   numChans : 		Integer; 
	   chanVect : 		PInteger; 
	   buffer : 		Pointer; 
	   count, 
	   iterations : 		Longint; 
	   rate : 			Double) : 
integer; far; external 'nidaq';

function WFM_Rate (
	   rate : 			Double; 
	   units : 			Integer; 
     var timebase : 		Integer;
     var updateInterval : 	Longint) : 
integer; far; external 'nidaq';

function WFM_Scale (
	   device, 
	   chan : 			Integer; 
	   count : 			Longint; 
	   gain : 			Double;
	   voltArray : 		PDouble; 
	   binArray : 		PInteger) : 
integer; far; external 'nidaq';


(*************************************************************************
 *
 *    NI-DAQ Windows - Obsolete Function Prototypes
 *
 *************************************************************************)

function AI_Scale (
	   device, 
	   gain, 
	   value : 			Integer; 
     var voltage : 		Double) : 
integer; far; external 'nidaq';

function AI_Config (
	   device, 
	   singOrDiff, 
	   range, 
	   uniOrBi : 		Integer) : 
integer; far; external 'nidaq';

function AO_Config (
	   device, 
	   chan, 
	   outputPolarity : 	Integer; 
	   refVoltage : 		Double; 
	   updateMode : 		Integer) : 
integer; far; external 'nidaq';

function DAQ_Scale (
	   device, 
	   gain : 			Integer; 
	   cnt : 			Longint; 
	   rawData : 		PInteger;
	   scaledData : 		PDouble) : 
integer; far; external 'nidaq';

function DAQ_Trigger_Config (
	   device, 
	   preTrig : 		Integer; 
	   preTrigCnt : 		Longint) : 
integer; far; external 'nidaq';

function Get_DA_Brds_Info (
	   device : 		Integer; 
     var brdCode, 
	   baseAddr, 
	   irq1Lvl,
	   irq2Lvl, 
	   irqTrigMode, 
	   dma1Lvl, 
	   dma2Lvl, 
	   daqMode : 		Integer) : 
integer; far; external 'nidaq';

function Lab_SCAN_Check (
	   device : 		Integer; 
     var status : 		Integer; 
     var retrieved : 		Longint; 
	   finalScanOrder : 	PInteger) : 
integer; far; external 'nidaq';

function Lab_SCAN_Op (
	   device, 
	   numChans, 
	   gain : 			Integer; 
	   buffer : 		PInteger;
	   cnt : 			Longint; 
	   sampleRate : 		Double; 
	   finalScanOrder : 	PInteger) : 
integer; far; external 'nidaq';

function Lab_SCAN_Start (
	   device, 
	   numChans, 
	   gain : 			Integer; 
	   buffer : 		PInteger;
	   cnt : 			Longint; 
	   timebase : 		Integer; 
	   sampleInt : 		Word) : 
integer; far; external 'nidaq';

function Lab_SCAN_to_Disk (
	   device, 
	   numChans, 
	   gain : 			Integer; 
	   fileName : 		PChar; 
	   cnt : 			Longint; 
	   sampleRate : 		Double; 
	   concat : 		Integer) : 
integer; far; external 'nidaq';

function MDAQ_Ext_Setup (
	   device : 		Integer; 
	   bufferSize : 		Longint; 
	   scansOrFrames : 	Integer; 
	   preTrigScans, 
	   postTrigScans, 
	   extMemAddr : 		Longint) : 
integer; far; external 'nidaq';

function MIO16_F5_Config (
	   device, 
	   dither : 		Integer) : 
integer; far; external 'nidaq';

function MIO16_F5_Calibrate (
	   device, 
	   calOP, 
	   saveNewCal, 
	   EEPROMloc, 
	   CalRefChan,
	   DAC0Chan, 
	   DAC1Chan : 		Integer; 
	   calRefVolts : 		Double; 
	   refLoc : 		Integer) :
integer; far; external 'nidaq';

function SCXI_1200_Calibrate (
	   device, 
	   calOP, 
	   saveNewCal, 
	   EEPROMloc, 
	   calRefChan,
	   grndRefChan, 
	   DAC0chan, 
	   DAC1chan : 		Integer; 
	   calRefVolts, 
	   gain : 			Double) : 
integer; far; external 'nidaq';

function SCXI_Set_Filter (
	   chassisID, 
	   module, 
	   channel : 		Integer; 
	   extDivideDown : 	Word; 
	   freq : 			Double; 
     var actFreq : 		Double) : 
integer; far; external 'nidaq';

function SCXI_Set_Module_Gain (
	   chassisID, 
	   module, 
	   gain : 			Integer) : 
integer; far; external 'nidaq';

function Set_DAQ_Mode (
	   device, 
	   newDaqMode : 		Integer) : 
integer; far; external 'nidaq';

function USE_E_Series : 
integer; far; external 'nidaq';

function USE_E_Series_AI : 
integer; far; external 'nidaq';

function USE_E_Series_AO : 
integer; far; external 'nidaq';

function USE_E_Series_DAQ : 
integer; far; external 'nidaq';

function USE_E_Series_DIO : 
integer; far; external 'nidaq';

function USE_E_Series_GPCTR : 
integer; far; external 'nidaq';

function USE_E_Series_GPCTR_Simple : 
integer; far; external 'nidaq';

function USE_E_Series_Misc : 
integer; far; external 'nidaq';

function USE_E_Series_WFM : 
integer; far; external 'nidaq';

function WF_Check (
	   device, 
	   chan : 			Integer; 
     var status : 		Integer; 
     var itersDone,
 	   nextPoint : 		Longint) : 
integer; far; external 'nidaq';

function WF_Clear (
	   device : 		Integer) : 
integer; far; external 'nidaq';

function WF_DB_Config (
	   device, 
	   chan, 
	   DBmode, 
	   oldDataStop : 		Integer) : 
integer; far; external 'nidaq';

function WF_DB_StrTransfer (
	   device, 
	   chan : 			Integer; 
	   buffer : 		PChar; 
	   cnt : 			Longint) : 
integer; far; external 'nidaq';

function WF_DB_Transfer (
	   device, 
	   chan : 			Integer; 
	   buffer : 		PInteger; 
 	   cnt : 			Longint) : 
integer; far; external 'nidaq';

function WF_from_Disk (
	   device, 
	   chan : 			Integer; 
	   fileName : 		PChar; 
	   iters : 			Longint; 
	   rate : 			Double; 
	   startPt, 
	   endPt : 			Longint) : 
integer; far; external 'nidaq';

function WF_Load (
	   device, 
	   chan : 			Integer; 
	   buffer : 		PInteger; 
	   cnt, 
	   iterations : 		Longint) : 
integer; far; external 'nidaq';

function WF_Op (
	   device, 
	   chan : 			Integer; 
	   buf0, 
	   buf1 : 			PInteger; 
	   cnt0, 
	   cnt1, 
	   iters0, 
	   iters1 : 		Longint; 
	   rate : 			Double) : 
integer; far; external 'nidaq';

function WF_Pause (
 	   device : 		Integer) : 
integer; far; external 'nidaq';

function WF_Rate (
	   rate : 			Double; 
	   units : 			Integer; 
     var timebase : 		Integer;
     var updateInt : 		Word) : 
integer; far; external 'nidaq';

function WF_Resume (
	   device : 		Integer) : 
integer; far; external 'nidaq';

function WF_Scale (
	   device, 
	   chan : 			Integer; 
	   cnt : 			Longint; 
	   gain : 			Double;
	   realArray : 		PDouble; 
	   intArray : 		PInteger) : 
integer; far; external 'nidaq';

function WF_Start (
	   device, 
	   timebase : 		Integer; 
	   updateInt : 		Word) : 
integer; far; external 'nidaq';

function WFM_UpdateRate (
	   device, 
	   group, 
	   timebase : 		Integer; 
	   updateInterval : 	Longint; 
	   mode : 			Integer) : 
integer; far; external 'nidaq';
