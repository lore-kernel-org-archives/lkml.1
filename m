Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbZKIWpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbZKIWpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 17:45:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbZKIWpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 17:45:03 -0500
Received: from imp03.mtu.ru ([62.5.255.20]:35255 "EHLO imp03.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbZKIWpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 17:45:02 -0500
From: Pavel Vasilyev <pavel@pavlinux.ru>
Organization: Pavlinux. Inc
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation/scsi/aic79xx.txt
Date: Tue, 10 Nov 2009 01:40:51 +0300
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc6; KDE/4.3.3; x86_64; ; )
X-Face: $dO4505L-bM3\Iz"(
 =?utf-8?q?V=3Dy=2EbL/75=7B5ys3=3AB=5B-aPBQvs*Z=25fdBqFhvc85hmZN4j1kwRzwvY*?=
 =?utf-8?q?R=0A=094=09nvQ/=23/+kWXH?=((aXWh\%mvG1V()Z0k:NwZAIu\S0d1%,nv`^
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart21346912.yH7ZFqp0JQ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200911100141.04280.pavel@pavlinux.ru>
X-Spam-Flag: NO
X-Spam-Yversion: Spamooborona-3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart21346912.yH7ZFqp0JQ
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

2.6.32-rc6, latest git


diff -ur a/Documentation/scsi/aic79xx.txt b/Documentation/scsi/aic79xx.txt
--- a/Documentation/scsi/aic79xx.txt    2009-11-10 01:37:25.054003554 +0300
+++ b/Documentation/scsi/aic79xx.txt    2009-11-10 01:37:59.575004426 +0300
@@ -269,7 +269,7 @@
                       per controller basis.  Both controllers and targets
                       may be ommitted indicating that they should retain
                       the default tag depth.
-            Examples: tag_info:{{16,32,32,64,8,8,,32,32,32,32,32,32,32,32,32}
+           Examples: tag_info:{{16,32,32,64,8,8,,32,32,32,32,32,32,32,32,32}}
                         On Controller 0
                           specifies a tag depth of 16 for target 0
                           specifies a tag depth of 64 for target 3


--nextPart21346912.yH7ZFqp0JQ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkr4moAACgkQOqfDywN0JIlwLwCgrpcS8Hod0Q7c6/VR/xbdtlBp
hYcAn1hNauWET6cpFkfJu2eJb6+QQjSp
=m1j0
-----END PGP SIGNATURE-----

--nextPart21346912.yH7ZFqp0JQ--
