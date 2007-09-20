Return-Path: <linux-kernel-owner+w=401wt.eu-S1757553AbXITQXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbXITQXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 12:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756694AbXITQXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 12:23:10 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:56971 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755689AbXITQXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 12:23:09 -0400
Date: Thu, 20 Sep 2007 18:24:29 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Philip Langdale <philipl@overt.org>
Cc: sdhci-devel@list.drzeus.cx, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: Disabler for Ricoh MMC controller
Message-ID: <20070920182429.247b28fb@poseidon.drzeus.cx>
In-Reply-To: <46EC3860.3070600@overt.org>
References: <46EC3860.3070600@overt.org>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-30393-1190305366-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-30393-1190305366-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 15 Sep 2007 12:54:08 -0700
Philip Langdale <philipl@overt.org> wrote:

> Thanks to Matt Domsch and Rezwanul Kabir at Dell, we know how to
> disable the MMC controller on the multi-function Ricoh R5C832. The
> MMC controller needs to be disabled or it will steal MMC cards from
> the SD controller where they would otherwise be supported by the
> Linux SDHCI driver.
>=20
> Signed-off-by: Philipl Langdale <philipl@overt.org>
>=20

Patch looks ok. Please try to sort out that completely disabled
controller that was reported first though.

Rgds
Pierre

--=_hera.drzeus.cx-30393-1190305366-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFG8p697b8eESbyJLgRAkf5AJ98zu/swGBKQuU4yYzULw0I2X1pDACfclVJ
3TrQ5lZatGM8fl1I5KA6HWA=
=73Kd
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-30393-1190305366-0001-2--
