Return-Path: <linux-kernel-owner+w=401wt.eu-S1760860AbZFMK5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760860AbZFMK5p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 06:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbZFMK5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 06:57:37 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:56256 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbZFMK5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 06:57:36 -0400
Date: Sat, 13 Jun 2009 12:57:32 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Wolfgang =?UTF-8?B?TcO8ZXM=?= <wolfgang.mues@auerswald.de>
Cc: "David Brownell" <david-b@pacbell.net>,
       "Matt Fleming" <matt@console-pimps.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc_spi: use EILSEQ for possible transmission errors
Message-ID: <20090613125732.3eca440f@mjolnir.ossman.eu>
In-Reply-To: <200906100929.49553.wolfgang.mues@auerswald.de>
References: <200905250243.46984.david-b@pacbell.net>
	<200905251659.17396.wolfgang.mues@auerswald.de>
	<20090609200750.2fa38dfe@mjolnir.ossman.eu>
	<200906100929.49553.wolfgang.mues@auerswald.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-24908-1244890657-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-24908-1244890657-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 10 Jun 2009 09:29:49 +0200
Wolfgang M=C3=BCes <wolfgang.mues@auerswald.de> wrote:

>=20
> Have you noticed that I have posted a revised revision of the patch named=
=20
>=20
> [PATCH] mmc_spi: don't use EINVAL for possible transmission errors
>=20
> on 26th of May 2009? This was based on the discussion with Matt Flemming=
=20
> and David Brownell. (I have changed the name of the patch because the old
> name was missleading now).

I did not. Thanks for pointing this out.

>=20
> Please queue up the new patch. Patch appended for reference here:
>=20

Done. Thanks for all the work.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-24908-1244890657-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkozhiAACgkQ7b8eESbyJLj9DQCaA8caondmGjcr7yitxmWexmwp
3ysAoK4++GrS0QcyLj/HVWxq4blJC+s8
=xQvX
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-24908-1244890657-0001-2--
