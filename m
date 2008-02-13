Return-Path: <linux-kernel-owner+w=401wt.eu-S1758793AbYBMLE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793AbYBMLE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 06:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYBMLEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 06:04:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:28708 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbYBMLEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 06:04:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,345,1199692800"; 
   d="scan'208";a="298129087"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C86E30.055E968E"
Subject: RE: [Bug-fix]:2.6.25-rc0 Generic thermal management [Patch 1/2]: validating input parameters
Date: Wed, 13 Feb 2008 16:33:10 +0530
Message-ID: <05B550FD4BD2014E841D83547B62600802A6BA72@bgsmsx411.gar.corp.intel.com>
In-Reply-To: <20080212133446.a521a8bb.akpm@linux-foundation.org>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [Bug-fix]:2.6.25-rc0 Generic thermal management [Patch 1/2]: validating input parameters
Thread-Index: Achtv8msotjLRyXUQO6aKLd5Z1jGygAbxPkA
References: <05B550FD4BD2014E841D83547B62600802A3A1B0@bgsmsx411.gar.corp.intel.com><20080211133827.16140ba0.akpm@linux-foundation.org><05B550FD4BD2014E841D83547B62600802A6B2A7@bgsmsx411.gar.corp.intel.com> <20080212133446.a521a8bb.akpm@linux-foundation.org>
From: "Thomas, Sujith" <sujith.thomas@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <lenb@kernel.org>, <mingo@elte.hu>, <torvalds@linux-foundation.org>,
       <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <linux-pm@lists.linux-foundation.org>,
       "Zhang, Rui" <rui.zhang@intel.com>
X-OriginalArrivalTime: 13 Feb 2008 11:03:15.0561 (UTC) FILETIME=[083AB590:01C86E30]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C86E30.055E968E
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

=20
Hi Andrew,
	For time being I am attaching the patch and in the meanwhile
I'll figure out
a way to fix the wordwrap issues. This was what Len Brown also had
recommended.

Regards,
Sujith
> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org]=20
> Sent: Wednesday, February 13, 2008 3:05 AM
> To: Thomas, Sujith
> Cc: lenb@kernel.org; mingo@elte.hu;=20
> torvalds@linux-foundation.org; linux-acpi@vger.kernel.org;=20
> linux-kernel@vger.kernel.org;=20
> linux-pm@lists.linux-foundation.org; Zhang, Rui
> Subject: Re: [Bug-fix]:2.6.25-rc0 Generic thermal management=20
> [Patch 1/2]: validating input parameters
>=20
> On Tue, 12 Feb 2008 21:27:44 +0530
> "Thomas, Sujith" <sujith.thomas@intel.com> wrote:
>=20
> > > The patch is fairly seriously wordwrapped.
> > Should be fixed now.
>=20
> No, even after I fixed all the wordwrapping I saw a large amount
> of fuzz and several rejects when trying to apply the patch.
>=20
> There's a reason why Len uses his kernel.org account to get=20
> real work done ;)
>=20

------_=_NextPart_001_01C86E30.055E968E
Content-Type: application/octet-stream;
	name="[Bug-fix]2.6.25-rc0 Generic thermal management [Patch 1 of 2]"
Content-Transfer-Encoding: base64
Content-Description: [Bug-fix]2.6.25-rc0 Generic thermal management [Patch 1 of 2]
Content-Disposition: attachment;
	filename="[Bug-fix]2.6.25-rc0 Generic thermal management [Patch 1 of 2]"

