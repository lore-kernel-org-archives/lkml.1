Return-Path: <linux-kernel-owner+w=401wt.eu-S1753115AbYITKOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbYITKOP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 06:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbYITKOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 06:14:07 -0400
Received: from server.drzeus.cx ([85.8.24.28]:36117 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751162AbYITKOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 06:14:05 -0400
Date: Sat, 20 Sep 2008 12:13:58 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org, kernel@avr32linux.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH 0/4] atmel-mci: fixes for 2.6.27
Message-ID: <20080920121358.3fc10a13@mjolnir.drzeus.cx>
In-Reply-To: <1221851370-20189-1-git-send-email-haavard.skinnemoen@atmel.com>
References: <1221851370-20189-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: Claws Mail 3.5.0cvs92 (GTK+ 2.14.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-10577-1221905644-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-10577-1221905644-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 19 Sep 2008 21:09:26 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> Hi Pierre,
>=20
> Here is a small handful of fixes for problems I've found while testing
> the new atmel-mci driver. I hope they can be applied before 2.6.27
> goes out the door.
>=20

Queued up and on its way to Linus.

> I guess it's too late to add DMA support at this point, so I'll post
> that separately along with a few other improvements.

Yeah, no features at this point. I do appreciate getting patches some
time before the merge window (preferably right after it closes).

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-10577-1221905644-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkjUzOoACgkQ7b8eESbyJLiLkACglU8R8Br9m0YUki1Ms6eAz20A
VGoAoKU4oWmBCTVsSvaOCl4Tax/jJi+t
=Wqw9
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-10577-1221905644-0001-2--
