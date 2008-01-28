Return-Path: <linux-kernel-owner+w=401wt.eu-S1764373AbYA1XOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764373AbYA1XOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764293AbYA1XNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:13:21 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:42115 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764300AbYA1XNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:13:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=i/AN5Lpp7SO58cUr4z9Zn0R6CFczJtIDxpCEy5lYllI1pE5OzmijIFzpciwqfMaBZYeg4j9wbMB8HZoUSjvLhPZfxKnerJRORw1Ld33z6TNr3ZeGAM/QNRrdopKgXwFd3oJN66bJnXwctf/7RiDnOIQySo3VfWTdjmcpLW86xMM=
Message-ID: <6101e8c40801281513i74a39743j2dbfe764545cb834@mail.gmail.com>
Date: Tue, 29 Jan 2008 00:13:16 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {01/17} - do_anonymous_page-race - series for stable kernel
Cc: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "Greg KH" <gregkh@suse.de>,
       "Willy Tarreau" <w@1wt.eu>, "Adrian Bunk" <bunk@kernel.org>,
       "Andrea Arcangeli" <andrea@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_8095_22104236.1201561996736"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_8095_22104236.1201561996736
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
Thanks,
Oliver

------=_Part_8095_22104236.1201561996736
Content-Type: text/x-diff; name=do_anonymous_page-race
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment; filename=do_anonymous_page-race

Y29tbWl0IDgzMjdlMGYxOTEzNDFjYzMyZmI4OWJmNGQ3YmVlN2MyNTI0YWU0ZTAKQXV0aG9yOiBB
bmRyZWEgQXJjYW5nZWxpIDxhbmRyZWFAc3VzZS5kZT4KRGF0ZTogICBNb24gSmFuIDI4IDIwOjUy
OjI5IDIwMDggKzAxMDAKCiAgICBTdWJqZWN0OiBSYWNlIGNvbmRpdGlvbiBpbiB1c2Vyc3BhY2Ug
dGVzdGNhc2UKICAgIFJlZmVyZW5jZXM6IDQ2OTQ4LCBMVEMxMTU3NAogICAgCiAgICAKICAgIEFk
ZGl0aW9uYWwgQ29tbWVudCAjMTAzIEZyb20gQW5kcmVhIEFyY2FuZ2VsaSAyMDA0LTEwLTE1IDE5
OjQxCiAgICB0aGUgbGFzdCBwYXRjaCBJIGF0dGFjaGVkIGlzIHRoZSBzYWZlc3QgSSBiZWxpZXZl
LgogICAgCiAgICBJJ20gbm90IHN1cmUgaWYgYSBsb2NrX3VubG9jayBvciBsb2NrX3VubG9jayBp
cyBhbHdheXMgZ3VhcmFudGVlZCB0byBoYXBwZW4KICAgIGFmdGVyIHRoZSBJL08sIGFuZCB0aGlz
IG1ha2VzIHN1cmUgbm8gcmFjZSBjYW4gaGFwcGVuIGFueW1vcmUuCgpkaWZmIC0tZ2l0IGEvZnMv
YmlvLmMgYi9mcy9iaW8uYwppbmRleCAwOTMzNDVmLi45ODRkNTg5IDEwMDY0NAotLS0gYS9mcy9i
aW8uYworKysgYi9mcy9iaW8uYwpAQCAtMTAyOCw2ICsxMDI4LDE1IEBAIHZvaWQgYmlvX2VuZGlv
KHN0cnVjdCBiaW8gKmJpbywgdW5zaWduZWQgaW50IGJ5dGVzX2RvbmUsIGludCBlcnJvcikKIAli
aW8tPmJpX3NpemUgLT0gYnl0ZXNfZG9uZTsKIAliaW8tPmJpX3NlY3RvciArPSAoYnl0ZXNfZG9u
ZSA+PiA5KTsKIAorCWlmIChiaW9fZGF0YV9kaXIoYmlvKSA9PSBSRUFEKQorCQkvKgorCQkgKiBJ
ZiB0aGUgY3VycmVudCBjcHUgaGFzIHdyaXR0ZW4gdG8gdGhlIHBhZ2UgYnkgaGFuZAorCQkgKiB3
aXRob3V0IGRtYSwgd2UgbXVzdCBlbmZvcmNlIG9yZGVyaW5nIHRvIGJlIHN1cmUKKwkJICogdGhp
cyB3cml0dGVuIGRhdGEgd2lsbCBiZSB2aXNpYmxlIGJlZm9yZSB3ZSBleHBvc2UKKwkJICogdGhl
IHBhZ2UgY29udGVudHMgdG8gb3RoZXIgY3B1cyAoZm9yIGV4YW1wbGUgd2l0aAorCQkgKiBhIHNl
dF9wdGUpLgorCQkgKi8KKwkJc21wX3dtYigpOwogCWlmIChiaW8tPmJpX2VuZF9pbykKIAkJYmlv
LT5iaV9lbmRfaW8oYmlvLCBieXRlc19kb25lLCBlcnJvcik7CiB9Cg==
------=_Part_8095_22104236.1201561996736--
