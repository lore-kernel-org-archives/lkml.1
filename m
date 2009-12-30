Return-Path: <linux-kernel-owner+w=401wt.eu-S1752355AbZL3WOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbZL3WOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 17:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290AbZL3WOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 17:14:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43335 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbZL3WOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 17:14:46 -0500
Subject: Re: [PATCH 1/3] x86: record relocation offset
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 30 Dec 2009 14:09:47 -0800
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>
Message-ID: <21grx5jirei08wl5eqklb4fd.1262210987153@email.android.com>
Content-Type: multipart/mixed; boundary="----YNFT58D523WHH6AAC5P72UO3OJVJXH"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------YNFT58D523WHH6AAC5P72UO3OJVJXH
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: base64

QXJlIHdlIGNvbmNlcm5lZCBhYm91dCB2aXJ0dWFsIG9yIHBoeXNpY2FsIGFkZHJlc3NlcywgaGVy
ZT8gIEknbSBhc3N1bWluZyB2aXJ0dWFsOyBpbiB0aGF0IGNhc2UgZG8gbm90ZSB0aGF0IHdlIG9u
bHkgYWN0dWFsbHkgcmVsb2NhdGUgdGhlIGtlcm5lbCBvbiAzMiBiaXRzIC0gb24gNjQgYml0cyB0
aGUgcmVsb2NhdGlvbiBpcyBkb25lIGF0IHRoZSBwYWdlIHRhYmxlIGxldmVsIHNpbmNlIHdlIG5l
ZWQgdGhlIGhpZ2ggbWFwIGFueXdheS4KCk9uIDMyIGJpdHMgb25lIGNhbiBjb21wYXJlIGFueSBv
bmUgc3ltYm9sIGJlZm9yZSBhbmQgYWZ0ZXIgcmVsb2NhdGlvbiAtIGl0IG9idmlvdXNseSBkb2Vz
bid0IG1hdHRlciB3aGljaCBzeW1ib2wgYXMgbG9uZyBhcyBpdCBpcyB0aGUgc2FtZS4gIFRoZSBr
ZXJuZWwgc3RhcnQgd2lsbCBiZSBnaXZlbiBieSBfdGV4dCBvciBzdGFydHVwXzMyOyBpZiB0aGF0
IGZlZWxzIHRvbyAiZnV6enkiIHdlIGNvdWxkIG9mIGNvdXJzZSBhZGQgYSBzcGVjaWZpYyBrZXJu
ZWwgc3RhcnQgc3ltYm9sIGV4cGxpY2l0bHkgZm9yIHRoYXQgcHVycG9zZS4KCiJBcm5hbGRvIENh
cnZhbGhvIGRlIE1lbG8iIDxhY21lQGluZnJhZGVhZC5vcmc+IHdyb3RlOgoKPkVtIFdlZCwgRGVj
IDMwLCAyMDA5IGF0IDA2OjM5OjM2UE0gLTAyMDAsIEFybmFsZG8gQ2FydmFsaG8gZGUgTWVsbyBl
c2NyZXZldToNCj4+IEVtIFdlZCwgRGVjIDMwLCAyMDA5IGF0IDExOjQ1OjMwQU0gLTA4MDAsIEgu
IFBldGVyIEFudmluIGVzY3JldmV1Og0KPj4gPiBUaGUga2VybmVsIGFscmVhZHkga25vd3Mgd2hl
cmUgaXQgaXMgbG9hZGVkIC0tIG9idmlvdXNseSwgYnkgc2hlZXINCj4+ID4gbmVjZXNzaXR5IC0t
IGFuZCBrbm93cyBob3cgaXQgd2FzIGl0c2VsZiBjb25maWd1cmVkLCBhbmQgYXMgc3VjaCB3ZQ0K
Pj4gPiBjYW4gZG8gdGhpcyBjYWxjdWxhdGlvbiBpbiBDIGNvZGUgd2l0aG91dCBtb2RpZnlpbmcg
Ym9vdF9wYXJhbXMgb3INCj4+ID4gdGhlIGVhcmx5IGJvb3RzdHJhcC4NCj4+IA0KPj4gUHJvYmxl
bSBpcyB0aGF0IGF0ICdwZXJmIHJlY29yZCcgdGltZSB3ZSBtYXkgbm90IGhhdmUgYWNjZXNzIHRv
IHRoZQ0KPj4gdm1saW51eCBmaWxlLCBhbmQgdGh1cyBub3QgYmUgYWJsZSB0byBmaWd1cmUgb3V0
IHRoZSByZWxvY2F0aW9uIGFwcGxpZWQNCj4+IGluIHRoYXQgYm9vdC4NCj4+IA0KPj4gVGhlbiwg
YXQgYSBsYXRlciB0aW1lLCBhbmQgcG9zc2libHkgb24gYW5vdGhlciBtYWNoaW5lLCBvbiBhbm90
aGVyIGFyY2gsDQo+PiB3ZSB0cnkgdG8gbWFwIGJhY2sgSVBzIHRvIHN5bWJvbHMsIHRoZSAvcHJv
Yy9rYWxsc3ltcyBpcyBjb21wbGV0ZWx5DQo+PiB1bnJlbGF0ZWQgYW5kIHdlIG5vdyBoYXZlIGEg
dm1saW51eCB1bnJlbG9jYXRlZC4uLg0KPj4gDQo+PiBTbyB3ZSBuZWVkIGEgd2F5IHRvIGdldCB0
aGUgcmVsb2NhdGlvbiBhcHBsaWVkIGF0ICdwZXJmIHJlY29yZCcgdGltZSBhbmQNCj4+IGVuY29k
ZSBpdCBpbiB0aGUgcGVyZi5kYXRhIGhlYWRlci4gSWRlYXMgYWJvdXQgaG93IHRvIGRvIHRoYXQ/
DQo+DQo+V2VsbCwgSSBndWVzcyB3ZSBjb3VsZCBkbyB0aGUgX3N0ZXh0IHRyaWNrIGFnYWluLCBz
dG9yaW5nIGl0cyB2YWx1ZSwNCj50YWtlbiBmcm9tIC9wcm9jL2thbGxzeW1zLCBpbnRvIHRoZSBw
ZXJmLmRhdGEgaGVhZGVyLCB0aGVuIGZpZ3VyaW5nIG91dA0KPnRoZSByZWxvY2F0aW9uIGJ5IGxv
b2tpbmcgYXQgaXRzIHZhbHVlIGluIHRoZSB2bWxpbnV4IHN5bXRhYi4NCj4NCj5UaGVyZSB3ZXJl
IGNvbmNlcm5zIGluIHRoZSBwYXN0IGFib3V0IHJlbHlpbmcgb24gX3N0ZXh0LCBJSVJDLCBKYW1l
cz8NCj4NCj4tIEFybmFsZG8NCgotLQpTZW50IGZyb20gbXkgbW9iaWxlIHBob25lLiBQbGVhc2Ug
ZXhjdXNlIGFueSBsYWNrIG9mIGZvcm1hdHRpbmcu

------YNFT58D523WHH6AAC5P72UO3OJVJXH--

