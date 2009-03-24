Return-Path: <linux-kernel-owner+w=401wt.eu-S1762966AbZCXUGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762966AbZCXUGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 16:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbZCXUGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 16:06:05 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:41176 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbZCXUGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 16:06:03 -0400
Date: Tue, 24 Mar 2009 21:05:56 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Ian Molton <ian@mnementh.co.uk>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       drzeus-wbsd@drzeus.cx, akpm@linux-foundation.org
Subject: Re: [PATCH 00/05] tmio_mmc: Minor fixes and cnf/irq changes
Message-ID: <20090324210556.6dd38515@mjolnir.ossman.eu>
In-Reply-To: <49C83EA4.8060108@mnementh.co.uk>
References: <20090311125845.1563.31960.sendpatchset@rx1.opensource.se>
	<20090316193010.56644165@mjolnir.ossman.eu>
	<49C83EA4.8060108@mnementh.co.uk>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-18725-1237925157-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-18725-1237925157-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 24 Mar 2009 02:00:04 +0000
Ian Molton <ian@mnementh.co.uk> wrote:

> Pierre Ossman wrote:
>=20
> > Ian, I noticed that there isn't a MAINTAINERS entry for this driver.
> > Care to send me a patch to remedy that?
>=20
> Something like this?
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5d460c9..6dd8805 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4298,6 +4298,11 @@ L:	tlinux-users@tce.toshiba-dme.co.jp
>   W:	http://www.buzzard.org.uk/toshiba/
>   S:	Maintained
>=20
> +TMIO MMC DRIVER
> +P:	Ian Molton
> +M:	ian@mnementh.co.uk
> +S:	Maintained
> +
>   TPM DEVICE DRIVER
>   P:	Debora Velarde
>   M:	debora@linux.vnet.ibm.com

Yes, thank you. I've queued up a commit with this.

--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-18725-1237925157-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAknJPScACgkQ7b8eESbyJLiF+wCgqESoeBW524lHrVPArpKPFVQE
tVUAn1A8/WepsR4tCkHJ8nLYIpcgnaLv
=BoMv
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-18725-1237925157-0001-2--
