Return-Path: <linux-kernel-owner+w=401wt.eu-S1764449AbYBBBfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764449AbYBBBfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 20:35:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763831AbYBBBdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 20:33:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:28697 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763769AbYBBBdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 20:33:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=qPXwhGxMNSsRqFmEUVyzsl82hYZtWb4xgs0BD6FcCEZCdQtKT6odTFoW65IBPpZbQl59tfsC6om6wqDP00W3WvsaEc/S1/hI7HAVdcsEqo4O8yTl9bwiwo/yYtqVg/XNzlJYfni0WCLYMXnBGiNmTfQo3usbTjq+J8SigQDmaR0=
Message-ID: <6101e8c40802011733g504c1cd7ubaceee5df9a51a66@mail.gmail.com>
Date: Sat, 2 Feb 2008 02:33:44 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {05/17} - cciss-fix_memory_leak - series for stable kernel #2
Cc: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "Greg KH" <gregkh@suse.de>,
       "Willy Tarreau" <w@1wt.eu>, "Adrian Bunk" <bunk@kernel.org>,
       "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Mike Miller" <mike.miller@hp.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_26261_31574446.1201916024654"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_26261_31574446.1201916024654
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

mainline: f2912a1223c0917a7b4e054f18086209137891ea

-- 
Thanks,
Oliver

------=_Part_26261_31574446.1201916024654
Content-Type: application/mbox; name=cciss-fix_memory_leak
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment; filename=cciss-fix_memory_leak

RnJvbSBmMjkxMmExMjIzYzA5MTdhN2I0ZTA1NGYxODA4NjIwOTEzNzg5MWVhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKZXNwZXIgSnVobCA8amVzcGVyLmp1aGxAZ21haWwuY29tPgpE
YXRlOiBUdWUsIDMxIEp1bCAyMDA3IDAwOjM5OjM5IC0wNzAwClN1YmplY3Q6IFtQQVRDSF0gY2Np
c3M6IGZpeCBtZW1vcnkgbGVhawoKVGhlcmUncyBhIG1lbW9yeSBsZWFrIGluIHRoZSBjY2lzcyBk
cml2ZXIuCgppbiBhbGxvY19jY2lzc19oYmEoKSB3ZSBtYXkgbGVhayBzaXplb2YoY3Rscl9pbmZv
X3QpIGJ5dGVzIGlmIGEKY2FsbCB0byBhbGxvY19kaXNrKDEgPDwgTldEX1NISUZUKSBmYWlscy4K
VGhpcyBwYXRjaCBzaG91bGQgZml4IHRoZSBpc3N1ZS4KClNwb3R0ZWQgYnkgdGhlIENvdmVyaXR5
IGNoZWNrZXIuCgpTaWduZWQtb2ZmLWJ5OiBKZXNwZXIgSnVobCA8amVzcGVyLmp1aGxAZ21haWwu
Y29tPgpBY2tlZC1ieTogTWlrZSBNaWxsZXIgPG1pa2UubWlsbGVyQGhwLmNvbT4KU2lnbmVkLW9m
Zi1ieTogQW5kcmV3IE1vcnRvbiA8YWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZz4KU2lnbmVkLW9m
Zi1ieTogTGludXMgVG9ydmFsZHMgPHRvcnZhbGRzQGxpbnV4LWZvdW5kYXRpb24ub3JnPgoKZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvYmxvY2svY2Npc3MuYyBiL2RyaXZlcnMvYmxvY2svY2Npc3MuYwpp
bmRleCAxYmU4MmQ1Li5hMTFiMmJkIDEwMDY0NAotLS0gYS9kcml2ZXJzL2Jsb2NrL2NjaXNzLmMK
KysrIGIvZHJpdmVycy9ibG9jay9jY2lzcy5jCkBAIC0zMjI3LDEyICszMjI3LDE1IEBAIHN0YXRp
YyBpbnQgYWxsb2NfY2Npc3NfaGJhKHZvaWQpCiAJZm9yIChpID0gMDsgaSA8IE1BWF9DVExSOyBp
KyspIHsKIAkJaWYgKCFoYmFbaV0pIHsKIAkJCWN0bHJfaW5mb190ICpwOworCiAJCQlwID0ga3ph
bGxvYyhzaXplb2YoY3Rscl9pbmZvX3QpLCBHRlBfS0VSTkVMKTsKIAkJCWlmICghcCkKIAkJCQln
b3RvIEVub21lbTsKIAkJCXAtPmdlbmRpc2tbMF0gPSBhbGxvY19kaXNrKDEgPDwgTldEX1NISUZU
KTsKLQkJCWlmICghcC0+Z2VuZGlza1swXSkKKwkJCWlmICghcC0+Z2VuZGlza1swXSkgeworCQkJ
CWtmcmVlKHApOwogCQkJCWdvdG8gRW5vbWVtOworCQkJfQogCQkJaGJhW2ldID0gcDsKIAkJCXJl
dHVybiBpOwogCQl9Cg==
------=_Part_26261_31574446.1201916024654--
