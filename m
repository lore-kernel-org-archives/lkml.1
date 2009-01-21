Return-Path: <linux-kernel-owner+w=401wt.eu-S1758596AbZAUOod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596AbZAUOod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 09:44:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754490AbZAUOoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 09:44:23 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:57790 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301AbZAUOoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 09:44:22 -0500
Date: Wed, 21 Jan 2009 15:44:20 +0100
From: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: X200 suspend issue / linux-next: Tree for January 21
Message-ID: <20090121144420.GA20617@denkbrett.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20090121150249.a87aca09.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gj572EiMnwbLXET9"
Content-Disposition: inline
In-Reply-To: <20090121150249.a87aca09.sfr@canb.auug.org.au>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.29-rc2-next-20090121-ikn x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gj572EiMnwbLXET9
Content-Type: multipart/mixed; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello!

News: The system freezes for almost a second and wakes up again!

At least no crash this time!

dmesg attached after one suspend failure.

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="suspend-2.6.29-rc2-next-20090121-ikn"
Content-Transfer-Encoding: quoted-printable

Autowakeup!


[15:38] ikn:~# dmesg -c
[ 7411.999645] PM: Syncing filesystems ... done.
[ 7412.658583] Freezing user space processes ... (elapsed 0.01 seconds) don=
e.
[ 7412.677241] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[ 7412.677666] Suspending console(s) (use no_console_suspend to debug)
[ 7412.692209] pci 0000:00:02.0: power state changed by ACPI to D3
[ 7413.368500] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 7413.368738] sd 0:0:0:0: [sda] Stopping disk
[ 7413.739464] iwlagn 0000:03:00.0: PCI INT A disabled
[ 7413.800393] ehci_hcd 0000:00:1d.7: PME# enabled
[ 7413.802570] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[ 7413.802586] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[ 7413.802828] uhci_hcd 0000:00:1d.2: wake-up capability enabled by ACPI
[ 7413.802838] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[ 7413.803050] uhci_hcd 0000:00:1d.1: wake-up capability enabled by ACPI
[ 7413.803059] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[ 7413.805476] uhci_hcd 0000:00:1d.0: wake-up capability enabled by ACPI
[ 7413.805489] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[ 7413.805751] HDA Intel 0000:00:1b.0: PCI INT B disabled
[ 7413.820125] ehci_hcd 0000:00:1a.7: PME# enabled
[ 7413.823016] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[ 7413.823034] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[ 7413.825414] uhci_hcd 0000:00:1a.2: wake-up capability enabled by ACPI
[ 7413.825424] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[ 7413.825638] uhci_hcd 0000:00:1a.1: wake-up capability enabled by ACPI
[ 7413.825646] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[ 7413.828564] uhci_hcd 0000:00:1a.0: wake-up capability enabled by ACPI
[ 7413.828575] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[ 7413.887091] e1000e 0000:00:19.0: PME# enabled
[ 7413.887124] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[ 7413.887131] e1000e 0000:00:19.0: PME# enabled
[ 7413.887136] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[ 7413.887147] e1000e 0000:00:19.0: PCI INT A disabled
[ 7413.900175] ACPI handle has no context!
[ 7413.964505] pci 0000:00:02.0: power state changed by ACPI to D3
[ 7413.969943] ACPI: Preparing to enter system sleep state S3
[ 7413.988894] Disabling non-boot CPUs ...
[ 7414.092021] CPU 1 is now offline
[ 7414.092025] SMP alternatives: switching to UP code
[ 7414.260316] CPU1 is down
[ 7414.260420] Extended CMOS year: 2000
[ 7414.260420] Back to C!
[ 7414.260420] Extended CMOS year: 2000
[ 7414.260420] pci 0000:00:02.0: restoring config space at offset 0x1 (was =
0x900007, writing 0x900403)
[ 7414.260420] pci 0000:00:02.1: restoring config space at offset 0x1 (was =
0x900000, writing 0x900007)
[ 7414.260420] pci 0000:00:03.0: restoring config space at offset 0xf (was =
0x100, writing 0x10b)
[ 7414.260420] pci 0000:00:03.0: restoring config space at offset 0x1 (was =
0x100006, writing 0x180006)
[ 7414.260420] pci 0000:00:03.2: restoring config space at offset 0xf (was =
0x300, writing 0x30b)
[ 7414.260420] pci 0000:00:03.2: restoring config space at offset 0x1 (was =
0xb00005, writing 0xb00001)
[ 7414.260420] serial 0000:00:03.3: restoring config space at offset 0xf (w=
as 0x200, writing 0x20b)
[ 7414.260420] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[ 7414.260420] uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[ 7414.260420] uhci_hcd 0000:00:1a.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[ 7414.260420] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[ 7414.260420] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1=
 (was 0x100106, writing 0x100102)
