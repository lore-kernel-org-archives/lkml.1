Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbYKJJyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbYKJJyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 04:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755122AbYKJJx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 04:53:57 -0500
Received: from server.drzeus.cx ([85.8.24.28]:55486 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754807AbYKJJx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 04:53:56 -0500
Date: Mon, 10 Nov 2008 10:53:47 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Lavinen Jarkko (Nokia-M/Helsinki)" <jarkko.lavinen@nokia.com>,
       "Bityutskiy Artem (Nokia-M/Helsinki)" <Artem.Bityutskiy@nokia.com>
Subject: Re: [PATCH 1/2] mmc_block: print better data error message after
 timeout
Message-ID: <20081110105347.27a41650@mjolnir.drzeus.cx>
In-Reply-To: <4917EEC7.3070701@nokia.com>
References: <48F7411F.3020109@nokia.com>
	<20081026121155.69692474@mjolnir.drzeus.cx>
	<49083B1C.6060803@nokia.com>
	<4917EEC7.3070701@nokia.com>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-583-1226310832-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-583-1226310832-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Nov 2008 10:20:23 +0200
Adrian Hunter <ext-adrian.hunter@nokia.com> wrote:

>=20
> What is the status of this patch?
>=20

Waiting for me to have time to look closer at it.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-583-1226310832-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkkYBLAACgkQ7b8eESbyJLiKBACgrIl4cuULqgv34jFj+2v74Zfp
NuEAmwYYxp43gCXMmBQMt87uEZGpJyVe
=xJ5t
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-583-1226310832-0001-2--
