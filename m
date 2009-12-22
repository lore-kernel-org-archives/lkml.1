Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbZLVUmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbZLVUmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 15:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbZLVUmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 15:42:42 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:22450 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbZLVUml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 15:42:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Zng0BSYxOea0oVp1ievXHYLZmGVVG6B5FwQwDTok9BTTgca0Jy1vVL1e7QlQM6RIc2
         msJ9LZvEepDFVpEzOhck/3Im0X36EZbFtZpEn8U06WkLvJTsbApIJtj4OwIdBcpLy+PQ
         vXzSpHvHghYiffwrcK09fn19vgO3IUFeLIjzU=
MIME-Version: 1.0
Date: Tue, 22 Dec 2009 15:42:39 -0500
Message-ID: <b3eb0ed40912221242h183cb99o1be6f76630769de5@mail.gmail.com>
Subject: Oops in 2.6.27.39 with Latest DTrace linux port.
From: Soumendu Satapathy <satapathy.soumendu@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=001636498a83342790047b573ff3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636498a83342790047b573ff3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

http://lkml.org/lkml/2009/12/22/219

Genuinely sorry , =A0attaching the patch once again as there was some issue=
s.


- Soumendu Sekhar Satapathy

--001636498a83342790047b573ff3
Content-Type: application/octet-stream; name=patch
Content-Disposition: attachment; filename=patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g3j52xz80

LS0tIGRyaXZlci9kdHJhY2VfbGludXguYy5vcmlnCTIwMDktMTItMjIgMjA6MzM6MDIuMjM5Mzgz
MDAwICswMDAwCisrKyBkcml2ZXIvZHRyYWNlX2xpbnV4LmMJMjAwOS0xMi0yMiAyMDozNTowMS44
NzAxOTYwMDAgKzAwMDAKQEAgLTE0NTAsNyArMTQ1MCwxNSBAQAogLy8JCXByaW50aygieXk6IHBt
ZD0lbHhcbiIsICpwbWQpOwogCQlyZXR1cm4gMDsKIAl9Ci0JcHRlID0gcHRlX29mZnNldF9rZXJu
ZWwocG1kLCBhZGRyKTsKKworCWlmIChwbWRfbGFyZ2UoKnBtZCkpIAorICAgICAgICAgICAgICAg
IHB0ZSA9IChwdGVfdCAqKXBtZDsKKyAgICAgICAgZWxzZSAKKyAgICAgICAgICAgICAgICBwdGUg
PSBwdGVfb2Zmc2V0X2tlcm5lbChwbWQsIGFkZHIpOworCisgICAgICAgIGlmIChwdGVfbm9uZSgq
cHRlKSkKKyAgICAgICAgICAgICAgICByZXR1cm4gMDsKKwogCWlmIChkdW1wX3RyZWUpIHsKIAkJ
cHJpbnRrKCJ5eSAtLSBiZWdpblxuIik7CiAJCXByaW50X3B0ZSgocHRlX3QgKikgcGdkLCAwKTsK
--001636498a83342790047b573ff3--
