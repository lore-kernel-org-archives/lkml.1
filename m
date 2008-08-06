Return-Path: <linux-kernel-owner+w=401wt.eu-S1756693AbYHFWjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbYHFWjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 18:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbYHFWjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 18:39:11 -0400
Received: from server.drzeus.cx ([85.8.24.28]:43116 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753837AbYHFWjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 18:39:10 -0400
Date: Thu, 7 Aug 2008 00:39:03 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Vitaly Luban <vitaly@luban.org>
Cc: linux-kernel@vger.kernel.org, Vitaly Luban <vitaly@luban.org>
Subject: Re: [PATCH] Tokyo Electron SDIO controller (Ellen) support
Message-ID: <20080807003903.7f6dcb00@mjolnir.drzeus.cx>
In-Reply-To: <47511ADA.20506@luban.org>
References: <47511ADA.20506@luban.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-23585-1218062348-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-23585-1218062348-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 01 Dec 2007 00:27:06 -0800
Vitaly Luban <vitaly@luban.org> wrote:

> Kernel "pci_ids.h" file has data for that card missing.
>=20
> Also, Ellen needs some control bits flipped before it functions properly=
=20
> as SDIO controller by the spec.
> Should apply clenly to Linus and Drzeus trees. Please apply.
>=20
> Signed-off-by:  Vitaly Luban <vitaly@luban.org>
>=20
>=20

The separation has now finally been performed in case you want to
revisit this patch.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-23585-1218062348-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiaKAoACgkQ7b8eESbyJLhpOQCfQu23gXOsfKSqf0JJSUSGYoBy
3d0AoJJIcrXYJhxsXDtx1AHaAb5lpP09
=jMdd
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-23585-1218062348-0001-2--
