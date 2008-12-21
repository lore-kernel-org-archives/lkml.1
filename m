Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbYLUPAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbYLUPAu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 10:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYLUPAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 10:00:41 -0500
Received: from server.drzeus.cx ([85.8.24.28]:51256 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752119AbYLUPAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 10:00:41 -0500
Date: Sun, 21 Dec 2008 16:00:33 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] mmc: balanc pci_iomap with pci_iounmap
Message-ID: <20081221160033.721b19f9@mjolnir.drzeus.cx>
In-Reply-To: <4944194D.3030405@gmail.com>
References: <494417FF.7010501@gmail.com>
	<4944194D.3030405@gmail.com>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-26566-1229871639-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-26566-1229871639-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 13 Dec 2008 21:21:33 +0100
Roel Kluin <roel.kluin@gmail.com> wrote:

> balance pci_iomap with pci_iounmap, not iounmap
>=20
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Sorry, this is what it should be...
>=20

Applied, thanks.

--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-26566-1229871639-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAklOWhcACgkQ7b8eESbyJLi1GQCgpHh0CkRWopFZFumP1oFG7eQ1
PJ0AoMxTqYQLpDy3+rNyadfUoMNXpkdp
=4W48
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-26566-1229871639-0001-2--
