Return-Path: <linux-kernel-owner+w=401wt.eu-S1763715AbXFFL0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763715AbXFFL0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 07:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760748AbXFFL0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 07:26:09 -0400
Received: from lug-owl.de ([195.71.106.12]:34537 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759635AbXFFL0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 07:26:08 -0400
Date: Wed, 6 Jun 2007 13:26:07 +0200
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: "Lars K.W. Gohlke" <lkwg82@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: serio interface
Message-ID: <20070606112607.GM2649@lug-owl.de>
Mail-Followup-To: "Lars K.W. Gohlke" <lkwg82@gmx.de>,
	linux-kernel@vger.kernel.org
References: <46667A3B.8070708@gmx.de> <20070606091503.GI2649@lug-owl.de> <46667FB9.70206@gmx.de> <20070606095159.GK2649@lug-owl.de> <46668ED5.5000807@gmx.de> <20070606104426.GL2649@lug-owl.de> <466691DD.9060904@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1VtFtf1bAEcuptAG"
Content-Disposition: inline
In-Reply-To: <466691DD.9060904@gmx.de>
X-Operating-System: Linux mail 2.6.18-4-686 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--1VtFtf1bAEcuptAG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-06-06 12:52:13 +0200, Lars K.W. Gohlke <lkwg82@gmx.de> wrote:
> Jan-Benedict Glaw schrieb:
> > On Wed, 2007-06-06 12:39:17 +0200, Lars K.W. Gohlke <lkwg82@gmx.de> wro=
te:
> > > Jan-Benedict Glaw schrieb:
> > > > OTOH, why do you want to do the serial stuff in kernel land? Isn't =
it
> > > > a *lot* easier to do it in userspace? What's your specific device y=
ou
> > > > want to work on?
>
> > You didn't actually answer any of my questions.

> sorry.
>=20
> I want to use the interface aka /dev/ttyS0.
> I want to process data inside of a kernel module to provide it /proc
> (done) or as own char-dev (done).
>=20
> but I can not grab the data.
>=20
> It is part of my project in my studies.
>=20
> It is more a conceptual work, but important. I want to release a howto,
> when I complete.

You still answer unasked questions. Please answer inline:

  * Why do you wanto to do the serial stuff in kernel land?

  * Isn't it easier to do it in userspace?

  * What specific device do you work on?

  * New: Is it a wise idea to do it in kernel land?

The /proc filesystem has been somewhat obsoleted in favour of sysfs
for device/driver information.

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
Signature of:                   ...und wenn Du denkst, es geht nicht mehr,
the second  :                          kommt irgendwo ein Lichtlein her.

--1VtFtf1bAEcuptAG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGZpnPHb1edYOZ4bsRAlwpAJsEIjlclrhWtFi4k99Qaqndl7I+iACfYgtD
ltEnpDm1xF32BkIKYUINM+M=
=GJmF
-----END PGP SIGNATURE-----

--1VtFtf1bAEcuptAG--
