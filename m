Return-Path: <linux-kernel-owner+w=401wt.eu-S1757121AbXL3NTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbXL3NTW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 08:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbXL3NTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 08:19:13 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:47833 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbXL3NTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 08:19:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type;
        b=PY+URT2HlJ7eGWY/ED8U4Mz8Acyrr7h7A4NQGupkIoppoOaPbQRFoF10Pee/7O9VE2OBWYn8eL/4xKHMpSAh2fOASktJXJ6arlS23uS5B4qlHK/4ZAG768wwG6kqZL420fzYz9kCAY1ii9X2pXA+oqUj4526G88N/7R3zzrg8LI=
Message-ID: <6101e8c40712300519y1e846185rb262fc26e02442a0@mail.gmail.com>
Date: Sun, 30 Dec 2007 14:19:11 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [03/06] [typo fix] net/core/net_namespace.c
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_16333_19408970.1199020751161"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_16333_19408970.1199020751161
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
Thanks,
Oliver

------=_Part_16333_19408970.1199020751161
Content-Type: text/x-diff; name=03.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment; filename=03.patch

Y29tbWl0IDg1NThiYzI1ZDMxYTFkNzA4Nzk4MTlmMjhmOTQ0ODVhYmMyODliNmIKQXV0aG9yOiBP
bGl2ZXIgUGludGVyIDxvbGl2ZXIucG50ckBnbWFpbC5jb20+CkNvbW1pdDogT2xpdmVyIFBpbnRl
ciA8b2xpdmVyLnBudHJAZ21haWwuY29tPgoKICAgIFt0eXBvIGZpeF0gbmV0L2NvcmUvbmV0X25h
bWVzcGFjZS5jCiAgICAKICAgIHR5cG8gZml4IGluIG5ldC9jb3JlL25ldF9uYW1lc3BhY2UuYwog
ICAgZm9vLWRlc3RvcnkgLT4gZm9vLWRlc3Ryb3kKICAgIAogICAgU2lnbmVkLW9mZi1ieTogT2xp
dmVyIFBpbnRlciA8b2xpdmVyLnBudHJAZ21haWwuY29tPgoKZGlmZiAtLWdpdCBhL25ldC9jb3Jl
L25ldF9uYW1lc3BhY2UuYyBiL25ldC9jb3JlL25ldF9uYW1lc3BhY2UuYwppbmRleCAzODMyNTJi
Li4yMTAxNzM5IDEwMDY0NAotLS0gYS9uZXQvY29yZS9uZXRfbmFtZXNwYWNlLmMKKysrIGIvbmV0
L2NvcmUvbmV0X25hbWVzcGFjZS5jCkBAIC0yODAsNyArMjgwLDcgQEAgRVhQT1JUX1NZTUJPTF9H
UEwocmVnaXN0ZXJfcGVybmV0X3N1YnN5cyk7CiAgKglAb3BzOiBwZXJuZXQgb3BlcmF0aW9ucyBz
dHJ1Y3R1cmUgdG8gbWFuaXB1bGF0ZQogICoKICAqCVJlbW92ZSB0aGUgcGVybmV0IG9wZXJhdGlv
bnMgc3RydWN0dXJlIGZyb20gdGhlIGxpc3QgdG8gYmUKLSAqCXVzZWQgd2hlbiBuZXR3b3JrIG5h
bWVzcGFjZXMgYXJlIGNyZWF0ZWQgb3IgZGVzdG9yeWVkLiAgSW4KKyAqCXVzZWQgd2hlbiBuZXR3
b3JrIG5hbWVzcGFjZXMgYXJlIGNyZWF0ZWQgb3IgZGVzdHJveWVkLiAgSW4KICAqCWFkZGl0aW9u
IHJ1biB0aGUgZXhpdCBtZXRob2QgZm9yIGFsbCBleGlzdGluZyBuZXR3b3JrCiAgKgluYW1lc3Bh
Y2VzLgogICovCkBAIC0zMjgsNyArMzI4LDcgQEAgRVhQT1JUX1NZTUJPTF9HUEwocmVnaXN0ZXJf
cGVybmV0X2RldmljZSk7CiAgKglAb3BzOiBwZXJuZXQgb3BlcmF0aW9ucyBzdHJ1Y3R1cmUgdG8g
bWFuaXB1bGF0ZQogICoKICAqCVJlbW92ZSB0aGUgcGVybmV0IG9wZXJhdGlvbnMgc3RydWN0dXJl
IGZyb20gdGhlIGxpc3QgdG8gYmUKLSAqCXVzZWQgd2hlbiBuZXR3b3JrIG5hbWVzcGFjZXMgYXJl
IGNyZWF0ZWQgb3IgZGVzdG9yeWVkLiAgSW4KKyAqCXVzZWQgd2hlbiBuZXR3b3JrIG5hbWVzcGFj
ZXMgYXJlIGNyZWF0ZWQgb3IgZGVzdHJveWVkLiAgSW4KICAqCWFkZGl0aW9uIHJ1biB0aGUgZXhp
dCBtZXRob2QgZm9yIGFsbCBleGlzdGluZyBuZXR3b3JrCiAgKgluYW1lc3BhY2VzLgogICovCg==

------=_Part_16333_19408970.1199020751161--
