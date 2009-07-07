Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbZGGFP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbZGGFP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 01:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbZGGFPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 01:15:17 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:53491 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbZGGFPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 01:15:17 -0400
Date: Tue, 7 Jul 2009 07:15:11 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-kernel@vger.kernel.org, Vipin Bhandari <vipin.bhandari@ti.com>,
       davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH v5] DaVinci: MMC: MMC/SD controller driver for DaVinci
 family.
Message-ID: <20090707071511.51865306@mjolnir.ossman.eu>
In-Reply-To: <871votjtfz.fsf@deeprootsystems.com>
References: <1245757600-1073-1-git-send-email-vipin.bhandari@ti.com>
	<871votjtfz.fsf@deeprootsystems.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-22748-1246943717-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-22748-1246943717-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 06 Jul 2009 16:13:52 -0700
Kevin Hilman <khilman@deeprootsystems.com> wrote:

> Pierre,
>=20
> Vipin Bhandari <vipin.bhandari@ti.com> writes:
>=20
> > This patch adds support for MMC/SD controller driver for all DaVinci fa=
mily
> > SoC. This patch supports davinci family SoC's DM6446, DM355, DM365 and
> > DA830/OMAPL137.
> >
> > The patch has been tested on DM355 EVM.
> >
> > The MMCSD controller specifications for DM355 can be found at
> > http://focus.ti.com/general/docs/litabsmultiplefilelist.tsp?literatureN=
umber=3Dspruee2c
> >
> > Signed-off-by: Vipin Bhandari <vipin.bhandari@ti.com>
> > Signed-off-by: Purshotam Kumar <purushotam@ti.com>
> > Acked-by: David Brownell <dbrownell@users.sourceforge.net>
>=20
> I don't yet see this driver upstream (at least not in linux-next.)
> Do you have this queued someplace? =20
>=20
> There is one other DaVinci MMC update needed after this patch due to
> some EDMA API changes in the DaVinci core which are queued for 2.6.32,
> so if this is queued for .31 it can go as is.  If it is queued for .32,
> the patch below should be folded in.
>    =20

I haven't had time to look over this version yet, but the plan is to
push it for .31.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-22748-1246943717-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkpS2eMACgkQ7b8eESbyJLiUVQCgtsvbpUAavjFp974c0KkN+0bj
KbQAniMpYubglfSA4NLfBdReBc+sfeQ0
=fKAt
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-22748-1246943717-0001-2--
