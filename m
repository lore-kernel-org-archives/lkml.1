Return-Path: <linux-kernel-owner+w=401wt.eu-S933238AbXDKGDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238AbXDKGDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 02:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbXDKGDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 02:03:03 -0400
Received: from heidi.rubysoft.com ([64.34.164.143]:38556 "EHLO
	heidi.rubysoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbXDKGDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 02:03:02 -0400
X-Greylist: delayed 1255 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Apr 2007 02:03:02 EDT
Date: Tue, 10 Apr 2007 23:41:56 -0600 (MDT)
From: Jeff Hansen <x@jeffhansen.com>
X-X-Sender: ninkid@ren
Reply-To: Jeff Hansen <x@jeffhansen.com>
To: linux-kernel@vger.kernel.org
Subject: [patch] Broadcom 2045
Message-ID: <Pine.LNX.4.64.0704102341080.7108@ren>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463786750-63213924-1176270116=:7108"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463786750-63213924-1176270116=:7108
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

Here's a patch that enables the necessary SCO work-around for the Broadcom 
2045 chip, which comes in the most recent IOGear dongles.

-Jeff Hansen

---------------------------------------------------
"If someone's gotta do it, it might as well be me."
                 x@jeffhansen.com
---1463786750-63213924-1176270116=:7108
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=bc2045.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0704102341560.7108@ren>
Content-Description: 
Content-Disposition: attachment; filename=bc2045.patch

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvYmx1ZXRvb3RoL2hjaV91c2IuYyBiL2Ry
aXZlcnMvYmx1ZXRvb3RoL2hjaV91c2IuYw0KaW5kZXggNmJkZjU5My4uMTZl
YTg1NiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvYmx1ZXRvb3RoL2hjaV91c2Iu
Yw0KKysrIGIvZHJpdmVycy9ibHVldG9vdGgvaGNpX3VzYi5jDQpAQCAtMTE1
LDYgKzExNSw5IEBAIHN0YXRpYyBzdHJ1Y3QgdXNiX2RldmljZV9pZCBibGFj
a2xpc3RfaWRzW10gPSB7DQogCXsgVVNCX0RFVklDRSgweDBhNWMsIDB4MjAw
YSksIC5kcml2ZXJfaW5mbyA9IEhDSV9SRVNFVCB8IEhDSV9XUk9OR19TQ09f
TVRVIH0sDQogCXsgVVNCX0RFVklDRSgweDBhNWMsIDB4MjAwOSksIC5kcml2
ZXJfaW5mbyA9IEhDSV9CQ005MjAzNSB9LA0KIA0KKwkvKiBCcm9hZGNvbSBC
Q00yMDQ1ICovDQorCXsgVVNCX0RFVklDRSgweDBhNWMsIDB4MjEwMSksIC5k
cml2ZXJfaW5mbyA9IEhDSV9XUk9OR19TQ09fTVRVIH0sDQorDQogCS8qIElC
TS9MZW5vdm8gVGhpbmtQYWQgd2l0aCBCcm9hZGNvbSBjaGlwICovDQogCXsg
VVNCX0RFVklDRSgweDBhNWMsIDB4MjAxZSksIC5kcml2ZXJfaW5mbyA9IEhD
SV9XUk9OR19TQ09fTVRVIH0sDQogCXsgVVNCX0RFVklDRSgweDBhNWMsIDB4
MjExMCksIC5kcml2ZXJfaW5mbyA9IEhDSV9XUk9OR19TQ09fTVRVIH0sDQo=

---1463786750-63213924-1176270116=:7108--
