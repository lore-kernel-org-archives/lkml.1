Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbZAHLtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbZAHLtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 06:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbZAHLt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 06:49:26 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:38257 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbZAHLtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 06:49:25 -0500
From: Jean Pihet <jpihet@mvista.com>
Organization: MontaVista
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [PATCH] OMAP: MMC: recover from transfer failures
Date: Thu, 8 Jan 2009 12:49:19 +0100
User-Agent: KMail/1.9.9
Cc: linux-arm-kernel@lists.arm.linux.org.uk, Tony Lindgren <tony@atomide.com>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Madhusudhan Chikkature <madhu.cr@ti.com>,
       David Brownell <david-b@pacbell.net>,
       "Jarkko Lavinen (NMP/Helsinki)" <jarkko.lavinen@nokia.com>
References: <20081207213617.10456.43951.stgit@localhost> <200901071128.43937.jpihet@mvista.com> <4965C120.3010705@nokia.com>
In-Reply-To: <4965C120.3010705@nokia.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_AheZJxIKecc/jAd"
Message-Id: <200901081249.20152.jpihet@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_AheZJxIKecc/jAd
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: base64
Content-Disposition: inline

VGhhbmtzIGZvciB0aGUgc3VnZ2VzdGlvbiwgaXQgd29ya3MgZ3JlYXQgKHN0cmVzcyB0ZXN0ZWQp
IGFuZCBpcyBhIGNsZWFuZXIgCmZpeC4KSGVyZSBpcyBhIHBhdGNoIHRoZSBsYXRlc3QgbGludXgt
b21hcC0yLjYgdHJlZS4gSXMgdGhpcyBPSz8KClJlZ2FyZHMsCkplYW4KCkZyb20gZDE0M2Y2YjJl
NzA1YWE0ZTlkMmIwMzIwOTdmZDFjODJmODE2MzI2MiBNb24gU2VwIDE3IDAwOjAwOjAwIDIwMDEK
RnJvbTogSmVhbiBQaWhldCA8anBpaGV0QG12aXN0YS5jb20+CkRhdGU6IFRodSwgOCBKYW4gMjAw
OSAxMjozNToyMSArMDEwMApTdWJqZWN0OiBbUEFUQ0hdIE9NQVA6IE1NQzogcmVjb3ZlciBmcm9t
IHRyYW5zZmVyIGZhaWx1cmVzCgpUaW1lb3V0cyBkdXJpbmcgYSBjb21tYW5kIHRoYXQgaGFzIGEg
ZGF0YSBwaGFzZSBjYW4gcmVzdWx0IGluIHRoZQpuZXh0IGNvbW1hbmQgaXNzdWVkIGFmdGVyIHRo
ZSBjb21tYW5kIHRoYXQgZmFpbGVkIG5vdCBiZWluZyBwcm9jZXNzZWQsCmkuZS4gbm8gaW50ZXJy
dXB0IGV2ZXIgb2NjdXJzIHRvIGluZGljYXRlIHRoZSBjb21tYW5kIGhhcyBjb21wbGV0ZWQuClRo
aXMgZmFpbHVyZSBjYW4gcmVzdWx0IGluIGEgZGVhZGxvY2suCgpUaGlzIHBhdGNoIHJlc2V0cyB0
aGUgZGF0YSBzdGF0ZSBtYWNoaW5lIHRvIGNsZWFyIHRoZSBlcnJvciBpbgpjYXNlIG9mIGEgY29t
bWFuZCB0aW1lb3V0LgoKVGVzdGVkIG9uIE9NQVAzNDMwIGNoaXAgYW5kIGludGVuc2l2ZSBNTUMv
U0QgZGV2aWNlIHJlbW92YWwgd2hpbGUKdHJhbnNmZXJyaW5nIGRhdGEuCgpTaWduZWQtb2ZmLWJ5
OiBBbmR5IExvd2UgPGFsb3dlQG12aXN0YS5jb20+ClNpZ25lZC1vZmYtYnk6IEplYW4gUGloZXQg
PGpwaWhldEBtdmlzdGEuY29tPgpTaWduZWQtb2ZmLWJ5OiBBZHJpYW4gSHVudGVyIDxleHQtYWRy
aWFuLmh1bnRlckBub2tpYS5jb20+Ci0tLQogZHJpdmVycy9tbWMvaG9zdC9vbWFwX2hzbW1jLmMg
fCAgICA5ICsrKysrKysrLQogMSBmaWxlcyBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDEgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tbWMvaG9zdC9vbWFwX2hzbW1jLmMgYi9k
cml2ZXJzL21tYy9ob3N0L29tYXBfaHNtbWMuYwppbmRleCBkNWMxZTlkLi45NzE1MGMwIDEwMDY0
NAotLS0gYS9kcml2ZXJzL21tYy9ob3N0L29tYXBfaHNtbWMuYworKysgYi9kcml2ZXJzL21tYy9o
b3N0L29tYXBfaHNtbWMuYwpAQCAtNDY0LDggKzQ2NCwxNSBAQCBzdGF0aWMgaXJxcmV0dXJuX3Qg
bW1jX29tYXBfaXJxKGludCBpcnEsIHZvaWQgKmRldl9pZCkKICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICB9CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZW5kX2NtZCA9IDE7
CiAgICAgICAgICAgICAgICAgICAgICAgIH0KLSAgICAgICAgICAgICAgICAgICAgICAgaWYgKGhv
c3QtPmRhdGEpCisgICAgICAgICAgICAgICAgICAgICAgIGlmIChob3N0LT5kYXRhKSB7CiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgbW1jX2RtYV9jbGVhbnVwKGhvc3QpOworICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIE9NQVBfSFNNTUNfV1JJVEUoaG9zdC0+YmFzZSwgU1lT
Q1RMLAorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgT01BUF9IU01NQ19S
RUFEKGhvc3QtPmJhc2UsCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgU1lTQ1RMKSB8IFNSRCk7CisgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgd2hpbGUgKE9NQVBfSFNNTUNfUkVBRChob3N0LT5iYXNlLAorICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBTWVNDVEwpICYgU1JEKQorICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgOworICAgICAgICAgICAgICAgICAgICAgICB9
CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICBpZiAoKHN0YXR1cyAmIERBVEFfVElN
RU9VVCkgfHwKICAgICAgICAgICAgICAgICAgICAgICAgKHN0YXR1cyAmIERBVEFfQ1JDKSkgewot
LQoxLjUuNC40LjIxLmdjNGE2YwoKCgpPbiBUaHVyc2RheSAwOCBKYW51YXJ5IDIwMDkgMTA6MDI6
MjQgQWRyaWFuIEh1bnRlciB3cm90ZToKPiBXaHkgbm90IGRvIHRoZSByZXNldCBpbiBtbWNfb21h
cF9pcnEoKSBsaWtlIHRoZSBvdGhlciByZXNldHM/Cj4gZS5nLgo+Cj4gc3RhdGljIGlycXJldHVy
bl90IG1tY19vbWFwX2lycShpbnQgaXJxLCB2b2lkICpkZXZfaWQpCj4gLi4uCj4goKCgoKCgoKCg
oKCgoKCgoGlmICgoc3RhdHVzICYgQ01EX1RJTUVPVVQpIHx8Cj4goKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgKHN0YXR1cyAmIENNRF9DUkMpKSB7Cj4goKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgaWYg
KGhvc3QtPmNtZCkgewo+IKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgaWYgKHN0YXR1
cyAmIENNRF9USU1FT1VUKSB7Cj4goKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoE9NQVBfSFNNTUNfV1JJVEUoaG9zdC0+YmFzZSwKPiBTWVNDVEwsIE9NQVBfSFNNTUNfUkVB
RChob3N0LT5iYXNlLCBTWVNDVEwpIHwgU1JDKTsgd2hpbGUKPiAoT01BUF9IU01NQ19SRUFEKGhv
c3QtPmJhc2UsIFNZU0NUTCkgJiBTUkMpIDsKPgo+IKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKBob3N0LT5jbWQtPmVycm9yID0gLUVUSU1FRE9VVDsKPiCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoH0gZWxzZSB7Cj4goKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoGhvc3QtPmNtZC0+ZXJyb3IgPSAtRUlMU0VROwo+IKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgfQo+IKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
ZW5kX2NtZCA9IDE7Cj4goKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgfQo+IC2goKCgoKCgoKCgoKCg
oKCgoKCgoKCgoGlmIChob3N0LT5kYXRhKQo+ICugoKCgoKCgoKCgoKCgoKCgoKCgoKCgoGlmICho
b3N0LT5kYXRhKSB7Cj4goKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKBtbWNfZG1hX2Ns
ZWFudXAoaG9zdCk7Cj4gK6CgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKBPTUFQX0hTTU1D
X1dSSVRFKGhvc3QtPmJhc2UsIFNZU0NUTCwKPiAroKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgT01BUF9IU01NQ19SRUFEKGhvc3QtPmJhc2UsCj4gK6CgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKBTWVNDVEwpIHwgU1JEKTsK
PiAroKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoHdoaWxlIChPTUFQX0hTTU1DX1JFQUQo
aG9zdC0+YmFzZSwKPiAroKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKBTWVNDVEwpICYgU1JEKQo+ICugoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKA7Cj4gK6CgoKCgoKCgoKCgoKCgoKCgoKCgoKCgfQo+IKCgoKCgoKCgoKCgoKCgoKB9Cj4g
oKCgoKCgoKCgoKCgoKCgoGlmICgoc3RhdHVzICYgREFUQV9USU1FT1VUKSB8fAo+IKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoChzdGF0dXMgJiBEQVRBX0NSQykpIHsKCgo=

