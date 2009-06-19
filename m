Return-Path: <linux-kernel-owner+w=401wt.eu-S1756996AbZFSTda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbZFSTda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 15:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbZFSTdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 15:33:21 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:34806 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbZFSTdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 15:33:21 -0400
Date: Fri, 19 Jun 2009 21:33:14 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Harald Welte <HaraldWelte@viatech.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sdhci: Specific quirk vor VIA SDHCI controller in
 VX855ES
Message-ID: <20090619213314.150f0d98@mjolnir.ossman.eu>
In-Reply-To: <20090618145338.GX7692@prithivi.gnumonks.org>
References: <20090618145338.GX7692@prithivi.gnumonks.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-11050-1245440002-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-11050-1245440002-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Jun 2009 16:53:38 +0200
Harald Welte <HaraldWelte@viatech.com> wrote:

> The SDHCI controller found in the VX855ES requires 10ms
> delay between applying power and applying clock.
>=20
> This issue has been discovered and documented by the OLPC XO1.5 team.
>=20
> Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
> ---

Does this block have a name? Something nicer than 0x95d0 in the id list
would be nice.

(Same thing goes for the via-sdmmc driver btw).

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-11050-1245440002-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAko76AAACgkQ7b8eESbyJLh0zgCg5LpoLLkgxH3Mv/9l8vUOz0pF
TFwAoK6uEtsWFH3n/5O3XvP4sNkM2Iws
=ZyA0
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-11050-1245440002-0001-2--
