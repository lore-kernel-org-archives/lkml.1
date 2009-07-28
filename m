Return-Path: <linux-kernel-owner+w=401wt.eu-S1752745AbZG1UUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbZG1UUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 16:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbZG1UUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 16:20:42 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:34643 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbZG1UUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 16:20:41 -0400
Date: Tue, 28 Jul 2009 22:20:34 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org, nico@cam.org,
       nicolas.ferre@rfo.atmel.com, hskinnemoen@atmel.com, tony@atomide.com,
       david-b@pacbell.net, manuel.lauss@gmail.com, mirq-linux@rere.qmqm.pl,
       ppisa@pikron.com, jarkko.lavinen@nokia.com, ben@fluff.org,
       saschasommer@freenet.de, avorontsov@ru.mvista.com, oakad@yahoo.com,
       ian@mnementh.co.uk, HaraldWelte@viatech.com, JosephChan@via.com.tw,
       adrian.hunter@nokia.com
Subject: Re: New MMC maintainer needed
Message-ID: <20090728222034.78966b3a@mjolnir.ossman.eu>
In-Reply-To: <20090722151744.fffd7bf5.akpm@linux-foundation.org>
References: <20090714153601.6dfe70ff@mjolnir.ossman.eu>
	<20090722151744.fffd7bf5.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-2546-1248812438-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-2546-1248812438-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 22 Jul 2009 15:17:44 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

>=20
> Thanks, Pierre.
>=20
> Until and unless someone else steps up I can act as maintainer of last
> resort for MMC.  As I'm presently doing for fbdev, hwmon, rtc, spi,
> gpio, i2o and about 1000 other identifiable subsystems.
>=20

I'm not falling of the face of the earth here, so people can still cc
me on MMC patches, although I probably cannot answer all of them. I
don't want to be the bottle neck that keeps MMC patches and discussions
moving at a glacial speed, which is the situation we're in today.

> Fortunately, MMC doesn't appear to have its own mailing list so I'll
> actually get to see the patches.  I do monitor a couple of
> subsystem-specific lists (fbdev, hwmon) but the delays can be awful - a
> month or two.

MMC discussions tend to often be very system specific, which makes
lists such as the arm kernel list more appropriate. Also, I've always
tried to steer people to LKML as it allows others to keep a casual eye
on things.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-2546-1248812438-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkpvXZYACgkQ7b8eESbyJLhB9gCgwPwab0z7gAEZs0U860FrA9+K
otcAoNP30e8UJEdHVDzfuXWBP0YBWtiJ
=YO7B
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-2546-1248812438-0001-2--
