Return-Path: <linux-kernel-owner+w=401wt.eu-S1765826AbZDJWEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765826AbZDJWEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 18:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbZDJWEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 18:04:43 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:47934 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbZDJWEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 18:04:42 -0400
Date: Sat, 11 Apr 2009 00:04:34 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Wolfgang =?UTF-8?B?TcO8ZXM=?= <wolfgang.mues@auerswald.de>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc_spi: speedup for slow cards, less wear-out
Message-ID: <20090411000434.035bb12d@mjolnir.ossman.eu>
In-Reply-To: <200904081114.07653.wolfgang.mues@auerswald.de>
References: <200904081114.07653.wolfgang.mues@auerswald.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-20273-1239401077-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-20273-1239401077-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 8 Apr 2009 10:14:07 +0100
Wolfgang M=C3=BCes <wolfgang.mues@auerswald.de> wrote:

> From: Wolfgang Muees <wolfgang.mues@auerswald.de>
>=20
> o Speedup for slow cards by transfering more data at once.
>   This patch also reduces the amount of wear-out of the flash
>   blocks because fewer partial blocks are written. =20
>=20
> Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>
>=20

Looks ok. Queued.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-20273-1239401077-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAknfwnUACgkQ7b8eESbyJLjNnQCghDg+Nb2AkeBUeHUS4LGMAPgI
ajwAn1qqq/Pbk+XT6rnTi+/WLIlhR12O
=4HuR
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-20273-1239401077-0001-2--
