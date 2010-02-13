Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab0BMWNK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 17:13:10 -0500
Received: from claw.goop.org ([74.207.240.146]:48485 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab0BMWNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 17:13:08 -0500
X-User-Agent: K-9 Mail for Android
In-Reply-To: <m1k4uhrcqm.fsf@fess.ebiederm.org>
References: =?US-ASCII?Q?=3C1266029390-30907-1-git-send-email-yi?= =?US-ASCII?Q?nghai=40kernel=2Eorg=3E=0D=0A=09=3Cm1zl3dre9e=2Efsf=40fes?= =?US-ASCII?Q?s=2Eebiederm=2Eorg=3E_=3C4B762137=2E4050604=40zyto?= =?US-ASCII?Q?r=2Ecom=3E_=3Cm1k4uhrcqm=2Efsf=40fess=2Eebiederm=2Eorg=3E?=
Content-Type: multipart/mixed; boundary="----VO3RAGT8UMNL9XMQB7E9HNNLKXOB4Q"
MIME-Version: 1.0
Subject: Re: [PATCH  0/8] tip related: radix tree for spareseirq and logical flat clean up
From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Sat, 13 Feb 2010 14:12:57 -0800
To: ebiederm@xmission.com, "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org
Message-ID: <83b97429-92d3-498f-b1a8-a6969713f7ba@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------VO3RAGT8UMNL9XMQB7E9HNNLKXOB4Q
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: base64

SSBkb24ndCBoYXZlIHRoZSBjb2RlIGluIGZyb250IG9mIG1lLCBidXQgSSB0aGluayB0aGF0IGNo
YW5nZSBzaG91bGQgYmUgT0suICBYZW4ganVzdCB3YW50cyB0byBpbml0aWF0ZSBpbnRlcnJ1cHQg
ZGVsaXZlcnkgZm9yIGEgZ2l2ZW4gaXJxLiAgQXQgbGVhc3QgZm9yIHg4NjsgSSB3b24ndCBtYWtl
IGFueSBjbGFpbXMgZm9yIGlhNjQuCgogICAgIEoKCmViaWVkZXJtQHhtaXNzaW9uLmNvbSB3cm90
ZToKCj4iSC4gUGV0ZXIgQW52aW4iIDxocGFAenl0b3IuY29tPiB3cml0ZXM6Cj4KPj4gT24gMDIv
MTIvMjAxMCAwNzo0NCBQTSwgRXJpYyBXLiBCaWVkZXJtYW4gd3JvdGU6Cj4+PiAKPj4+IFRoYW5r
cyBmb3Iga2VlcGluZyB0aGlzIHdvcmsgYWxpdmUuCj4+PiAKPj4KPj4gSW5kZWVkLiAgSSBhbSBo
b3BpbmcgdG8gcHV0IHRoaXMgaW4gdGlwIHRvbW9ycm93IG9yIHNvLgo+Pgo+Pj4gSSBqdXN0IHNr
aW1tZWQgdGhyb3VnaCBkb19JUlEgYW5kIEkgaGFwcGVuZWQgdG8gbm90aWNlIHRoYXQKPj4+IHdl
IGhhdmUgYW4gdW5uZWNlc3NhcnkgaW5lZmZpY2llbmN5IHRoYXQgdXNpbmcgYSByYWRpeCB0cmVl
IGZvcgo+Pj4gaXJxX3RvX2Rlc2Mgd2lsbCBtYWduaWZ5Lgo+Pj4gCj4+PiBoYW5kbGVfaXJxIHNo
b3VsZCB0YWtlIGFuIHN0cnVjdCBpcnFfZGVzYyAqIGluc3RlYWQgb2YgYSB1bnNpZ25lZCBpbnQg
aXJxLgo+Pj4gCj4+PiBhbmQgdGhlIHBlciBjcHUgdmVjdG9yX2lycSBhcnJheSBzaG91bGQgYmVj
b21lIGEgcGVyIGNwdSB2ZWN0b3JfZGVzYyBhcnJheS4KPj4+IAo+Pj4gQXMgc29vbiBhcyBpcnFf
dG9fZGVzYyBpcyBtb3JlIHRoYW4gJmlycV9kZXNjW2lycV0gdGhpcyBzYXZlcyB1cyB3b3JrCj4+
PiBhbmQgY2FjaGUgbGluZSBtaXNzZXMgIGF0IHRoZSBjb3N0IG9mIGEgc2ltcGxlIGNvZGUgY2xl
YW51cC4KPj4KPj4gR29vZCBjYXRjaC4gIEkgaGF2ZW4ndCBsb29rZWQgdGhyb3VnaCB0aGUgZGV0
YWlscyB5ZXQsIGJ1dCBJIHByZXN1bWUKPj4gdGhpcyBjYW4gYmUgZG9uZSBvbiB0b3Agb2YgdGhp
cyBjaGFuZ2VzZXQ/Cj4KPkNvZGV3aXNlIHRoZSBjaGFuZ2VzIHNob3VsZCBiZSBjb21wbGV0ZWx5
IGluZGVwZW5kZW50Lgo+Cj4KPgo+UHJvYmFibHkgdGhlIHRyaWNraWVzdCBiaXQgaXMgdGhhdCBk
cml2ZXJzL3hlbi9ldmVudHMuYyBjYWxscyBoYW5kbGVfaXJxCj5hbmQgbWFrZXMgaGFuZGxlX2ly
cSBvbiBpYTY0IGEgd3JhcHBlciBmb3IgX19kb19JUlEuCj4KPkplcmVteSBpcyB0aGVyZSBhbnkg
Z29vZCByZWFzb24gd2h5IGRyaXZlcnMveGVuL2V2ZW50cy5jIGRvZXMgbm90IGp1c3QgZG86Cj4K
PmRlc2MgPSBpcnFfdG9fZGVzYyhpcnEpOwo+aWYgKGRlc2MpCj4JZ2VuZXJpY19oYW5kbGVfaXJx
X2Rlc2MoaXJxLCBkZXNjKTsKPgo+QW5kIGluc3RlYWQgaW50cm9kdWNlcyBhIHdlaXJkIG9uZS1v
ZmYgeGVuIHNwZWNpZmljIG11bHRpLWFyY2ggZnVuY3Rpb24/Cj4KPgo+RXJpYwo+CgotLSAKU2Vu
dCBmcm9tIG15IEFuZHJvaWQgcGhvbmUgd2l0aCBLLTkgTWFpbC4gUGxlYXNlIGV4Y3VzZSBteSBi
cmV2aXR5Lg==

------VO3RAGT8UMNL9XMQB7E9HNNLKXOB4Q--

