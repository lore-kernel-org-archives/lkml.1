Return-Path: <linux-kernel-owner+w=401wt.eu-S1758284AbXFINQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284AbXFINQS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 09:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbXFINQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 09:16:06 -0400
Received: from lug-owl.de ([195.71.106.12]:34421 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbXFINQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 09:16:05 -0400
Date: Sat, 9 Jun 2007 15:16:04 +0200
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Christian Leber <christian@leber.de>, Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: beeping patch for debugging acpi sleep
Message-ID: <20070609131604.GM2649@lug-owl.de>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	Christian Leber <christian@leber.de>, Andrew Morton <akpm@osdl.org>,
	kernel list <linux-kernel@vger.kernel.org>
References: <20070518213701.GA810@core> <20070520200142.GB5235@ucw.cz> <20070602182014.GB29546@core> <20070609130817.GI27793@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MdsOjv/FQ+tsWHFo"
Content-Disposition: inline
In-Reply-To: <20070609130817.GI27793@elf.ucw.cz>
X-Operating-System: Linux mail 2.6.18-4-686 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--MdsOjv/FQ+tsWHFo
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-06-09 15:08:17 +0200, Pavel Machek <pavel@ucw.cz> wrote:
>=20
> Starting beeper as soon as ACPI sleep returns is very useful in
> debugging "apparently dead" machines. If it beeps at all, it makes
> sense to start playing with CMOS tracer.

I'd even go so far and implement it unconditionally.

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
Signature of:                     Eine Freie Meinung in einem Freien Kopf
the second  :                   f=C3=BCr einen Freien Staat voll Freier B=
=C3=BCrger.

--MdsOjv/FQ+tsWHFo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGaqgUHb1edYOZ4bsRAr5VAJ9XaMpbRtrIk4yTbv9drt7Q7MuIzACcDhM+
fGYkR+VZ7YlNNoF/vZczJps=
=hdDd
-----END PGP SIGNATURE-----

--MdsOjv/FQ+tsWHFo--
