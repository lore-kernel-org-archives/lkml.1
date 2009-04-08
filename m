Return-Path: <linux-kernel-owner+w=401wt.eu-S1764872AbZDHSqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764872AbZDHSqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 14:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755535AbZDHSq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 14:46:28 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:46717 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398AbZDHSq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 14:46:27 -0400
Date: Wed, 8 Apr 2009 20:46:21 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Wolfgang =?UTF-8?B?TcO8ZXM=?= <wolfgang.mues@auerswald.de>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7 revised] mmc_spi: support for non-byte-aligned cards
Message-ID: <20090408204621.2d604110@mjolnir.ossman.eu>
In-Reply-To: <200904081048.58264.wolfgang.mues@auerswald.de>
References: <200904081048.58264.wolfgang.mues@auerswald.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-26052-1239216382-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-26052-1239216382-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 8 Apr 2009 09:48:58 +0100
Wolfgang M=C3=BCes <wolfgang.mues@auerswald.de> wrote:

> From: Wolfgang Muees <wolfgang.mues@auerswald.de>
>=20
> o A very large subset of SD cards in the market send their
>   responses and data non-byte-aligned. So add logic to the
>   mmc spi driver to handle this mess.
>=20
> Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>
>=20
> ---
>=20

Applied.

--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-26052-1239216382-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAknc8P8ACgkQ7b8eESbyJLi1rwCfQoxxCDKyMjs/nCiNzLOoGkwh
VtsAnjq7AdKjMiyYMg/ha46JbVXNHdWW
=0kL6
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-26052-1239216382-0001-2--
