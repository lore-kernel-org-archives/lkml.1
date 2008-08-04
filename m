Return-Path: <linux-kernel-owner+w=401wt.eu-S1758404AbYHDW1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404AbYHDW1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbYHDW0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:26:50 -0400
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:55383 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655AbYHDW0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:26:46 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Aug 2008 18:26:46 EDT
Message-ID: <4897809E.8070902@alum.mit.edu>
Date: Mon, 04 Aug 2008 18:20:14 -0400
From: Robert Krawitz <rlk@alum.mit.edu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Another one for fixup-storage
Content-Type: multipart/mixed;
 boundary="------------080007000409090407010609"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080007000409090407010609
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This is for a Dell Inspiron E1705/9400.  I'm using a non-OEM disk (a 
Hitachi 320 GB drive).

Note that matching on "MP061" doesn't work -- it needs to be "MP061*" 
due to the way dmidecode seems to return the data (with a bunch of 
spaces after the tag).  Hence I've attached the data rather than merely

I've only had this thing a month or so and already had over 70,000 
unload cycles.  Ick.
-- 
Robert Krawitz                                     <rlk@alum.mit.edu>

Tall Clubs International  --  http://www.tall.org/ or 1-888-IM-TALL-2
Member of the League for Programming Freedom -- mail lpf@uunet.uu.net
Project lead for Gutenprint   --    http://gimp-print.sourceforge.net

"Linux doesn't dictate how I work, I dictate how Linux works."
--Eric Crampton

--------------080007000409090407010609
Content-Type: text/plain;
 name="sda.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sda.out"


/dev/sda:

ATA device, with non-removable media
	Model Number:       Hitachi HTS543232L9A300                 
	Serial Number:      080403FB0400LEG0YVBA
	Firmware Revision:  FB4OC40C
	Transport:          Serial, ATA8-AST, SATA 1.0a, SATA II Extensions, SATA Rev 2.5; Revision: ATA8-AST T13 Project D1697 Revision 0b
Standards:
	Used: ATA-8-ACS revision 3f 
	Supported: 8 7 6 5 
Configuration:
	Logical		max	current
	cylinders	16383	16383
	heads		16	16
	sectors/track	63	63
	--
	CHS current addressable sectors:   16514064
	LBA    user addressable sectors:  268435455
	LBA48  user addressable sectors:  625142448
	device size with M = 1024*1024:      305245 MBytes
	device size with M = 1000*1000:      320072 MBytes (320 GB)
Capabilities:
	LBA, IORDY(can be disabled)
	Queue depth: 32
	Standby timer values: spec'd by Vendor, no device specific minimum
	R/W multiple sector transfer: Max = 16	Current = 8
	Advanced power management level: disabled
	Recommended acoustic management value: 128, current value: 254
	DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6 
	     Cycle time: min=120ns recommended=120ns
	PIO: pio0 pio1 pio2 pio3 pio4 
	     Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
	Enabled	Supported:
	   *	SMART feature set
	    	Security Mode feature set
	   *	Power Management feature set
	   *	Write cache
	   *	Look-ahead
	   *	Host Protected Area feature set
	   *	WRITE_BUFFER command
	   *	READ_BUFFER command
	   *	NOP cmd
	   *	DOWNLOAD_MICROCODE
	    	Advanced Power Management feature set
	    	Power-Up In Standby feature set
	   *	SET_FEATURES required to spinup after power up
	    	SET_MAX security extension
	    	Automatic Acoustic Management feature set
	   *	48-bit Address feature set
	   *	Device Configuration Overlay feature set
	   *	Mandatory FLUSH_CACHE
	   *	FLUSH_CACHE_EXT
	   *	SMART error logging
	   *	SMART self-test
	   *	General Purpose Logging feature set
	   *	WRITE_{DMA|MULTIPLE}_FUA_EXT
	   *	64-bit World wide name
	   *	IDLE_IMMEDIATE with UNLOAD
	   *	WRITE_UNCORRECTABLE_EXT command
	   *	Segmented DOWNLOAD_MICROCODE
	   *	SATA-I signaling speed (1.5Gb/s)
	   *	SATA-II signaling speed (3.0Gb/s)
	   *	Native Command Queueing (NCQ)
	   *	Host-initiated interface power management
	   *	Phy event counters
	   *	unknown 76[12]
	    	Non-Zero buffer offsets in DMA Setup FIS
	    	DMA Setup Auto-Activate optimization
	   *	Device-initiated interface power management
	    	In-order data delivery
	   *	Software settings preservation
	   *	SMART Command Transport (SCT) feature set
	   *	SCT LBA Segment Access (AC2)
	   *	SCT Error Recovery Control (AC3)
	   *	SCT Features Control (AC4)
	   *	SCT Data Tables (AC5)
