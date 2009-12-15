Return-Path: <linux-kernel-owner+w=401wt.eu-S1761045AbZLOUDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761045AbZLOUDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 15:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932633AbZLOUDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 15:03:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52177 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760989AbZLOUDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 15:03:48 -0500
Subject: Re: [PATCH resend] x86, amd: Get multi-node CPU info from NodeId MSR instead of PCI config space
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 15 Dec 2009 12:00:36 -0800
To: Borislav Petkov <borislav.petkov@amd.com>, Ingo Molnar <mingo@elte.hu>
CC: Andreas Herrmann <herrmann.der.user@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Message-ID: <mkk2iqhh6vhhmxaxruuvafvb.1260907236343@email.android.com>
Content-Type: multipart/mixed; boundary="----LLVGJF2YJEGSVVBH1SKKSPA3M42TQY"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------LLVGJF2YJEGSVVBH1SKKSPA3M42TQY
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: base64

VGhhdCdzIG5pY2UuICBJdCBzaG91bGQgYmUgaW4gdGhlIGNvZGUsIG5vdCBpbiB0aGUgY29tbWl0
IG1lc3NhZ2UuCgoiQm9yaXNsYXYgUGV0a292IiA8Ym9yaXNsYXYucGV0a292QGFtZC5jb20+IHdy
b3RlOgoKPk9uIFR1ZSwgRGVjIDE1LCAyMDA5IGF0IDA4OjMxOjUwUE0gKzAxMDAsIEluZ28gTW9s
bmFyIHdyb3RlOg0KPj4gDQo+PiAqIEFuZHJlYXMgSGVycm1hbm4gPGhlcnJtYW5uLmRlci51c2Vy
QGdvb2dsZW1haWwuY29tPiB3cm90ZToNCj4+IA0KPj4gPiArCXJkbXNybCgweGMwMDExMDBjLCB2
YWx1ZSk7DQo+PiANCj4+IERvbnQgd2Ugd2FudCBzb21lIG5pY2UsIG1lYW5pbmdmdWxseSBuYW1l
ZCBzeW1ib2xpYyBjb25zdGFudCBoZXJlLCBpbnN0ZWFkIG9mIA0KPj4gMHhjMDAxMTAwYz8NCj4N
Cj5UaGUgTVNSIG5hbWUgaXMgYWN0dWFsbHkgaW4gdGhlIGNvbW1pdCBtc2csIG1heWJlIHNvbWV0
aGluZyBsaWtlDQo+TVNSX0YxMEhfTk9ERV9JRC4NCj4NCj4tLSANCj5SZWdhcmRzL0dydXNzLA0K
PkJvcmlzLg0KPg0KPk9wZXJhdGluZyB8IEFkdmFuY2VkIE1pY3JvIERldmljZXMgR21iSA0KPiAg
U3lzdGVtICB8IEthcmwtSGFtbWVyc2NobWlkdC1TdHIuIDM0LCA4NTYwOSBEb3JuYWNoIGIuIE3D
vG5jaGVuLCBHZXJtYW55DQo+IFJlc2VhcmNoIHwgR2VzY2jDpGZ0c2bDvGhyZXI6IEFuZHJldyBC
b3dkLCBUaG9tYXMgTS4gTWNDb3ksIEdpdWxpYW5vIE1lcm9uaQ0KPiAgQ2VudGVyICB8IFNpdHo6
IERvcm5hY2gsIEdlbWVpbmRlIEFzY2hoZWltLCBMYW5ka3JlaXMgTcO8bmNoZW4NCj4gIChPU1JD
KSAgfCBSZWdpc3RlcmdlcmljaHQgTcO8bmNoZW4sIEhSQiBOci4gNDM2MzINCj4NCgotLQpTZW50
IGZyb20gbXkgbW9iaWxlIHBob25lLiBQbGVhc2UgZXhjdXNlIGFueSBsYWNrIG9mIGZvcm1hdHRp
bmcu

------LLVGJF2YJEGSVVBH1SKKSPA3M42TQY--

