Return-Path: <linux-kernel-owner+w=401wt.eu-S1759966AbZEMSAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966AbZEMSAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 14:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755090AbZEMSAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 14:00:05 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:60884 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbZEMSAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 14:00:04 -0400
Date: Wed, 13 May 2009 19:59:56 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Tobias Diedrich <ranma+kernel@tdiedrich.de>
Cc: SDHCI development <sdhci-devel@lists.ossman.eu>,
       linux-kernel@vger.kernel.org
Subject: Re: Ricoh R5C822 and QUIRK_FORCE_DMA
Message-ID: <20090513195956.30f78012@mjolnir.ossman.eu>
In-Reply-To: <20090430224524.GA9487@yamamaya.is-a-geek.org>
References: <20090430224524.GA9487@yamamaya.is-a-geek.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-8146-1242237600-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-8146-1242237600-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

(cc:ing sdhci-devel)

On Fri, 1 May 2009 00:45:24 +0200
Tobias Diedrich <ranma+kernel@tdiedrich.de> wrote:

>=20
> Do you know any controller bugs for this revision which may be the
> reason for not advertising DMA capability?
> I haven't done any big tests yet, but at first glance it seems to
> read/write the card just fine.
>=20

Might be a system problem so it's Lenovo that disabled it. You're the
first report I've seen on this since the DMA logic was reworked so that
DMA didn't have to be forced for most cases.

Is there anyone else reading this that are having DMA problems?

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-8146-1242237600-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkoLCqAACgkQ7b8eESbyJLhxrQCgikIgIlWa4z72vWvHmmah1hIQ
OL0An3R8/0BhOLKza68MHs1QlnLmrZNS
=r6hk
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-8146-1242237600-0001-2--
