Return-Path: <linux-kernel-owner+w=401wt.eu-S1753540AbZGDTq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbZGDTq6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 15:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbZGDTqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 15:46:49 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:58333 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbZGDTqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 15:46:48 -0400
Date: Sat, 4 Jul 2009 16:23:52 +0200
From: Nico Schottelius <nico-linux-20090703@schottelius.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Nico Schottelius <nico-linux-20090703@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: How to reliable rebuild different kernel versions with the
	same config?
Message-ID: <20090704142352.GA31118@ikn.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20090703@schottelius.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <20090703144640.GA24922@ikn.schottelius.org> <20090703090729.8c95a1e7.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <20090703090729.8c95a1e7.randy.dunlap@oracle.com>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.30-rc7 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Randy,

Randy Dunlap [Fri, Jul 03, 2009 at 09:07:29AM -0700]:
> > [...]
> > The problem is, that after changing the version, make all or make oldco=
nfig
> > prompt us to fillout some values, which is problematic, because we
> > want to run it automatically.
>=20
> Use:
> $ yes "" | make oldconfig
> to supply replies to the prompts.

Ahh, nice idea! Will try that on monday!

Thanks for all the hints, enjoy the sunny weekend ;-)

Nico

--=20
Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpPZfgACgkQuL75KpiFGIynCACgu5fnhOcF7ybPQZJtJd3Mzg+O
fLoAoMXcn2jXJSHHllvNN3y2Uein2D8v
=ndw5
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