Security: 
	Master password revision code = 65534
		supported
	not	enabled
	not	locked
		frozen
	not	expired: security count
		supported: enhanced erase
	126min for SECURITY ERASE UNIT. 128min for ENHANCED SECURITY ERASE UNIT.
Logical Unit WWN Device Identifier: 5000cca55dc0700e
	NAA		: 5
	IEEE OUI	: cca
	Unique ID	: 55dc0700e
Checksum: correct

--------------080007000409090407010609
Content-Type: text/plain;
 name="dmi.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmi.out"

# dmidecode 2.9
SMBIOS 2.4 present.
44 structures occupying 1913 bytes.
Table at 0x000F7950.

Handle 0xDA00, DMI type 218, 251 bytes
OEM-specific Type
	Header and Data:
		DA FB 00 DA B2 00 0D 5F 1F 37 40 7D 00 00 00 00
		00 7E 00 02 00 00 00 40 00 04 00 01 00 41 00 04
		00 00 00 65 00 05 00 00 00 66 00 05 00 01 00 5E
		00 06 00 01 00 5F 00 06 00 00 00 F1 00 07 00 00
		00 F2 00 07 00 01 00 F3 00 07 00 02 00 42 00 08
		00 01 00 43 00 08 00 00 00 55 00 09 00 00 00 6D
		00 09 00 01 00 98 01 09 00 02 00 0A 01 0A 00 01
		00 0B 01 0A 00 00 00 2D 00 0B 00 02 00 6E 00 0B
		00 01 00 2E 00 0B 00 00 00 11 01 0C 00 00 00 10
		01 0C 00 01 00 F0 00 0D 00 01 00 ED 00 0D 00 00
		00 41 01 0E 00 01 00 40 01 0E 00 00 00 47 01 0F
		00 01 00 46 01 0F 00 00 00 4A 01 10 00 00 00 4B
		01 10 00 01 00 52 01 11 00 01 00 53 01 11 00 00
		00 80 01 12 00 01 00 7F 01 12 00 00 00 94 01 13
		00 00 00 93 01 13 00 01 00 86 01 14 00 01 00 85
		01 14 00 00 00 FF FF 00 00 00 00

