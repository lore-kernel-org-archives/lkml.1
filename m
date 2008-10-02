Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbYJBIdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbYJBIdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 04:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYJBIdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 04:33:07 -0400
Received: from server.drzeus.cx ([85.8.24.28]:36589 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752553AbYJBIdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 04:33:04 -0400
Date: Thu, 2 Oct 2008 10:32:57 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Christer Weinigel <christer@weinigel.se>
Cc: Christer Weinigel <christer.weinigel@csr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/3] RFC: Low-latency SDIO
Message-ID: <20081002103257.3b2f7c5d@mjolnir.drzeus.cx>
In-Reply-To: <20080930102313.418263345@zoo.weinigel.se>
References: <20080930102313.418263345@zoo.weinigel.se>
X-Mailer: Claws Mail 3.5.0cvs92 (GTK+ 2.14.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-7157-1222936384-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-7157-1222936384-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 30 Sep 2008 12:23:13 +0200
Christer Weinigel <christer@weinigel.se> wrote:

> Hi Pierre and anyone else who is interested,
>=20

Hi Christer,

> Here is a cleaned up patch that implements the low-latency SDIO stuff
> I mailed about a couple of weeks ago.  Basically the patches adds
> asynchronous SDIO operations and makes it possible to register a
> "hard" SDIO interrupt handler which will be called directly from
> interrupt context (mmc_signal_sdio_irq).
>=20
> So, tell me what you think. :-)
>=20

Did you see the response I sent to the previous thread?

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-7157-1222936384-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkjkhz0ACgkQ7b8eESbyJLiJwQCfdDD7r43nckwUB3j5jDhXuSnl
v5YAoIKNIqHgJWucMR46LECFl0GTINeZ
=cW3x
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-7157-1222936384-0001-2--
