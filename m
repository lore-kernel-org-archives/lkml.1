Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbYGEWi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbYGEWi6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 18:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbYGEWiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 18:38:50 -0400
Received: from server.drzeus.cx ([85.8.24.28]:55016 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752361AbYGEWit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 18:38:49 -0400
Date: Sun, 6 Jul 2008 00:38:40 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: marcel@holtmann.org, linux-kernel@vger.kernel.org,
       Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH 2/5 V2] MMC: wbsd.c fix shadowing of 'dma' variable
Message-ID: <20080706003840.4b24e0d9@mjolnir.drzeus.cx>
In-Reply-To: <1214869984-20115-2-git-send-email-tomas.winkler@intel.com>
References: <1214869984-20115-1-git-send-email-tomas.winkler@intel.com>
	<1214869984-20115-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-15430-1215297526-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-15430-1215297526-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue,  1 Jul 2008 02:53:01 +0300
Tomas Winkler <tomas.winkler@intel.com> wrote:

> This patch fix warning :shadowing dma variable
> and made use of module_param_named instead of module_param
>=20
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---

Ooops. It should of course been this I applied. Redone with the right
patch. :)

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-15430-1215297526-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhv9/YACgkQ7b8eESbyJLiFjgCfTLwZBY4jn1M5AVwx0OB5MeTE
/rsAoOT2GwymO4dlL+qaut9cOgRSW11o
=Cf5a
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-15430-1215297526-0001-2--
