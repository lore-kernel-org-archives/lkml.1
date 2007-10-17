Return-Path: <linux-kernel-owner+w=401wt.eu-S1760733AbXJQTfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760733AbXJQTfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbXJQTfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:35:08 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:55011 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753818AbXJQTfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:35:06 -0400
Date: Wed, 17 Oct 2007 21:35:00 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Andrew Victor <andrew@sanpeople.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>
Subject: Re: [PATCH] mmc: at91_mci: cleanup: use MCI_ERRORS
Message-ID: <20071017213500.63182425@poseidon.drzeus.cx>
In-Reply-To: <4715DBA4.1020005@atmel.com>
References: <4715DBA4.1020005@atmel.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-19575-1192649672-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-19575-1192649672-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Oct 2007 11:53:40 +0200
Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> From: Andrew Victor <andrew@sanpeople.com>
>=20
> A small MMC driver cleanup.
>=20
> Use the defined AT91_MCI_ERRORS in at91_mci_completed_command()
> instead of specifying all the error bits individually.
>=20
> Signed-off-by: Andrew Victor <andrew@sanpeople.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---

Applied, thanks.

--=_hera.drzeus.cx-19575-1192649672-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHFmPk7b8eESbyJLgRAvvZAJ4tpmIcAYgBLStijC4NlAyXSCEeEwCg3vhc
X3+kI5qEW8DgkXOdUeiIYu0=
=PhTs
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-19575-1192649672-0001-2--
