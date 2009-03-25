Return-Path: <linux-kernel-owner+w=401wt.eu-S1760922AbZCYQSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760922AbZCYQSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 12:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbZCYQR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 12:17:58 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:36689 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218AbZCYQR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 12:17:58 -0400
Date: Wed, 25 Mar 2009 17:17:49 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: =?UTF-8?B?Sm9zw6kgTWFyw63CrWEgRmVybsOhbmRleiBHb256w6FsZXo=?= 
	<josemariafg@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mmc: Some microSD cards are not recognized by
 PCIxx12 SDA controller
Message-ID: <20090325171749.62bd0fbb@mjolnir.ossman.eu>
In-Reply-To: <49C9E4B8.3000708@gmail.com>
References: <49B5C091.3090303@gmail.com>
	<20090324211748.30cd7429@mjolnir.ossman.eu>
	<49C9E4B8.3000708@gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-28806-1237997872-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-28806-1237997872-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Mar 2009 09:00:56 +0100
Jos=C3=A9 Mar=C3=AD=C2=ADa Fern=C3=A1ndez Gonz=C3=A1lez <josemariafg@gmail.=
com> wrote:

>=20
> As I'm going to install 2.6.29 today, I can test the patch with it and HZ=
=3D100.

Please do. And try to determine where it breaks. I'd prefer if we don't
need to increase this yet again in a month because we were relying on
some scheduling latencies. :)

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-28806-1237997872-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAknKWTAACgkQ7b8eESbyJLhhVwCg3GLdjHz7y78BG+rpOj+wFIOQ
xv0AnizF4TrIlijoKVXF4KbJEoGHL13o
=aYsP
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-28806-1237997872-0001-2--