--Boundary-00=_AheZJxIKecc/jAd
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="OMAP-MMC-recover-from-transfer-failures.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="OMAP-MMC-recover-from-transfer-failures.patch"

=46rom d143f6b2e705aa4e9d2b032097fd1c82f8163262 Mon Sep 17 00:00:00 2001
=46rom: Jean Pihet <jpihet@mvista.com>
Date: Thu, 8 Jan 2009 12:35:21 +0100
Subject: [PATCH] OMAP: MMC: recover from transfer failures

Timeouts during a command that has a data phase can result in the
next command issued after the command that failed not being processed,
i.e. no interrupt ever occurs to indicate the command has completed.
This failure can result in a deadlock.

This patch resets the data state machine to clear the error in
case of a command timeout.

Tested on OMAP3430 chip and intensive MMC/SD device removal while
transferring data.

Signed-off-by: Andy Lowe <alowe@mvista.com>
Signed-off-by: Jean Pihet <jpihet@mvista.com>
Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
=2D--
 drivers/mmc/host/omap_hsmmc.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index d5c1e9d..97150c0 100644
=2D-- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -464,8 +464,15 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 				}
 				end_cmd =3D 1;
 			}
=2D			if (host->data)
+			if (host->data) {
 				mmc_dma_cleanup(host);
+				OMAP_HSMMC_WRITE(host->base, SYSCTL,
+					OMAP_HSMMC_READ(host->base,
+							SYSCTL) | SRD);
+				while (OMAP_HSMMC_READ(host->base,
+						SYSCTL) & SRD)
+					;
+			}
 		}
 		if ((status & DATA_TIMEOUT) ||
 			(status & DATA_CRC)) {
=2D-=20
1.5.4.4.21.gc4a6c


--Boundary-00=_AheZJxIKecc/jAd--
