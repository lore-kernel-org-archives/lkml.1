Return-Path: <linux-kernel-owner+w=401wt.eu-S1764240AbYA1XTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764240AbYA1XTB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:19:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764399AbYA1XN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:13:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:43907 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764376AbYA1XN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:13:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=e0eEsA6MB+CH4MVp/iTTJgp8WMDW5qI8e75QNhONOlTGpS/6yHbyLMKROo/gteMQSo2K6aVcRuZmGMMpTjqshnIlUpMn9ucrmPIoPB7X7irGqTSca7SCFGfiNDe/y+XWZI9CTzTO5yFq+K1acIMqAXmEVwizv4qXWSwtVT2aA38=
Message-ID: <6101e8c40801281513j3559de4fs50885ee59bb87426@mail.gmail.com>
Date: Tue, 29 Jan 2008 00:13:55 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {11/17} - via-velocity-dont-oops-on-mtu-change-2 - series for stable kernel
Cc: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "Greg KH" <gregkh@suse.de>,
       "Willy Tarreau" <w@1wt.eu>, "Adrian Bunk" <bunk@kernel.org>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Jeff Mahoney" <jeffm@suse.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_8117_32186455.1201562035639"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_8117_32186455.1201562035639
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
Thanks,
Oliver

------=_Part_8117_32186455.1201562035639
Content-Type: text/x-diff; name=via-velocity-dont-oops-on-mtu-change-2
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment;
 filename=via-velocity-dont-oops-on-mtu-change-2

