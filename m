Return-Path: <linux-kernel-owner+w=401wt.eu-S1758632AbXLNPpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632AbXLNPpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 10:45:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbXLNPpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 10:45:04 -0500
Received: from mail3.key-systems.net ([81.3.43.213]:52008 "HELO
	mail3.key-systems.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754333AbXLNPpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 10:45:00 -0500
Subject: Re: Strange ATA problems
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <47629E40.5020007@gmail.com>
References: <1197591699.3453.38.camel@fermat.scientia.net>
	 <47629E40.5020007@gmail.com>
Content-Type: multipart/signed; micalg=sha1; protocol="application/x-pkcs7-signature"; boundary="=-MeH615n2A1/ShXRPoebC"
Date: Fri, 14 Dec 2007 16:44:55 +0100
Message-Id: <1197647095.3454.3.camel@fermat.scientia.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MeH615n2A1/ShXRPoebC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Tejun.


On Sat, 2007-12-15 at 00:16 +0900, Tejun Heo wrote:
> Do you have log with timestamp?  It's difficult to tell what's going on
> without knowing what happened when.
Ah sorry,... I've completely missed that... perhaps those two problems
were not related (at least there's so much time between).

Dec 13 17:05:51 fermat kernel: NVRM: loading NVIDIA UNIX x86_64 Kernel
Module  100.14.19  Wed Sep 12 14:08:38 PDT 2007
Dec 13 17:12:36 fermat kernel: usb 1-1: new high speed USB device using
ehci_hcd and address 5
Dec 13 17:12:36 fermat kernel: usb 1-1: configuration #1 chosen from 1
choice
Dec 13 17:12:36 fermat kernel: scsi6 : SCSI emulation for USB Mass
Storage devices
Dec 13 17:12:36 fermat kernel: usb-storage: device found at 5
Dec 13 17:12:36 fermat kernel: usb-storage: waiting for device to settle
before scanning
Dec 13 17:12:41 fermat kernel: scsi 6:0:0:0: CD-ROM            PLEXTOR
DVD-ROM PX-130A  1.03 PQ: 0 ANSI: 0 CCS
Dec 13 17:12:41 fermat kernel: sr0: scsi3-mmc drive: 0x/50x cd/rw
xa/form2 cdda tray
Dec 13 17:12:41 fermat kernel: sr 6:0:0:0: Attached scsi CD-ROM sr0
Dec 13 17:12:41 fermat kernel: sr 6:0:0:0: Attached scsi generic sg3
type 5
Dec 13 17:12:41 fermat kernel: usb-storage: device scan complete
Dec 13 17:13:33 fermat kernel: end_request: I/O error, dev sr0, sector
308688
Dec 13 17:13:33 fermat kernel: Buffer I/O error on device sr0, logical
block 77172
Dec 13 17:13:33 fermat kernel: Buffer I/O error on device sr0, logical
block 77173
Dec 13 17:13:33 fermat kernel: end_request: I/O error, dev sr0, sector
308688
Dec 13 17:13:33 fermat kernel: Buffer I/O error on device sr0, logical
block 77172
Dec 13 17:13:33 fermat kernel: Buffer I/O error on device sr0, logical
block 77173
Dec 13 17:13:33 fermat kernel: end_request: I/O error, dev sr0, sector
308816
Dec 13 17:13:33 fermat kernel: Buffer I/O error on device sr0, logical
block 77204
Dec 13 17:13:33 fermat kernel: Buffer I/O error on device sr0, logical
block 77205
Dec 13 17:13:33 fermat kernel: end_request: I/O error, dev sr0, sector
308816
Dec 13 17:13:33 fermat kernel: Buffer I/O error on device sr0, logical
block 77204
Dec 13 17:13:33 fermat kernel: Buffer I/O error on device sr0, logical
block 77205
Dec 13 17:18:32 fermat kernel: UDF-fs: No VRS found
Dec 13 18:09:43 fermat kernel: tun0: Disabled Privacy Extensions
Dec 14 01:06:33 fermat kernel: usb 1-1: USB disconnect, address 5
Dec 14 01:06:33 fermat kernel: ata1: EH in ADMA mode, notifier 0x0
notifier_error 0x0 gen_ctl 0x1501000 status 0x400 next cpb count 0x0
next
 cpb idx 0x0
Dec 14 01:06:33 fermat kernel: ata1: CPB 0: ctl_flags 0x1f, resp_flags
0x2
Dec 14 01:06:33 fermat kernel: ata1: CPB 1: ctl_flags 0x1f, resp_flags
0x2
Dec 14 01:06:33 fermat kernel: ata1: CPB 2: ctl_flags 0x1f, resp_flags
0x2
Dec 14 01:06:33 fermat kernel: ata1: CPB 3: ctl_flags 0x1f, resp_flags
0x2
Dec 14 01:06:33 fermat kernel: ata1: CPB 4: ctl_flags 0x1f, resp_flags
0x2
Dec 14 01:06:33 fermat kernel: ata1: CPB 5: ctl_flags 0x1f, resp_flags
0x2
Dec 14 01:06:33 fermat kernel: ata1: CPB 6: ctl_flags 0x1f, resp_flags
0x2
Dec 14 01:06:33 fermat kernel: ata1: CPB 7: ctl_flags 0x1f, resp_flags
0x2
Dec 14 01:06:33 fermat kernel: ata1: CPB 8: ctl_flags 0x1f, resp_flags
0x2
Dec 14 01:06:33 fermat kernel: ata1: CPB 9: ctl_flags 0x1f, resp_flags
0x2
Dec 14 01:06:33 fermat kernel: ata1: CPB 10: ctl_flags 0x1f, resp_flags
0x2
Dec 14 01:06:33 fermat kernel: ata1: timeout waiting for ADMA IDLE,
stat=3D0x400
Dec 14 01:06:33 fermat kernel: ata1.00: exception Emask 0x0 SAct 0x7ff
SErr 0x0 action 0x2 frozen
Dec 14 01:06:33 fermat kernel: ata1.00: cmd
61/10:00:2e:07:a8/01:00:0b:00:00/40 tag 0 cdb 0x0 data 139264 out
Dec 14 01:06:33 fermat kernel:          res
40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
Dec 14 01:06:33 fermat kernel: ata1.00: cmd
61/18:08:07:3f:02/00:00:00:00:00/40 tag 1 cdb 0x0 data 12288 out
Dec 14 01:06:33 fermat kernel:          res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Dec 14 01:06:33 fermat kernel: ata1.00: cmd
61/08:10:b6:a8:23/00:00:0d:00:00/40 tag 2 cdb 0x0 data 4096 out
Dec 14 01:06:33 fermat kernel:          res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Dec 14 01:06:33 fermat kernel: ata1.00: cmd
61/08:18:f6:37:68/00:00:0d:00:00/40 tag 3 cdb 0x0 data 4096 out
Dec 14 01:06:33 fermat kernel:          res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Dec 14 01:06:33 fermat kernel: ata1.00: cmd
61/08:20:9e:32:a1/00:00:0d:00:00/40 tag 4 cdb 0x0 data 4096 out
Dec 14 01:06:33 fermat kernel:          res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Dec 14 01:06:33 fermat kernel: ata1.00: cmd
61/08:28:4f:00:dc/00:00:02:00:00/40 tag 5 cdb 0x0 data 4096 out
Dec 14 01:06:33 fermat kernel:          res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Dec 14 01:06:33 fermat kernel: ata1.00: cmd
61/08:30:6f:00:dc/00:00:02:00:00/40 tag 6 cdb 0x0 data 4096 out
Dec 14 01:06:33 fermat kernel:          res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Dec 14 01:06:33 fermat kernel: ata1.00: cmd
61/08:38:3f:03:2c/00:00:05:00:00/40 tag 7 cdb 0x0 data 4096 out
Dec 14 01:06:33 fermat kernel:          res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Dec 14 01:06:33 fermat kernel: ata1.00: cmd
61/08:40:36:ea:72/00:00:0d:00:00/40 tag 8 cdb 0x0 data 4096 out
Dec 14 01:06:33 fermat kernel:          res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Dec 14 01:06:33 fermat kernel: ata1.00: cmd
61/08:48:7f:00:c4/00:00:05:00:00/40 tag 9 cdb 0x0 data 4096 out
Dec 14 01:06:33 fermat kernel:          res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Dec 14 01:06:33 fermat kernel: ata1.00: cmd
61/08:50:47:02:d8/00:00:05:00:00/40 tag 10 cdb 0x0 data 4096 out
Dec 14 01:06:33 fermat kernel:          res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Dec 14 01:06:33 fermat kernel: ata1: soft resetting port
Dec 14 01:06:33 fermat kernel: ata1: SATA link up 3.0 Gbps (SStatus 123
SControl 300)
Dec 14 01:06:33 fermat kernel: ata1.00: configured for UDMA/133
Dec 14 01:06:33 fermat kernel: ata1: EH complete
Dec 14 01:06:33 fermat kernel: sd 0:0:0:0: [sda] 488397168 512-byte
hardware sectors (250059 MB)
Dec 14 01:06:33 fermat kernel: sd 0:0:0:0: [sda] Write Protect is off
Dec 14 01:06:33 fermat kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Dec 14 01:06:33 fermat kernel: sd 0:0:0:0: [sda] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA
Dec 14 01:27:45 fermat kernel: Kernel logging (proc) stopped.



> Also, please post the result of
> 'cat /proc/interrupts'.
           CPU0       CPU1       CPU2       CPU3      =20
  0:        393       1181      82962    4513047   IO-APIC-edge
timer
  1:          0          0          0          2   IO-APIC-edge
i8042
  6:          0          0          0          5   IO-APIC-edge
floppy
  8:          0          0          0          0   IO-APIC-edge      rtc
  9:          0          0          0          0   IO-APIC-fasteoi
acpi
 12:          0         84       1376     210883   IO-APIC-edge
i8042
 14:          0          3         17       1220   IO-APIC-edge
ide0
 18:          0         64       4964     300769   IO-APIC-fasteoi
nvidia
 19:          0          0          0          3   IO-APIC-fasteoi
ohci1394
 20:          0          0          0          4   IO-APIC-fasteoi
ehci_hcd:usb1
 21:          0          0          1        165   IO-APIC-fasteoi
sata_nv
 22:          0         44       1856     165693   IO-APIC-fasteoi
sata_nv, NVidia CK804
 23:          0        117       8565     452639   IO-APIC-fasteoi
ohci_hcd:usb3, eth1
 24:          0         37       3710     185125   IO-APIC-fasteoi
ICE1724
 30:          3       1833      52841   18139903   IO-APIC-fasteoi
ioc0, ehci_hcd:usb2
 31:          0          0          0         45   IO-APIC-fasteoi
ioc1
 55:        129     530948          1         81   IO-APIC-fasteoi
eth2
NMI:          0          0          0          0=20
LOC:    4597004    4596930    4596860    4596786=20
ERR:          0


> If your USB cdrom is bus powered and you yanked it, it could have caused
> fluctuation in power which in turn can cause disruption on serial ATA
> bus leading to transmission error and timeouts.  There are other
> possibilities but this kind of thing does happen often with SATA.  Those
> highspeed low-voltage serial links are very susceptible to interferences.
Well,.. it actually "worked" again when I unplugged it, but the errors
from the cdrom above are probably unrelated..


> As long as EH recovered it properly, there's nothing to worry about.
What does that mean?

Thanks and regards,
Chris.

--=-MeH615n2A1/ShXRPoebC
Content-Type: application/x-pkcs7-signature; name=smime.p7s
Content-Disposition: attachment; filename=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIQ/DCCBXQw
ggNcoAMCAQICAjh/MA0GCSqGSIb3DQEBBQUAMFQxFDASBgNVBAoTC0NBY2VydCBJbmMuMR4wHAYD
VQQLExVodHRwOi8vd3d3LkNBY2VydC5vcmcxHDAaBgNVBAMTE0NBY2VydCBDbGFzcyAzIFJvb3Qw
HhcNMDcxMDI0MTkyNzQxWhcNMDkxMDIzMTkyNzQxWjB8MSEwHwYDVQQDExhDaHJpc3RvcGggQW50
b24gTWl0dGVyZXIxJDAiBgkqhkiG9w0BCQEWFWNhbGVzdHlvQHNjaWVudGlhLm5ldDExMC8GCSqG
SIb3DQEJARYibWFpbEBjaHJpc3RvcGguYW50b24ubWl0dGVyZXIubmFtZTCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBAPgLlUBy3NRbH25w8pOnhF+qtj4GN04aG7ur+JsXTcEkFNOZWZ5I
al2PaQWP7GfEEp5lL0w/LdYXPfnLNohp4l/Nb+db8aHUeVBYgGBTPGF+mJHfJGeochfvZo78u6Bp
KkCrDAw2BKN1JNxw+OxmWuunCmXSFM9gqRfBnfmc25P6ba9tQlDXGLKZA8/JKXLMKcTTS7dIkroE
bM5FTSaAmGWkvwnD6fpxjFgWNLXjagNqlQD6+q+a//+gXNOGP34aZ3qPnLPR/gUi/yqrQuAVvGep
GAhl4B1Kn+c7eROoodq33Ghomoznh8hogBkDJXp+Xq4k8measwtN99ZUdMaFeJsCAwEAAaOCASYw
ggEiMAwGA1UdEwEB/wQCMAAwVgYJYIZIAYb4QgENBEkWR1RvIGdldCB5b3VyIG93biBjZXJ0aWZp
Y2F0ZSBmb3IgRlJFRSBoZWFkIG92ZXIgdG8gaHR0cDovL3d3dy5DQWNlcnQub3JnMEAGA1UdJQQ5
MDcGCCsGAQUFBwMEBggrBgEFBQcDAgYKKwYBBAGCNwoDBAYKKwYBBAGCNwoDAwYJYIZIAYb4QgQB
MDIGCCsGAQUFBwEBBCYwJDAiBggrBgEFBQcwAYYWaHR0cDovL29jc3AuY2FjZXJ0Lm9yZzBEBgNV
HREEPTA7gRVjYWxlc3R5b0BzY2llbnRpYS5uZXSBIm1haWxAY2hyaXN0b3BoLmFudG9uLm1pdHRl
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


--=-MeH615n2A1/ShXRPoebC--

