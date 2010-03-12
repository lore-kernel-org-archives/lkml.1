Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab0CLDL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 22:11:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54900 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367Ab0CLDL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 22:11:56 -0500
X-User-Agent: K-9 Mail for Android
Content-Type: multipart/mixed; boundary="----5DY4AP7D8GMRUOBJV9C0F72VOFTQQY"
MIME-Version: 1.0
Subject: Re: ATA 4 KiB sector issues.
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 11 Mar 2010 19:10:43 -0800
To: Tejun Heo <tj@kernel.org>, Greg Freemyer <greg.freemyer@gmail.com>
CC: tytso@mit.edu, Nikanth Karthikesan <knikanth@suse.de>,
       James Bottomley <James.Bottomley@suse.de>,
       Damian Lukowski <damian@tvk.rwth-aachen.de>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Mark Lord <kernel@teksavvy.com>,
       hirofumi@mail.parknet.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       aschnell@suse.de, jdelvare@suse.de
Message-ID: <6d5f68da-fa38-48e3-9af0-567f8b381601@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------5DY4AP7D8GMRUOBJV9C0F72VOFTQQY
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: base64

SSB0aGluayBpZiB5b3UgdXNlIHRoZSBET1MgY29tcGF0IG9wdGlvbiB0byBjcmVhdGUgdGhlIGxl
Z2FjeSBwYXJ0aXRpb25zIG9ubHksIHlvdSBzaG91bGQgYmUgZmluZS4KCiJUZWp1biBIZW8iIDx0
akBrZXJuZWwub3JnPiB3cm90ZToKCj5IZWxsbywNCj4NCj5PbiAwMy8xMi8yMDEwIDAxOjM0IEFN
LCBHcmVnIEZyZWVteWVyIHdyb3RlOg0KPj4gSSBkbyB0aGluayB0aGUgbGludXggcGFydGl0aW9u
ZXJzIHNob3VsZCBwcm92aWRlIGEgd2F5IHRvIGZvcmNlIGENCj4+IGN5bGluZGVyIGFsaWdubWVu
dC4gIFRlanVuLCBJIHdvdWxkIGxpa2UgdG8gc2VlIHlvdXIgZG9jIGRlc2NyaWJlIGhvdw0KPj4g
dG8gZm9yY2UgYSB3aW4yayBjb21wYXRpYmxlIHBhcnRpdGlvbiBsYXlvdXQuDQo+DQo+SSBzdXBw
b3NlIEkgY2FuIHBsYXkgd2l0aCBmZGlzayBhbmQgbGlzdCBpdCBhcyBhbiBleGFtcGxlIGJ1dCBp
Zg0KPmFueW9uZSBrbm93cyBiZXR0ZXIvcHJvcGVyIHdheSB0byBmb3JjZSBjZXJ0YWluIHBhcnRp
dGlvbnMgdG8gbGVnYWN5DQo+YWxpZ25tZW50IHdoaWxlIGxlYXZpbmcgb3RoZXJzIHByb3Blcmx5
IGFsaWduZWQsIEknbGwgYmUgaGFwcHkgdG8NCj5pbmNsdWRlIGl0Lg0KPg0KPlRoYW5rcy4NCj4N
Cj4tLSANCj50ZWp1bg0KCi0tClNlbnQgZnJvbSBteSBtb2JpbGUgcGhvbmUsIHBhcmRvbiBhbnkg
bGFjayBvZiBmb3JtYXR0aW5nLg==

------5DY4AP7D8GMRUOBJV9C0F72VOFTQQY--

