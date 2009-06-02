Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbZFBQvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbZFBQvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 12:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbZFBQvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 12:51:10 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:63432 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbZFBQvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 12:51:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer;
        b=UgAnJTUOaIti35kR3FzEM47NSNSI4v6CTaI/sq7pAr5ckEJAH5qyyZwEfZTm5T9h9A
         CPJUJNLKZCfT8gjhA7qSXh4KlKDb3rqBgRlue+mKdLI5wX0RYcew+9QGcybfzkJO2N+D
         0NshO5mEp5fLfyYeQtSznRykA9ARSsXc7hRaM=
Subject: Re: [2.6.27-rc7 vs 2.6.29 Regresion] Wifi Network Slownes rt2500pci
From: Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<alejandro.riveira@gmail.com>
Reply-To: alejandro.riveira@gmail.com
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linville@tuxdriver.com,
       Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <200906021834.40009.IvDoorn@gmail.com>
References: <1243247687.5322.8.camel@varda> <1243351397.4888.2.camel@varda>
	 <1243951292.22942.1.camel@varda>  <200906021834.40009.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-xqSLr7diPuRo3bwbiEDD"
Date: Tue, 02 Jun 2009 18:51:05 +0200
Message-Id: <1243961465.9894.3.camel@varda>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xqSLr7diPuRo3bwbiEDD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

El mar, 02-06-2009 a las 18:34 +0200, Ivo van Doorn escribi=C3=B3:
> On Tuesday 02 June 2009, Alejandro Riveira Fern=C3=A1ndez wrote:

[...]

> > ICMP ECHO REQUEST
> >=20
> > Any advance?
>=20
> Well I checked the dumps from the bugreport, but like I expected
> the only difference is that with the slow speed the correct value
> is written, and the fast speed the wrong value is written.

So my chip works better with incorrect values written in its registers?

/me confused

What about other chips out there do they prefer wrong values too ;)
Maybe what we thought wrong values are not that wrong ?

/me stops rambling

> I couldn't find anything else interesting in it... :(

Thanks anyway.

>=20
> Ivo
--=20
OOP to me means only messaging, local retention and protection and
hiding of state-process, and extreme late-binding of all things. It can
be done in Smalltalk and in LISP. There are possibly other systems in
which this is possible, but I'm not aware of them.
                                                      -- Alan Kay --

--=-xqSLr7diPuRo3bwbiEDD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esto es una parte de mensaje firmado digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAABAgAGBQJKJVhzAAoJEDO4iEReSTB2fg0QAML3N8nusJHAQ2+8+MGmspnA
D5Zzmq5Wy03DSY4QP2yqXOE4B/nS9iEtBEtWXYt5t0NjuKySKykgNj9ZTQB87AoP
uX1Ezuw1JW3yQ3nBpdKqNivPbXX9+hRvsvi7fVy5tt3CR1aD70tv09C5gsi7qKYY
OhZaR72X5IArPkdyv+lGx1PrHWF+KB255L3iJ3rE+nBSWCHMS0n+EOUzGTlAuCpI
mmN2wAJt32mpsuvLgTsFWu1r98yyQR8f5c9GzFvg+YpLkQWVz4nnNfpT/5g2ii3P
AVJsFLMlGfr0luHYTf0M5c55J5A4nxZq0C4zXtb3yRmrXW2jCfp5w9UEq2lsYR/I
23wW5RBJDSvb+VIS3hsvBv+awA5X17F0aClTdfXNw02p1cZ7P516+S1M6q6w7Qq1
o5s5OskEL8aLbKQ7Ex2Dw1oxjQmUtNAiigo0z5NALNUSAG//RAYEA2GMuPwReuAC
Ov+f624eYU5bbDk99poYyLT/omPRG67MsknjEq5Zm6JCWvHdJQSS2VjFHJm3QXT5
OFcvoS7bwdL5iBVNh4vrWvAeZSoeDJXv/j+T0ArXLkRAo8WBw36AB0XBz2Lcv426
9khuD+IsLfxtvMbExeGkDicBESzFWXXJg02t+I0o9HyzSSxpOsm9rvuHwPr1g3n0
UJhEzNS4xOXWTQKnDfpi
=tvS2
-----END PGP SIGNATURE-----

--=-xqSLr7diPuRo3bwbiEDD--

