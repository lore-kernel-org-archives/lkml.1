Return-Path: <linux-kernel-owner+w=401wt.eu-S1758538AbYGJT7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538AbYGJT7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 15:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754942AbYGJT72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 15:59:28 -0400
Received: from server.drzeus.cx ([85.8.24.28]:38676 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754804AbYGJT71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 15:59:27 -0400
Date: Thu, 10 Jul 2008 21:59:20 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH 1/1] MMC: sido_io.c Fix sparse warnings
Message-ID: <20080710215920.35f20388@mjolnir.drzeus.cx>
In-Reply-To: <1215648116-2070-1-git-send-email-tomas.winkler@intel.com>
References: <1215648116-2070-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-17502-1215719965-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-17502-1215719965-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 10 Jul 2008 03:01:56 +0300
Tomas Winkler <tomas.winkler@intel.com> wrote:

> Unfold nested macros it creates not readable code and
> sparse warnings
> sdio_io.c:190:9: warning: symbol '_min1' shadows an earlier one
>=20
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---

I actually think the original version is more readable, but I've
applied it for the sake of avoiding sparse noise.

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-17502-1215719965-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkh2ahsACgkQ7b8eESbyJLibKQCfSU8UYDeHHD7qO3hVl6R3VHWy
y3YAoK/0fCdDRddlA6+dNmhGLzzitx6A
=TjUU
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-17502-1215719965-0001-2--
