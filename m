Return-Path: <linux-kernel-owner+w=401wt.eu-S1762681AbYGFRxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762681AbYGFRxz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761586AbYGFRuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:50:07 -0400
Received: from server.drzeus.cx ([85.8.24.28]:54855 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761261AbYGFRuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:50:05 -0400
Date: Sun, 6 Jul 2008 19:49:58 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Sascha Sommer <saschasommer@freenet.de>
Cc: sdricohcs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Status of Ricoh Bay1Controller driver?
Message-ID: <20080706194958.655056b4@mjolnir.drzeus.cx>
In-Reply-To: <200807060909.30563.saschasommer@freenet.de>
References: <20080705115039.77bf7e1c@mjolnir.drzeus.cx>
	<200807052111.49807.saschasommer@freenet.de>
	<20080706012435.016358d6@mjolnir.drzeus.cx>
	<200807060909.30563.saschasommer@freenet.de>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-641-1215366602-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-641-1215366602-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 6 Jul 2008 09:09:30 +0200
Sascha Sommer <saschasommer@freenet.de> wrote:

>=20
> So to summarize this I agree that it is important to get rid off these=20
> hacks ;) but I don't have a better solution available at the moment ;(.
>=20

Very odd. Anyway, send an updated patch with a proper entry in
MAINTAINERS and I'll queue it up.

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-641-1215366602-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhxBcoACgkQ7b8eESbyJLjC3gCgoGdmedUdIQ+SGkQJgRHD4SXc
yGQAoLVhMWWEZxZWv2KlirzMe78S5B3P
=A/YO
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-641-1215366602-0001-2--
