Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbZCOLUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbZCOLUd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 07:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbZCOLUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 07:20:21 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:50505 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027AbZCOLUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 07:20:20 -0400
Date: Sun, 15 Mar 2009 12:20:11 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Wolfgang =?UTF-8?B?TcO8ZXM=?= <wolfgang.mues@auerswald.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Fleming <matt@console-pimps.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] mmc_spi: allow setting of spi mode 3
Message-ID: <20090315122011.7baad7cc@mjolnir.ossman.eu>
In-Reply-To: <1236862232.12514.3.camel@localhost>
References: <200903111413.15981.wolfgang.mues@auerswald.de>
	<1236862232.12514.3.camel@localhost>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-26474-1237116014-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-26474-1237116014-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Mar 2009 14:50:32 +0200
Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> Small question:
>=20
> Do linux SDHCI driver support SD 4 wire mode?
>=20
> Or it uses the SPI mode.
>=20

I think you've managed to confuse yourself pretty good here. :)

This is a patch for the mmc_spi driver, which surprisingly enough is
for operating MMC/SD cards in SPI mode. ;)

The sdhci driver is completely unrelated (but yes, it supports 4-bit
mode).

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-26474-1237116014-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkm85G4ACgkQ7b8eESbyJLhwGACcCjmHnrR6pR7lNkgcAbxTPnOM
AjkAn08n8rsqzs8+Dbt+QQ/wArzGdW2+
=EqaR
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-26474-1237116014-0001-2--