Y29tbWl0IGQ4YTcxYTVlNmU0ZDEwZDE0NmY4NjBiNTE2YzA4ZDVlOGZjMWNkZTQKQXV0aG9yOiBT
dGVwaGVuIEhlbW1pbmdlciA8c2hlbW1pbmdlckBsaW51eC1mb3VuZGF0aW9uLm9yZz4KRGF0ZTog
ICBXZWQgTm92IDI4IDIyOjIwOjE2IDIwMDcgLTA4MDAKCiAgICBTdWJqZWN0OiB2aWEtdmVsb2Np
dHk6IGRvbid0IG9vcHMgb24gTVRVIGNoYW5nZSAocmVzZW5kKQogICAgUGF0Y2gtbWFpbmxpbmU6
IHYyLjYuMjQtcmM0CiAgICBSZWZlcmVuY2VzOiAzNDE1MzcKICAgIAogICAgdmlhLXZlbG9jaXR5
OiBkb24ndCBvb3BzIG9uIE1UVSBjaGFuZ2UgKHJlc2VuZCkKICAgIAogICAgVGhlIFZJQSB2ZWxv
aWN0eSBkcml2ZXIgbmVlZHMgdGhlIGZvbGxvd2luZyB0byBhbGxvdyBjaGFuZ2luZyBNVFUgd2hl
biBkb3duLgogICAgVGhlIGJ1ZmZlciBzaXplIG5lZWRzIHRvIGJlIGNvbXB1dGVkIHdoZW4gZGV2
aWNlIGlzIGJyb3VnaHQgdXAsIG5vdCB3aGVuCiAgICBkZXZpY2UgaXMgaW5pdGlhbGl6ZWQuICBU
aGlzIGFsc28gZml4ZXMgYSBidWcgd2hlcmUgdGhlIGJ1ZmZlciBzaXplIHdhcwogICAgY29tcHV0
ZWQgZGlmZmVyZW50bHkgb24gY2hhbmdlX210dSB2ZXJzdXMgaW5pdGlhbCBzZXR0aW5nLgogICAg
CiAgICBTaWduZWQtb2ZmLWJ5OiBTdGVwaGVuIEhlbW1pbmdlciA8c2hlbW1pbmdlckBsaW51eC1m
b3VuZGF0aW9uLm9yZz4KICAgIFNpZ25lZC1vZmYtYnk6IEplZmYgR2FyemlrIDxqZWZmQGdhcnpp
ay5vcmc+CiAgICBBY2tlZC1ieTogSmVmZiBNYWhvbmV5IDxqZWZmbUBzdXNlLmNvbT4KCmRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC92aWEtdmVsb2NpdHkuYyBiL2RyaXZlcnMvbmV0L3ZpYS12ZWxv
Y2l0eS5jCmluZGV4IDYzYTJmODEuLjQzMTI2OWUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3Zp
YS12ZWxvY2l0eS5jCisrKyBiL2RyaXZlcnMvbmV0L3ZpYS12ZWxvY2l0eS5jCkBAIC0xMDc1LDYg
KzEwNzUsOSBAQCBzdGF0aWMgaW50IHZlbG9jaXR5X2luaXRfcmRfcmluZyhzdHJ1Y3QgdmVsb2Np
dHlfaW5mbyAqdnB0cikKIAlpbnQgcmV0ID0gLUVOT01FTTsKIAl1bnNpZ25lZCBpbnQgcnNpemUg
PSBzaXplb2Yoc3RydWN0IHZlbG9jaXR5X3JkX2luZm8pICoKIAkJCQkJdnB0ci0+b3B0aW9ucy5u
dW1yeDsKKwlpbnQgbXR1ID0gdnB0ci0+ZGV2LT5tdHU7CisKKwl2cHRyLT5yeF9idWZfc3ogPSAo
bXR1IDw9IEVUSF9EQVRBX0xFTikgPyBQS1RfQlVGX1NaIDogbXR1ICsgMzI7CiAKIAl2cHRyLT5y
ZF9pbmZvID0ga21hbGxvYyhyc2l6ZSwgR0ZQX0tFUk5FTCk7CiAJaWYodnB0ci0+cmRfaW5mbyA9
PSBOVUxMKQpAQCAtMTczMyw4ICsxNzM2LDYgQEAgc3RhdGljIGludCB2ZWxvY2l0eV9vcGVuKHN0
cnVjdCBuZXRfZGV2aWNlICpkZXYpCiAJc3RydWN0IHZlbG9jaXR5X2luZm8gKnZwdHIgPSBuZXRk
ZXZfcHJpdihkZXYpOwogCWludCByZXQ7CiAKLQl2cHRyLT5yeF9idWZfc3ogPSAoZGV2LT5tdHUg
PD0gMTUwNCA/IFBLVF9CVUZfU1ogOiBkZXYtPm10dSArIDMyKTsKLQogCXJldCA9IHZlbG9jaXR5
X2luaXRfcmluZ3ModnB0cik7CiAJaWYgKHJldCA8IDApCiAJCWdvdG8gb3V0OwpAQCAtMTgxMywx
MiArMTgxNCw2IEBAIHN0YXRpYyBpbnQgdmVsb2NpdHlfY2hhbmdlX210dShzdHJ1Y3QgbmV0X2Rl
dmljZSAqZGV2LCBpbnQgbmV3X210dSkKIAkJdmVsb2NpdHlfZnJlZV9yZF9yaW5nKHZwdHIpOwog
CiAJCWRldi0+bXR1ID0gbmV3X210dTsKLQkJaWYgKG5ld19tdHUgPiA4MTkyKQotCQkJdnB0ci0+
cnhfYnVmX3N6ID0gOSAqIDEwMjQ7Ci0JCWVsc2UgaWYgKG5ld19tdHUgPiA0MDk2KQotCQkJdnB0
ci0+cnhfYnVmX3N6ID0gODE5MjsKLQkJZWxzZQotCQkJdnB0ci0+cnhfYnVmX3N6ID0gNCAqIDEw
MjQ7CiAKIAkJcmV0ID0gdmVsb2NpdHlfaW5pdF9yZF9yaW5nKHZwdHIpOwogCQlpZiAocmV0IDwg
MCkK
------=_Part_8117_32186455.1201562035639--
