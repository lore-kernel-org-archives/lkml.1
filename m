Return-Path: <linux-kernel-owner+w=401wt.eu-S1757791AbZCOLse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791AbZCOLse (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 07:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbZCOLsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 07:48:25 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:34485 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbZCOLsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 07:48:25 -0400
Date: Sun, 15 Mar 2009 12:48:16 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Wolfgang =?UTF-8?B?TcO8ZXM=?= <wolfgang.mues@auerswald.de>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/7] mmc_spi: fix bug introduced in patch 3/7
Message-ID: <20090315124816.499f6226@mjolnir.ossman.eu>
In-Reply-To: <200903121549.37620.wolfgang.mues@auerswald.de>
References: <200903121549.37620.wolfgang.mues@auerswald.de>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-26956-1237117699-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-26956-1237117699-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

I've applied patched 1,2 and 5. The other ones had comments and/or
wouldn't apply because of missing earlier patches. So please fix up the
things suggested and resend those patches.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-26956-1237117699-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkm86wQACgkQ7b8eESbyJLjCOgCgoIr/2R1VBDXvpFRF6OTnzltn
CiEAn1Uf7nlM1tOAK/qDAW3bosTQn0DF
=bq91
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-26956-1237117699-0001-2--
