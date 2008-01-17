Return-Path: <linux-kernel-owner+w=401wt.eu-S1754932AbYAQRhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbYAQRhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 12:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbYAQRh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 12:37:26 -0500
Received: from threatwall.zlynx.org ([199.45.143.218]:33072 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751012AbYAQRhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 12:37:25 -0500
Subject: Re: echo mem > /sys/power/state
From: Zan Lynx <zlynx@acm.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080116222445.6f7ff66e.akpm@linux-foundation.org>
References: <20080116222445.6f7ff66e.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5GrDJ++r624i+mRT3yUH"
Date: Thu, 17 Jan 2008 10:36:51 -0700
Message-Id: <1200591411.34145.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20080117/1JFYfd-0002Oe-27-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5GrDJ++r624i+mRT3yUH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Wed, 2008-01-16 at 22:24 -0800, Andrew Morton wrote:
> So I take everyone's latest and greatest product and injudiciously type t=
he
> above command.  The result five minutes later is at
> http://userweb.kernel.org/~akpm/borkage.jpg.  See if you can count all th=
e bugs.
>=20
> Sorry, but I've had it with this stuff and I'm tired of fixing everyone e=
lse's
> stuff.  I'm just going to ship it.  Good luck.

Heh.  Laptop suspend to anything has been so broken for so long in the
-mm series on my Compaq R3000 that I didn't even know it was ever
supposed to work.
--=20
Zan Lynx <zlynx@acm.org>

--=-5GrDJ++r624i+mRT3yUH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHj5IzG8fHaOLTWwgRApvCAJ47VyHSDl5eNU4hrvnc/S7aZKkWdACcDieZ
IsE1iZ4NaWdj+Pdd29IvpFE=
=+IhQ
-----END PGP SIGNATURE-----

--=-5GrDJ++r624i+mRT3yUH--

