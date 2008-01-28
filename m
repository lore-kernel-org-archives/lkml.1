Return-Path: <linux-kernel-owner+w=401wt.eu-S1764495AbYA1XSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764495AbYA1XSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:18:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764367AbYA1XNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:13:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:43907 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764358AbYA1XNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:13:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=XzgN4+4VwubeFdz1aUlZMouQzSoo4rrvD0MiftK3+rU1DKUSsjx5qy/GT/MLWSAm7J/tIVyfAak2qI/8xRhj7sTF2aCs436iedBJ/EFr19CJ8zKYzonfB3CpRLNjCb1FS7VdMbC+kQM4wg16eZoCHiSCJIPRj0aALk7b1isfyBE=
Message-ID: <6101e8c40801281513g7c3ecca3kecd609f88dd3dd59@mail.gmail.com>
Date: Tue, 29 Jan 2008 00:13:48 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {09/17} - sony-laptop-call-sonypi_compat_init-earlier - series for stable kernel
Cc: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "Greg KH" <gregkh@suse.de>,
       "Willy Tarreau" <w@1wt.eu>, "Adrian Bunk" <bunk@kernel.org>,
       "Mattia Dongili" <malattia@linux.it>, "Len Brown" <len.brown@intel.com>,
       "Jeff Mahoney" <jeffm@suse.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_8112_31022209.1201562028985"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_8112_31022209.1201562028985
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
Thanks,
Oliver

------=_Part_8112_31022209.1201562028985
Content-Type: text/x-diff; name=sony-laptop-call-sonypi_compat_init-earlier
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment;
 filename=sony-laptop-call-sonypi_compat_init-earlier

