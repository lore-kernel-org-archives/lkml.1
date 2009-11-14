Return-Path: <linux-kernel-owner+w=401wt.eu-S1755042AbZKNJJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbZKNJJv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 04:09:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbZKNJJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 04:09:49 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:49264 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbZKNJJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 04:09:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=d9eQ+TuTW6v6k6GODApPEJHdrxw23LXKZPc1Tj8DcDvS1Q2ltfDgOG/6uBcOCUCzYy
         xPC0Dr3pKQCfmP5e4BloMmimSUJRyZcnUYnDTSDu0XnUKBBc2G+kEFaA6nvjS3DMwpQc
         TKp7t5pcdiqxc4crLIsD9il64gclXdAk3uix4=
MIME-Version: 1.0
Date: Sat, 14 Nov 2009 17:09:53 +0800
Message-ID: <e5b1e8d40911140109k78721b1er7b167d05d6f2e26e@mail.gmail.com>
Subject: [stk-webcam] change constants to work better on FreeBSD
From: Buganini <buganini@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: multipart/mixed; boundary=000e0cd5f6fab6ef62047851234e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd5f6fab6ef62047851234e
Content-Type: text/plain; charset=UTF-8

Suggested by hselasky@FreeBSD.org, tested by me on FreeBSD.
With original value it hangs a lot.

I dont fully understand background knowledge,
it's said that the default value is not enough for high speed transfer.


--Buganini

--000e0cd5f6fab6ef62047851234e
Content-Type: application/octet-stream; name="stk-webcam.h.patch"
Content-Disposition: attachment; filename="stk-webcam.h.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

LS0tIGxpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vc3RrLXdlYmNhbS5oLm9yaWcJMjAwOS0xMS0x
MiAyMjoyMTowNS4wMDAwMDAwMDAgKzA4MDAKKysrIGxpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8v
c3RrLXdlYmNhbS5oCTIwMDktMTEtMTIgMDI6NDI6NDUuNjE2NjAzMzc5ICswODAwCkBAIC0yOCw4
ICsyOCw4IEBACiAjZGVmaW5lIERSSVZFUl9WRVJTSU9OCQkidjAuMC4xIgogI2RlZmluZSBEUklW
RVJfVkVSU0lPTl9OVU0JMHgwMDAwMDEKIAotI2RlZmluZSBNQVhfSVNPX0JVRlMJCTMKLSNkZWZp
bmUgSVNPX0ZSQU1FU19QRVJfREVTQwkxNgorI2RlZmluZSBNQVhfSVNPX0JVRlMJCTIKKyNkZWZp
bmUgSVNPX0ZSQU1FU19QRVJfREVTQwk2NAogI2RlZmluZSBJU09fTUFYX0ZSQU1FX1NJWkUJMyAq
IDEwMjQKICNkZWZpbmUgSVNPX0JVRkZFUl9TSVpFCQkoSVNPX0ZSQU1FU19QRVJfREVTQyAqIElT
T19NQVhfRlJBTUVfU0laRSkKIAo=
--000e0cd5f6fab6ef62047851234e--
