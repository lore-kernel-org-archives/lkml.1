Return-Path: <linux-kernel-owner+w=401wt.eu-S1759692AbXFIX2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759692AbXFIX2L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 19:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757493AbXFIX17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 19:27:59 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:40220 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757449AbXFIX17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 19:27:59 -0400
Subject: Re: beeping patch for debugging acpi sleep
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Pavel Machek <pavel@ucw.cz>
Cc: Christian Leber <christian@leber.de>, Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20070609225421.GA20521@elf.ucw.cz>
References: <20070518213701.GA810@core> <20070520200142.GB5235@ucw.cz>
	 <20070602182014.GB29546@core> <20070609130817.GI27793@elf.ucw.cz>
	 <20070609131604.GM2649@lug-owl.de>  <20070609225421.GA20521@elf.ucw.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-N8i+Z9jCCJxqa22GGqpe"
Date: Sun, 10 Jun 2007 09:27:55 +1000
Message-Id: <1181431675.14045.140.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-N8i+Z9jCCJxqa22GGqpe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Sun, 2007-06-10 at 00:54 +0200, Pavel Machek wrote:
> On Sat 2007-06-09 15:16:04, Jan-Benedict Glaw wrote:
> > On Sat, 2007-06-09 15:08:17 +0200, Pavel Machek <pavel@ucw.cz> wrote:
> > >=20
> > > Starting beeper as soon as ACPI sleep returns is very useful in
> > > debugging "apparently dead" machines. If it beeps at all, it makes
> > > sense to start playing with CMOS tracer.
> >=20
> > I'd even go so far and implement it unconditionally.
>=20
> Well, try it; it is too annoying to be unconditional.

Could you modify the pitch or the length then, to make it less annoying?
It sounds like a really good idea to me.

Regards,

Nigel

--=-N8i+Z9jCCJxqa22GGqpe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGazd7N0y+n1M3mo0RAuWSAJ4/Nok96X4S73FRa8WAueG5aSnkXwCgmoX5
x3xKW3ow/BJXydZyfw4K+PE=
=/jiT
-----END PGP SIGNATURE-----

--=-N8i+Z9jCCJxqa22GGqpe--

