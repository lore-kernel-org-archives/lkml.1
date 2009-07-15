Return-Path: <linux-kernel-owner+w=401wt.eu-S1754406AbZGOLz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbZGOLz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 07:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbZGOLz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 07:55:28 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:57347 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbZGOLz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 07:55:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type;
        b=D+PHskulAjBe6qNwucEOv/riUSRYVuQCtTRzcg9La3QSXu6kE50tVj8ScyfK1OYeKs
         SNfQRbTHz0opDJ3NSSgbyMiv+jCjDGmDadUe42HCqSXB/StI5+9aLb3ab/vb+H5hRE7u
         Sjqw0JJ5/f3udf+jPpjZSBov2IzWPadVBL1NE=
Date: Wed, 15 Jul 2009 13:56:49 +0200
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] - updated F and T in Maintainers (kristoffer ericson)
Message-Id: <20090715135649.3ff3b107.kristoffer.ericson@gmail.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Wed__15_Jul_2009_13_56_49_+0200_2LHXNlIYuGXidKoN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Wed__15_Jul_2009_13_56_49_+0200_2LHXNlIYuGXidKoN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

This patch adds the relevant git repositories and affected files to the 
maintainership of HP Jornada 700-series and Epson s1d13xxxfb support.

Signed-off-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 9d1601e..39cd895 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -709,6 +709,9 @@ P:	Kristoffer Ericson
 M:	kristoffer.ericson@gmail.com
 W:	www.jlime.com
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kristoffer/linux-hpc.git
+F:	arch/arm/mach-sa1100/jornada720.c
+F:	arch/arm/mach-sa1100/include/mach/jornada720.h
 
 ARM/INTEL IOP32X ARM ARCHITECTURE
 P:	Lennert Buytenhek
@@ -2215,6 +2218,7 @@ EPSON S1D13XXX FRAMEBUFFER DRIVER
 P:	Kristoffer Ericson
 M:	kristoffer.ericson@gmail.com
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kristoffer/linux-hpc.git
 F:	drivers/video/s1d13xxxfb.c
 F:	include/video/s1d13xxxfb.h
 


-- 
Kristoffer Ericson <kristoffer.ericson@gmail.com>

--Multipart=_Wed__15_Jul_2009_13_56_49_+0200_2LHXNlIYuGXidKoN
Content-Type: application/octet-stream;
 name="maintainers-2.6.30.patch"
Content-Disposition: attachment;
 filename="maintainers-2.6.30.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL01BSU5UQUlORVJTIGIvTUFJTlRBSU5FUlMKaW5kZXggOWQxNjAxZS4uMzlj
ZDg5NSAxMDA2NDQKLS0tIGEvTUFJTlRBSU5FUlMKKysrIGIvTUFJTlRBSU5FUlMKQEAgLTcwOSw2
ICs3MDksOSBAQCBQOglLcmlzdG9mZmVyIEVyaWNzb24KIE06CWtyaXN0b2ZmZXIuZXJpY3NvbkBn
bWFpbC5jb20KIFc6CXd3dy5qbGltZS5jb20KIFM6CU1haW50YWluZWQKK1Q6CWdpdCBnaXQ6Ly9n
aXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQva3Jpc3RvZmZlci9saW51eC1o
cGMuZ2l0CitGOglhcmNoL2FybS9tYWNoLXNhMTEwMC9qb3JuYWRhNzIwLmMKK0Y6CWFyY2gvYXJt
L21hY2gtc2ExMTAwL2luY2x1ZGUvbWFjaC9qb3JuYWRhNzIwLmgKIAogQVJNL0lOVEVMIElPUDMy
WCBBUk0gQVJDSElURUNUVVJFCiBQOglMZW5uZXJ0IEJ1eXRlbmhlawpAQCAtMjIxNSw2ICsyMjE4
LDcgQEAgRVBTT04gUzFEMTNYWFggRlJBTUVCVUZGRVIgRFJJVkVSCiBQOglLcmlzdG9mZmVyIEVy
aWNzb24KIE06CWtyaXN0b2ZmZXIuZXJpY3NvbkBnbWFpbC5jb20KIFM6CU1haW50YWluZWQKK1Q6
CWdpdCBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQva3Jpc3Rv
ZmZlci9saW51eC1ocGMuZ2l0CiBGOglkcml2ZXJzL3ZpZGVvL3MxZDEzeHh4ZmIuYwogRjoJaW5j
bHVkZS92aWRlby9zMWQxM3h4eGZiLmgKIAo=

--Multipart=_Wed__15_Jul_2009_13_56_49_+0200_2LHXNlIYuGXidKoN--
