Return-Path: <linux-kernel-owner+w=401wt.eu-S1758525AbYCNAJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525AbYCNAJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 20:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbYCNAJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 20:09:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:61072 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772AbYCNAJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 20:09:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=db1ZyLMhPNY4vPZ4Lm4hi2bh0YvLtkwt1dQm1Ifcrymu2PgqY+8ZhgtBdYfzGfE4TKUbxMUWh9OuzsxhNGHv8YbQq9au+/KHLuYTN0KpulS3atymsrWqyOs5lnx/zgKmmqBVqNWr5Srwx0CsEFq24nFuEhdd6gt/t2K6Iu/dft8=
Message-ID: <9810cff90803131709m3a5b1e5ep2bfe566b3c3bdb66@mail.gmail.com>
Date: Thu, 13 Mar 2008 17:09:15 -0700
From: "Bill Huey (hui)" <bill.huey@gmail.com>
To: "Gregory Haskins" <ghaskins@novell.com>, mingo@elte.hu
Subject: Re: [PATCH RT 2/6] lockstat measurement extensions
Cc: a.p.zijlstra@chello.nl, tglx@linutronix.de, rostedt@goodmis.org,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       kevin@hilman.org, cminyard@mvista.com, dsingleton@mvista.com,
       dwalker@mvista.com, npiggin@suse.de, dsaxena@plexity.net, ak@suse.de,
       pavel@ucw.cz, acme@redhat.com, gregkh@suse.de, sdietrich@novell.com,
       pmorreale@novell.com, mkohari@novell.com
In-Reply-To: <9810cff90803131707v4fb3197fv396b8a5e8ae32b4d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_25278_30175704.1205453360132"
References: <9810cff90803131703t3626d83fq727b04242f407c13@mail.gmail.com>
	 <9810cff90803131707v4fb3197fv396b8a5e8ae32b4d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_25278_30175704.1205453360132
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Function prototype redefinitions.

bill

------=_Part_25278_30175704.1205453360132
Content-Type: application/octet-stream; name=patch1.diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fdrzr6b9
Content-Disposition: attachment; filename=patch1.diff

