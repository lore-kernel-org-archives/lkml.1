Return-Path: <linux-kernel-owner+w=401wt.eu-S1754953AbYIHTs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953AbYIHTs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 15:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbYIHTss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 15:48:48 -0400
Received: from smtp-01.mandic.com.br ([200.225.81.132]:39387 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbYIHTsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 15:48:47 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Sep 2008 15:48:45 EDT
Message-ID: <48C57FDE.2010306@diamondcut.com.br>
Date: Mon, 08 Sep 2008 16:41:18 -0300
From: "Renato S. Yamane" <yamane@diamondcut.com.br>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
       Daniel Barkalow <barkalow@iabervon.org>, linux-kernel@vger.kernel.org,
       Christopher Desjardins <cddesjardins@gmail.com>
Subject: Re: Lenovo 3000 N100 i8042 problems
References: <alpine.LNX.1.00.0808240148580.19665@iabervon.org> <Pine.LNX.4.64.0809020120130.29111@twin.jikos.cz> <alpine.LNX.1.00.0809012014280.19665@iabervon.org> <alpine.LNX.1.10.0809021121410.23448@jikos.suse.cz> <20080902083940.ZZRA012@mailhub.coreip.homeip.net> <alpine.LNX.1.10.0809031349081.23448@jikos.suse.cz> <20080903101947.ZZRA012@mailhub.coreip.homeip.net> <20080903213258.GC14620@khazad-dum.debian.net>
In-Reply-To: <20080903213258.GC14620@khazad-dum.debian.net>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------000902020800030709020505"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000902020800030709020505
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Henrique de Moraes Holschuh wrote:
> I fell I need to warn you guys that you are likely breaking machines that
> match that DMI info but have a newer BIOS, unless they use different BIOSes
> (not enough data without a full dmidecode output from the other machine).

dmidecode just from 3000-N100?
Attached a dmidecode from a Lenovo Thinkpad T61.
I have a Lenovo 3000-V200 too. You want a dmidecode from it?

Regards,
Renato

--------------000902020800030709020505
Content-Type: text/plain;
 name="dmidecode.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmidecode.txt"

# dmidecode 2.9
SMBIOS 2.4 present.
73 structures occupying 2436 bytes.
Table at 0x000E0010.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: LENOVO
	Version: 7LETC1WW (2.21 )
	Release Date: 07/01/2008
	Address: 0xE0000
	Runtime Size: 128 kB
	ROM Size: 4096 kB
	Characteristics:
		PCI is supported
		PC Card (PCMCIA) is supported
		PNP is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		ESCD support is available
		Boot from CD is supported
		Selectable boot is supported
		BIOS ROM is socketed
		EDD is supported
		ACPI is supported
		USB legacy is supported
		BIOS boot specification is supported
		Targeted content distribution is supported
	BIOS Revision: 2.33
	Firmware Revision: 1.8

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: LENOVO
	Product Name: 6457BB5
	Version: ThinkPad T61
	Serial Number: L3R2406
	UUID: E01A1C81-4975-11CB-8382-B82531DB6AF1
	Wake-up Type: Power Switch
	SKU Number: Not Specified
	Family: ThinkPad T61

Handle 0x0002, DMI type 2, 8 bytes
Base Board Information
	Manufacturer: LENOVO
	Product Name: 6457BB5
	Version: Not Available
	Serial Number: VF1A981M2DE

Handle 0x0003, DMI type 3, 13 bytes
Chassis Information
	Manufacturer: LENOVO
	Type: Notebook
	Lock: Not Present
	Version: Not Available
	Serial Number: Not Available
	Asset Tag: No Asset Information
	Boot-up State: Unknown
	Power Supply State: Unknown
	Thermal State: Unknown
	Security Status: Unknown

Handle 0x0004, DMI type 126, 13 bytes
Inactive

Handle 0x0005, DMI type 126, 13 bytes
Inactive

Handle 0x0006, DMI type 4, 35 bytes
Processor Information
	Socket Designation: None
	Type: Central Processor
	Family: Other
	Manufacturer: GenuineIntel
	ID: FB 06 00 00 FF FB EB BF
	Version: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz
	Voltage: 1.4 V
	External Clock: 200 MHz
	Max Speed: 2200 MHz
	Current Speed: 2200 MHz
	Status: Populated, Enabled
	Upgrade: None
	L1 Cache Handle: 0x000A
	L2 Cache Handle: 0x000C
	L3 Cache Handle: Not Provided
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified

Handle 0x0007, DMI type 5, 20 bytes
Memory Controller Information
	Error Detecting Method: None
	Error Correcting Capabilities:
		None
	Supported Interleave: One-way Interleave
	Current Interleave: One-way Interleave
	Maximum Memory Module Size: 4096 MB
	Maximum Total Memory Size: 8192 MB
	Supported Speeds:
		Other
	Supported Memory Types:
		DIMM
		SDRAM
	Memory Module Voltage: 2.9 V
	Associated Memory Slots: 2
		0x0008
		0x0009
	Enabled Error Correcting Capabilities:
		Unknown

Handle 0x0008, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: DIMM Slot 1
	Bank Connections: 0 1
	Current Speed: 155 ns
	Type: DIMM SDRAM
	Installed Size: 1024 MB (Double-bank Connection)
	Enabled Size: 1024 MB (Double-bank Connection)
	Error Status: OK

Handle 0x0009, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: DIMM Slot 2
	Bank Connections: 2 3
	Current Speed: 155 ns
	Type: DIMM SDRAM
	Installed Size: 1024 MB (Double-bank Connection)
	Enabled Size: 1024 MB (Double-bank Connection)
	Error Status: OK

Handle 0x000A, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Internal L1 Cache
	Configuration: Enabled, Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 64 KB
	Maximum Size: 64 KB
	Supported SRAM Types:
		Synchronous
	Installed SRAM Type: Synchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Instruction
	Associativity: 8-way Set-associative

Handle 0x000B, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Internal L1 Cache
	Configuration: Enabled, Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 64 KB
	Maximum Size: 64 KB
	Supported SRAM Types:
		Synchronous
	Installed SRAM Type: Synchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Data
	Associativity: 8-way Set-associative

Handle 0x000C, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Internal L2 Cache
	Configuration: Enabled, Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 4096 KB
	Maximum Size: 4096 KB
	Supported SRAM Types:
		Burst
	Installed SRAM Type: Burst
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unified
	Associativity: 8-way Set-associative

Handle 0x000D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: External Monitor
	External Connector Type: DB-15 female
	Port Type: Video Port

Handle 0x000E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: Microphone Jack
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x000F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: Headphone Jack
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0010, DMI type 126, 9 bytes
Inactive

Handle 0x0011, DMI type 126, 9 bytes
Inactive

Handle 0x0012, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: Modem
	External Connector Type: RJ-11
	Port Type: Modem Port

Handle 0x0013, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: Ethernet
	External Connector Type: RJ-45
	Port Type: Network Port

Handle 0x0014, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: USB 1
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0015, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: USB 2
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0016, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: USB 3
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0017, DMI type 126, 9 bytes
Inactive

Handle 0x0018, DMI type 126, 9 bytes
Inactive

Handle 0x0019, DMI type 126, 9 bytes
Inactive

Handle 0x001A, DMI type 126, 9 bytes
Inactive

Handle 0x001B, DMI type 126, 9 bytes
Inactive

Handle 0x001C, DMI type 126, 9 bytes
Inactive

Handle 0x001D, DMI type 126, 9 bytes
Inactive

Handle 0x001E, DMI type 126, 9 bytes
Inactive

Handle 0x001F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: IEEE1394
	External Connector Type: IEEE 1394
	Port Type: Firewire (IEEE P1394)

Handle 0x0020, DMI type 9, 13 bytes
System Slot Information
	Designation: ExpressCard Slot 1
	Type: x1 PCI Express
	Current Usage: Available
	Length: Other
	ID: 0
	Characteristics:
		Hot-plug devices are supported

Handle 0x0021, DMI type 9, 13 bytes
System Slot Information
	Designation: CardBus Slot 1
	Type: 32-bit PC Card (PCMCIA)
	Current Usage: Available
	Length: Other
	ID: Adapter 1, Socket 0
	Characteristics:
		5.0 V is provided
		3.3 V is provided
		PC Card-16 is supported
		Cardbus is supported
		Zoom Video is supported
		Modem ring resume is supported
		PME signal is supported
		Hot-plug devices are supported

Handle 0x0022, DMI type 126, 13 bytes
Inactive

Handle 0x0023, DMI type 126, 13 bytes
Inactive

Handle 0x0024, DMI type 9, 13 bytes
System Slot Information
	Designation: Media Card Slot 1
	Type: Other
	Current Usage: Available
	Length: Other
	Characteristics:
		Hot-plug devices are supported

Handle 0x0025, DMI type 126, 13 bytes
Inactive

Handle 0x0026, DMI type 126, 13 bytes
Inactive

Handle 0x0027, DMI type 10, 6 bytes
On Board Device Information
	Type: Other
	Status: Enabled
	Description: IBM Embedded Security hardware

Handle 0x0028, DMI type 11, 5 bytes
OEM Strings
	String 1: IBM ThinkPad Embedded Controller -[7KHT24WW-1.08    ]-

Handle 0x0029, DMI type 13, 22 bytes
BIOS Language Information
	Installable Languages: 1
		enUS
	Currently Installed Language: enUS

Handle 0x002A, DMI type 15, 25 bytes
System Event Log
	Area Length: 0 bytes
	Header Start Offset: 0x0000
	Header Length: 16 bytes
	Data Start Offset: 0x0010
	Access Method: General-purpose non-volatile data functions
	Access Address: 0x0000
	Status: Valid, Not Full
	Change Token: 0x00000080
	Header Format: Type 1
	Supported Log Type Descriptors: 1
	Descriptor 1: POST error
	Data Format 1: POST results bitmap

Handle 0x002B, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 4 GB
	Error Information Handle: Not Provided
	Number Of Devices: 2

Handle 0x002C, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x002B
	Error Information Handle: 0xFF01
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 1024 MB
	Form Factor: SODIMM
	Set: None
	Locator: DIMM 1
	Bank Locator: Bank 0/1
	Type: DDR2
	Type Detail: Synchronous
	Speed: 667 MHz (1.5 ns)
	Manufacturer: Not Specified
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified

Handle 0x002D, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x002B
	Error Information Handle: 0xFF01
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 1024 MB
	Form Factor: SODIMM
	Set: None
	Locator: DIMM 2
	Bank Locator: Bank 2/3
	Type: DDR2
	Type Detail: Synchronous
	Speed: 667 MHz (1.5 ns)
	Manufacturer: Not Specified
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified

Handle 0x002E, DMI type 18, 23 bytes
32-bit Memory Error Information
	Type: OK
	Granularity: Unknown
	Operation: Unknown
	Vendor Syndrome: Unknown
	Memory Array Address: Unknown
	Device Address: Unknown
	Resolution: Unknown

Handle 0x002F, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0007FFFFFFF
	Range Size: 2 GB
	Physical Array Handle: 0x002B
	Partition Width: 0

Handle 0x0030, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0003FFFFFFF
	Range Size: 1 GB
	Physical Device Handle: 0x002C
	Memory Array Mapped Address Handle: 0x002F
	Partition Row Position: 1

Handle 0x0031, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00040000000
	Ending Address: 0x0007FFFFFFF
	Range Size: 1 GB
	Physical Device Handle: 0x002D
	Memory Array Mapped Address Handle: 0x002F
	Partition Row Position: 1

Handle 0x0032, DMI type 21, 7 bytes
Built-in Pointing Device
	Type: Track Point
	Interface: PS/2
	Buttons: 3

Handle 0x0033, DMI type 21, 7 bytes
Built-in Pointing Device
	Type: Touch Pad
	Interface: PS/2
	Buttons: 0

Handle 0x0034, DMI type 22, 26 bytes
Portable Battery
	Location: Rear
	Manufacturer: Panasonic
	Name: 92P1133
	Design Capacity: 84240 mWh
	Design Voltage: 10800 mV
	SBDS Version: 03.01
	Maximum Error: Unknown
	SBDS Serial Number: 0072
	SBDS Manufacture Date: 2008-02-29
	SBDS Chemistry: LION
	OEM-specific Information: 0x00000000

Handle 0x0035, DMI type 126, 26 bytes
Inactive

Handle 0x0036, DMI type 24, 5 bytes
Hardware Security
	Power-On Password Status: Disabled
	Keyboard Password Status: Disabled
	Administrator Password Status: Disabled
	Front Panel Reset Status: Unknown

Handle 0x0037, DMI type 32, 11 bytes
System Boot Information
	Status: No errors detected

Handle 0x0038, DMI type 131, 17 bytes
OEM-specific Type
	Header and Data:
		83 11 38 00 01 02 03 FF FF 1F 00 00 00 00 00 02
		00
	Strings:
		BOOTINF 20h
		BOOTDEV 21h
		KEYPTRS 23h

Handle 0x0039, DMI type 131, 22 bytes
OEM-specific Type
	Header and Data:
		83 16 39 00 01 02 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 01
	Strings:
		TVT-Enablement

Handle 0x003A, DMI type 132, 7 bytes
OEM-specific Type
	Header and Data:
		84 07 3A 00 02 D8 36

Handle 0x003B, DMI type 133, 5 bytes
OEM-specific Type
	Header and Data:
		85 05 3B 00 01
	Strings:
		KHOIHGIUCCHHII

Handle 0x003C, DMI type 134, 13 bytes
OEM-specific Type
	Header and Data:
		86 0D 3C 00 11 03 08 20 00 00 00 00 00

Handle 0x003D, DMI type 134, 16 bytes
OEM-specific Type
	Header and Data:
		86 10 3D 00 00 41 54 4D 4C 01 01 00 00 03 01 02
	Strings:
		TPM INFO
		System Reserved

Handle 0x003E, DMI type 135, 13 bytes
OEM-specific Type
	Header and Data:
		87 0D 3E 00 54 50 07 00 01 00 00 00 00

Handle 0x003F, DMI type 135, 18 bytes
OEM-specific Type
	Header and Data:
		87 12 3F 00 54 50 07 01 01 AE 0F 00 00 00 00 00
		00 00

Handle 0x0040, DMI type 135, 35 bytes
OEM-specific Type
	Header and Data:
		87 23 40 00 54 50 07 02 42 41 59 20 49 2F 4F 20
		01 00 02 00 00 0A 00 48 1C 1E 1C 02 00 0E 00 F0
		01 F6 03

Handle 0x0041, DMI type 135, 26 bytes
OEM-specific Type
	Header and Data:
		87 1A 41 00 54 50 07 04 01 04 01 01 02 00 02 01
		02 00 03 01 02 00 04 01 02 00

Handle 0x0042, DMI type 136, 6 bytes
OEM-specific Type
	Header and Data:
		88 06 42 00 5A 5A

Handle 0x0043, DMI type 137, 28 bytes
OEM-specific Type
	Header and Data:
		89 1C 43 00 0C 02 00 01 01 00 00 01 50 57 4D 53
		20 49 6E 66 6F 72 6D 61 74 69 6F 6E

Handle 0x0044, DMI type 138, 40 bytes
OEM-specific Type
	Header and Data:
		8A 28 44 00 14 01 02 01 40 02 01 40 02 01 40 02
		01 40 01 40 42 49 4F 53 20 50 61 73 73 77 6F 72
		64 20 46 6F 72 6D 61 74

Handle 0x0045, DMI type 139, 37 bytes
OEM-specific Type
	Header and Data:
		8B 25 45 00 11 01 0A 00 00 00 00 00 00 00 00 00
		00 50 57 4D 53 20 4B 65 79 20 49 6E 66 6F 72 6D
		61 74 69 6F 6E

Handle 0x0046, DMI type 129, 8 bytes
OEM-specific Type
	Header and Data:
		81 08 46 00 01 01 02 00
	Strings:
		Intel_ASF
		Intel_ASF_001

Handle 0x0047, DMI type 130, 20 bytes
OEM-specific Type
	Header and Data:
		82 14 47 00 24 41 4D 54 01 00 00 00 00 A5 00 00
		00 00 00 00

Handle 0x0048, DMI type 127, 4 bytes
End Of Table


--------------000902020800030709020505--
