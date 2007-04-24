Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbXDXFCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbXDXFCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 01:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbXDXFCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 01:02:41 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:50983 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754573AbXDXFCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 01:02:38 -0400
Message-ID: <462D8FA2.5010609@drzeus.cx>
Date: Tue, 24 Apr 2007 07:03:30 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070414)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_hera.drzeus.cx-12689-1177390956-0001-2"
To: Madhusudhan c <cr.madhusudhan@gmail.com>
CC: linux-kernel@vger.kernel.org, philipl@overt.org
Subject: Re: MMCv4 support (8-bit support missing)
References: <ff1613620704162359w62df9e0ao6c43215a767bd706@mail.gmail.com>	 <4625DAFC.4000208@drzeus.cx>	 <ff1613620704180453t69585e21h5c31a4fe908d0aac@mail.gmail.com>	 <46262953.3040801@drzeus.cx>	 <ff1613620704190704n2cf37c9dv43536bb8fc0d4c79@mail.gmail.com>	 <462797EE.2050808@drzeus.cx> <ff1613620704200421w1e1aeea5r5acc3a7c0c548b96@mail.gmail.com>
In-Reply-To: <ff1613620704200421w1e1aeea5r5acc3a7c0c548b96@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-12689-1177390956-0001-2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Madhusudhan c wrote:
>=20
> Suppose a host controller is capable of suporting 8-bit and it tells
> the core that it can support 8-bit. Now the card that is plugged in
> might or might not support 8-bit based on the type of the card. There
> is no field in the ext_csd which will tell you what bus width the card
> can support.
>=20

I've looked through the MMC 4.2 spec and I see nothing in it that even hi=
nts
that 8-bit support might be optional. So as it stands, the bus testing is=
 still out.

Rgds
Pierre



--=_hera.drzeus.cx-12689-1177390956-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGLY+m7b8eESbyJLgRAhvjAJ4nQQc3KReYipkVbCuXMj1psq38WQCggFrj
yi9lyqCaR6Wg/RVFdIax9TI=
=WNNX
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-12689-1177390956-0001-2--
