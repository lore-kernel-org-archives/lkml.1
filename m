Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293AbYKKDLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbYKKDLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 22:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754183AbYKKDLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 22:11:11 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:57404 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbYKKDLK (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 22:11:10 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: 28-rc4-mmotm1110 build error with CONFIG_KEXEC=y
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1226373066_3458P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 10 Nov 2008 22:11:06 -0500
Message-ID: <34270.1226373066@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1226373066_3458P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Build ka-blam number 1:

  CC      init/initramfs.o
In file included from init/initramfs.c:542:
include/linux/kexec.h:201: error: braced-group within expression allowed =
only inside a function
include/linux/kexec.h:201: error: braced-group within expression allowed =
only inside a function
include/linux/kexec.h:201: error: braced-group within expression allowed =
only inside a function
include/linux/kexec.h:202: warning: type defaults to =E2=80=98int=E2=80=
=99 in declaration of =E2=80=98crash_notes=E2=80=99
include/linux/kexec.h:203: error: braced-group within expression allowed =
only inside a function
include/linux/kexec.h:203: error: braced-group within expression allowed =
only inside a function
make=5B1=5D: *** =5Binit/initramfs.o=5D Error 1
make: *** =5Binit=5D Error 2



--==_Exmh_1226373066_3458P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJGPfKcC3lWbTT17ARAi4OAKDvTh5zjkLAesFe0mRgZ2GTePEkQgCfdPZQ
ObLQ4pem1W8vizixAiYqa9g=
=ugDt
-----END PGP SIGNATURE-----

--==_Exmh_1226373066_3458P--
