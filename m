Return-Path: <linux-kernel-owner+w=401wt.eu-S1759437AbZAUMco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437AbZAUMco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 07:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764294AbZAUMc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 07:32:27 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:35384 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764478AbZAUMc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 07:32:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=aLyAwm0tPGBwQizPd/KFgBuaCqLx8SzrFKKcsej63D+Vy3WC7KFuUXiWxTaiZoFhgv
         1mjDGYiVt+giBhZoQVj+BmC1x+P+d4u1JvCM5jdtU5HJt2udH94WtD6ISBVmaQypVWrh
         ztPyowfBnSUTyWs8nFhv+4w9Pms8i0bdrUdO8=
MIME-Version: 1.0
Date: Wed, 21 Jan 2009 13:32:23 +0100
Message-ID: <5787cf470901210432l5327e48el94c53c8fb7fd6d1d@mail.gmail.com>
Subject: [patch] x86: Unneeded assignment to tsk in recent x86 change
From: Uros Bizjak <ubizjak@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=001636c5a7970804390460fd59db
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636c5a7970804390460fd59db
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello!

Impact: Cleanup.

Remove unneeded assignment to tsk in recent x86 change [1].

[1]: http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=commitdiff;h=d737c7649e2f7bdaa8760a9205dffaa45c117f20

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>

Patch vs. tip/master.

Uros.

--001636c5a7970804390460fd59db
Content-Type: text/plain; charset=US-ASCII; name="l.diff.txt"
Content-Disposition: attachment; filename="l.diff.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fq7z5a3n0

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L21tL2ZhdWx0LmMgYi9hcmNoL3g4Ni9tbS9mYXVsdC5jCmlu
ZGV4IDkzYTU2M2IuLjYyMWU5YjMgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L21tL2ZhdWx0LmMKKysr
IGIvYXJjaC94ODYvbW0vZmF1bHQuYwpAQCAtNDIxLDcgKzQyMSw2IEBAIHN0YXRpYyBub2lubGlu
ZSB2b2lkIHBndGFibGVfYmFkKHN0cnVjdCBwdF9yZWdzICpyZWdzLAogCXByaW50ayhLRVJOX0FM
RVJUICIlczogQ29ycnVwdGVkIHBhZ2UgdGFibGUgYXQgYWRkcmVzcyAlbHhcbiIsCiAJICAgICAg
IHRzay0+Y29tbSwgYWRkcmVzcyk7CiAJZHVtcF9wYWdldGFibGUoYWRkcmVzcyk7Ci0JdHNrID0g
Y3VycmVudDsKIAl0c2stPnRocmVhZC5jcjIgPSBhZGRyZXNzOwogCXRzay0+dGhyZWFkLnRyYXBf
bm8gPSAxNDsKIAl0c2stPnRocmVhZC5lcnJvcl9jb2RlID0gZXJyb3JfY29kZTsKQEAgLTc5NSwx
MyArNzk0LDEyIEBAIGFzbWxpbmthZ2UKIHZvaWQgX19rcHJvYmVzIGRvX3BhZ2VfZmF1bHQoc3Ry
dWN0IHB0X3JlZ3MgKnJlZ3MsIHVuc2lnbmVkIGxvbmcgZXJyb3JfY29kZSkKIHsKIAl1bnNpZ25l
ZCBsb25nIGFkZHJlc3M7Ci0Jc3RydWN0IHRhc2tfc3RydWN0ICp0c2s7CisJc3RydWN0IHRhc2tf
c3RydWN0ICp0c2sgPSBjdXJyZW50OwogCXN0cnVjdCBtbV9zdHJ1Y3QgKm1tOwogCXN0cnVjdCB2
bV9hcmVhX3N0cnVjdCAqdm1hOwogCWludCB3cml0ZTsKIAlpbnQgZmF1bHQ7CiAKLQl0c2sgPSBj
dXJyZW50OwogCW1tID0gdHNrLT5tbTsKIAlwcmVmZXRjaHcoJm1tLT5tbWFwX3NlbSk7CiAK
--001636c5a7970804390460fd59db--
