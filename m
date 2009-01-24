Return-Path: <linux-kernel-owner+w=401wt.eu-S1757339AbZAYAAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbZAYAAy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 19:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbZAYAAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 19:00:34 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:37121 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674AbZAYAAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 19:00:33 -0500
Date: Sat, 24 Jan 2009 22:11:12 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Philip Langdale <philipl@overt.org>,
       linux kernel <linux-kernel@vger.kernel.org>, sdhci-devel@list.drzeus.cx
Subject: Re: [PATCH] ricoh_mmc: Use suspend_late/resume_early
Message-ID: <20090124221112.56132f98@mjolnir.drzeus.cx>
In-Reply-To: <200901242155.02113.rjw@sisk.pl>
References: <39393.98.210.152.237.1232305880.squirrel@overt.org>
	<20090124185723.7dc9a875@mjolnir.drzeus.cx>
	<497B7CA3.3080802@overt.org>
	<200901242155.02113.rjw@sisk.pl>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-2574-1232841630-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-2574-1232841630-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 24 Jan 2009 21:55:01 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Saturday 24 January 2009, Philip Langdale wrote:
> > Pierre Ossman wrote:
> > >=20
> > > What's the plan here? Apply for .29?
> >=20
> > That's what I'd recommend - we are seeing reports of problems that
> > would be fixed by this.
> >=20
> > eg: http://lkml.org/lkml/2009/1/21/241
>=20
> Agreed.
>=20

Queueing it up then.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-2574-1232841630-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkl7g/QACgkQ7b8eESbyJLhzyQCfeECOq5VUQrE6wwomLb10Ni1I
7zQAn10Imyjh4HWJ2H1/u7AJN2MElLH8
=3mgC
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-2574-1232841630-0001-2--
