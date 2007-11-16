Return-Path: <linux-kernel-owner+w=401wt.eu-S935373AbXKPXbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935373AbXKPXbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 18:31:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757834AbXKPXbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 18:31:45 -0500
Received: from lug-owl.de ([195.71.106.12]:42386 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbXKPXbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 18:31:44 -0500
Date: Sat, 17 Nov 2007 00:31:42 +0100
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: How to disable ECC with bootparam ?
Message-ID: <20071116233142.GG31205@lug-owl.de>
Mail-Followup-To: Xavier Bestel <xavier.bestel@free.fr>,
	lkml <linux-kernel@vger.kernel.org>
References: <1195255221.4408.7.camel@skapc.parateam.prv>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XRI2XbIfl/05pQwm"
Content-Disposition: inline
In-Reply-To: <1195255221.4408.7.camel@skapc.parateam.prv>
X-Operating-System: Linux mail 2.6.18-5-686 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--XRI2XbIfl/05pQwm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-11-17 00:20:20 +0100, Xavier Bestel <xavier.bestel@free.fr> wr=
ote:
>=20
> I have replaced my machine with another one which gives many ECC errors.
> At first sight they may be pessimistic because memtest (with ECC off)
> doesn't find anything (I'm letting run it overnight, I'll see tomorrow
> morning if it really didn't find anything).
> I'd like to let it run without thoses ECC messages (which slow it down
> pretty much), but

Erm...

"ECC" means there are extra bits that, with small amount of errors,
allow to recalculate the initial value.

If you're getting error messages with ECC errors, that means that your
RAM really looses its contents. You should fix your machine. (Check
that eg. timings are correct with RAM's specification, ...)

You're on risk. Really.

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
Signature of:                     Eine Freie Meinung in einem Freien Kopf
the second  :                   f=C3=BCr einen Freien Staat voll Freier B=
=C3=BCrger.

--XRI2XbIfl/05pQwm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHPiheHb1edYOZ4bsRAmjEAJ472G+h2cClFcsRHe2JJDYur96fQgCdGdaO
pY+St+ZMtdFhzl8VKm0/GCw=
=h1Gz
-----END PGP SIGNATURE-----

--XRI2XbIfl/05pQwm--
