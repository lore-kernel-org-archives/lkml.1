Return-Path: <linux-kernel-owner+w=401wt.eu-S1755033AbZCVOrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbZCVOrj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 10:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbZCVOra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 10:47:30 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:39497 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416AbZCVOra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 10:47:30 -0400
Date: Sun, 22 Mar 2009 15:47:21 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Wolfgang =?UTF-8?B?TcO8ZXM=?= <wolfgang.mues@auerswald.de>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7 revised] mmc_spi: adjust for delayed data token
 response
Message-ID: <20090322154721.647307f8@mjolnir.ossman.eu>
In-Reply-To: <200903161223.03402.wolfgang.mues@auerswald.de>
References: <200903161223.03402.wolfgang.mues@auerswald.de>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-23461-1237733244-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-23461-1237733244-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Mar 2009 12:23:03 +0100
Wolfgang M=C3=BCes <wolfgang.mues@auerswald.de> wrote:

> From: Wolfgang Muees <wolfgang.mues@auerswald.de>
>=20
> o some cards are not able to send the data token in time, but
>   miss the time frame for some bits(!). So synchronize to the
>   start of the token.
>=20
> Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>
>=20

Queued.

--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-23461-1237733244-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAknGT3sACgkQ7b8eESbyJLgPWwCeNgIGvVNyqfE3IK0wSFJM/dM3
knQAoIRxRSnOHILFffch+WZdOt0qI7Ru
=KiJs
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-23461-1237733244-0001-2--
