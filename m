Return-Path: <linux-kernel-owner+w=401wt.eu-S934809AbXG2T3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934809AbXG2T3i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 15:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933553AbXG2T3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 15:29:22 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:37411 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933414AbXG2T3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 15:29:21 -0400
Date: Sun, 29 Jul 2007 21:29:07 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nicolas Pitre <npitre@mvista.com>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] make struct sdio_dev_attrs[] static
Message-ID: <20070729212907.67957011@poseidon.drzeus.cx>
In-Reply-To: <20070729145809.GV16817@stusta.de>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
	<20070729145809.GV16817@stusta.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-11784-1185737356-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-11784-1185737356-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 29 Jul 2007 16:58:09 +0200
Adrian Bunk <bunk@stusta.de> wrote:

> On Wed, Jul 25, 2007 at 04:03:04AM -0700, Andrew Morton wrote:
> >...
> > Changes since 2.6.22-rc6-mm1:
> >...
> >  git-mmc.patch
> >...
> >  git trees
> >...
>=20
> sdio_dev_attrs[] can become static.
>=20
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
>=20

Thanks, applied.

Rgds
Pierre

--=_hera.drzeus.cx-11784-1185737356-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGrOqE7b8eESbyJLgRAtq9AKDakXmlLsyqIG3iszXsnfx+4QlILgCeLgy9
I32+cv4h8ai+BH9sVQF9yvM=
=1viC
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-11784-1185737356-0001-2--
