Return-Path: <linux-kernel-owner+w=401wt.eu-S1764297AbXHDKBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764297AbXHDKBT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 06:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755285AbXHDKBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 06:01:11 -0400
Received: from mail.gmx.net ([213.165.64.20]:60489 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753886AbXHDKBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 06:01:10 -0400
X-Authenticated: #815327
X-Provags-ID: V01U2FsdGVkX1/lAAkAkwTlVMyTAXrZv2e2nS+LgCp6T+D20OQoEN
	oAI8kSMlce4H5r
Date: Sat, 4 Aug 2007 12:01:05 +0200
From: Malte =?UTF-8?B?U2NocsO2ZGVy?= <maltesch@gmx.de>
To: "Chakri n" <chakriin5@gmail.com>
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: OOPS in shrink_dcache_for_umount
Message-ID: <20070804120105.47ae82fc@highlander.home.lan>
In-Reply-To: <92cbf19b0708021427l7c88c642g3901e393ac2b90b9@mail.gmail.com>
References: <92cbf19b0708021427l7c88c642g3901e393ac2b90b9@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary=Sig_e4W3c19RHe5ff9CRa7Dn8pB;
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_e4W3c19RHe5ff9CRa7Dn8pB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 2 Aug 2007 14:27:04 -0700
"Chakri n" <chakriin5@gmail.com> wrote:

> Hi,
>=20
> We are seeing this problem while unmounting file systems. It happens
> once in a while.
> I am able to grab the trace and core from linux-2.6.18-1.8.el5, but I
> have observed the same problem with linux-2.6.20.1 kernel.
>=20
> Has this problem fixed in recent kernel?
>=20

I had those too ... but I haven't seen one in a while.
I currently run 2.6.22 + cfs-v19 + the Patch from
http://linux-nfs.org/Linux-2.6.x/2.6.22/linux-2.6.22-NFS_ALL.dif

--=20
---------------------------------------
Malte Schr=C3=B6der
MalteSch@gmx.de
ICQ# 68121508
---------------------------------------


--Sig_e4W3c19RHe5ff9CRa7Dn8pB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGtE5h4q3E2oMjYtURAtATAKDxxFKJtJ9fIF2o7MeCSs1WWVCE6wCfY8+c
SRhCkvQdIUSUo1wJiDvzDVY=
=MycX
-----END PGP SIGNATURE-----

--Sig_e4W3c19RHe5ff9CRa7Dn8pB--
