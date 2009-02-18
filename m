Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbZBRVSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbZBRVSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 16:18:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbZBRVSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 16:18:12 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:38283 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756987AbZBRVSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 16:18:10 -0500
Date: Wed, 18 Feb 2009 22:17:47 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] MMC fixes for 2.6.29-rc6
Message-ID: <20090218221747.26a1344d@mjolnir.ossman.eu>
In-Reply-To: <20090218220428.1d3f50e2@mjolnir.ossman.eu>
References: <20090218220428.1d3f50e2@mjolnir.ossman.eu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.drzeus.cx-32354-1234991887-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-32354-1234991887-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Feb 2009 22:04:28 +0100
Pierre Ossman <drzeus-list@drzeus.cx> wrote:

> Linus, please pull from
>=20
>         git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-=
linus
>=20

And just as I sent this I got the necessary acks for three more fixes
to the new omap_hsmmc driver. So you'll be getting these as well: :)

David Brownell (1):
      omap_hsmmc: only MMC1 allows HCTL.SDVS !=3D 1.8V

Jean Pihet (2):
      omap_hsmmc: recover from transfer failures
      omap_hsmmc: Change while(); loops with finite version

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-32354-1234991887-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAkmcew0ACgkQ7b8eESbyJLh8VACdHmCfF6744/cpIgAO1tCoQM1b
P2cAoP0mefpkwXMQ3+kdmapuvBHezkiW
=lE1y
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-32354-1234991887-0001-2--
