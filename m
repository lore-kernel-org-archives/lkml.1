Return-Path: <linux-kernel-owner+w=401wt.eu-S1031129AbXDQQPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031129AbXDQQPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 12:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031130AbXDQQPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 12:15:12 -0400
Received: from seahorse.shentel.net ([204.111.1.244]:53770 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031129AbXDQQPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 12:15:10 -0400
Date: Tue, 17 Apr 2007 12:13:52 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org
Subject: [PATCH] top of tree: convert CREDITS and MAINTAINERS to UTF-8
Message-ID: <alpine.DEB.0.83.0704171207160.27446@sigma.j-a-k-j.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1875672472-1120376025-1176826433=:27446"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1875672472-1120376025-1176826433=:27446
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

From: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

Convert the toplevel files CREDITS and MAINTAINERS to UTF-8.

Signed-off-by: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

---

I can't get my mail client to send in ISO-8859-1 instead of UTF-8, so the 
actual patch is attached in octet-stream format. The below patch is just 
for reference and will almost certainly NOT work.

Also, since the patch includes both encodings, whichever encoding you 
select while viewing it will display one correct and one garbled line. 
However, the bytecodes -are- correct.

diff -uprN linux-2.6.21-rc7.orig/CREDITS linux-2.6.21-rc7.mod/CREDITS
--- linux-2.6.21-rc7.orig/CREDITS	2007-04-17 11:41:41.000000000 -0400
+++ linux-2.6.21-rc7.mod/CREDITS	2007-04-17 11:53:29.000000000 -0400
@@ -374,7 +374,7 @@ S: FutureTV Labs Ltd
 S: Brunswick House, 61-69 Newmarket Rd, Cambridge CB5 8EG
 S: United Kingdom
 
-N: Thomas Bogendörfer
+N: Thomas BogendÃ¶rfer
 E: tsbogend@alpha.franken.de
 D: PCnet32 driver, SONIC driver, JAZZ_ESP driver
 D: newport abscon driver, g364 framebuffer driver
@@ -394,7 +394,7 @@ W: http://math-www.uni-paderborn.de/~axe
 D: Configuration help text support
 D: Linux CD and Support Giveaway List
 
-N: Erik Inge Bolsø
+N: Erik Inge BolsÃ¸
 E: knan@mo.himolde.no
 D: Misc kernel hacks
 
@@ -422,7 +422,7 @@ D: Various fixes (mostly networking)
 S: Montreal, Quebec
 S: Canada
 
-N: Zoltán Böszörményi
+N: ZoltÃ¡n BÃ¶szÃ¶rmÃ©nyi
 E: zboszor@mail.externet.hu
 D: MTRR emulation with Cyrix style ARR registers, Athlon MTRR support
 
@@ -1023,11 +1023,11 @@ D: Future Domain TMC-16x0 SCSI driver (a
 D: APM driver (early port)
 D: DRM drivers (author of several)
 
-N: János Farkas
+N: JÃ¡nos Farkas
 E: chexum@shadow.banki.hu
 D: romfs, various (mostly networking) fixes
 P: 1024/F81FB2E1 41 B7 E4 E6 3E D4 A6 71  6D 9C F3 9F F2 BF DF 6E
-S: Madarász Viktor utca 25
+S: MadarÃ¡sz Viktor utca 25
 S: 1131 Budapest
 S: Hungary
 
@@ -1038,10 +1038,10 @@ D: UDF filesystem
 S: (ask for current address)
 S: USA
 
-N: Jürgen Fischer
+N: JÃ¼rgen Fischer
 E: fischer@norbit.de (=?iso-8859-1?q?J=FCrgen?= Fischer)
 D: Author of Adaptec AHA-152x SCSI driver
-S: Schulstraße 18
+S: SchulstraÃŸe 18
 S: 26506 Norden
 S: Germany
 
@@ -1107,7 +1107,7 @@ E: fuganti@netbank.com.br
 D: random kernel hacker, ZF MachZ Watchdog driver
 S: Conectiva S.A.
 S: R. Tocantins, 89 - Cristo Rei
-S: 80050-430 - Curitiba - Paraná
+S: 80050-430 - Curitiba - ParanÃ¡
 S: Brazil
 
 N: Kumar Gala
@@ -1252,12 +1252,12 @@ S: 44 St. Joseph Street, Suite 506
 S: Toronto, Ontario, M4Y 2W4
 S: Canada
 
-N: Richard Günther
+N: Richard GÃ¼nther
 E: rguenth@tat.physik.uni-tuebingen.de
 W: http://www.tat.physik.uni-tuebingen.de/~rguenth
 P: 2048/2E829319 2F 83 FC 93 E9 E4 19 E2  93 7A 32 42 45 37 23 57
 D: binfmt_misc
-S: 72074 Tübingen
+S: 72074 TÃ¼bingen
 S: Germany
 
 N: Justin Guyett
@@ -1281,7 +1281,7 @@ N: Bruno Haible
 E: haible@ma2s2.mathematik.uni-karlsruhe.de
 D: SysV FS, shm swapping, memory management fixes
 S: 17 rue Danton
-S: F - 94270 Le Kremlin-Bicêtre
+S: F - 94270 Le Kremlin-BicÃªtre
 S: France
 
 N: Greg Hankins
@@ -1695,7 +1695,7 @@ S: Czech Republic
 N: Jakob Kemi
 E: jakob.kemi@telia.com
 D: V4L W9966 Webcam driver
-S: Forsbyvägen 33
+S: ForsbyvÃ¤gen 33
 S: 74143 Knivsta
 S: Sweden
 
@@ -2058,7 +2058,7 @@ D: misc. kernel hacking and debugging
 S: Cambridge, MA 02139
 S: USA
 
-N: Martin von Löwis
+N: Martin von LÃ¶wis
 E: loewis@informatik.hu-berlin.de
 D: script binary format
 D: NTFS driver
@@ -2135,7 +2135,7 @@ S: PO BOX 220, HFX. CENTRAL
 S: Halifax, Nova Scotia
 S: Canada B3J 3C8
 
-N: Kai Mäkisara
+N: Kai MÃ¤kisara
 E: Kai.Makisara@kolumbus.fi
 D: SCSI Tape Driver
 
@@ -2293,7 +2293,7 @@ P: 1024D/9224DF01 D5DF E3BB E3C8 BCBB F8
 D: IPX, LLC, DCCP, cyc2x, wl3501_cs, net/ hacks
 S: Mandriva
 S: R. Tocantins, 89 - Cristo Rei
-S: 80050-430 - Curitiba - Paraná
+S: 80050-430 - Curitiba - ParanÃ¡
 S: Brazil
 
 N: Karsten Merker
@@ -2779,10 +2779,10 @@ N: Juan Quintela
 E: quintela@fi.udc.es
 D: Memory Management hacking
 S: LFCIA
-S: Departamento de Computación
-S: Universidade da Coruña
+S: Departamento de ComputaciÃ³n
+S: Universidade da CoruÃ±a
 S: E-15071
-S: A Coruña
+S: A CoruÃ±a
 S: Spain
 
 N: Augusto Cesar Radtke
@@ -2933,7 +2933,7 @@ E: aris@cathedrallabs.org
 D: Support for EtherExpress 10 ISA (i82595) in eepro driver
 D: User level driver support for input
 S: R. Jose Serrato, 130 - Santa Candida
-S: 82640-320 - Curitiba - Paraná
+S: 82640-320 - Curitiba - ParanÃ¡
 S: Brazil
 
 N: Alessandro Rubini
@@ -3331,15 +3331,15 @@ P: 1024D/D0FE7AFB B24A 65C9 1D71 2AC2 DE
 D: rcutorture maintainer
 D: lock annotations, finding and fixing lock bugs
 
-N: Winfried Trümper
+N: Winfried TrÃ¼mper
 E: winni@xpilot.org
 W: http://www.shop.de/~winni/
 D: German HOWTO, Crash-Kurs Linux (German, 100 comprehensive pages)
 D: CD-Writing HOWTO, various mini-HOWTOs
 D: One-week tutorials on Linux twice a year (free of charge)
-D: Linux-Workshop Köln (aka LUG Cologne, Germany), Installfests
+D: Linux-Workshop KÃ¶ln (aka LUG Cologne, Germany), Installfests
 S: Tacitusstr. 6
-S: D-50968 Köln
+S: D-50968 KÃ¶ln
 
 N: Tsu-Sheng Tsao
 E: tsusheng@scf.usc.edu
diff -uprN linux-2.6.21-rc7.orig/MAINTAINERS linux-2.6.21-rc7.mod/MAINTAINERS
--- linux-2.6.21-rc7.orig/MAINTAINERS	2007-04-17 11:41:42.000000000 -0400
+++ linux-2.6.21-rc7.mod/MAINTAINERS	2007-04-17 11:53:29.000000000 -0400
@@ -2657,7 +2657,7 @@ L:	linux-abi-devel@lists.sourceforge.net
 S:	Maintained
 
 PHRAM MTD DRIVER
-P:	Jörn Engel
+P:	JÃ¶rn Engel
 M:	joern@wh.fh-wedel.de
 L:	linux-mtd@lists.infradead.org
 S:	Maintained
@@ -2931,7 +2931,7 @@ T:	git kernel.org:/pub/scm/linux/kernel/
 S:	Maintained
 
 SCSI TAPE DRIVER
-P:	Kai Mäkisara
+P:	Kai MÃ¤kisara
 M:	Kai.Makisara@kolumbus.fi
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
--1875672472-1120376025-1176826433=:27446
Content-Type: APPLICATION/octet-stream; name=patch-CREDITS-MAINTAINERS.bin
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.0.83.0704171213520.27446@sigma.j-a-k-j.com>
Content-Description: 
Content-Disposition: attachment; filename=patch-CREDITS-MAINTAINERS.bin

ZGlmZiAtdXByTiBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvQ1JFRElUUyBsaW51
eC0yLjYuMjEtcmM3Lm1vZC9DUkVESVRTCi0tLSBsaW51eC0yLjYuMjEtcmM3
Lm9yaWcvQ1JFRElUUwkyMDA3LTA0LTE3IDExOjQxOjQxLjAwMDAwMDAwMCAt
MDQwMAorKysgbGludXgtMi42LjIxLXJjNy5tb2QvQ1JFRElUUwkyMDA3LTA0
LTE3IDExOjUzOjI5LjAwMDAwMDAwMCAtMDQwMApAQCAtMzc0LDcgKzM3NCw3
IEBAIFM6IEZ1dHVyZVRWIExhYnMgTHRkCiBTOiBCcnVuc3dpY2sgSG91c2Us
IDYxLTY5IE5ld21hcmtldCBSZCwgQ2FtYnJpZGdlIENCNSA4RUcKIFM6IFVu
aXRlZCBLaW5nZG9tCiAKLU46IFRob21hcyBCb2dlbmT2cmZlcgorTjogVGhv
bWFzIEJvZ2VuZMO2cmZlcgogRTogdHNib2dlbmRAYWxwaGEuZnJhbmtlbi5k
ZQogRDogUENuZXQzMiBkcml2ZXIsIFNPTklDIGRyaXZlciwgSkFaWl9FU1Ag
ZHJpdmVyCiBEOiBuZXdwb3J0IGFic2NvbiBkcml2ZXIsIGczNjQgZnJhbWVi
dWZmZXIgZHJpdmVyCkBAIC0zOTQsNyArMzk0LDcgQEAgVzogaHR0cDovL21h
dGgtd3d3LnVuaS1wYWRlcmJvcm4uZGUvfmF4ZQogRDogQ29uZmlndXJhdGlv
biBoZWxwIHRleHQgc3VwcG9ydAogRDogTGludXggQ0QgYW5kIFN1cHBvcnQg
R2l2ZWF3YXkgTGlzdAogCi1OOiBFcmlrIEluZ2UgQm9sc/gKK046IEVyaWsg
SW5nZSBCb2xzw7gKIEU6IGtuYW5AbW8uaGltb2xkZS5ubwogRDogTWlzYyBr
ZXJuZWwgaGFja3MKIApAQCAtNDIyLDcgKzQyMiw3IEBAIEQ6IFZhcmlvdXMg
Zml4ZXMgKG1vc3RseSBuZXR3b3JraW5nKQogUzogTW9udHJlYWwsIFF1ZWJl
YwogUzogQ2FuYWRhCiAKLU46IFpvbHThbiBC9nN69nJt6W55aQorTjogWm9s
dMOhbiBCw7ZzesO2cm3DqW55aQogRTogemJvc3pvckBtYWlsLmV4dGVybmV0
Lmh1CiBEOiBNVFJSIGVtdWxhdGlvbiB3aXRoIEN5cml4IHN0eWxlIEFSUiBy
ZWdpc3RlcnMsIEF0aGxvbiBNVFJSIHN1cHBvcnQKIApAQCAtMTAyMywxMSAr
MTAyMywxMSBAQCBEOiBGdXR1cmUgRG9tYWluIFRNQy0xNngwIFNDU0kgZHJp
dmVyIChhCiBEOiBBUE0gZHJpdmVyIChlYXJseSBwb3J0KQogRDogRFJNIGRy
aXZlcnMgKGF1dGhvciBvZiBzZXZlcmFsKQogCi1OOiBK4W5vcyBGYXJrYXMK
K046IErDoW5vcyBGYXJrYXMKIEU6IGNoZXh1bUBzaGFkb3cuYmFua2kuaHUK
IEQ6IHJvbWZzLCB2YXJpb3VzIChtb3N0bHkgbmV0d29ya2luZykgZml4ZXMK
IFA6IDEwMjQvRjgxRkIyRTEgNDEgQjcgRTQgRTYgM0UgRDQgQTYgNzEgIDZE
IDlDIEYzIDlGIEYyIEJGIERGIDZFCi1TOiBNYWRhcuFzeiBWaWt0b3IgdXRj
YSAyNQorUzogTWFkYXLDoXN6IFZpa3RvciB1dGNhIDI1CiBTOiAxMTMxIEJ1
ZGFwZXN0CiBTOiBIdW5nYXJ5CiAKQEAgLTEwMzgsMTAgKzEwMzgsMTAgQEAg
RDogVURGIGZpbGVzeXN0ZW0KIFM6IChhc2sgZm9yIGN1cnJlbnQgYWRkcmVz
cykKIFM6IFVTQQogCi1OOiBK/HJnZW4gRmlzY2hlcgorTjogSsO8cmdlbiBG
aXNjaGVyCiBFOiBmaXNjaGVyQG5vcmJpdC5kZSAoPT9pc28tODg1OS0xP3E/
Sj1GQ3JnZW4/PSBGaXNjaGVyKQogRDogQXV0aG9yIG9mIEFkYXB0ZWMgQUhB
LTE1MnggU0NTSSBkcml2ZXIKLVM6IFNjaHVsc3RyYd9lIDE4CitTOiBTY2h1
bHN0cmHDn2UgMTgKIFM6IDI2NTA2IE5vcmRlbgogUzogR2VybWFueQogCkBA
IC0xMTA3LDcgKzExMDcsNyBAQCBFOiBmdWdhbnRpQG5ldGJhbmsuY29tLmJy
CiBEOiByYW5kb20ga2VybmVsIGhhY2tlciwgWkYgTWFjaFogV2F0Y2hkb2cg
ZHJpdmVyCiBTOiBDb25lY3RpdmEgUy5BLgogUzogUi4gVG9jYW50aW5zLCA4
OSAtIENyaXN0byBSZWkKLVM6IDgwMDUwLTQzMCAtIEN1cml0aWJhIC0gUGFy
YW7hCitTOiA4MDA1MC00MzAgLSBDdXJpdGliYSAtIFBhcmFuw6EKIFM6IEJy
YXppbAogCiBOOiBLdW1hciBHYWxhCkBAIC0xMjUyLDEyICsxMjUyLDEyIEBA
IFM6IDQ0IFN0LiBKb3NlcGggU3RyZWV0LCBTdWl0ZSA1MDYKIFM6IFRvcm9u
dG8sIE9udGFyaW8sIE00WSAyVzQKIFM6IENhbmFkYQogCi1OOiBSaWNoYXJk
IEf8bnRoZXIKK046IFJpY2hhcmQgR8O8bnRoZXIKIEU6IHJndWVudGhAdGF0
LnBoeXNpay51bmktdHVlYmluZ2VuLmRlCiBXOiBodHRwOi8vd3d3LnRhdC5w
aHlzaWsudW5pLXR1ZWJpbmdlbi5kZS9+cmd1ZW50aAogUDogMjA0OC8yRTgy
OTMxOSAyRiA4MyBGQyA5MyBFOSBFNCAxOSBFMiAgOTMgN0EgMzIgNDIgNDUg
MzcgMjMgNTcKIEQ6IGJpbmZtdF9taXNjCi1TOiA3MjA3NCBU/GJpbmdlbgor
UzogNzIwNzQgVMO8YmluZ2VuCiBTOiBHZXJtYW55CiAKIE46IEp1c3RpbiBH
dXlldHQKQEAgLTEyODEsNyArMTI4MSw3IEBAIE46IEJydW5vIEhhaWJsZQog
RTogaGFpYmxlQG1hMnMyLm1hdGhlbWF0aWsudW5pLWthcmxzcnVoZS5kZQog
RDogU3lzViBGUywgc2htIHN3YXBwaW5nLCBtZW1vcnkgbWFuYWdlbWVudCBm
aXhlcwogUzogMTcgcnVlIERhbnRvbgotUzogRiAtIDk0MjcwIExlIEtyZW1s
aW4tQmlj6nRyZQorUzogRiAtIDk0MjcwIExlIEtyZW1saW4tQmljw6p0cmUK
IFM6IEZyYW5jZQogCiBOOiBHcmVnIEhhbmtpbnMKQEAgLTE2OTUsNyArMTY5
NSw3IEBAIFM6IEN6ZWNoIFJlcHVibGljCiBOOiBKYWtvYiBLZW1pCiBFOiBq
YWtvYi5rZW1pQHRlbGlhLmNvbQogRDogVjRMIFc5OTY2IFdlYmNhbSBkcml2
ZXIKLVM6IEZvcnNieXbkZ2VuIDMzCitTOiBGb3JzYnl2w6RnZW4gMzMKIFM6
IDc0MTQzIEtuaXZzdGEKIFM6IFN3ZWRlbgogCkBAIC0yMDU4LDcgKzIwNTgs
NyBAQCBEOiBtaXNjLiBrZXJuZWwgaGFja2luZyBhbmQgZGVidWdnaW5nCiBT
OiBDYW1icmlkZ2UsIE1BIDAyMTM5CiBTOiBVU0EKIAotTjogTWFydGluIHZv
biBM9ndpcworTjogTWFydGluIHZvbiBMw7Z3aXMKIEU6IGxvZXdpc0BpbmZv
cm1hdGlrLmh1LWJlcmxpbi5kZQogRDogc2NyaXB0IGJpbmFyeSBmb3JtYXQK
IEQ6IE5URlMgZHJpdmVyCkBAIC0yMTM1LDcgKzIxMzUsNyBAQCBTOiBQTyBC
T1ggMjIwLCBIRlguIENFTlRSQUwKIFM6IEhhbGlmYXgsIE5vdmEgU2NvdGlh
CiBTOiBDYW5hZGEgQjNKIDNDOAogCi1OOiBLYWkgTeRraXNhcmEKK046IEth
aSBNw6RraXNhcmEKIEU6IEthaS5NYWtpc2FyYUBrb2x1bWJ1cy5maQogRDog
U0NTSSBUYXBlIERyaXZlcgogCkBAIC0yMjkzLDcgKzIyOTMsNyBAQCBQOiAx
MDI0RC85MjI0REYwMSBENURGIEUzQkIgRTNDOCBCQ0JCIEY4CiBEOiBJUFgs
IExMQywgRENDUCwgY3ljMngsIHdsMzUwMV9jcywgbmV0LyBoYWNrcwogUzog
TWFuZHJpdmEKIFM6IFIuIFRvY2FudGlucywgODkgLSBDcmlzdG8gUmVpCi1T
OiA4MDA1MC00MzAgLSBDdXJpdGliYSAtIFBhcmFu4QorUzogODAwNTAtNDMw
IC0gQ3VyaXRpYmEgLSBQYXJhbsOhCiBTOiBCcmF6aWwKIAogTjogS2Fyc3Rl
biBNZXJrZXIKQEAgLTI3NzksMTAgKzI3NzksMTAgQEAgTjogSnVhbiBRdWlu
dGVsYQogRTogcXVpbnRlbGFAZmkudWRjLmVzCiBEOiBNZW1vcnkgTWFuYWdl
bWVudCBoYWNraW5nCiBTOiBMRkNJQQotUzogRGVwYXJ0YW1lbnRvIGRlIENv
bXB1dGFjafNuCi1TOiBVbml2ZXJzaWRhZGUgZGEgQ29ydfFhCitTOiBEZXBh
cnRhbWVudG8gZGUgQ29tcHV0YWNpw7NuCitTOiBVbml2ZXJzaWRhZGUgZGEg
Q29ydcOxYQogUzogRS0xNTA3MQotUzogQSBDb3J18WEKK1M6IEEgQ29ydcOx
YQogUzogU3BhaW4KIAogTjogQXVndXN0byBDZXNhciBSYWR0a2UKQEAgLTI5
MzMsNyArMjkzMyw3IEBAIEU6IGFyaXNAY2F0aGVkcmFsbGFicy5vcmcKIEQ6
IFN1cHBvcnQgZm9yIEV0aGVyRXhwcmVzcyAxMCBJU0EgKGk4MjU5NSkgaW4g
ZWVwcm8gZHJpdmVyCiBEOiBVc2VyIGxldmVsIGRyaXZlciBzdXBwb3J0IGZv
ciBpbnB1dAogUzogUi4gSm9zZSBTZXJyYXRvLCAxMzAgLSBTYW50YSBDYW5k
aWRhCi1TOiA4MjY0MC0zMjAgLSBDdXJpdGliYSAtIFBhcmFu4QorUzogODI2
NDAtMzIwIC0gQ3VyaXRpYmEgLSBQYXJhbsOhCiBTOiBCcmF6aWwKIAogTjog
QWxlc3NhbmRybyBSdWJpbmkKQEAgLTMzMzEsMTUgKzMzMzEsMTUgQEAgUDog
MTAyNEQvRDBGRTdBRkIgQjI0QSA2NUM5IDFENzEgMkFDMiBERQogRDogcmN1
dG9ydHVyZSBtYWludGFpbmVyCiBEOiBsb2NrIGFubm90YXRpb25zLCBmaW5k
aW5nIGFuZCBmaXhpbmcgbG9jayBidWdzCiAKLU46IFdpbmZyaWVkIFRy/G1w
ZXIKK046IFdpbmZyaWVkIFRyw7xtcGVyCiBFOiB3aW5uaUB4cGlsb3Qub3Jn
CiBXOiBodHRwOi8vd3d3LnNob3AuZGUvfndpbm5pLwogRDogR2VybWFuIEhP
V1RPLCBDcmFzaC1LdXJzIExpbnV4IChHZXJtYW4sIDEwMCBjb21wcmVoZW5z
aXZlIHBhZ2VzKQogRDogQ0QtV3JpdGluZyBIT1dUTywgdmFyaW91cyBtaW5p
LUhPV1RPcwogRDogT25lLXdlZWsgdHV0b3JpYWxzIG9uIExpbnV4IHR3aWNl
IGEgeWVhciAoZnJlZSBvZiBjaGFyZ2UpCi1EOiBMaW51eC1Xb3Jrc2hvcCBL
9mxuIChha2EgTFVHIENvbG9nbmUsIEdlcm1hbnkpLCBJbnN0YWxsZmVzdHMK
K0Q6IExpbnV4LVdvcmtzaG9wIEvDtmxuIChha2EgTFVHIENvbG9nbmUsIEdl
cm1hbnkpLCBJbnN0YWxsZmVzdHMKIFM6IFRhY2l0dXNzdHIuIDYKLVM6IEQt
NTA5NjggS/ZsbgorUzogRC01MDk2OCBLw7ZsbgogCiBOOiBUc3UtU2hlbmcg
VHNhbwogRTogdHN1c2hlbmdAc2NmLnVzYy5lZHUKZGlmZiAtdXByTiBsaW51
eC0yLjYuMjEtcmM3Lm9yaWcvTUFJTlRBSU5FUlMgbGludXgtMi42LjIxLXJj
Ny5tb2QvTUFJTlRBSU5FUlMKLS0tIGxpbnV4LTIuNi4yMS1yYzcub3JpZy9N
QUlOVEFJTkVSUwkyMDA3LTA0LTE3IDExOjQxOjQyLjAwMDAwMDAwMCAtMDQw
MAorKysgbGludXgtMi42LjIxLXJjNy5tb2QvTUFJTlRBSU5FUlMJMjAwNy0w
NC0xNyAxMTo1MzoyOS4wMDAwMDAwMDAgLTA0MDAKQEAgLTI2NTcsNyArMjY1
Nyw3IEBAIEw6CWxpbnV4LWFiaS1kZXZlbEBsaXN0cy5zb3VyY2Vmb3JnZS5u
ZXQKIFM6CU1haW50YWluZWQKIAogUEhSQU0gTVREIERSSVZFUgotUDoJSvZy
biBFbmdlbAorUDoJSsO2cm4gRW5nZWwKIE06CWpvZXJuQHdoLmZoLXdlZGVs
LmRlCiBMOglsaW51eC1tdGRAbGlzdHMuaW5mcmFkZWFkLm9yZwogUzoJTWFp
bnRhaW5lZApAQCAtMjkzMSw3ICsyOTMxLDcgQEAgVDoJZ2l0IGtlcm5lbC5v
cmc6L3B1Yi9zY20vbGludXgva2VybmVsLwogUzoJTWFpbnRhaW5lZAogCiBT
Q1NJIFRBUEUgRFJJVkVSCi1QOglLYWkgTeRraXNhcmEKK1A6CUthaSBNw6Rr
aXNhcmEKIE06CUthaS5NYWtpc2FyYUBrb2x1bWJ1cy5maQogTDoJbGludXgt
c2NzaUB2Z2VyLmtlcm5lbC5vcmcKIFM6CU1haW50YWluZWQK

--1875672472-1120376025-1176826433=:27446--
