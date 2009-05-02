Return-Path: <linux-kernel-owner+w=401wt.eu-S1752359AbZEBFY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359AbZEBFY1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 01:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbZEBFYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 01:24:18 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38087 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbZEBFYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 01:24:18 -0400
Date: Sat, 2 May 2009 15:24:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>
Subject: Re: linux-next: Tree for May 1 (tmpfs)
Message-Id: <20090502152414.547a8052.sfr@canb.auug.org.au>
In-Reply-To: <49FB12D0.5030809@oracle.com>
References: <20090501163405.973f9088.sfr@canb.auug.org.au>
	<49FB12D0.5030809@oracle.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__2_May_2009_15_24_14_+1000_zqHFeFzCGRX_.I2g"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__2_May_2009_15_24_14_+1000_zqHFeFzCGRX_.I2g
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Just added some cc's]

On Fri, 01 May 2009 08:18:40 -0700 Randy Dunlap <randy.dunlap@oracle.com> w=
rote:
>=20
> When CONFIG_SHMEM=3Dn:
>=20
> init/built-in.o: In function `kernel_init':
> main.c:(.init.text+0x8be): undefined reference to `init_tmpfs'
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__2_May_2009_15_24_14_+1000_zqHFeFzCGRX_.I2g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkn72P4ACgkQjjKRsyhoI8yUNQCfSsDBcLL8oTmcIQ69giSG8gzO
vSsAn2dUspDIKizsGcfyFpirsuMGMTXX
=FbEb
-----END PGP SIGNATURE-----

--Signature=_Sat__2_May_2009_15_24_14_+1000_zqHFeFzCGRX_.I2g--
