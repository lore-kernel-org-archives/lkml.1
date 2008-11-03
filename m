Return-Path: <linux-kernel-owner+w=401wt.eu-S1754976AbYKCINT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbYKCINT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 03:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbYKCINI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 03:13:08 -0500
Received: from pusher.mail.ru ([194.67.23.231]:7102 "EHLO mx48.mail.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753238AbYKCINH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 03:13:07 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-ext4@vger.kernel.org
Subject: 2.6.28-rc3: ext4_ext_search_right: =?utf-8?q?=E2=80=98ix=E2=80=99_may_be_used?= uninitialized
Date: Mon, 3 Nov 2008 11:12:59 +0300
User-Agent: KMail/1.9.10
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1574675.CcO6eUx3RS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200811031113.01297.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1574675.CcO6eUx3RS
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

  CC [M]  fs/ext4/extents.o
/home/bor/src/linux-git/fs/ext4/extents.c: In function =E2=80=98ext4_ext_se=
arch_right=E2=80=99:
/home/bor/src/linux-git/fs/ext4/extents.c:1120: warning: =E2=80=98ix=E2=80=
=99 may be used uninitialized in this function

{pts/1}% rpm -q gcc
gcc-4.3.2-3mnb2
{pts/1}%      =20

on Mandriva cooker

--nextPart1574675.CcO6eUx3RS
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkOso0ACgkQR6LMutpd94z+9QCgxclE6QaQ98NCiVVXy0dMIHz3
0roAoJ/+IUfJftcC9fVlUZrSBzkMGJjs
=4FO/
-----END PGP SIGNATURE-----

--nextPart1574675.CcO6eUx3RS--
