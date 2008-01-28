Return-Path: <linux-kernel-owner+w=401wt.eu-S1752002AbYA1XVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbYA1XVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:21:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764403AbYA1XON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:14:13 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:44024 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892AbYA1XOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:14:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=S/rQIgPLYkcdKTD/M1fdKFIf0b6YRKrdQ0wOM+3SbuRcLpR9bXVsm75/rRarx79Bmc/UxzuMpK3WstjQEAmGa94EhoRqHvjRqO289lKaxGVzykvIPVGdYBiDgcLoQtncyCzGMl0KQaEdGLEg6tm8QVR68v8DvU9cKa8NGlu/nbs=
Message-ID: <6101e8c40801281514w10ecca6eo87bb2b985ba17ced@mail.gmail.com>
Date: Tue, 29 Jan 2008 00:14:05 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {15/17} - nfs-unmount-leak.patch - series for stable kernel
Cc: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "Greg KH" <gregkh@suse.de>,
       "Willy Tarreau" <w@1wt.eu>, "Adrian Bunk" <bunk@kernel.org>,
       "Trond Myklebust" <Trond.Myklebust@netapp.com>,
       "Neil Brown" <neilb@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_8127_8606776.1201562045713"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_8127_8606776.1201562045713
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
Thanks,
Oliver

------=_Part_8127_8606776.1201562045713
Content-Type: text/x-diff; name=nfs-unmount-leak.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment; filename=nfs-unmount-leak.patch

Y29tbWl0IDIyY2U5NmU0YTBhZGI1OTIyMzAzOWUzYTc5ZDZjNTkwZGNhNjAzMjQKQXV0aG9yOiBU
cm9uZCBNeWtsZWJ1c3QgPFRyb25kLk15a2xlYnVzdEBuZXRhcHAuY29tPgpEYXRlOiAgIFR1ZSBE
ZWMgMTEgMTE6MDU6MTkgMjAwNyAtMDUwMAoKICAgIFN1YmplY3Q6IE5GU3YyL3YzOiBGaXggYSBt
ZW1vcnkgbGVhayB3aGVuIHVzaW5nIC1vbm9sb2NrCiAgICBQYXRjaC1tYWlubGluZTogMi42LjI0
CiAgICBSZWZlcmVuY2VzOiAzMzYyNTMKICAgIAogICAgCiAgICAKICAgICAgICBOZWlsIEJyb3du
IHNhaWQ6CiAgICAgICAgPiBIaSBUcm9uZCwKICAgICAgICA+CiAgICAgICAgPiBXZSBmb3VuZCB0
aGF0IGEgbWFjaGluZSB3aGljaCBtYWRlIG1vZGVyYXRlbHkgaGVhdnkgdXNlIG9mCiAgICAgICAg
PiAnYXV0b21vdW50JyB3YXMgbGVha2luZyBzb21lIG5mcyBkYXRhIHN0cnVjdHVyZXMgLSBwYXJ0
aWN1bGFybHkgdGhlCiAgICAgICAgPiA0SyBhbGxvY2F0ZWQgYnkgcnBjX2FsbG9jX2lvc3RhdHMu
CiAgICAgICAgPiBJdCB0dXJucyBvdXQgdGhhdCB0aGlzIG9ubHkgaGFwcGVucyB3aXRoIGZpbGVz
eXN0ZW1zIHdpdGggLW9ub2xvY2sKICAgICAgICA+IHNldC4KICAgIAogICAgICAgID4gVGhlIHBy
b2JsZW0gaXMgdGhhdCBpZiBORlNfTU9VTlRfTk9OTE0gaXMgc2V0LCBuZnNfc3RhcnRfbG9ja2Qg
ZG9lc24ndAogICAgICAgID4gc2V0IHNlcnZlci0+ZGVzdHJveSwgc28gd2hlbiB0aGUgZmlsZXN5
c3RlbSBpcyB1bm1vdW50ZWQsIHRoZQogICAgICAgID4gLT5jbGllbnRfYWNsIGlzIG5vdCBzaHV0
ZG93biwgYW5kIHNvIHNldmVyYWwgcmVzb3VyY2VzIGFyZSBzdGlsbAogICAgICAgID4gaGVsZC4g
IE11bHRpcGxlIG1vdW50L3Vtb3VudCBjeWNsZXMgd2lsbCBzbG93bHkgZWF0IGF3YXkgbWVtb3J5
CiAgICAgICAgPiBzZXZlcmFsIHBhZ2VzIGF0IGEgdGltZS4KICAgIAogICAgICAgIFNpZ25lZC1v
ZmYtYnk6IFRyb25kIE15a2xlYnVzdCA8VHJvbmQuTXlrbGVidXN0QG5ldGFwcC5jb20+CiAgICAK
ICAgIEFja2VkLWJ5OiBOZWlsIEJyb3duIDxuZWlsYkBzdXNlLmRlPgogICAgU2lnbmVkLW9mZi1i
eTogTmVpbCBCcm93biA8bmVpbGJAc3VzZS5kZT4KCmRpZmYgLS1naXQgYS9mcy9uZnMvY2xpZW50
LmMgYi9mcy9uZnMvY2xpZW50LmMKaW5kZXggYWFmNGIwNC4uYjZmZDhhNyAxMDA2NDQKLS0tIGEv
ZnMvbmZzL2NsaWVudC5jCisrKyBiL2ZzL25mcy9jbGllbnQuYwpAQCAtNDMzLDkgKzQzMyw2IEBA
IHN0YXRpYyBpbnQgbmZzX2NyZWF0ZV9ycGNfY2xpZW50KHN0cnVjdCBuZnNfY2xpZW50ICpjbHAs
IGludCBwcm90bywKICAqLwogc3RhdGljIHZvaWQgbmZzX2Rlc3Ryb3lfc2VydmVyKHN0cnVjdCBu
ZnNfc2VydmVyICpzZXJ2ZXIpCiB7Ci0JaWYgKCFJU19FUlIoc2VydmVyLT5jbGllbnRfYWNsKSkK
LQkJcnBjX3NodXRkb3duX2NsaWVudChzZXJ2ZXItPmNsaWVudF9hY2wpOwotCiAJaWYgKCEoc2Vy
dmVyLT5mbGFncyAmIE5GU19NT1VOVF9OT05MTSkpCiAJCWxvY2tkX2Rvd24oKTsJLyogcmVsZWFz
ZSBycGMubG9ja2QgKi8KIH0KQEAgLTc3MSw2ICs3NjgsOSBAQCB2b2lkIG5mc19mcmVlX3NlcnZl
cihzdHJ1Y3QgbmZzX3NlcnZlciAqc2VydmVyKQogCiAJaWYgKHNlcnZlci0+ZGVzdHJveSAhPSBO
VUxMKQogCQlzZXJ2ZXItPmRlc3Ryb3koc2VydmVyKTsKKworCWlmICghSVNfRVJSKHNlcnZlci0+
Y2xpZW50X2FjbCkpCisJCXJwY19zaHV0ZG93bl9jbGllbnQoc2VydmVyLT5jbGllbnRfYWNsKTsK
IAlpZiAoIUlTX0VSUihzZXJ2ZXItPmNsaWVudCkpCiAJCXJwY19zaHV0ZG93bl9jbGllbnQoc2Vy
dmVyLT5jbGllbnQpOwogCg==
------=_Part_8127_8606776.1201562045713--
