Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbZCZRTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbZCZRTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 13:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbZCZRTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 13:19:03 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:43392 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbZCZRTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 13:19:01 -0400
Date: Thu, 26 Mar 2009 18:18:57 +0100
From: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Invalid module format: Re: linux-next: Tree for March 24
Message-ID: <20090326171857.GF6496@denkbrett.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20090324183024.59260457.sfr@canb.auug.org.au> <20090324170215.GB5495@denkbrett.schottelius.org> <20090325094159.8dad1d49.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="S5HS5MvDw4DmbRmb"
Content-Disposition: inline
In-Reply-To: <20090325094159.8dad1d49.sfr@canb.auug.org.au>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.29 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--S5HS5MvDw4DmbRmb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Stephen Rothwell [Wed, Mar 25, 2009 at 09:41:59AM +1100]:
> Hi Nico,
>=20
> On Tue, 24 Mar 2009 18:02:15 +0100 Nico -telmich- Schottelius <nico-linux=
-next@schottelius.org> wrote:
> >
> >=20
> > My system does not bootup, as I cannot load the crypto modules,
> > because it says
> >=20
> >   Invalid module format
>=20
> Architecture?

amd64

> config?

http://git.schottelius.org/?p=3Dconfigs/linux;a=3Dblob;f=3Dlenovo/x200/next=
-20090324;h=3D5eba35aca92d2f244831efea7c20c2e1e3cccda6;hb=3D325f152e27f4872=
0763e0ad3e99b69049ab90116

> any other boot messages?

sure, normal, until it tries to access my hd

> Is it just the crypto modules?

Cannot check, as it does not bootup. But I did not see
any other before.

Sincerly,

Nico



--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--S5HS5MvDw4DmbRmb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknLuQEACgkQuL75KpiFGIxPYQCfWM5w9qGXsftH9meEC3R137PG
8UUAoOmQCrwb45w8u8mw1sQxm2wXXP42
=SP7B
-----END PGP SIGNATURE-----

--S5HS5MvDw4DmbRmb--