Handle 0xDA01, DMI type 218, 251 bytes
OEM-specific Type
	Header and Data:
		DA FB 01 DA B2 00 0D 5F 1F 37 40 82 01 15 00 01
		00 81 01 15 00 00 00 9B 01 16 00 00 00 9C 01 16
		00 01 00 9D 01 16 00 02 00 9E 01 16 00 03 00 8B
		01 17 00 00 00 8B 01 17 00 01 00 EA 00 18 00 00
		00 EB 00 18 00 01 00 EC 00 18 00 02 00 28 00 19
		00 00 00 29 00 19 00 01 00 2A 00 19 00 02 00 2B
		00 1A 00 00 00 2C 00 1B 00 00 00 E7 00 1C 00 01
		00 E6 00 1C 00 00 00 0E 01 1D 00 01 00 0F 01 1D
		00 00 00 9B 00 1E 00 01 00 9C 00 1E 00 00 00 D1
		00 1F 00 01 00 D2 00 1F 00 00 00 E8 00 20 00 01
		00 E9 00 20 00 00 00 12 01 21 00 01 00 13 01 21
		00 00 00 9A 01 22 00 01 00 99 01 22 00 00 00 01
		01 23 00 00 00 02 01 23 00 01 00 04 01 23 00 02
		00 76 01 76 01 01 00 75 01 75 01 01 00 01 F0 01
		F0 00 00 02 F0 02 F0 00 00 03 F0 03 F0 00 00 04
		F0 04 F0 00 00 FF FF 00 00 00 00

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: Dell Inc.
	Version: A09
	Release Date: 06/27/2007
	Address: 0xF0000
	Runtime Size: 64 kB
	ROM Size: 576 kB
	Characteristics:
		ISA is supported
		PCI is supported
		PC Card (PCMCIA) is supported
		PNP is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		Boot from CD is supported
		Selectable boot is supported
		3.5"/720 KB floppy services are supported (int 13h)
		Print screen service is supported (int 5h)
		8042 keyboard services are supported (int 9h)
		Serial services are supported (int 14h)
		Printer services are supported (int 17h)
		CGA/mono video services are supported (int 10h)
		ACPI is supported
		USB legacy is supported
		AGP is supported
		Smart battery is supported
		BIOS boot specification is supported
		Function key-initiated network boot is supported
		Targeted content distribution is supported
	BIOS Revision: 0.9
	Firmware Revision: 0.9

Handle 0x0100, DMI type 1, 27 bytes
System Information
	Manufacturer: Dell Inc.
	Product Name: MP061                           
	Version: Not Specified
	Serial Number: JBQN6C1
	UUID: 44454C4C-4200-1051-804E-CAC04F364331
	Wake-up Type: Power Switch
	SKU Number: Not Specified
	Family:  

Handle 0x0200, DMI type 2, 9 bytes
Base Board Information
	Manufacturer: Dell Inc.
	Product Name: 0YD479
	Version:    
	Serial Number: .JBQN6C1.CN129616BK2142.

Handle 0x0300, DMI type 3, 13 bytes
Chassis Information
	Manufacturer: Dell Inc.
	Type: Portable
	Lock: Not Present
	Version: Not Specified
	Serial Number: JBQN6C1
	Asset Tag: Not Specified
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Safe
	Security Status: None

Handle 0x0400, DMI type 4, 40 bytes
Processor Information
	Socket Designation: Microprocessor
	Type: Central Processor
	Family: Pentium M
	Manufacturer: Intel
	ID: F6 06 00 00 FF FB EB BF
	Signature: Type 0, Family 6, Model 15, Stepping 6
	Flags:
		FPU (Floating-point unit on-chip)
		VME (Virtual mode extension)
		DE (Debugging extension)
		PSE (Page size extension)
		TSC (Time stamp counter)
		MSR (Model specific registers)
		PAE (Physical address extension)
		MCE (Machine check exception)
		CX8 (CMPXCHG8 instruction supported)
		APIC (On-chip APIC hardware supported)
		SEP (Fast system call)
		MTRR (Memory type range registers)
		PGE (Page global enable)
		MCA (Machine check architecture)
		CMOV (Conditional move instruction supported)
		PAT (Page attribute table)
		PSE-36 (36-bit page size extension)
		CLFSH (CLFLUSH instruction supported)
		DS (Debug store)
		ACPI (ACPI supported)
		MMX (MMX technology supported)
		FXSR (Fast floating-point save and restore)
		SSE (Streaming SIMD extensions)
		SSE2 (Streaming SIMD extensions 2)
		SS (Self-snoop)
		HTT (Hyper-threading technology)
		TM (Thermal monitor supported)
		PBE (Pending break enabled)
	Version: Not Specified
	Voltage: 3.3 V
	External Clock: 166 MHz
	Max Speed: 2130 MHz
	Current Speed: 1833 MHz
	Status: Populated, Enabled
	Upgrade: None
	L1 Cache Handle: 0x0700
	L2 Cache Handle: 0x0701
	L3 Cache Handle: Not Provided
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified
	Core Count: 2
	Core Enabled: 2
	Thread Count: 2
	Characteristics:
		64-bit capable

