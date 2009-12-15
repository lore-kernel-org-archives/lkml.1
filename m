Return-Path: <linux-kernel-owner+w=401wt.eu-S1761056AbZLOUEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761056AbZLOUEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 15:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761018AbZLOUEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 15:04:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52205 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760997AbZLOUEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 15:04:45 -0500
Subject: Re: [PATCH resend] x86, amd: Get multi-node CPU info from NodeId MSR instead of PCI config space
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 15 Dec 2009 11:51:37 -0800
To: Ingo Molnar <mingo@elte.hu>,
       Andreas Herrmann <herrmann.der.user@googlemail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Message-ID: <uqtdsfmgx5kgsducseo3254j.1260906697878@email.android.com>
Content-Type: multipart/mixed; boundary="----2BX9OUFF7FW6AKPLP3UVJIR0H0WCO7"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------2BX9OUFF7FW6AKPLP3UVJIR0H0WCO7
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: base64

QWJzb2x1dGVseSAtIHRoZSBvbmx5IHBsYWNlIGZvciBNU1IgbnVtYmVycyBpcyBpbiBtc3ItaW5k
ZXguaAoKIkluZ28gTW9sbmFyIiA8bWluZ29AZWx0ZS5odT4gd3JvdGU6Cgo+DQo+KiBBbmRyZWFz
IEhlcnJtYW5uIDxoZXJybWFubi5kZXIudXNlckBnb29nbGVtYWlsLmNvbT4gd3JvdGU6DQo+DQo+
PiArCXJkbXNybCgweGMwMDExMDBjLCB2YWx1ZSk7DQo+DQo+RG9udCB3ZSB3YW50IHNvbWUgbmlj
ZSwgbWVhbmluZ2Z1bGx5IG5hbWVkIHN5bWJvbGljIGNvbnN0YW50IGhlcmUsIGluc3RlYWQgb2Yg
DQo+MHhjMDAxMTAwYz8NCj4NCj4JSW5nbw0KCi0tClNlbnQgZnJvbSBteSBtb2JpbGUgcGhvbmUu
IFBsZWFzZSBleGN1c2UgYW55IGxhY2sgb2YgZm9ybWF0dGluZy4=

------2BX9OUFF7FW6AKPLP3UVJIR0H0WCO7--

