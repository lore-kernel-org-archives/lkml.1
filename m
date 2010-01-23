Return-Path: <linux-kernel-owner+w=401wt.eu-S1755717Ab0AWCge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab0AWCge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 21:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754308Ab0AWCgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 21:36:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54364 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416Ab0AWCgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 21:36:33 -0500
X-User-Agent: K-9 Mail for Android
Content-Type: multipart/mixed; boundary="----A13LPEE0FAAOQ7NGKRB2C21X7T0WJ6"
MIME-Version: 1.0
Subject: Re: RFC: deprecate CONFIG_X86_CPU_DEBUG and schedule it for rapid removal
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 22 Jan 2010 18:34:53 -0800
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?UTF-8?Q?Ozan_=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
       Yinghai Lu <yinghai@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       mingo@elte.hu, a.p.zijlstra@chello.nl, stable@kernel.org,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Message-ID: <fea02893-f940-4e12-9136-2953c7313544@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------A13LPEE0FAAOQ7NGKRB2C21X7T0WJ6
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: base64

TWFrZXMgc2Vuc2UuICBXaWxsIGRvLgoKIkxpbnVzIFRvcnZhbGRzIiA8dG9ydmFsZHNAbGludXgt
Zm91bmRhdGlvbi5vcmc+IHdyb3RlOgoKPg0KPg0KPk9uIEZyaSwgMjIgSmFuIDIwMTAsIEFuZHJl
dyBNb3J0b24gd3JvdGU6DQo+PiANCj4+IFdlIGtub3cgdGhhdCBlbmFibGluZyB0aGlzIGZlYXR1
cmUgd2lsbCBjYXVzZSBzb21lIG1hY2hpbmVzIHRvIGhhbmcsDQo+PiBhbmQgdGhhdCB0aGlzIHBy
b2JsZW0gaGFzIGV4aXN0ZWQgZm9yIHNpeCBtb250aHMuDQo+PiANCj4+IFdvdWxkIGl0IG5vdCBi
ZSBiZXR0ZXIgdG8gZml4IHRoYXQgcHJvYmxlbSAocGVyaGFwcyBqdXN0IHdpdGggdGhlDQo+PiBy
ZXZlcnQpIHNvIHRoYXQgMi42LjMzLCAyLjYuMzIueCBhbmQgZWFybGllciBjYW4gYmUgZml4ZWQ/
ICBUaGVuIHdlIGNhbg0KPj4gbnVrZSB0aGUgZmVhdHVyZSBpbiAyLjYuMzQuDQo+DQo+QW5vdGhl
ciB3YXkgb2YgbG9va2luZyBhdCBpcyAid2Uga25vdyBpdCdzIGJlZW4gYnJva2VuIGZvciBzaXgg
bW9udGhzLCBhbmQgDQo+Y2xlYXJseSBub2JvZHkgcmVhbGx5IGV2ZXIgZW5hYmxlZCBpdCBpbiBh
bnkgZGlzdHJvLCBhbmQgZXZlbiBnZXR0aW5nIGEgDQo+YnVnIHJlcG9ydCBvbiBpdCB0b29rIGZv
cmV2ZXIuIFNvIHdoeSBrZWVwIGl0IGFyb3VuZCBhdCBhbGwiPw0KPg0KPlNvIEknZCBwZXJzb25h
bGx5IHJhdGhlciBqdXN0IHJlbW92ZSBpdCBvdXRyaWdodCB0aGFuIGRlcHJlY2F0ZSBpdCBvciBl
dmVuIA0KPnRyeSB0byBmaXggaXQuIFNpbmNlIGNsZWFybHkgYWJzb2x1dGVseSBub2JvZHkgZGVw
ZW5kcyBvbiBpdC4NCj4NCj5UaGUgdXN1YWwgcmVhc29uIGZvciBkZXByZWNhdGluZyBhIGZlYXR1
cmUgaXMgdG8gZ2l2ZSBwZW9wbGUgdGltZSB0byBtb3ZlIA0KPmF3YXkgZnJvbSBpdCwgYnV0IHNp
bmNlIGNsZWFybHkgbm9ib2R5IHVzZXMgaXQuLi4NCj4NCj4JCUxpbnVzDQoKLS0KU2VudCBmcm9t
IG15IG1vYmlsZSBwaG9uZSwgcGFyZG9uIGFueSBsYWNrIG9mIGZvcm1hdHRpbmcu

------A13LPEE0FAAOQ7NGKRB2C21X7T0WJ6--

