Return-Path: <linux-kernel-owner+w=401wt.eu-S1764830AbYA1XSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764830AbYA1XSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:18:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764368AbYA1XNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:13:55 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:43907 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762890AbYA1XNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:13:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=iyd9usNHi/D4pp18Lf/WE6B10eEacOrmwh1Ae7fA/e/txA5DzA+C7qgNRVXaOlO7lQ1vynmGnTSsVCS0/rG7Yqv/MhM+uKuJ3vz3TYmzrV1X/oCDGI4BoBX4E0FF7CSJXTr4VvQgbT80nTYPvnElPWgpRfKrQSjVrJx0/nfD6v0=
Message-ID: <6101e8c40801281513j4b561dfdv52406f31bf313284@mail.gmail.com>
Date: Tue, 29 Jan 2008 00:13:51 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {10/17} - via-velocity-dont-oops-on-mtu-change-1 - series for stable kernel
Cc: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "Greg KH" <gregkh@suse.de>,
       "Willy Tarreau" <w@1wt.eu>, "Adrian Bunk" <bunk@kernel.org>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Jeff Mahoney" <jeffm@suse.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_8114_12725345.1201562031741"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_8114_12725345.1201562031741
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
Thanks,
Oliver

------=_Part_8114_12725345.1201562031741
Content-Type: text/x-diff; name=via-velocity-dont-oops-on-mtu-change-1
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment;
 filename=via-velocity-dont-oops-on-mtu-change-1

Y29tbWl0IGNlZmUwYjIwNWJjNDYxOTViZDNkNzI3YzNhNjRkMTMxNWViMzQ4ZDEKQXV0aG9yOiBT
dGVwaGVuIEhlbW1pbmdlciA8c2hlbW1pbmdlckBsaW51eC1mb3VuZGF0aW9uLm9yZz4KRGF0ZTog
ICBUaHUgTm92IDE1IDAzOjQ3OjI3IDIwMDcgLTA4MDAKCiAgICBTdWJqZWN0OiBbVklBX1ZFTE9D
SVRZXTogRG9uJ3Qgb29wcyBvbiBNVFUgY2hhbmdlLgogICAgUGF0Y2gtbWFpbmxpbmU6IHYyLjYu
MjQtcmMzCiAgICBSZWZlcmVuY2VzOiAzNDE1MzcKICAgIAogICAgW1ZJQV9WRUxPQ0lUWV06IERv
bid0IG9vcHMgb24gTVRVIGNoYW5nZS4KICAgIAogICAgU2ltcGxlIG10dSBjaGFuZ2Ugd2hlbiBk
ZXZpY2UgaXMgZG93bi4KICAgIEZpeCBodHRwOi8vYnVnemlsbGEua2VybmVsLm9yZy9zaG93X2J1
Zy5jZ2k/aWQ9OTM4Mi4KICAgIAogICAgU2lnbmVkLW9mZi1ieTogU3RlcGhlbiBIZW1taW5nZXIg
PHNoZW1taW5nZXJAbGludXgtZm91bmRhdGlvbi5vcmc+CiAgICBTaWduZWQtb2ZmLWJ5OiBEYXZp
ZCBTLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+CiAgICBBY2tlZC1ieTogSmVmZiBNYWhv
bmV5IDxqZWZmbUBzdXNlLmNvbT4KCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC92aWEtdmVsb2Np
dHkuYyBiL2RyaXZlcnMvbmV0L3ZpYS12ZWxvY2l0eS5jCmluZGV4IGI2NzBiOTcuLjYzYTJmODEg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3ZpYS12ZWxvY2l0eS5jCisrKyBiL2RyaXZlcnMvbmV0
L3ZpYS12ZWxvY2l0eS5jCkBAIC0xNzk4LDYgKzE3OTgsMTEgQEAgc3RhdGljIGludCB2ZWxvY2l0
eV9jaGFuZ2VfbXR1KHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsIGludCBuZXdfbXR1KQogCQlyZXR1
cm4gLUVJTlZBTDsKIAl9CiAKKwlpZiAoIW5ldGlmX3J1bm5pbmcoZGV2KSkgeworCQlkZXYtPm10
dSA9IG5ld19tdHU7CisJCXJldHVybiAwOworCX0KKwogCWlmIChuZXdfbXR1ICE9IG9sZG10dSkg
ewogCQlzcGluX2xvY2tfaXJxc2F2ZSgmdnB0ci0+bG9jaywgZmxhZ3MpOwogCg==
------=_Part_8114_12725345.1201562031741--
