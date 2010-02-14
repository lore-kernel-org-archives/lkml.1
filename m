Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535Ab0BNQOc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 11:14:32 -0500
Received: from mail-pz0-f197.google.com ([209.85.222.197]:36903 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab0BNQOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 11:14:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=WvgjXFCEF54DKHhCbplqWNCu3cPTRerQRgsZxMX2EhEOxi34iGF/AtTs5yrGmHc4fK
         p+dkVtu/hVzhkEy17cTF1c0B1MWgbjB8MCXigM+4EJ2/4FNciQcevuh+14S1mRA66ZBO
         J0oKClIc/d9Iy+54Rreh+25SN4TaJ5SZ6U3Ew=
MIME-Version: 1.0
From: =?UTF-8?B?5p2o5Z+O?= <gump.yang@gmail.com>
Date: Mon, 15 Feb 2010 00:14:08 +0800
Message-ID: <d4d4c7ef1002140814x5c406afaq7f60dc584e389348@mail.gmail.com>
Subject: apply chip ID
To: Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@marvell.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=000e0cd2e3ca815955047f91cbe4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd2e3ca815955047f91cbe4
Content-Type: text/plain; charset=ISO-8859-1

Hello everybody,

    My English very weak, can read don't write. My apply add new arm
chips ID, patch file in appendix. TKS

>From 5986e814ba1745b9371de943ce18e29147361bac Mon Sep 17 00:00:00 2001
From: Gump Yang <gump.yang@gmail.com>
Date: Fri, 12 Feb 2010 23:12:21 +0800
Subject: [PATCH 05/10] apply anyka chip ID
MIME-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit

Signed-off-by: Gump Yang <gump.yang@gmail.com>
---
 arch/arm/tools/mach-types |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/tools/mach-types b/arch/arm/tools/mach-types
index 07b976d..629b858 100644
--- a/arch/arm/tools/mach-types
+++ b/arch/arm/tools/mach-types
@@ -2635,3 +2635,4 @@ hw90240			MACH_HW90240		HW90240			2648
dm365_leopard		MACH_DM365_LEOPARD	DM365_LEOPARD		2649
mityomapl138		MACH_MITYOMAPL138	MITYOMAPL138		2650
scat110			MACH_SCAT110		SCAT110			2651
+ak780x			MACH_AK780X		AK780X			2557
+ak880x			MACH_AK880X		AK880X			2558
\ No newline at end of file
-- 
1.6.6.1



Gump Yang

--000e0cd2e3ca815955047f91cbe4
Content-Type: application/octet-stream; name="0005-CPU.patch"
Content-Disposition: attachment; filename="0005-CPU.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g5o12lix0

RnJvbSA1OTg2ZTgxNGJhMTc0NWI5MzcxZGU5NDNjZTE4ZTI5MTQ3MzYxYmFjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBHdW1wIFlhbmcgPGd1bXAueWFuZ0BnbWFpbC5jb20+CkRhdGU6
IEZyaSwgMTIgRmViIDIwMTAgMjM6MTI6MjEgKzA4MDAKU3ViamVjdDogW1BBVENIIDA1LzEwXSBh
cHBseSBhbnlrYSBjaGlwIElECk1JTUUtVmVyc2lvbjogMS4wCkNvbnRlbnQtVHlwZTogdGV4dC9w
bGFpbjsgY2hhcnNldD1nYmsKQ29udGVudC1UcmFuc2Zlci1FbmNvZGluZzogOGJpdAoKU2lnbmVk
LW9mZi1ieTogR3VtcCBZYW5nIDxndW1wLnlhbmdAZ21haWwuY29tPgotLS0KIGFyY2gvYXJtL3Rv
b2xzL21hY2gtdHlwZXMgfCAgICAxICsKIDEgZmlsZXMgY2hhbmdlZCwgMSBpbnNlcnRpb25zKCsp
LCAwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gvYXJtL3Rvb2xzL21hY2gtdHlwZXMg
Yi9hcmNoL2FybS90b29scy9tYWNoLXR5cGVzCmluZGV4IDA3Yjk3NmQuLjYyOWI4NTggMTAwNjQ0
Ci0tLSBhL2FyY2gvYXJtL3Rvb2xzL21hY2gtdHlwZXMKKysrIGIvYXJjaC9hcm0vdG9vbHMvbWFj
aC10eXBlcwpAQCAtMjYzNSwzICsyNjM1LDQgQEAgaHc5MDI0MAkJCU1BQ0hfSFc5MDI0MAkJSFc5
MDI0MAkJCTI2NDgKZG0zNjVfbGVvcGFyZAkJTUFDSF9ETTM2NV9MRU9QQVJECURNMzY1X0xFT1BB
UkQJCTI2NDkKbWl0eW9tYXBsMTM4CQlNQUNIX01JVFlPTUFQTDEzOAlNSVRZT01BUEwxMzgJCTI2
NTAKc2NhdDExMAkJCU1BQ0hfU0NBVDExMAkJU0NBVDExMAkJCTI2NTEKK2FrNzgweAkJCU1BQ0hf
QUs3ODBYCQlBSzc4MFgJCQkyNTU3Cithazg4MHgJCQlNQUNIX0FLODgwWAkJQUs4ODBYCQkJMjU1
OApcIE5vIG5ld2xpbmUgYXQgZW5kIG9mIGZpbGUKLS0gCjEuNi42LjEKCg==
--000e0cd2e3ca815955047f91cbe4--
