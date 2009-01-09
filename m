Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbZAIT5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbZAIT5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 14:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbZAIT5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 14:57:11 -0500
Received: from smtp02.lnh.mail.rcn.net ([207.172.157.102]:13195 "EHLO
	smtp02.lnh.mail.rcn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbZAIT5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 14:57:08 -0500
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Jan 2009 14:57:07 EST
From: "Jesse F. Hughes" <jesse@phiwumbda.org>
To: linux-kernel@vger.kernel.org
Organization: The Eternal (and Int'l) Order of Palsy-Walsies -- President
Subject: Various problems with new AMD 64 HP Pavilion Desktop machine. (2/2)
Content-Type: message/partial; id="Fri_Jan__9_14:47:20_2009@hume.phiwumbda.org"; number=2; total=2
Date: Fri, 09 Jan 2009 14:47:28 -0500
Message-ID: <87priwi7n3.fsf@phiwumbda.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[    2.001992] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 3
[    2.005910] ehci_hcd 0000:00:1a.7: debug port 1
[    2.005916] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    2.005931] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf9cfec00
[    2.021618] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    2.021720] usb usb3: configuration #1 chosen from 1 choice
[    2.021743] hub 3-0:1.0: USB hub found
[    2.021750] hub 3-0:1.0: 4 ports detected
[    2.125931] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.125940] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.125945] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.125972] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    2.126023] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000b800
[    2.126112] usb usb4: configuration #1 chosen from 1 choice
[    2.126139] hub 4-0:1.0: USB hub found
[    2.126147] hub 4-0:1.0: 2 ports detected
[    2.228298] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.228311] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.228314] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.228334] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
[    2.228365] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000b880
[    2.228441] usb usb5: configuration #1 chosen from 1 choice
[    2.228462] hub 5-0:1.0: USB hub found
[    2.228467] hub 5-0:1.0: 2 ports detected
[    2.334417] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.334423] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.334426] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.334448] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
[    2.334470] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000bc00
[    2.334537] usb usb6: configuration #1 chosen from 1 choice
[    2.334557] hub 6-0:1.0: USB hub found
[    2.334562] hub 6-0:1.0: 2 ports detected
[    2.542402] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    2.542412] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    2.542416] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    2.542437] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 7
[    2.542472] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000c000
[    2.542547] usb usb7: configuration #1 chosen from 1 choice
[    2.542567] hub 7-0:1.0: USB hub found
[    2.542573] hub 7-0:1.0: 2 ports detected
[    2.652015] usb 6-2: new full speed USB device using uhci_hcd and address 2
[    2.749085] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.749097] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.749100] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.749121] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 8
[    2.753008] ehci_hcd 0000:00:1d.7: debug port 1
[    2.753013] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    2.753018] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf9cff800
[    2.776032] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    2.776119] usb usb8: configuration #1 chosen from 1 choice
[    2.776150] hub 8-0:1.0: USB hub found
[    2.776161] hub 8-0:1.0: 8 ports detected
[    2.986140] ahci 0000:00:1f.2: version 3.0
[    2.986155] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.986275] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl RAID mode
[    2.986278] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ems 
[    2.986283] ahci 0000:00:1f.2: setting latency timer to 64
[    2.986820] scsi0 : ahci
[    2.986947] scsi1 : ahci
[    2.987025] scsi2 : ahci
[    2.987104] scsi3 : ahci
[    2.987181] scsi4 : ahci
[    2.987257] scsi5 : ahci
[    2.987368] ata1: SATA max UDMA/133 abar m2048@0xf9cff000 port 0xf9cff100 irq 2299
[    2.987371] ata2: SATA max UDMA/133 abar m2048@0xf9cff000 port 0xf9cff180 irq 2299
[    2.987374] ata3: SATA max UDMA/133 abar m2048@0xf9cff000 port 0xf9cff200 irq 2299
[    2.987377] ata4: SATA max UDMA/133 abar m2048@0xf9cff000 port 0xf9cff280 irq 2299
[    2.987379] ata5: SATA max UDMA/133 abar m2048@0xf9cff000 port 0xf9cff300 irq 2299
[    2.987382] ata6: SATA max UDMA/133 abar m2048@0xf9cff000 port 0xf9cff380 irq 2299
[    3.172054] usb 6-2: device not accepting address 2, error -71
[    3.228571] hub 6-0:1.0: unable to enumerate USB device on port 2
[    3.304033] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.304727] ata1.00: ATA-8: WDC WD5000AAKS-65A7B0, 01.03B01, max UDMA/133
[    3.304732] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    3.305516] ata1.00: configured for UDMA/133
[    3.468045] usb 8-6: new high speed USB device using ehci_hcd and address 2
[    3.602500] usb 8-6: configuration #1 chosen from 1 choice
[    3.716023] usb 8-8: new high speed USB device using ehci_hcd and address 3
[    3.856073] usb 8-8: configuration #1 chosen from 1 choice
[    4.044044] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.047495] ata2.00: ATAPI: HL-DT-ST DVD-RW GSA-H60L, DC08, max UDMA/100
[    4.052091] ata2.00: configured for UDMA/100
[    4.792053] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.820615] ata3.00: ATA-8: ST31000333AS, SD35, max UDMA/133
[    4.820618] ata3.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    4.862390] ata3.00: configured for UDMA/133
[    5.196029] ata4: SATA link down (SStatus 0 SControl 300)
[    5.532043] ata5: SATA link down (SStatus 0 SControl 300)
[    5.872030] ata6: SATA link down (SStatus 0 SControl 300)
[    5.884132] scsi 0:0:0:0: Direct-Access     ATA      WDC WD5000AAKS-6 01.0 PQ: 0 ANSI: 5
[    5.888197] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD-RW GSA-H60L  DC08 PQ: 0 ANSI: 5
[    5.888379] scsi 2:0:0:0: Direct-Access     ATA      ST31000333AS     SD35 PQ: 0 ANSI: 5
[    5.888480] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    5.888516] r8169 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    5.888556] r8169 0000:02:00.0: setting latency timer to 64
[    5.888981] eth0: RTL8168c/8111c at 0xffffc20000642000, 00:1e:8c:4d:00:a8, XID 3c2000c0 IRQ 2298
[    5.890636] ohci1394 0000:01:05.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    5.942354] ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[20]  MMIO=[f9dff000-f9dff7ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
[    5.950856] scsi 0:0:0:0: Attached scsi generic sg0 type 0
[    5.950890] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[    5.950919] scsi 2:0:0:0: Attached scsi generic sg2 type 0
[    5.953374] usbcore: registered new interface driver libusual
[    5.958266] Initializing USB Mass Storage driver...
[    5.958378] scsi6 : SCSI emulation for USB Mass Storage devices
[    5.958459] usb-storage: device found at 2
[    5.958461] usb-storage: waiting for device to settle before scanning
[    5.958471] usbcore: registered new interface driver usb-storage
[    5.958474] USB Mass Storage support registered.
[    5.970823] Driver 'sd' needs updating - please use bus_type methods
[    5.970914] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[    5.970929] sd 0:0:0:0: [sda] Write Protect is off
[    5.970931] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.970953] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.971023] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[    5.971036] sd 0:0:0:0: [sda] Write Protect is off
[    5.971037] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.971059] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.971062]  sda:<4>Driver 'sr' needs updating - please use bus_type methods
[    5.977073]  sda1 sda2 < sda5 >
[    6.004317] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.004477] sd 2:0:0:0: [sdb] 1953525168 512-byte hardware sectors (1000205 MB)
[    6.004493] sd 2:0:0:0: [sdb] Write Protect is off
[    6.004495] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    6.004527] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.004585] sd 2:0:0:0: [sdb] 1953525168 512-byte hardware sectors (1000205 MB)
[    6.004598] sd 2:0:0:0: [sdb] Write Protect is off
[    6.004600] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    6.004624] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.004627]  sdb: unknown partition table
[    6.014875] sd 2:0:0:0: [sdb] Attached SCSI disk
[    6.230779] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
[    6.230785] Uniform CD-ROM driver Revision: 3.20
[    6.230893] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    6.922012] PM: Starting manual resume from disk
[    6.922015] PM: Resume from partition 8:5
[    6.922016] PM: Checking hibernation image.
[    6.922143] PM: Resume from disk failed.
[    6.939402] EXT3-fs: INFO: recovery required on readonly filesystem.
[    6.939405] EXT3-fs: write access will be enabled during recovery.
[    7.229160] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[001e8c00000d4497]
[    7.243639] kjournald starting.  Commit interval 5 seconds
[    7.243658] EXT3-fs: recovery complete.
[    7.244165] EXT3-fs: mounted filesystem with ordered data mode.
[   10.956185] usb-storage: device scan complete
[   10.956223] isa bounce pool size: 16 pages
[   10.956758] scsi 6:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
[   10.957388] scsi 6:0:0:1: Direct-Access     Generic  USB CF Reader    1.01 PQ: 0 ANSI: 0
[   10.957890] scsi 6:0:0:2: Direct-Access     Generic  USB SM Reader    1.02 PQ: 0 ANSI: 0
[   10.958528] scsi 6:0:0:3: Direct-Access     Generic  USB MS Reader    1.03 PQ: 0 ANSI: 0
[   10.959698] sd 6:0:0:0: [sdc] Attached SCSI removable disk
[   10.959785] sd 6:0:0:0: Attached scsi generic sg3 type 0
[   10.960552] sd 6:0:0:1: [sdd] Attached SCSI removable disk
[   10.960594] sd 6:0:0:1: Attached scsi generic sg4 type 0
[   10.961300] sd 6:0:0:2: [sde] Attached SCSI removable disk
[   10.961345] sd 6:0:0:2: Attached scsi generic sg5 type 0
[   10.962075] sd 6:0:0:3: [sdf] Attached SCSI removable disk
[   10.962111] sd 6:0:0:3: Attached scsi generic sg6 type 0
[   13.937433] udevd version 124 started
[   14.291502] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[   14.313033] ACPI: Power Button (FF) [PWRF]
[   14.313136] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input3
[   14.321344] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   14.325068] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   14.345060] ACPI: Power Button (CM) [PWRB]
[   14.534852] iTCO_vendor_support: vendor-support=0
[   14.554105] input: PC Speaker as /devices/platform/pcspkr/input/input4
[   14.570873] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
[   14.580177] iTCO_wdt: Found a ICH9R TCO device (Version=2, TCOBASE=0x0860)
[   14.580281] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   14.690359] Linux video capture interface: v2.00
[   14.747472] logips2pp: Detected unknown logitech mouse model 127
[   14.841548] cx23885 driver version 0.0.1 loaded
[   14.841599] cx23885 0000:03:00.0: enabling device (0000 -> 0002)
[   14.841607] cx23885 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   14.841673] CORE cx23885[0]: subsystem: 0070:7801, board: Hauppauge WinTV-HVR1800 [card=2,autodetected]
[   15.036879] cx23885[0]: i2c bus 0 registered
[   15.036900] cx23885[0]: i2c bus 1 registered
[   15.036913] cx23885[0]: i2c bus 2 registered
[   15.037018] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   15.037047] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   15.039084] tveeprom 0-0050: Huh, no eeprom present (err=-5)?
[   15.039086] tveeprom 0-0050: Encountered bad packet header [00]. Corrupt or not a Hauppauge eeprom.
[   15.039088] cx23885[0]: warning: unknown hauppauge model #0
[   15.039089] cx23885[0]: hauppauge eeprom: model=0
[   15.050932] cx23885[0]/0: registered device video0 [v4l2]
[   15.050962] cx23885[0]: registered device video1 [mpeg]
[   15.050964] cx23885[0]: cx23885 based dvb card
[   15.074276] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
[   15.116142] s5h1409_readreg: readreg error (ret == -5)
[   15.116197] cx23885[0]: frontend initialization failed
[   15.116199] cx23885_dvb_register() dvb_register failed err = -1
[   15.116201] cx23885_dev_setup() Failed to register dvb on VID_C
[   15.116205] cx23885_dev_checkrevision() New hardware revision found 0x0
[   15.116207] cx23885_dev_checkrevision() Hardware revision unknown 0x0
[   15.116214] cx23885[0]/0: found at 0000:03:00.0, rev: 15, irq: 17, latency: 0, mmio: 0xf9e00000
[   15.116224] cx23885 0000:03:00.0: setting latency timer to 64
[   15.204611] input: ImExPS/2 Logitech Explorer Mouse as /devices/platform/i8042/serio1/input/input5
[   15.252323] rtl8187: 8187B chip detected. Support is EXPERIMENTAL, and could damage your
[   15.252325]          hardware, use at your own risk
[   15.252675] phy0: Selected rate control algorithm 'pid'
[   15.424428] phy0: hwaddr 00:14:d1:54:15:4e, RTL8187BvE V0 + rtl8225z2
[   15.424450] usbcore: registered new interface driver rtl8187
[   15.432099] udev: renamed network interface wlan0 to wlan1
[   15.713682] lp: driver loaded but no devices found
[   15.990581] Adding 9044552k swap on /dev/sda5.  Priority:-1 extents:1 across:9044552k
[   16.539767] EXT3 FS on sda1, internal journal
[   16.730958] device-mapper: uevent: version 1.0.3
[   16.733075] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[   17.644717] type=1505 audit(1231527959.087:2): operation="profile_load" name="/usr/share/gdm/guest-session/Xsession" name2="default" pid=4808
[   17.756225] type=1505 audit(1231527959.195:3): operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" name2="default" pid=4813
[   17.756392] type=1505 audit(1231527959.199:4): operation="profile_load" name="/usr/sbin/cupsd" name2="default" pid=4813
[   17.794484] type=1505 audit(1231527959.235:5): operation="profile_load" name="/usr/sbin/mysqld" name2="default" pid=4817
[   17.904339] ip_tables: (C) 2000-2006 Netfilter Core Team
[   18.903118] ACPI: WMI: Mapper loaded
[   19.675170] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
[   20.020689] NET: Registered protocol family 10
[   20.021137] lo: Disabled Privacy Extensions
[   23.212176] ppdev: user-space parallel port driver
[   53.057317] nvidia: module license 'NVIDIA' taints kernel.
[   53.310120] nvidia 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   53.310131] nvidia 0000:05:00.0: setting latency timer to 64
[   53.310221] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  177.82  Tue Nov  4 16:50:05 PST 2008
[  122.724734] Bluetooth: Core ver 2.13
[  122.725270] NET: Registered protocol family 31
[  122.725276] Bluetooth: HCI device and connection manager initialized
[  122.725279] Bluetooth: HCI socket layer initialized
[  122.734516] Bluetooth: L2CAP ver 2.11
[  122.734523] Bluetooth: L2CAP socket layer initialized
[  122.769182] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[  122.769189] Bluetooth: BNEP filters: protocol multicast
[  122.777808] Bridge firewalling registered
[  122.777972] pan0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
[  122.787061] Bluetooth: SCO (Voice Link) ver 0.6
[  122.787068] Bluetooth: SCO socket layer initialized
[  123.027199] Bluetooth: RFCOMM socket layer initialized
[  123.027761] Bluetooth: RFCOMM TTY layer initialized
[  123.027766] Bluetooth: RFCOMM ver 1.10
[  127.188535] r8169: eth0: link down
[  127.189440] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  143.571131] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  143.707142] NET: Registered protocol family 17
[  146.460824] wlan1: authenticate with AP 00:18:39:02:f0:ff
[  146.465455] wlan1: authenticated
[  146.465463] wlan1: associate with AP 00:18:39:02:f0:ff
[  146.467461] wlan1: RX AssocResp from 00:18:39:02:f0:ff (capab=0x401 status=0 aid=3)
[  146.467467] wlan1: associated
[  146.468403] ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
[  146.468520] wlan1: disassociating by local choice (reason=3)
[  156.868009] wlan1: no IPv6 routers present
[  219.150186] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  219.319068] wlan1: authenticate with AP 00:0c:41:cc:53:2d
[  219.320696] wlan1: authenticated
[  219.320703] wlan1: associate with AP 00:0c:41:cc:53:2d
[  219.322699] wlan1: RX AssocResp from 00:0c:41:cc:53:2d (capab=0x401 status=12 aid=0)
[  219.322704] wlan1: AP denied association (code=12)
[  219.520023] wlan1: associate with AP 00:0c:41:cc:53:2d
[  219.526085] wlan1: RX AssocResp from 00:0c:41:cc:53:2d (capab=0x401 status=12 aid=0)
[  219.526090] wlan1: AP denied association (code=12)
[  219.721008] wlan1: associate with AP 00:0c:41:cc:53:2d
[  219.722970] wlan1: RX AssocResp from 00:0c:41:cc:53:2d (capab=0x401 status=12 aid=0)
[  219.722974] wlan1: AP denied association (code=12)
[  219.921010] wlan1: association with AP 00:0c:41:cc:53:2d timed out
[  223.331057] wlan1: authenticate with AP 00:0c:41:cc:53:2d
[  238.977242] wlan1: authenticate with AP 00:18:39:02:f0:ff
[  239.025371] wlan1: authenticated
[  239.025378] wlan1: associate with AP 00:18:39:02:f0:ff
[  239.027502] wlan1: RX AssocResp from 00:18:39:02:f0:ff (capab=0x401 status=0 aid=3)
[  239.027509] wlan1: associated
[  239.028428] ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
[  249.860010] wlan1: no IPv6 routers present
[  287.175053] wlan1: deauthenticating by local choice (reason=3)
[  287.361272] wlan1: authenticate with AP 00:18:39:02:f0:ff

-- 
"So why talk [about my factoring method] out on Usenet?  Because it's a
highly public place so I'm unlikely to disappear[...]  You people are
my protection. [...]  You may be what's keeping me free and walking out
in the open air." -- James S. Harris, theory guy on the edge.