Y29tbWl0IGU4MThlMmJkOTZkMTI4MGRiNzljOTM4M2IwNzAxM2I0MjUxNWVkZWQKQXV0aG9yOiBN
YXR0aWEgRG9uZ2lsaSA8bWFsYXR0aWFAbGludXguaXQ+CkRhdGU6ICAgU3VuIEF1ZyAxMiAwNzoy
MDoyNyAyMDA3ICswOTAwCgogICAgU3ViamVjdDogc29ueS1sYXB0b3A6IGNhbGwgc29ueXBpX2Nv
bXBhdF9pbml0IGVhcmxpZXIKICAgIFBhdGNoLW1haW5saW5lOiAyLjYuMjMKICAgIFJlZmVyZW5j
ZXM6IDM1MDk4NAogICAgCiAgICBzb255LWxhcHRvcDogY2FsbCBzb255cGlfY29tcGF0X2luaXQg
ZWFybGllcgogICAgCiAgICBzb255cGlfY29tcGF0IHVzZXMgYSBrZmlmbyB0aGF0IG5lZWRzIHRv
IGJlIHByZXNlbnQgYmVmb3JlIF9TUlMgaXMKICAgIGNhbGxlZCB0byBiZSBhYmxlIHRvIGNvcGUg
d2l0aCB0aGUgSVJRcyB0cmlnZ2VyZWQgd2hlbiBzZXR0aW5nCiAgICByZXNvdXJjZXMuCiAgICAK
ICAgIFNpZ25lZC1vZmYtYnk6IE1hdHRpYSBEb25naWxpIDxtYWxhdHRpYUBsaW51eC5pdD4KICAg
IFNpZ25lZC1vZmYtYnk6IExlbiBCcm93biA8bGVuLmJyb3duQGludGVsLmNvbT4KICAgIEFja2Vk
LWJ5OiBKZWZmIE1haG9uZXkgPGplZmZtQHN1c2UuY29tPgoKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bWlzYy9zb255LWxhcHRvcC5jIGIvZHJpdmVycy9taXNjL3NvbnktbGFwdG9wLmMKaW5kZXggYWIy
Y2E2My4uNmQyZDY0ZiAxMDA2NDQKLS0tIGEvZHJpdmVycy9taXNjL3NvbnktbGFwdG9wLmMKKysr
IGIvZHJpdmVycy9taXNjL3NvbnktbGFwdG9wLmMKQEAgLTIwNTYsOCArMjA1Niw2IEBAIHN0YXRp
YyBpbnQgc29ueV9waWNfcmVtb3ZlKHN0cnVjdCBhY3BpX2RldmljZSAqZGV2aWNlLCBpbnQgdHlw
ZSkKIAlzdHJ1Y3Qgc29ueV9waWNfaW9wb3J0ICppbywgKnRtcF9pbzsKIAlzdHJ1Y3Qgc29ueV9w
aWNfaXJxICppcnEsICp0bXBfaXJxOwogCi0Jc29ueXBpX2NvbXBhdF9leGl0KCk7Ci0KIAlpZiAo
c29ueV9waWNfZGlzYWJsZShkZXZpY2UpKSB7CiAJCXByaW50ayhLRVJOX0VSUiBEUlZfUEZYICJD
b3VsZG4ndCBkaXNhYmxlIGRldmljZS5cbiIpOwogCQlyZXR1cm4gLUVOWElPOwpAQCAtMjA2Nyw2
ICsyMDY1LDggQEAgc3RhdGljIGludCBzb255X3BpY19yZW1vdmUoc3RydWN0IGFjcGlfZGV2aWNl
ICpkZXZpY2UsIGludCB0eXBlKQogCXJlbGVhc2VfcmVnaW9uKHNwaWNfZGV2LmN1cl9pb3BvcnQt
PmlvLm1pbmltdW0sCiAJCQlzcGljX2Rldi5jdXJfaW9wb3J0LT5pby5hZGRyZXNzX2xlbmd0aCk7
CiAKKwlzb255cGlfY29tcGF0X2V4aXQoKTsKKwogCXNvbnlfbGFwdG9wX3JlbW92ZV9pbnB1dCgp
OwogCiAJLyogcGYgYXR0cnMgKi8KQEAgLTIxMzIsNiArMjEzMiw5IEBAIHN0YXRpYyBpbnQgc29u
eV9waWNfYWRkKHN0cnVjdCBhY3BpX2RldmljZSAqZGV2aWNlKQogCQlnb3RvIGVycl9mcmVlX3Jl
c291cmNlczsKIAl9CiAKKwlpZiAoc29ueXBpX2NvbXBhdF9pbml0KCkpCisJCWdvdG8gZXJyX3Jl
bW92ZV9pbnB1dDsKKwogCS8qIHJlcXVlc3QgaW8gcG9ydCAqLwogCWxpc3RfZm9yX2VhY2hfZW50
cnkoaW8sICZzcGljX2Rldi5pb3BvcnRzLCBsaXN0KSB7CiAJCWlmIChyZXF1ZXN0X3JlZ2lvbihp
by0+aW8ubWluaW11bSwgaW8tPmlvLmFkZHJlc3NfbGVuZ3RoLApAQCAtMjE0Niw3ICsyMTQ5LDcg
QEAgc3RhdGljIGludCBzb255X3BpY19hZGQoc3RydWN0IGFjcGlfZGV2aWNlICpkZXZpY2UpCiAJ
aWYgKCFzcGljX2Rldi5jdXJfaW9wb3J0KSB7CiAJCXByaW50ayhLRVJOX0VSUiBEUlZfUEZYICJG
YWlsZWQgdG8gcmVxdWVzdF9yZWdpb24uXG4iKTsKIAkJcmVzdWx0ID0gLUVOT0RFVjsKLQkJZ290
byBlcnJfcmVtb3ZlX2lucHV0OworCQlnb3RvIGVycl9yZW1vdmVfY29tcGF0OwogCX0KIAogCS8q
IHJlcXVlc3QgSVJRICovCkBAIC0yMTg2LDkgKzIxODksNiBAQCBzdGF0aWMgaW50IHNvbnlfcGlj
X2FkZChzdHJ1Y3QgYWNwaV9kZXZpY2UgKmRldmljZSkKIAlpZiAocmVzdWx0KQogCQlnb3RvIGVy
cl9yZW1vdmVfcGY7CiAKLQlpZiAoc29ueXBpX2NvbXBhdF9pbml0KCkpCi0JCWdvdG8gZXJyX3Jl
bW92ZV9wZjsKLQogCXJldHVybiAwOwogCiBlcnJfcmVtb3ZlX3BmOgpAQCAtMjIwNCw2ICsyMjA0
LDkgQEAgZXJyX3JlbGVhc2VfcmVnaW9uOgogCXJlbGVhc2VfcmVnaW9uKHNwaWNfZGV2LmN1cl9p
b3BvcnQtPmlvLm1pbmltdW0sCiAJCQlzcGljX2Rldi5jdXJfaW9wb3J0LT5pby5hZGRyZXNzX2xl
bmd0aCk7CiAKK2Vycl9yZW1vdmVfY29tcGF0OgorCXNvbnlwaV9jb21wYXRfZXhpdCgpOworCiBl
cnJfcmVtb3ZlX2lucHV0OgogCXNvbnlfbGFwdG9wX3JlbW92ZV9pbnB1dCgpOwogCg==
------=_Part_8112_31022209.1201562028985--
