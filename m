Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784Ab0AQXCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab0AQXCs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 18:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754139Ab0AQXCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 18:02:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52255 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab0AQXCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 18:02:47 -0500
X-User-Agent: K-9 Mail for Android
Content-Type: multipart/mixed; boundary="----FW2V7M14IEQQX5392OC4VRVSL3B6LI"
MIME-Version: 1.0
Subject: =?US-ASCII?Q?Re=3A_=5BRFC_PATCH_2/8=5D_jump_label_v4_-_x86=3A_Intr?= =?US-ASCII?Q?oduce_generic_jump=09patching_without_stop=5Fmachine?=
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 17 Jan 2010 14:56:38 -0800
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: rostedt@goodmis.org, Jason Baron <jbaron@redhat.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, Arjan van de Ven <arjan@infradead.org>
Message-ID: <a108a3ca-c8db-48be-8adb-3733257323d6@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------FW2V7M14IEQQX5392OC4VRVSL3B6LI
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: base64

SWYgc2luZ2xlLWJ5dGUgdXBkYXRlcyB3ZXJlbid0IGF0b21pYywgdGhlbiB0aGUgaW50MyBzY2hl
bWUgd291bGQgbm90IGJlIHBvc3NpYmxlIGluIHRoZSBmaXJzdCBwbGFjZS4gIE9mIGNvdXJzZSwg
aWYgeW91IHdhbnQgdGhlcmUgdG8gYmUgYSBzeW5jaHJvbml6YXRpb24gcG9pbnQgYmV5b25kIHdo
aWNoIHRoZSBtb2RpZmljYXRpb24gaXMgZ3VhcmFudGVlZCB0byBoYXZlIGFmZmVjdGVkIGFsbCBD
UFVzLCB5b3UgbmVlZCBhbiBJUEktSVJFVCBvbiBhbGwgQ1BVcy4KClRoZSBvdGhlciB0aGluZyB0
byB3YXRjaCBvdXQgZm9yIGlzIHRoYXQgdGhlIENQVSBpdHNlbGYgaXMgc3ViamVjdCB0byB0ZXh0
IG1vZGlmaWNhdGlvbiB0aHJvdWdoIGEgZGlmZmVyZW50IGFsaWFzLCB3aGljaCBtZWFucyBzb21l
IG9mIHRoZSBoYXJkd2FyZSBTTUMgcHJvdGVjdGlvbnMgYXJlIGluZWZmZWN0aXZlLgoKIk1hdGhp
ZXUgRGVzbm95ZXJzIiA8bWF0aGlldS5kZXNub3llcnNAcG9seW10bC5jYT4gd3JvdGU6Cgo+KiBI
LiBQZXRlciBBbnZpbiAoaHBhQHp5dG9yLmNvbSkgd3JvdGU6DQo+PiBPbiAwMS8xNC8yMDEwIDA3
OjMyIEFNLCBTdGV2ZW4gUm9zdGVkdCB3cm90ZToNCj4+ID4+ICsNCj4+ID4+ICsJLyogUmVwbGFj
aW5nIDEgYnl0ZSBjYW4gYmUgZG9uZSBhdG9taWNhbGx5LiAqLw0KPj4gPj4gKwlpZiAodW5saWtl
bHkobGVuIDw9IDEpKQ0KPj4gPj4gKwkJcmV0dXJuIHRleHRfcG9rZShhZGRyLCBvcGNvZGUsIGxl
bik7DQo+PiA+IA0KPj4gPiBUaGlzIHBhcnQgYm90aGVycyBtZS4gVGhlIHRleHRfcG9rZSBqdXN0
IHdyaXRlcyBvdmVyIHRoZSB0ZXh0IGRpcmVjdGx5DQo+PiA+ICh1c2luZyBhIHNlcGFyYXRlIG1h
cHBpbmcpLiBCdXQgaWYgdGhhdCBtZW1vcnkgaXMgaW4gdGhlIHBpcGVsaW5lIG9mDQo+PiA+IGFu
b3RoZXIgQ1BVLCBJIHRoaW5rIHRoaXMgY291bGQgY2F1c2UgYSBHUEYuDQo+PiA+IA0KPj4gDQo+
PiBDb3VsZCB5b3UgY2xhcmlmeSB3aHkgeW91IHRoaW5rIHRoYXQ/DQo+DQo+QmFzaWNhbGx5LCB3
aGF0IFN0ZXZlbiBhbmQgSSB3ZXJlIGNvbmNlcm5lZCBhYm91dCBpbiB0aGlzIHBhcnRpY3VsYXIN
Cj5wYXRjaCB2ZXJzaW9uIGlzIHRoZSBmYWN0IHRoYXQgdGhpcyBjb2RlIHRvb2sgYSAic2hvcnRj
dXQiIGZvcg0KPnNpbmdsZS1ieXRlIHRleHQgbW9kaWZpY2F0aW9uLCB0aHVzIGJ5cGFzc2luZyB0
aGUgaW50My1ieXBhc3Mgc2NoZW1lDQo+YWx0b2dldGhlci4NCj4NCj5BcyBtZXJlIGF0b21pY2l0
eSBvZiB0aGUgbW9kaWZpY2F0aW9uIGlzIG5vdCB0aGUgb25seSBjb25jZXJuIGhlcmUNCj4oYmVj
YXVzZSB3ZSBhbHNvIGhhdmUgdG8gZGVhbCB3aXRoIGluc3RydWN0aW9uIHRyYWNlIGNhY2hlIGNv
aGVyZW5jeSBhbmQNCj5zbyBmb3J0aCksIHRoZW4gdGhlIGludDMgYnJlYWtwb2ludCBzY2hlbWUg
aXMsIEkgdGhpbmssIGFsc28gbmVlZGVkIGZvcg0KPnNpbmdsZS1ieXRlIHVwZGF0ZXMuDQo+DQo+
VGhhbmtzLA0KPg0KPk1hdGhpZXUNCj4NCj4+IA0KPj4gCS1ocGENCj4+IA0KPj4gLS0gDQo+PiBI
LiBQZXRlciBBbnZpbiwgSW50ZWwgT3BlbiBTb3VyY2UgVGVjaG5vbG9neSBDZW50ZXINCj4+IEkg
d29yayBmb3IgSW50ZWwuICBJIGRvbid0IHNwZWFrIG9uIHRoZWlyIGJlaGFsZi4NCj4+IA0KPg0K
Pi0tIA0KPk1hdGhpZXUgRGVzbm95ZXJzDQo+T3BlblBHUCBrZXkgZmluZ2VycHJpbnQ6IDhDRDUg
NTJDMyA4RTNDIDQxNDAgNzE1RiAgQkEwNiAzRjI1IEE4RkUgM0JBRSA5QTY4DQoKLS0KU2VudCBm
cm9tIG15IG1vYmlsZSBwaG9uZSwgcGFyZG9uIGFueSBsYWNrIG9mIGZvcm1hdHRpbmcu

------FW2V7M14IEQQX5392OC4VRVSL3B6LI--

