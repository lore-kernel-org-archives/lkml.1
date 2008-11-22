Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbYKVSle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbYKVSle (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 13:41:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbYKVSlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 13:41:24 -0500
Received: from server.drzeus.cx ([85.8.24.28]:34224 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751072AbYKVSlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 13:41:24 -0500
Date: Sat, 22 Nov 2008 19:41:05 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Ben Dooks <ben-linux@fluff.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>, kernel@avr32linux.org
Subject: Re: [PATCH] mmc: atmel-mci: move atmel-mci.h file to include/linux
Message-ID: <20081122194105.348cd5e0@mjolnir.drzeus.cx>
In-Reply-To: <49257B40.8020807@atmel.com>
References: <491C0C05.6040301@atmel.com>
	<20081113134818.GA9161@fluff.org.uk>
	<491C3D16.1050501@atmel.com>
	<20081119193631.448ae25e@mjolnir.drzeus.cx>
	<49257B40.8020807@atmel.com>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-17339-1227379275-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-17339-1227379275-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 20 Nov 2008 15:59:12 +0100
Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> Needed to use the atmel-mci driver in an architecture
> independant maner.
>=20
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> ---

Colour me confused. Shouldn't this go through Haavard?

--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-17339-1227379275-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkkoUkUACgkQ7b8eESbyJLj0egCePSccK6NgskBIU4qDNKaKozfX
KX0AoKWGgyTPuEmmweF2WmI9H0BX9f6z
=rPOQ
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-17339-1227379275-0001-2--