Handle 0x0700, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Not Specified
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 32 KB
	Maximum Size: 32 KB
	Supported SRAM Types:
		Unknown
	Installed SRAM Type: Unknown
	Speed: Unknown
	Error Correction Type: None
	System Type: Data
	Associativity: 4-way Set-associative

Handle 0x0701, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Not Specified
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Varies With Memory Address
	Location: Internal
	Installed Size: 2048 KB
	Maximum Size: 2048 KB
	Supported SRAM Types:
		Pipeline Burst
	Installed SRAM Type: Pipeline Burst
	Speed: 15 ns
	Error Correction Type: None
	System Type: Unified
	Associativity: Other

Handle 0x0804, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0806, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: MONITOR
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: DB-15 female
	Port Type: Video Port

Handle 0x080B, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: FireWire
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: IEEE 1394
	Port Type: Firewire (IEEE P1394)

Handle 0x080C, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Modem
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: RJ-11
	Port Type: Modem Port

Handle 0x080D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Ethernet
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: RJ-45
	Port Type: Network Port

Handle 0x0900, DMI type 9, 13 bytes
System Slot Information
	Designation: PCMCIA 0
	Type: 32-bit PC Card (PCMCIA)
	Current Usage: Available
	Length: Other
	ID: Adapter 0, Socket 0
	Characteristics:
		5.0 V is provided
		3.3 V is provided
		PC Card-16 is supported
		Cardbus is supported
		Zoom Video is supported
		Modem ring resume is supported

Handle 0x0A00, DMI type 10, 6 bytes
On Board Device Information
	Type: Video
	Status: Enabled
	Description: ATI MOBILITY Radeon X1400     

Handle 0x0A01, DMI type 10, 6 bytes
On Board Device Information
	Type: Sound
	Status: Enabled
	Description: Sigmatel 9200

Handle 0x0B00, DMI type 11, 5 bytes
OEM Strings
	String 1: Dell System
	String 2: 5[0003]
	String 3: 13[PP05XB]

Handle 0x0D00, DMI type 13, 22 bytes
BIOS Language Information
	Installable Languages: 1
		en|US|iso8859-1
	Currently Installed Language: en|US|iso8859-1

Handle 0x1000, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 4 GB
	Error Information Handle: Not Provided
	Number Of Devices: 2

Handle 0x1100, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x1000
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 1024 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM_A
	Bank Locator: Not Specified
	Type: DDR
	Type Detail: Synchronous
	Speed: 667 MHz (1.5 ns)
	Manufacturer: CE00000000000000
	Serial Number: F5550AA6
	Asset Tag: 430649
	Part Number: M4 70T2953CZ3-CE6 

Handle 0x1101, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x1000
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 1024 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM_B
	Bank Locator: Not Specified
	Type: DDR
	Type Detail: Synchronous
	Speed: 667 MHz (1.5 ns)
	Manufacturer: CE00000000000000
	Serial Number: F5550B63
	Asset Tag: 430649
	Part Number: M4 70T2953CZ3-CE6 

Handle 0x1300, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0000009FFFF
	Range Size: 640 kB
	Physical Array Handle: 0x1000
	Partition Width: 0

Handle 0x1301, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000100000
	Ending Address: 0x0007FFFFFFF
	Range Size: 2047 MB
	Physical Array Handle: 0x1000
	Partition Width: 0

Handle 0x1400, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0000009FFFF
	Range Size: 640 kB
	Physical Device Handle: 0x1100
	Memory Array Mapped Address Handle: 0x1300
	Partition Row Position: 1

Handle 0x1401, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000100000
	Ending Address: 0x0003FFFFFFF
	Range Size: 1023 MB
	Physical Device Handle: 0x1100
	Memory Array Mapped Address Handle: 0x1301
	Partition Row Position: 1

