Return-Path: <linux-kernel-owner+w=401wt.eu-S1759943AbYGJTzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759943AbYGJTzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 15:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbYGJTzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 15:55:46 -0400
Received: from server.drzeus.cx ([85.8.24.28]:33930 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751216AbYGJTzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 15:55:45 -0400
Date: Thu, 10 Jul 2008 21:55:37 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linux-kernel@vger.kernel.org, Benzi Zbit <benzi.zbit@intel.com>
Subject: Re: [PATCH 1/1 V3] MMC: core - fix the use of hard coded timeout
 value.
Message-ID: <20080710215537.15a04805@mjolnir.drzeus.cx>
In-Reply-To: <1215646903-810-1-git-send-email-tomas.winkler@intel.com>
References: <1215646903-810-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-17482-1215719743-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-17482-1215719743-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 10 Jul 2008 02:41:43 +0300
Tomas Winkler <tomas.winkler@intel.com> wrote:

> From: Benzi Zbit <benzi.zbit@intel.com>
>=20
> This adds reading and using of enable_timeout from the CIS
>=20
> Signed-off-by: Benzi Zbit <benzi.zbit@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---

Looks ok. Applied.

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-17482-1215719743-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkh2aT0ACgkQ7b8eESbyJLg6JACfTObc8iyGQx1VwCCXxI8GD7f8
DT8AoJQjNqqDS4IY6yuO/zpBntjrCqVR
=Nq8R
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-17482-1215719743-0001-2--
