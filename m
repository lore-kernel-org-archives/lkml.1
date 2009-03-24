Return-Path: <linux-kernel-owner+w=401wt.eu-S1762810AbZCXUHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762810AbZCXUHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 16:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbZCXUHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 16:07:33 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:42881 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036AbZCXUHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 16:07:32 -0400
Date: Tue, 24 Mar 2009 21:07:25 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org,
       Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH] atmel-mci: fix sdc_reg typo
Message-ID: <20090324210725.7250dd17@mjolnir.ossman.eu>
In-Reply-To: <1237889166-17760-1-git-send-email-haavard.skinnemoen@atmel.com>
References: <1237889166-17760-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-18749-1237925246-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-18749-1237925246-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 24 Mar 2009 11:06:06 +0100
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
>=20
> This fixes a bug when setting the sdc_reg for 4-bit bus width
> transactions.
>=20
> Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> ---

Queued, thanks.

--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-18749-1237925246-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAknJPYAACgkQ7b8eESbyJLg8iACfavmPfJqo7HG3TC2616jHoTBk
n+IAoKbWnmVmdNu6YHIyn2d7zhE/0RD7
=F3iO
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-18749-1237925246-0001-2--
