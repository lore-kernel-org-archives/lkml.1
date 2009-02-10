Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbZBJVu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbZBJVu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 16:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbZBJVuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 16:50:12 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:62133 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbZBJVuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 16:50:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=NuIu+St0MfgM3nhY4pWSfpFCg2eAn4Od/H6BDNAMPmCfpKhaA9lHZK3soNXHNbqyuu
         maKviZ3qKYZIY2xl0X4I7t1zcW4T3HoPDiWqjmwWjjuvFDCFOYihiVBglUzfmjkVZdJr
         Vz2O3xXlOmLQECFHeOc1O1pa1TYO2z3k0M9Bc=
MIME-Version: 1.0
In-Reply-To: <46e1c7760902101337qe239336n9ef2652a47f89aed@mail.gmail.com>
References: <46e1c7760901230433i3045f273oa109ce97e790bca3@mail.gmail.com>
	 <Pine.LNX.4.64.0901240951110.13803@anakin>
	 <46e1c7760901240109m5a0f3a85p788aa3ce35b49fa9@mail.gmail.com>
	 <Pine.LNX.4.64.0901241425310.13803@anakin>
	 <46e1c7760901240649v1e45bbb1v8c9997f236a3ec4c@mail.gmail.com>
	 <46e1c7760902101337qe239336n9ef2652a47f89aed@mail.gmail.com>
Date: Tue, 10 Feb 2009 23:50:08 +0200
Message-ID: <46e1c7760902101350r5a04d076j49cc611a843e6429@mail.gmail.com>
Subject: Re: [Linux-fbdev-devel] [PATCH] fb: hide cursor in graphics mode
From: Risto Suominen <risto.suominen@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: adaplas@pol.net, linux-fbdev-devel@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0016e6d59d1d841daf046297786b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6d59d1d841daf046297786b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

The same as attachment, so the last line won't disappear.

Risto

--0016e6d59d1d841daf046297786b
Content-Type: application/octet-stream; name="fbcon-graphics-nocursor.diff"
Content-Disposition: attachment; filename="fbcon-graphics-nocursor.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fr13h3x60

WHNlcnZlciBYZmJkZXYgKGtkcml2ZSkgdXNlcyBsaW51eCBmcmFtZWJ1ZmZlciBpbiBncmFwaGlj
cyBtb2RlLiBJdCBkb2Vzbid0Cm5lZWQgdGhlIHRleHQgbW9kZSBjdXJzb3IsIGl0J3MgYSBiaXQg
YW5ub3lpbmcgdG8gaGF2ZSBpdCB0aGVyZSBzaXR0aW5nIGluIGEKY29ybmVyLiBUaGlzIHBhdGNo
IGRpc2FibGVzIHRoZSBjdXJzb3IgZXZlbiB3aGVuIGluIGdyYXBoaWNzIG1vZGUuCgpTaWduZWQt
b2ZmLWJ5OiBSaXN0byBTdW9taW5lbiA8UmlzdG8uU3VvbWluZW5AZ21haWwuY29tPgotLS0KVGhl
IHRlc3RpbmcgaXMgZG9uZSBvbiBrZXJuZWwgdmVyc2lvbiAyLjYuMTguCgotLS0gYS9kcml2ZXJz
L3ZpZGVvL2NvbnNvbGUvZmJjb24uYy5vcmcJMjAwNy0wMy0wMyAwNzoxNDo1NC4wMDAwMDAwMDAg
KzAyMDAKKysrIGIvZHJpdmVycy92aWRlby9jb25zb2xlL2ZiY29uLmMJMjAwOS0wMS0yMyAxMjo0
MjoxNC4wMDAwMDAwMDAgKzAyMDAKQEAgLTEzNjMsNiArMTM2MywxMiBAQCBzdGF0aWMgdm9pZCBm
YmNvbl9jdXJzb3Ioc3RydWN0IHZjX2RhdGEgCiAJaW50IHk7CiAgCWludCBjID0gc2NyX3JlYWR3
KCh1MTYgKikgdmMtPnZjX3Bvcyk7CiAKKwlpZiAobW9kZSA9PSBDTV9FUkFTRSAmJiBpbmZvLT5m
Ym9wcy0+ZmJfY3Vyc29yKSB7CisJCS8qIEhpZGUgSC9XLWN1cnNvciB1bmNvbmRpdGlvbmFsbHkg
Ki8KKwkJb3BzLT5jdXJzb3IodmMsIGluZm8sIG1vZGUsIDAsIDAsIDApOworCQlyZXR1cm47CisJ
fQorCiAJaWYgKGZiY29uX2lzX2luYWN0aXZlKHZjLCBpbmZvKSB8fCB2Yy0+dmNfZGVjY20gIT0g
MSkKIAkJcmV0dXJuOwogCg==
--0016e6d59d1d841daf046297786b--
