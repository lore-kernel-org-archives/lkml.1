Return-Path: <linux-kernel-owner+w=401wt.eu-S1753243AbYJZLuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbYJZLuj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 07:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbYJZLuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 07:50:22 -0400
Received: from server.drzeus.cx ([85.8.24.28]:44929 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753073AbYJZLuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 07:50:22 -0400
Date: Sun, 26 Oct 2008 12:50:11 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: trivial annotation of 'blocks'
Message-ID: <20081026125011.6bc0047e@mjolnir.drzeus.cx>
In-Reply-To: <1224720540.6823.7.camel@brick>
References: <1224720540.6823.7.camel@brick>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-8797-1225021821-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-8797-1225021821-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 22 Oct 2008 17:09:00 -0700
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> sg_init_one is reading a be32, annotate as such.
>=20
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---

Applied, thanks.

--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-8797-1225021821-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkkEWXkACgkQ7b8eESbyJLiebACfV/hFTn8IPZm2Z+4fmn7/EEs9
BfYAoNPZyZ+V0PqkuU8NF2GO1ddS/Xz4
=UJ+U
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-8797-1225021821-0001-2--
