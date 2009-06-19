Return-Path: <linux-kernel-owner+w=401wt.eu-S1755598AbZFSTaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbZFSTaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 15:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754357AbZFSTaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 15:30:08 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:34486 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708AbZFSTaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 15:30:07 -0400
Date: Fri, 19 Jun 2009 21:30:03 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Harald Welte <HaraldWelte@viatech.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       JosephChan@via.com.tw, Bruce Chang <BruceChang@via.com.tw>
Subject: Re: [PATCH] mmc: Add new via-sdmmc host controller driver
Message-ID: <20090619213003.6e8a4e27@mjolnir.ossman.eu>
In-Reply-To: <20090617182239.GG7692@prithivi.gnumonks.org>
References: <20090617182239.GG7692@prithivi.gnumonks.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-11027-1245439808-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-11027-1245439808-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Jun 2009 20:22:39 +0200
Harald Welte <HaraldWelte@viatech.com> wrote:

> This adds the via-sdmmc driver for the SD/MMC-controller of VIA,
> which is found in a number of recent integrated VIA chipset
> products.
>=20
> Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
> ---

Queued (with MAINTAINERS entry fixed). Thanks.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-11027-1245439808-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAko75z8ACgkQ7b8eESbyJLg0LwCfSeb+geioHwiz8wcR6eyEf0BB
8OEAoOr0Jz45+IvvoaLWBWVZoVZUAPI8
=SmM7
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-11027-1245439808-0001-2--