Handle 0x1402, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00040000000
	Ending Address: 0x0007FFFFFFF
	Range Size: 1 GB
	Physical Device Handle: 0x1101
	Memory Array Mapped Address Handle: 0x1301
	Partition Row Position: 1

Handle 0x1500, DMI type 21, 7 bytes
Built-in Pointing Device
	Type: Touch Pad
	Interface: Bus Mouse
	Buttons: 2

Handle 0x1600, DMI type 22, 26 bytes
Portable Battery
	Location: Sys. Battery Bay
	Manufacturer: SMP             
	Name: DELL F51356A    
	Design Capacity: 48000 mWh
	Design Voltage: 11100 mV
	SBDS Version: 1.0
	Maximum Error: 100%
	SBDS Serial Number: 0743
	SBDS Manufacture Date: 2006-10-18
	SBDS Chemistry: LION            
	OEM-specific Information: 0x00000001

Handle 0x1B00, DMI type 27, 12 bytes
Cooling Device
	Type: Fan
	Status: OK
	OEM-specific Information: 0x0000DD00

Handle 0x1C00, DMI type 28, 20 bytes
Temperature Probe
	Description: CPU Internal Temperature
	Location: Processor
	Status: OK
	Maximum Value: 127.0 deg C
	Minimum Value 0.0 deg C
	Resolution: 1.000 deg C
	Tolerance: 0.5 deg C
	Accuracy: Unknown
	OEM-specific Information: 0x0000DC00

Handle 0x2000, DMI type 32, 11 bytes
System Boot Information
	Status: No errors detected

Handle 0xB000, DMI type 176, 5 bytes
OEM-specific Type
	Header and Data:
		B0 05 00 B0 42

Handle 0xB100, DMI type 177, 12 bytes
OEM-specific Type
	Header and Data:
		B1 0C 00 B1 02 00 00 00 00 00 00 00

Handle 0xB200, DMI type 178, 6 bytes
OEM-specific Type
	Header and Data:
		B2 06 00 B2 E7 0C

Handle 0xD000, DMI type 208, 10 bytes
OEM-specific Type
	Header and Data:
		D0 0A 00 D0 01 04 FE 00 CD 01

Handle 0xD800, DMI type 216, 9 bytes
OEM-specific Type
	Header and Data:
		D8 09 00 D8 01 03 01 F0 03
	Strings:
		ATI Technologies Inc.
		 
		009.012.001.009.193.050  

Handle 0xD900, DMI type 217, 8 bytes
OEM-specific Type
	Header and Data:
		D9 08 00 D9 01 02 01 03
	Strings:
		US-101
		Proprietary

Handle 0xDB00, DMI type 219, 9 bytes
OEM-specific Type
	Header and Data:
		DB 09 00 DB 03 01 02 03 FF
	Strings:
		System Device Bay
		Floppy, Battery, CD-ROM, CD-RW, DVD, DVD+RW, DVD+/-RW, Hard Disk
		DVD+/-RW  

Handle 0xDC00, DMI type 220, 22 bytes
OEM-specific Type
	Header and Data:
		DC 16 00 DC 01 F0 00 00 02 F0 00 00 00 00 03 F0
		04 F0 00 00 00 00

Handle 0xDD00, DMI type 221, 19 bytes
OEM-specific Type
	Header and Data:
		DD 13 00 DD 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00

Handle 0xD400, DMI type 212, 37 bytes
OEM-specific Type
	Header and Data:
		D4 25 00 D4 74 00 75 00 00 10 2D 2E 5C 00 78 BF
		40 5D 00 78 BF 00 08 00 1D DF 00 03 00 1D DF 00
		FF FF 00 00 00

Handle 0xDE00, DMI type 222, 13 bytes
OEM-specific Type
	Header and Data:
		DE 0D 00 DE 01 02 FF FF 00 00 00 00 00

Handle 0x7F00, DMI type 127, 4 bytes
End Of Table


--------------080007000409090407010609--
