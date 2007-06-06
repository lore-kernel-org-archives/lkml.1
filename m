Return-Path: <linux-kernel-owner+w=401wt.eu-S1761528AbXFFJwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761528AbXFFJwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 05:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbXFFJwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 05:52:03 -0400
Received: from lug-owl.de ([195.71.106.12]:49168 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756160AbXFFJwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 05:52:01 -0400
Date: Wed, 6 Jun 2007 11:51:59 +0200
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: linux-kernel@vger.kernel.org, "Lars K.W. Gohlke" <lkwg82@gmx.de>
Subject: Re: serio interface
Message-ID: <20070606095159.GK2649@lug-owl.de>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	"Lars K.W. Gohlke" <lkwg82@gmx.de>
References: <46667A3B.8070708@gmx.de> <20070606091503.GI2649@lug-owl.de> <46667FB9.70206@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hu1ClgjWvfumRnAp"
Content-Disposition: inline
In-Reply-To: <46667FB9.70206@gmx.de>
X-Operating-System: Linux mail 2.6.18-4-686
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--hu1ClgjWvfumRnAp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-06-06 11:34:49 +0200, Lars K.W. Gohlke <lkwg82@gmx.de> wrote:
> Jan-Benedict Glaw schrieb:
> > On Wed, 2007-06-06 11:11:23 +0200, Lars K.W. Gohlke <lkwg82@gmx.de> wro=
te:
> > > wouldsomebody explain me the serio interface or give me a code link f=
or
> > > very simple example.
> >
> > What do you want to do with it?  Do you want on the serial port side,
> > or on the mouse/keyboard/gadget side?  See for example the various
> > serial keyboards and mice drivers.
>
> I want on the kernelside process data from first uart-hardware interface
> aka ttyS0.
>=20
> I don't understand the structure of e.g. input/mouse/sermouse.c
>=20
> where is said, which hardware is used for reading data from?

I'm not entirely sure, but I guess that most of the time, you assign a
serial port with the help of `inputattach' to a given device driver,
which expects to find its hardware on that port.

OTOH, why do you want to do the serial stuff in kernel land? Isn't it
a *lot* easier to do it in userspace? What's your specific device you
want to work on?

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
Signature of:                     Eine Freie Meinung in einem Freien Kopf
the second  :                   f=C3=BCr einen Freien Staat voll Freier B=
=C3=BCrger.

--hu1ClgjWvfumRnAp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGZoO/Hb1edYOZ4bsRAs+zAJ9jAuvJIq2SBThzH309D2otPZwoMwCeNfUC
Zb4BRIL83XOb47EMFOzKA0w=
=9lIM
-----END PGP SIGNATURE-----

--hu1ClgjWvfumRnAp--
