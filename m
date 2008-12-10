Return-Path: <linux-kernel-owner+w=401wt.eu-S1753633AbYLJL1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbYLJL1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 06:27:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbYLJL1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 06:27:38 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:54760 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbYLJL1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 06:27:37 -0500
Date: Wed, 10 Dec 2008 12:27:30 +0100
From: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 8
Message-ID: <20081210112730.GA11869@denkbrett.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20081208205929.366a9a01.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <20081208205929.366a9a01.sfr@canb.auug.org.au>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.28-rc6-wl-denkbrett-21906-g24e8b9a x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Stephen Rothwell [Mon, Dec 08, 2008 at 08:59:29PM +1100]:
> Hi all,
>=20
> Changes since 20081204:

kryptd crashes now:

- first time cryptsetup is called I get a call trace
- after the second time cryptsetup is called, I get a call trace
  and system freeze

Error message can be found at

http://home.schottelius.org/~nico/unix/linux/kernel/next-20081208-kcrypt.jp=
eg

Sincerly,

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkk/p6IACgkQuL75KpiFGIzDUQCffOsbgyKidYSSNXLGU9x3loYB
NnsAnR962/aifvcFTfVd8hfhzC9ULjoG
=8hA7
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