IGRyaXZlcnMvdGhlcm1hbC90aGVybWFsLmMgfCAgIDYzICsrKysrKysrKysrKysrKysrKysrKysr
KysrKy0tLS0tLS0tLS0tLS0tLS0tLS0KIDEgZmlsZXMgY2hhbmdlZCwgMzggaW5zZXJ0aW9ucygr
KSwgMjUgZGVsZXRpb25zKC0pCgpJbmRleDogbGludXgtMi42LjI0LXJjMy9kcml2ZXJzL3RoZXJt
YWwvdGhlcm1hbC5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi4yNC1yYzMub3JpZy9kcml2ZXJz
L3RoZXJtYWwvdGhlcm1hbC5jCisrKyBsaW51eC0yLjYuMjQtcmMzL2RyaXZlcnMvdGhlcm1hbC90
aGVybWFsLmMKQEAgLTMwMSwxMyArMzAxLDI0IEBAIGludCB0aGVybWFsX3pvbmVfYmluZF9jb29s
aW5nX2RldmljZShzdHIKIHsKIAlzdHJ1Y3QgdGhlcm1hbF9jb29saW5nX2RldmljZV9pbnN0YW5j
ZSAqZGV2OwogCXN0cnVjdCB0aGVybWFsX2Nvb2xpbmdfZGV2aWNlX2luc3RhbmNlICpwb3M7CisJ
c3RydWN0IHRoZXJtYWxfem9uZV9kZXZpY2UgKnBvczE7CisJc3RydWN0IHRoZXJtYWxfY29vbGlu
Z19kZXZpY2UgKnBvczI7CiAJaW50IHJlc3VsdDsKIAogCWlmICh0cmlwID49IHR6LT50cmlwcyB8
fAogCSAgICAodHJpcCA8IDAgJiYgdHJpcCAhPSBUSEVSTUFMX1RSSVBTX05PTkUpKQogCQlyZXR1
cm4gLUVJTlZBTDsKIAotCWlmICghdHogfHwgIWNkZXYpCisJbGlzdF9mb3JfZWFjaF9lbnRyeShw
b3MxLCAmdGhlcm1hbF90el9saXN0LCBub2RlKSB7CisJCWlmIChwb3MxID09IHR6KQorCQkJYnJl
YWs7CisJfQorCWxpc3RfZm9yX2VhY2hfZW50cnkocG9zMiwgJnRoZXJtYWxfY2Rldl9saXN0LCBu
b2RlKSB7CisJCWlmIChwb3MyID09IGNkZXYpCisJCQlicmVhazsKKwl9CisKKwlpZiAodHogIT0g
cG9zMSB8fCBjZGV2ICE9IHBvczIpCiAJCXJldHVybiAtRUlOVkFMOwogCiAJZGV2ID0KQEAgLTQy
NywyMSArNDM4LDI0IEBAIHN0cnVjdCB0aGVybWFsX2Nvb2xpbmdfZGV2aWNlICp0aGVybWFsX2MK
IAlzdHJ1Y3QgdGhlcm1hbF96b25lX2RldmljZSAqcG9zOwogCWludCByZXN1bHQ7CiAKKwlpZiAo
IXR5cGUpCisJCXJldHVybiBFUlJfUFRSKC1FSU5WQUwpOworCiAJaWYgKHN0cmxlbih0eXBlKSA+
PSBUSEVSTUFMX05BTUVfTEVOR1RIKQotCQlyZXR1cm4gTlVMTDsKKwkJcmV0dXJuIEVSUl9QVFIo
LUVJTlZBTCk7CiAKIAlpZiAoIW9wcyB8fCAhb3BzLT5nZXRfbWF4X3N0YXRlIHx8ICFvcHMtPmdl
dF9jdXJfc3RhdGUgfHwKIAkJIW9wcy0+c2V0X2N1cl9zdGF0ZSkKLQkJcmV0dXJuIE5VTEw7CisJ
CXJldHVybiBFUlJfUFRSKC1FSU5WQUwpOwogCiAJY2RldiA9IGt6YWxsb2Moc2l6ZW9mKHN0cnVj
dCB0aGVybWFsX2Nvb2xpbmdfZGV2aWNlKSwgR0ZQX0tFUk5FTCk7CiAJaWYgKCFjZGV2KQotCQly
ZXR1cm4gTlVMTDsKKwkJcmV0dXJuIEVSUl9QVFIoLUVOT01FTSk7CiAKIAlyZXN1bHQgPSBnZXRf
aWRyKCZ0aGVybWFsX2NkZXZfaWRyLCAmdGhlcm1hbF9pZHJfbG9jaywgJmNkZXYtPmlkKTsKIAlp
ZiAocmVzdWx0KSB7CiAJCWtmcmVlKGNkZXYpOwotCQlyZXR1cm4gTlVMTDsKKwkJcmV0dXJuIEVS
Ul9QVFIocmVzdWx0KTsKIAl9CiAKIAlzdHJjcHkoY2Rldi0+dHlwZSwgdHlwZSk7CkBAIC00NTMs
MTYgKzQ2NywxNCBAQCBzdHJ1Y3QgdGhlcm1hbF9jb29saW5nX2RldmljZSAqdGhlcm1hbF9jCiAJ
aWYgKHJlc3VsdCkgewogCQlyZWxlYXNlX2lkcigmdGhlcm1hbF9jZGV2X2lkciwgJnRoZXJtYWxf
aWRyX2xvY2ssIGNkZXYtPmlkKTsKIAkJa2ZyZWUoY2Rldik7Ci0JCXJldHVybiBOVUxMOworCQly
ZXR1cm4gRVJSX1BUUihyZXN1bHQpOwogCX0KIAogCS8qIHN5cyBJL0YgKi8KLQlpZiAodHlwZSkg
ewotCQlyZXN1bHQgPSBkZXZpY2VfY3JlYXRlX2ZpbGUoJmNkZXYtPmRldmljZSwKLQkJCQkJICAg
ICZkZXZfYXR0cl9jZGV2X3R5cGUpOwotCQlpZiAocmVzdWx0KQotCQkJZ290byB1bnJlZ2lzdGVy
OwotCX0KKwlyZXN1bHQgPSBkZXZpY2VfY3JlYXRlX2ZpbGUoJmNkZXYtPmRldmljZSwKKwkJCQkg
ICAgJmRldl9hdHRyX2NkZXZfdHlwZSk7CisJaWYgKHJlc3VsdCkKKwkJZ290byB1bnJlZ2lzdGVy
OwogCiAJcmVzdWx0ID0gZGV2aWNlX2NyZWF0ZV9maWxlKCZjZGV2LT5kZXZpY2UsICZkZXZfYXR0
cl9tYXhfc3RhdGUpOwogCWlmIChyZXN1bHQpCkBAIC00OTAsNyArNTAyLDcgQEAgc3RydWN0IHRo
ZXJtYWxfY29vbGluZ19kZXZpY2UgKnRoZXJtYWxfYwogICAgICAgdW5yZWdpc3RlcjoKIAlyZWxl
YXNlX2lkcigmdGhlcm1hbF9jZGV2X2lkciwgJnRoZXJtYWxfaWRyX2xvY2ssIGNkZXYtPmlkKTsK
IAlkZXZpY2VfdW5yZWdpc3RlcigmY2Rldi0+ZGV2aWNlKTsKLQlyZXR1cm4gTlVMTDsKKwlyZXR1
cm4gRVJSX1BUUihyZXN1bHQpOwogfQogRVhQT1JUX1NZTUJPTCh0aGVybWFsX2Nvb2xpbmdfZGV2
aWNlX3JlZ2lzdGVyKTsKIApAQCAtNTU5LDE4ICs1NzEsMjEgQEAgc3RydWN0IHRoZXJtYWxfem9u
ZV9kZXZpY2UgKnRoZXJtYWxfem9uZQogCWludCByZXN1bHQ7CiAJaW50IGNvdW50OwogCisJaWYg
KCF0eXBlKQorCQlyZXR1cm4gRVJSX1BUUigtRUlOVkFMKTsKKwogCWlmIChzdHJsZW4odHlwZSkg
Pj0gVEhFUk1BTF9OQU1FX0xFTkdUSCkKLQkJcmV0dXJuIE5VTEw7CisJCXJldHVybiBFUlJfUFRS
KC1FSU5WQUwpOwogCiAJaWYgKHRyaXBzID4gVEhFUk1BTF9NQVhfVFJJUFMgfHwgdHJpcHMgPCAw
KQotCQlyZXR1cm4gTlVMTDsKKwkJcmV0dXJuIEVSUl9QVFIoLUVJTlZBTCk7CiAKIAlpZiAoIW9w
cyB8fCAhb3BzLT5nZXRfdGVtcCkKLQkJcmV0dXJuIE5VTEw7CisJCXJldHVybiBFUlJfUFRSKC1F
SU5WQUwpOwogCiAJdHogPSBremFsbG9jKHNpemVvZihzdHJ1Y3QgdGhlcm1hbF96b25lX2Rldmlj
ZSksIEdGUF9LRVJORUwpOwogCWlmICghdHopCi0JCXJldHVybiBOVUxMOworCQlyZXR1cm4gRVJS
X1BUUigtRU5PTUVNKTsKIAogCUlOSVRfTElTVF9IRUFEKCZ0ei0+Y29vbGluZ19kZXZpY2VzKTsK
IAlpZHJfaW5pdCgmdHotPmlkcik7CkBAIC01NzgsNyArNTkzLDcgQEAgc3RydWN0IHRoZXJtYWxf
em9uZV9kZXZpY2UgKnRoZXJtYWxfem9uZQogCXJlc3VsdCA9IGdldF9pZHIoJnRoZXJtYWxfdHpf
aWRyLCAmdGhlcm1hbF9pZHJfbG9jaywgJnR6LT5pZCk7CiAJaWYgKHJlc3VsdCkgewogCQlrZnJl
ZSh0eik7Ci0JCXJldHVybiBOVUxMOworCQlyZXR1cm4gRVJSX1BUUihyZXN1bHQpOwogCX0KIAog
CXN0cmNweSh0ei0+dHlwZSwgdHlwZSk7CkBAIC01OTEsMTUgKzYwNiwxMyBAQCBzdHJ1Y3QgdGhl
cm1hbF96b25lX2RldmljZSAqdGhlcm1hbF96b25lCiAJaWYgKHJlc3VsdCkgewogCQlyZWxlYXNl
X2lkcigmdGhlcm1hbF90el9pZHIsICZ0aGVybWFsX2lkcl9sb2NrLCB0ei0+aWQpOwogCQlrZnJl
ZSh0eik7Ci0JCXJldHVybiBOVUxMOworCQlyZXR1cm4gRVJSX1BUUihyZXN1bHQpOwogCX0KIAog
CS8qIHN5cyBJL0YgKi8KLQlpZiAodHlwZSkgewotCQlyZXN1bHQgPSBkZXZpY2VfY3JlYXRlX2Zp
bGUoJnR6LT5kZXZpY2UsICZkZXZfYXR0cl90eXBlKTsKLQkJaWYgKHJlc3VsdCkKLQkJCWdvdG8g
dW5yZWdpc3RlcjsKLQl9CisJcmVzdWx0ID0gZGV2aWNlX2NyZWF0ZV9maWxlKCZ0ei0+ZGV2aWNl
LCAmZGV2X2F0dHJfdHlwZSk7CisJaWYgKHJlc3VsdCkKKwkJZ290byB1bnJlZ2lzdGVyOwogCiAJ
cmVzdWx0ID0gZGV2aWNlX2NyZWF0ZV9maWxlKCZ0ei0+ZGV2aWNlLCAmZGV2X2F0dHJfdGVtcCk7
CiAJaWYgKHJlc3VsdCkKQEAgLTYzMyw3ICs2NDYsNyBAQCBzdHJ1Y3QgdGhlcm1hbF96b25lX2Rl
dmljZSAqdGhlcm1hbF96b25lCiAgICAgICB1bnJlZ2lzdGVyOgogCXJlbGVhc2VfaWRyKCZ0aGVy
bWFsX3R6X2lkciwgJnRoZXJtYWxfaWRyX2xvY2ssIHR6LT5pZCk7CiAJZGV2aWNlX3VucmVnaXN0
ZXIoJnR6LT5kZXZpY2UpOwotCXJldHVybiBOVUxMOworCXJldHVybiBFUlJfUFRSKHJlc3VsdCk7
CiB9CiBFWFBPUlRfU1lNQk9MKHRoZXJtYWxfem9uZV9kZXZpY2VfcmVnaXN0ZXIpOwogCg==

------_=_NextPart_001_01C86E30.055E968E--
