Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbZFDFjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbZFDFjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 01:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbZFDFjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 01:39:25 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:36466 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbZFDFjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 01:39:24 -0400
Date: Thu, 4 Jun 2009 07:39:19 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       " =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?=" <mirq-linux@rere.qmqm.pl>
Subject: Re: linux-next: mmc tree build failure
Message-ID: <20090604073919.6422358d@mjolnir.ossman.eu>
In-Reply-To: <20090604120435.bc32b890.sfr@canb.auug.org.au>
References: <20090604120435.bc32b890.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-4523-1244093964-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-4523-1244093964-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 4 Jun 2009 12:04:35 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Pierre,
>=20
> Today's linux-next build (powerpc_ppc64_defconfig) failed like this:
>=20
> drivers/misc/Kconfig:238: can't open file "drivers/misc/cb710/Kconfig"
>=20
> Caused by commit f8d1918a2e7adbfdde0efc1a9a22cca3d5c5cae9 ("mmc: Driver
> for CB710/720 memory card reader (MMC part)").
>=20
> I have used the version of the mmc tree from next-20090603 for today.
>=20
> Please build test what you are submitting to linux-next.

Sorry, it seems I had some files in my working that weren't properly
added. :/

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
  TigerVNC, core developer          http://www.tigervnc.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-4523-1244093964-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkonXgoACgkQ7b8eESbyJLjvGwCfRnWg0jgXhqW+CUCDuoQN6RAt
kCEAnjiVMtQYjbgkcO2tZ0QyILg4oZvA
=WMnG
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-4523-1244093964-0001-2--
