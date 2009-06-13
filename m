Return-Path: <linux-kernel-owner+w=401wt.eu-S1760101AbZFMTc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101AbZFMTc6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 15:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZFMTcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 15:32:51 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:44254 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbZFMTcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 15:32:50 -0400
Date: Sat, 13 Jun 2009 21:32:46 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Ian Molton <ian@mnementh.co.uk>
Cc: Philipp Zabel <philipp.zabel@gmail.com>, linux-kernel@vger.kernel.org,
       Samuel Ortiz <sameo@openedhand.com>
Subject: Re: [PATCH 0/7] ASIC3 support for tmio_mmc
Message-ID: <20090613213246.10da8b0d@mjolnir.ossman.eu>
In-Reply-To: <4A33F311.9060204@mnementh.co.uk>
References: <1244139157-16404-1-git-send-email-philipp.zabel@gmail.com>
	<20090613135830.6246d0b8@mjolnir.ossman.eu>
	<4A33F311.9060204@mnementh.co.uk>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-28819-1244921571-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-28819-1244921571-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 13 Jun 2009 19:42:25 +0100
Ian Molton <ian@mnementh.co.uk> wrote:

> Pierre Ossman wrote:
>=20
> > I've queued up everything except patch 7 as I haven't seen Ian's
> > response on that yet.
>=20
> Is that using my replacement for patch 6 ? I didnt ack that one since=20
> (whilst correct) My solution is simpler and fixes another bug as well.
>=20

I queued up your replacement, yes.

> Patch 7 is Acked-by me now that Philipp has explained the idea behind it.

Ok. I'll queue that up as well.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-28819-1244921571-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkoz/uIACgkQ7b8eESbyJLgiDwCfdlAMOOnJTQYcNsLbBxHWm1yt
fzYAoIbF3IXIBCzs2NVqOiUNTmDWarMe
=pyhf
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-28819-1244921571-0001-2--
