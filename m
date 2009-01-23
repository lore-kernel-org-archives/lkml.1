Return-Path: <linux-kernel-owner+w=401wt.eu-S1761450AbZAWJy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761450AbZAWJy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 04:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbZAWJyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 04:54:49 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:33100 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463AbZAWJys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 04:54:48 -0500
Date: Fri, 23 Jan 2009 10:54:46 +0100
From: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Rebooting at boot: linux-next: Tree for January 22
Message-ID: <20090123095446.GB4436@denkbrett.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20090122180543.1ab0baa6.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FkmkrVfFsRoUs1wW"
Content-Disposition: inline
In-Reply-To: <20090122180543.1ab0baa6.sfr@canb.auug.org.au>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.28-rc9-wl-denkbrett-24896-gf4f5c96 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello!

Stephen Rothwell [Thu, Jan 22, 2009 at 06:05:43PM +1100]:
> Hi all,
>=20
> Changes since 20090121:

This kernel instantly reboots after being booted on the x200.
With 20090121 it booted, but suspend is still broken.

I'm back on 2.6.28-rc9-wl-denkbrett-24896-gf4f5c96, which almost
always suspends and wakes up: After some days of suspend/wakeup
this kernel also freezes.

I suspect there's more than one bug in the suspend code.

Sincerly,

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--FkmkrVfFsRoUs1wW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkl5k+YACgkQuL75KpiFGIwkWACdFCr3OmjmUKvN0FzMpPd2GEDz
4wMAoI/uSEGnD8eQd2Z8/+MxgQQBCi6V
=8LZg
-----END PGP SIGNATURE-----

--FkmkrVfFsRoUs1wW--
