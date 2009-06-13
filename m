Return-Path: <linux-kernel-owner+w=401wt.eu-S1760839AbZFMUMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760839AbZFMUMT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 16:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757553AbZFMUMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 16:12:08 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:51665 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202AbZFMUMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 16:12:06 -0400
Date: Sat, 13 Jun 2009 22:12:00 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: haavard.skinnemoen@atmel.com, linux-arm-kernel@lists.arm.linux.org.uk,
       poorarm@shoreis.com, linux-kernel@vger.kernel.org, avictor.za@gmail.com,
       nicolas.ferre@atmel.com
Subject: Re: [PATCH 1/2] atmel-mci: Integrate AT91 specific definition in
 header file
Message-ID: <20090613221200.2e0154c7@mjolnir.ossman.eu>
In-Reply-To: <1244822310-11562-1-git-send-email-nicolas.ferre@atmel.com>
References: <1244822310-11562-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-29253-1244923927-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-29253-1244923927-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 12 Jun 2009 17:58:29 +0200
Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> The MCI IP is shared among AVR32 and AT91 SOCs.
> AT91 has specific bit definitions in the user interface of MCI SD/MMC IP.
>=20
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> Thanks to Rob Emanuele who has begun this unification work. I take the ha=
nd on
> this header file work as I have some bits to integrate for MCI2 support.
>=20

Both patches applied.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-29253-1244923927-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAko0CBUACgkQ7b8eESbyJLjfNgCgvBZKSZMpcFjhw8hm5YGj1A5l
KesAoIvsvQ8ztUVZ95NPEZqBwy9YQS5+
=YKB9
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-29253-1244923927-0001-2--