LS0tIGxpbnV4LTIuNi4yNC9pbmNsdWRlL2xpbnV4L3J0bXV0ZXguaAkyMDA4LTAyLTI1IDE1OjMy
OjA1LjAwMDAwMDAwMCAtMDgwMAorKysgbGludXgtMi42LjI0LndvcmtpbmcvaW5jbHVkZS9saW51
eC9ydG11dGV4LmgJMjAwOC0wMy0wNCAwMTowMTowNi4wMDAwMDAwMDAgLTA4MDAKQEAgLTg1LDE0
ICs4NSwxNSBAQAogZXh0ZXJuIHZvaWQgX19ydF9tdXRleF9pbml0KHN0cnVjdCBydF9tdXRleCAq
bG9jaywgY29uc3QgY2hhciAqbmFtZSk7CiBleHRlcm4gdm9pZCBydF9tdXRleF9kZXN0cm95KHN0
cnVjdCBydF9tdXRleCAqbG9jayk7CiAKLWV4dGVybiB2b2lkIHJ0X211dGV4X2xvY2soc3RydWN0
IHJ0X211dGV4ICpsb2NrKTsKK2V4dGVybiB2b2lkIHJ0X211dGV4X2xvY2soc3RydWN0IHJ0X211
dGV4ICpsb2NrIF9fTE9DS0RFUF9ERUNMUyk7CiBleHRlcm4gaW50IHJ0X211dGV4X2xvY2tfaW50
ZXJydXB0aWJsZShzdHJ1Y3QgcnRfbXV0ZXggKmxvY2ssCi0JCQkJCQlpbnQgZGV0ZWN0X2RlYWRs
b2NrKTsKKwkJCQkJCWludCBkZXRlY3RfZGVhZGxvY2sgX19MT0NLREVQX0RFQ0xTKTsKIGV4dGVy
biBpbnQgcnRfbXV0ZXhfdGltZWRfbG9jayhzdHJ1Y3QgcnRfbXV0ZXggKmxvY2ssCiAJCQkJCXN0
cnVjdCBocnRpbWVyX3NsZWVwZXIgKnRpbWVvdXQsCiAJCQkJCWludCBkZXRlY3RfZGVhZGxvY2sp
OwogCiBleHRlcm4gaW50IHJ0X211dGV4X3RyeWxvY2soc3RydWN0IHJ0X211dGV4ICpsb2NrKTsK
K2V4dGVybiBpbnQgX19ydF9tdXRleF90cnlsb2NrKHN0cnVjdCBydF9tdXRleCAqbG9jayBfX0xP
Q0tERVBfREVDTFMpOwogCiBleHRlcm4gdm9pZCBydF9tdXRleF91bmxvY2soc3RydWN0IHJ0X211
dGV4ICpsb2NrKTsKIAotLS0gbGludXgtMi42LjI0L2luY2x1ZGUvbGludXgvc2NoZWQuaAkyMDA4
LTAyLTI1IDE1OjMyOjA1LjAwMDAwMDAwMCAtMDgwMAorKysgbGludXgtMi42LjI0Lndvcmtpbmcv
aW5jbHVkZS9saW51eC9zY2hlZC5oCTIwMDgtMDMtMTMgMDA6NDA6MDIuMDAwMDAwMDAwIC0wNzAw
CkBAIC0yMDkzLDEwICsyMDkzLDE3IEBACiBleHRlcm4gdm9pZCBzaWduYWxfd2FrZV91cChzdHJ1
Y3QgdGFza19zdHJ1Y3QgKnQsIGludCByZXN1bWVfc3RvcHBlZCk7CiAKIC8qCisgKiBsb2Nrc3Rh
dCBzdXBwb3J0CisgKi8KK2V4dGVybiBpbnQgdGFza19zcGlubmFibGUoc3RydWN0IHRhc2tfc3Ry
dWN0ICpwKTsKKworLyoKICAqIFdyYXBwZXJzIGZvciBwLT50aHJlYWRfaW5mby0+Y3B1IGFjY2Vz
cy4gTm8tb3Agb24gVVAuCiAgKi8KICNpZmRlZiBDT05GSUdfU01QCiAKK2V4dGVybiBhdG9taWNf
dCBjcHVfcmFuZ2VfZXJyb3I7CisKIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgaW50IHRhc2tfY3B1
KGNvbnN0IHN0cnVjdCB0YXNrX3N0cnVjdCAqcCkKIHsKIAlyZXR1cm4gdGFza190aHJlYWRfaW5m
byhwKS0+Y3B1OwotLS0gbGludXgtMi42LjI0L2luY2x1ZGUvbGludXgvc3BpbmxvY2suaAkyMDA4
LTAyLTI1IDE1OjMyOjA1LjAwMDAwMDAwMCAtMDgwMAorKysgbGludXgtMi42LjI0Lndvcmtpbmcv
aW5jbHVkZS9saW51eC9zcGlubG9jay5oCTIwMDgtMDMtMDMgMTQ6MDE6NDguMDAwMDAwMDAwIC0w
ODAwCkBAIC0xNjksNyArMTY5LDcgQEAKICAqIGxvY2tkZXAtbGVzcyBjYWxscywgZm9yIGRlcml2
ZWQgdHlwZXMgbGlrZSByd2xvY2s6CiAgKiAoZm9yIHRyeWxvY2sgdGhleSBjYW4gdXNlIHJ0X211
dGV4X3RyeWxvY2soKSBkaXJlY3RseS4KICAqLwotZXh0ZXJuIHZvaWQgX19sb2NrZnVuYyBfX3J0
X3NwaW5fbG9jayhzdHJ1Y3QgcnRfbXV0ZXggKmxvY2spOworZXh0ZXJuIHZvaWQgX19sb2NrZnVu
YyBfX3J0X3NwaW5fbG9jayhzdHJ1Y3QgcnRfbXV0ZXggKmxvY2sgX19MT0NLREVQX0RFQ0xTKTsK
IGV4dGVybiB2b2lkIF9fbG9ja2Z1bmMgX19ydF9zcGluX3VubG9jayhzdHJ1Y3QgcnRfbXV0ZXgg
KmxvY2spOwogCiAjaWZkZWYgQ09ORklHX1BSRUVNUFRfUlQK
------=_Part_25278_30175704.1205453360132--
