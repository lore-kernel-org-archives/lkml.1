Return-Path: <linux-kernel-owner+w=401wt.eu-S1763427AbZDHSXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763427AbZDHSXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 14:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760748AbZDHSXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 14:23:36 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:44157 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756894AbZDHSXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 14:23:36 -0400
Date: Wed, 8 Apr 2009 20:23:24 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Jonas Larsson <jonas.larsson@martinsson.se>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH] atmel-mci: Add support for inverted detect pin
Message-ID: <20090408202324.60080108@mjolnir.ossman.eu>
In-Reply-To: <1238507945-5453-1-git-send-email-haavard.skinnemoen@atmel.com>
References: <1238507945-5453-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-25561-1239215009-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-25561-1239215009-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 31 Mar 2009 15:59:05 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> From: Jonas Larsson <jonas.larsson@martinsson.se>
>=20
> Same patch as before, modified to use bool. Also adds description of
> the new field in struct atmel_mci that I missed in the first patch.
>=20
> This patch adds Atmel MCI support for inverted detect pins.
>=20
> Signed-off-by: Jonas Larsson <jonas.larsson@martinsson.se>
> Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> ---
> Pierre, if it's fine with you, I'd like to apply this to the avr32 tree
> since I have another patch which depends on this as well as another
> change which hasn't gone upstream yet.
>=20

Sure.

Acked-by: Pierre Ossman <pierre@ossman.eu>

--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-25561-1239215009-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAknc66MACgkQ7b8eESbyJLgYbACg8CuVvq6X/ub3hX6j+JqPQTeW
k2YAn2rFWS22eNhDpOFBzKxJzCUqdETa
=LmBU
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-25561-1239215009-0001-2--
