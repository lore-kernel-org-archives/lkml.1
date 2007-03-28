Return-Path: <linux-kernel-owner+w=401wt.eu-S933030AbXC1QrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030AbXC1QrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 12:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933133AbXC1QrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 12:47:11 -0400
Received: from mail.gmx.net ([213.165.64.20]:55764 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933030AbXC1QrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 12:47:10 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/5tI41W0z5KFSczu0g/YjpspvW1owV07UTMWFUNj
	TItAfjxp/pSYig
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: andrea@suse.de
Subject: fs/block_dev.c:953: warning: 'found' might be used uninitialized in this function
Date: Wed, 28 Mar 2007 18:47:02 +0200
User-Agent: KMail/1.9.5
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2270823.slyZ4iofkq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200703281847.05356.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2270823.slyZ4iofkq
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I compiled current git source 2.6.21-rc5-g28defbe and got this warning:
=2E..
fs/block_dev.c: In function `bd_claim_by_kobject':
fs/block_dev.c:953: warning: 'found' might be used uninitialized in this fu=
nction
=2E..

=2D-=20
MfG/Sincerely

Toralf F=F6rster

--nextPart2270823.slyZ4iofkq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGCpwJhyrlCH22naMRAuMqAKDI/fiW13vFbONrffyM1hluSCEN3wCgqBdN
j29Z/552ebO1wGrfmP5E/6g=
=AWjH
-----END PGP SIGNATURE-----

--nextPart2270823.slyZ4iofkq--
