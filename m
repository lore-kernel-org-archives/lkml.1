Return-Path: <linux-kernel-owner+w=401wt.eu-S1755373AbXD0GTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbXD0GTX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 02:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755377AbXD0GTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 02:19:23 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:42888 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373AbXD0GTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 02:19:21 -0400
Message-ID: <4631962E.5050701@drzeus.cx>
Date: Fri, 27 Apr 2007 08:20:30 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070414)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_hera.drzeus.cx-9408-1177654760-0001-2"
To: Madhusudhan c <cr.madhusudhan@gmail.com>
CC: linux-kernel@vger.kernel.org, philipl@overt.org
Subject: Re: MMCv4 support (8-bit support missing)
References: <ff1613620704162359w62df9e0ao6c43215a767bd706@mail.gmail.com>	 <4625DAFC.4000208@drzeus.cx>	 <ff1613620704180453t69585e21h5c31a4fe908d0aac@mail.gmail.com>	 <46262953.3040801@drzeus.cx>	 <ff1613620704190704n2cf37c9dv43536bb8fc0d4c79@mail.gmail.com>	 <462797EE.2050808@drzeus.cx>	 <ff1613620704200421w1e1aeea5r5acc3a7c0c548b96@mail.gmail.com>	 <462D8FA2.5010609@drzeus.cx> <ff1613620704252034j2474f3f8j73eaa66f4499d258@mail.gmail.com>
In-Reply-To: <ff1613620704252034j2474f3f8j73eaa66f4499d258@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-9408-1177654760-0001-2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Madhusudhan c wrote:
>=20
> Philip asked me about the access to the 8-bit controller. We might not
> be able to provide you direct access to the hardware platform as it
> requires involvement of business managers and so on. But can I be of
> help by testing your code on our platform and leting you know the
> results?
>=20

Sure. Or you'll construct a patch for that yourselves. It should be fairl=
y
trivial to extend the current stuff.

Will this driver be submitted upstream? I'm not too fond of merging featu=
res in
the mmc layer that no in-kernel driver uses.

Rgds
Pierre



--=_hera.drzeus.cx-9408-1177654760-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGMZYu7b8eESbyJLgRAltwAKCFZWQp+3L+3q2ceT7RPt5rJoKDmQCcDABj
+eou+tMhCDF2hioG1JJF+IM=
=IUl2
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-9408-1177654760-0001-2--
