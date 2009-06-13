Return-Path: <linux-kernel-owner+w=401wt.eu-S1761367AbZFMKjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761367AbZFMKjR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 06:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbZFMKjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 06:39:11 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:43925 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbZFMKjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 06:39:10 -0400
Date: Sat, 13 Jun 2009 12:39:05 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.29.4] Driver for CB710/720 memory card reader (MMC
 part) - v5 fixed
Message-ID: <20090613123905.1d83b5d0@mjolnir.ossman.eu>
In-Reply-To: <20090604102455.GA32296@rere.qmqm.pl>
References: <20081004215122.0626cd7b@mjolnir.drzeus.cx>
	<20081029141146.GA17741@rere.qmqm.pl>
	<20081114220658.38f0645c@mjolnir.drzeus.cx>
	<20090201185435.GA9165@rere.qmqm.pl>
	<20090221134603.6bc3c385@mjolnir.ossman.eu>
	<20090508151622.GA23006@rere.qmqm.pl>
	<20090522132755.144efcca@mjolnir.ossman.eu>
	<20090522175501.GA673@rere.qmqm.pl>
	<20090522183359.GA3567@rere.qmqm.pl>
	<20090527221342.3a1ba44d@mjolnir.ossman.eu>
	<20090604102455.GA32296@rere.qmqm.pl>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-24803-1244889551-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-24803-1244889551-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 4 Jun 2009 12:24:55 +0200
Micha=C5=82 Miros=C5=82aw <mirq-linux@rere.qmqm.pl> wrote:

> On Wed, May 27, 2009 at 10:13:42PM +0200, Pierre Ossman wrote:
> > On Fri, 22 May 2009 20:33:59 +0200
> > Micha=C5=82 Miros=C5=82aw <mirq-linux@rere.qmqm.pl> wrote:
> [cut: CB710 driver patch description]
> > Queued.
>=20
> One more fixup for the driver following.
>=20

I had already done some of this, but I've merged the rest of the
changes you had here.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-24803-1244889551-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkozgc4ACgkQ7b8eESbyJLgvygCbBN3yNY/mzXPVgdDV+kTxbNNb
cn4AnjQZTZLKxDdi2g6QsAB2ZAuQ4+Gc
=Y1dx
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-24803-1244889551-0001-2--
