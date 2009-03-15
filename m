Return-Path: <linux-kernel-owner+w=401wt.eu-S1753350AbZCOLXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbZCOLXW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 07:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbZCOLXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 07:23:13 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:48787 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbZCOLXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 07:23:12 -0400
Date: Sun, 15 Mar 2009 12:23:04 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: David Brownell <david-b@pacbell.net>
Cc: Wolfgang =?UTF-8?B?TcO8ZXM=?= <wolfgang.mues@auerswald.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] mmc_spi: adjust for delayed data token response
Message-ID: <20090315122304.34cc0f00@mjolnir.ossman.eu>
In-Reply-To: <200903120224.38260.david-b@pacbell.net>
References: <200903111345.33154.david-b@pacbell.net>
	<200903120920.06935.wolfgang.mues@auerswald.de>
	<200903120224.38260.david-b@pacbell.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-26504-1237116186-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-26504-1237116186-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Mar 2009 01:24:37 -0800
David Brownell <david-b@pacbell.net> wrote:

>=20
> Well, aligned to zero bytes is the same as "immediately".  ;)
>=20
> And that description matches up with your other patch.  But
> either way, the comment was confusing.
>=20

I guess we need a new one then to avoid this happening again. ;)

And what about that changed if-clause?

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-26504-1237116186-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkm85RsACgkQ7b8eESbyJLj2nQCg87jzYJMelVFTa5cHaFcqaxBS
x38AoLIlifmDMpX359ADGpnHL/EpwUIG
=etU4
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-26504-1237116186-0001-2--
