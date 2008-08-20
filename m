Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbYHTLFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbYHTLFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 07:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYHTLEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 07:04:53 -0400
Received: from server.drzeus.cx ([85.8.24.28]:33607 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751648AbYHTLEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 07:04:53 -0400
Date: Wed, 20 Aug 2008 13:04:41 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sdhci: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter -
 disabling IRQ
Message-ID: <20080820130441.339bb459@mjolnir.drzeus.cx>
In-Reply-To: <20080820064522.GA2501@hardeman.nu>
References: <20080624181656.GB14243@hardeman.nu>
	<20080710083457.7887d363@mjolnir.drzeus.cx>
	<20080711164706.GA8943@hardeman.nu>
	<20080719015531.6c8a1981@mjolnir.drzeus.cx>
	<20080802224725.GA6574@hardeman.nu>
	<20080805112234.759819fe@mjolnir.drzeus.cx>
	<20080820064522.GA2501@hardeman.nu>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-6824-1219230291-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-6824-1219230291-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 20 Aug 2008 08:45:22 +0200
David H=C3=A4rdeman <david@hardeman.nu> wrote:

>=20
> In the end, it turns out that if the iwl4965 is disabled (e.g. via the=20
> rfkill button) and stays disabled, no error message is generated (I=20
> waited for > 30 minutes). If I later enable it and connect to my=20
> wireless AP, I get the error message approx 10 minutes after I've=20
> connected to the AP.
>=20
> Does this mean I should contact the iwl4965 maintainers?
>=20

Yes indeed. Since this is an issue that has been present previously, it
hopefully isn't that hard to fix.

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-6824-1219230291-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkir+lAACgkQ7b8eESbyJLjguQCfTyXhvcuDTHOC0M6SK7W39DD6
hYcAoJ5Mwt4Jfabm3KQYBrqdPsldeP0J
=Wmsn
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-6824-1219230291-0001-2--
