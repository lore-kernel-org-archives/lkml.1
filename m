Return-Path: <linux-kernel-owner+w=401wt.eu-S932378AbXBSQSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378AbXBSQSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 11:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932387AbXBSQSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 11:18:53 -0500
Received: from mail.gmx.net ([213.165.64.20]:54055 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932378AbXBSQSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 11:18:53 -0500
X-Provags-ID: V01U2FsdGVkX1/6GMMTBlP6CGFaF+/PA8IiSNaYOOSSRNCD/N8OiJ
	GBgw==
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Paulo Marques <pmarques@grupopie.com>
Subject: Re: linux-2.6.19.3 build faild with "Inconsistent kallsyms data"
Date: Mon, 19 Feb 2007 17:18:48 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200702190917.16533.toralf.foerster@gmx.de> <45D9B356.9050009@grupopie.com>
In-Reply-To: <45D9B356.9050009@grupopie.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3432945.ZKtDJfZ3Jm";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702191718.50650.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3432945.ZKtDJfZ3Jm
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Montag, 19. Februar 2007 15:25 schrieb Paulo Marques:
> Toralf F=F6rster wrote:
> > Hello,
> >=20
> > the build with the attached .config failed, make ends with:
> > ...
> > scripts/kconfig/conf -s arch/i386/Kconfig
> >   CHK     include/linux/version.h
> >   CHK     include/linux/utsrelease.h
> >   CHK     include/linux/compile.h
> >   AS      .tmp_kallsyms2.o
> >   LD      vmlinux
> >   SYSMAP  System.map
> >   SYSMAP  .tmp_System.map
> > Inconsistent kallsyms data
> > Try setting CONFIG_KALLSYMS_EXTRA_PASS
> > make: *** [vmlinux] Error 1
> >=20
> > Here's the config:
>=20
> Hummm, I just tried that .config with a vanilla 2.6.19.3 and it built=20
> just fine.
>=20
You're right, I tried it twice again and it buils fine - don't know what ha=
ppend during the first build - sorry for the noise.

=2D-=20
MfG/Sincerely

Toralf F=F6rster

--nextPart3432945.ZKtDJfZ3Jm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBF2c3qhyrlCH22naMRAtTFAJ0Us6NlfqWlweRrZ6fGhOwOQbXgUQCeLrHY
pAUjmbkhlwOLIOI5GwAY8V8=
=BhP4
-----END PGP SIGNATURE-----

--nextPart3432945.ZKtDJfZ3Jm--
