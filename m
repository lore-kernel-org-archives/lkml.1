Return-Path: <linux-kernel-owner+w=401wt.eu-S1764109AbZE0UWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764109AbZE0UWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757876AbZE0UWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:22:04 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:53755 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761578AbZE0UWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:22:02 -0400
Date: Wed, 27 May 2009 22:21:58 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ian Molton <spyro@f2s.com>,
       Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [PATCH 5/5] mmc: tmio_mmc: move probe function into __init
 section
Message-ID: <20090527222158.5f734a90@mjolnir.ossman.eu>
In-Reply-To: <1243279681-4233-6-git-send-email-philipp.zabel@gmail.com>
References: <1243279681-4233-1-git-send-email-philipp.zabel@gmail.com>
	<1243279681-4233-6-git-send-email-philipp.zabel@gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-4545-1243455722-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-4545-1243455722-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 25 May 2009 21:28:01 +0200
Philipp Zabel <philipp.zabel@gmail.com> wrote:

> As MFD cells are not hotpluggable, this should be safe to do.
>=20
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> Cc: Pierre Ossman <pierre@ossman.eu>
> Cc: Ian Molton <spyro@f2s.com>
> ---

You can still bind/unbind the driver though, so I don't think this is
inherently safe.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-4545-1243455722-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkodoOkACgkQ7b8eESbyJLgOZwCeIEySU3wwJ/qNYCzaOesu/+5A
YKAAn2DlYtnsWwk62iFoYhAV6YdhuQZg
=XWDB
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-4545-1243455722-0001-2--