[ 7414.260420] pcieport-driver 0000:00:1c.0: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100503)
[ 7414.260420] pcieport-driver 0000:00:1c.1: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100503)
[ 7414.260420] pcieport-driver 0000:00:1c.3: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100503)
[ 7414.260420] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[ 7414.260420] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[ 7414.260420] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[ 7414.260420] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[ 7414.260420] pci 0000:00:1e.0: restoring config space at offset 0xf (was =
0x40000, writing 0x400ff)
[ 7414.260420] pci 0000:00:1e.0: restoring config space at offset 0x9 (was =
0x10001, writing 0x1fff1)
[ 7414.260420] pci 0000:00:1e.0: restoring config space at offset 0x8 (was =
0x0, writing 0xfff0)
[ 7414.260420] pci 0000:00:1e.0: restoring config space at offset 0x7 (was =
0x22800000, writing 0x228000f0)
[ 7414.260420] pci 0000:00:1e.0: restoring config space at offset 0x1 (was =
0x100000, writing 0x100103)
[ 7414.260420] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was=
 0x2b00007, writing 0x2b00407)
[ 7414.260420] Enabling non-boot CPUs ...
[ 7414.260420] SMP alternatives: switching to SMP code
[ 7414.383355] Booting processor 1 APIC 0x1 ip 0x6000
[ 7414.253790] Initializing CPU#1
[ 7414.253790] Calibrating delay using timer specific routine.. 4522.02 Bog=
oMIPS (lpj=3D9044057)
[ 7414.253790] CPU: L1 I cache: 32K, L1 D cache: 32K
[ 7414.253790] CPU: L2 cache: 3072K
[ 7414.253790] [ds] using core 2 configuration
[ 7414.253790] CPU: Physical Processor ID: 0
[ 7414.253790] CPU: Processor Core ID: 1
[ 7414.253790] CPU1: Thermal monitoring enabled (TM2)
[ 7414.472519] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[ 7414.473010] Switched to high resolution mode on CPU 1
[ 7414.484309] CPU1 is up
[ 7414.484311] ACPI: Waking up from system sleep state S3
[ 7414.524853] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[ 7414.616959] pci 0000:00:02.0: PME# disabled
[ 7414.616969] pci 0000:00:02.1: PME# disabled
[ 7414.616976] pci 0000:00:03.0: PME# disabled
[ 7414.616983] pci 0000:00:03.2: PME# disabled
[ 7414.617134] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[ 7414.617142] e1000e 0000:00:19.0: setting latency timer to 64
[ 7414.617150] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[ 7414.617157] e1000e 0000:00:19.0: PME# disabled
[ 7414.617161] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[ 7414.617169] e1000e 0000:00:19.0: PME# disabled
[ 7414.617220] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[ 7414.676721] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[ 7414.676738] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[ 7414.676749] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[ 7414.676758] uhci_hcd 0000:00:1a.0: wake-up capability disabled by ACPI
[ 7414.676787] usb usb2: root hub lost power or was reset
[ 7414.676815] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[ 7414.676825] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[ 7414.676831] uhci_hcd 0000:00:1a.1: wake-up capability disabled by ACPI
[ 7414.676858] usb usb4: root hub lost power or was reset
[ 7414.677781] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[ 7414.677790] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[ 7414.677800] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[ 7414.677807] uhci_hcd 0000:00:1a.2: wake-up capability disabled by ACPI
[ 7414.677835] usb usb5: root hub lost power or was reset
[ 7414.678888] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[ 7414.678900] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[ 7414.678910] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[ 7414.678917] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[ 7414.678926] ehci_hcd 0000:00:1a.7: PME# disabled
[ 7414.678956] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[ 7414.678965] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 7414.679002] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[ 7414.679020] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[ 7414.679038] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[ 7414.679939] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[ 7414.679948] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[ 7414.679958] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[ 7414.679965] uhci_hcd 0000:00:1d.0: wake-up capability disabled by ACPI
[ 7414.679992] usb usb6: root hub lost power or was reset
[ 7414.680038] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[ 7414.680049] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[ 7414.680056] uhci_hcd 0000:00:1d.1: wake-up capability disabled by ACPI
[ 7414.680084] usb usb7: root hub lost power or was reset
[ 7414.680108] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[ 7414.680118] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[ 7414.680124] uhci_hcd 0000:00:1d.2: wake-up capability disabled by ACPI
[ 7414.680151] usb usb8: root hub lost power or was reset
[ 7414.681049] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[ 7414.681060] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[ 7414.681071] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[ 7414.681078] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[ 7414.681086] ehci_hcd 0000:00:1d.7: PME# disabled
[ 7414.681103] pci 0000:00:1e.0: setting latency timer to 64
[ 7414.681204] ahci 0000:00:1f.2: setting latency timer to 64
[ 7414.681384] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[ 7414.681569] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[ 7414.681637] iwlagn: Radio disabled by HW RF Kill switch
[ 7414.682199] sd 0:0:0:0: [sda] Starting disk
[ 7415.000286] ata2: SATA link down (SStatus 0 SControl 300)
[ 7415.616270] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 7415.709877] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[ 7415.709885] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[ 7415.710003] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[ 7415.710009] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[ 7415.720963] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[ 7415.720970] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[ 7415.721085] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[ 7415.721091] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[ 7415.722194] ata1.00: configured for UDMA/100
[ 7415.724815] ata1.00: configured for UDMA/100
[ 7415.740266] ata1: EH complete
[ 7415.740365] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[ 7415.740398] sd 0:0:0:0: [sda] Write Protect is off
[ 7415.740402] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 7415.740449] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[ 7415.740503] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[ 7415.740532] sd 0:0:0:0: [sda] Write Protect is off
[ 7415.740536] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 7415.740581] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[ 7417.020319] usb 1-6: reset high speed USB device using ehci_hcd and addr=
ess 4
[ 7417.268284] usb 4-1: reset full speed USB device using uhci_hcd and addr=
ess 2
[ 7417.419773] pci 0000:00:02.0: power state changed by ACPI to D0
[ 7417.419967] pci 0000:00:02.0: power state changed by ACPI to D0
[ 7417.419979] pci 0000:00:02.0: setting latency timer to 64
[ 7417.438607] Restarting tasks ... done.
[ 7418.529332] elantech.c: unexpected magic knock result 0x00, 0x02, 0x64.
[ 7418.845911] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[ 7418.865749] input: TPPS/2 IBM TrackPoint as /class/input/input12
[15:38] ikn:~#=20


--qDbXVdCdHGoSgWSk--

--gj572EiMnwbLXET9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkl3NMQACgkQuL75KpiFGIymbgCg26lkt3NNnMF2GChFX9ZKPFYY
bDwAni1rVg+b6uL6UbXWovttz9n6w4Xl
=S59N
-----END PGP SIGNATURE-----

--gj572EiMnwbLXET9--
