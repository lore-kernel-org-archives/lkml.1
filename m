Return-Path: <linux-kernel-owner+w=401wt.eu-S1763637AbYBBBdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763637AbYBBBdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 20:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762959AbYBBBd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 20:33:26 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:28697 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762975AbYBBBdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 20:33:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=RVQ/hjqev+RdKLvpKjk+S5LSlBOIbLYPo7gyE0MFPhUcjhCPJMuXQmqeWtpIjOU0cgB3fDqQW1fzJDbtpxiY30TpnEimiAn+3b+dbdfDpTD5WLRM6R2WuoxVeXumJSB2rOTGzU1oOIy28Mzdi7yACfyT+DrVKUAO1Dg+fs0wXTo=
Message-ID: <6101e8c40802011733y69521724t9e02690419f55201@mail.gmail.com>
Date: Sat, 2 Feb 2008 02:33:24 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: [2.6.22.y] {01**/17} - do_anonymous_page-race - series for stable kernel
Cc: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "Greg KH" <gregkh@suse.de>,
       "Willy Tarreau" <w@1wt.eu>, "Adrian Bunk" <bunk@kernel.org>,
       "Andrea Arcangeli" <andrea@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_26253_25279671.1201916004119"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_26253_25279671.1201916004119
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

NOT IN MAINLINE

Linus it's go or drop it?



-- 
Thanks,
Oliver

------=_Part_26253_25279671.1201916004119
Content-Type: message/rfc822; name=do_anonymous_page-race
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment; filename=do_anonymous_page-race


ZGl0aW9uIGluIHVzZXJzcGFjZSB0ZXN0Y2FzZQpSZWZlcmVuY2VzOiA0Njk0OCwgTFRDMTE1NzQK
CgpBZGRpdGlvbmFsIENvbW1lbnQgIzEwMyBGcm9tIEFuZHJlYSBBcmNhbmdlbGkgMjAwNC0xMC0x
NSAxOTo0MQp0aGUgbGFzdCBwYXRjaCBJIGF0dGFjaGVkIGlzIHRoZSBzYWZlc3QgSSBiZWxpZXZl
LgoKSSdtIG5vdCBzdXJlIGlmIGEgbG9ja191bmxvY2sgb3IgbG9ja191bmxvY2sgaXMgYWx3YXlz
IGd1YXJhbnRlZWQgdG8gaGFwcGVuCmFmdGVyIHRoZSBJL08sIGFuZCB0aGlzIG1ha2VzIHN1cmUg
bm8gcmFjZSBjYW4gaGFwcGVuIGFueW1vcmUuCgotLS0KIGZzL2Jpby5jIHwgICAgOSArKysrKysr
KysKIDEgZmlsZSBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKykKCi0tLSBhL2ZzL2Jpby5jCTIwMDct
MDctMDggMTk6MzI6MTcuMDAwMDAwMDAwIC0wNDAwCisrKyBiL2ZzL2Jpby5jCTIwMDctMDgtMjcg
MTQ6MDE6MjEuMDAwMDAwMDAwIC0wNDAwCkBAIC0xMDI4LDYgKzEwMjgsMTUgQEAgdm9pZCBiaW9f
ZW5kaW8oc3RydWN0IGJpbyAqYmlvLCB1bnNpZ25lZAogCWJpby0+Ymlfc2l6ZSAtPSBieXRlc19k
b25lOwogCWJpby0+Ymlfc2VjdG9yICs9IChieXRlc19kb25lID4+IDkpOwogCisJaWYgKGJpb19k
YXRhX2RpcihiaW8pID09IFJFQUQpCisJCS8qCisJCSAqIElmIHRoZSBjdXJyZW50IGNwdSBoYXMg
d3JpdHRlbiB0byB0aGUgcGFnZSBieSBoYW5kCisJCSAqIHdpdGhvdXQgZG1hLCB3ZSBtdXN0IGVu
Zm9yY2Ugb3JkZXJpbmcgdG8gYmUgc3VyZQorCQkgKiB0aGlzIHdyaXR0ZW4gZGF0YSB3aWxsIGJl
IHZpc2libGUgYmVmb3JlIHdlIGV4cG9zZQorCQkgKiB0aGUgcGFnZSBjb250ZW50cyB0byBvdGhl
ciBjcHVzIChmb3IgZXhhbXBsZSB3aXRoCisJCSAqIGEgc2V0X3B0ZSkuCisJCSAqLworCQlzbXBf
d21iKCk7CiAJaWYgKGJpby0+YmlfZW5kX2lvKQogCQliaW8tPmJpX2VuZF9pbyhiaW8sIGJ5dGVz
X2RvbmUsIGVycm9yKTsKIH0K
------=_Part_26253_25279671.1201916004119--
