Return-Path: <linux-kernel-owner+w=401wt.eu-S1757579AbZEVLxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbZEVLxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 07:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbZEVLxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 07:53:18 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:36797 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbZEVLxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 07:53:17 -0400
Date: Fri, 22 May 2009 13:53:11 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: avorontsov@ru.mvista.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: Add fsl,esdhc as a valid compatible to bind
 against
Message-ID: <20090522135311.090c98ad@mjolnir.ossman.eu>
In-Reply-To: <1241790769-3843-1-git-send-email-galak@kernel.crashing.org>
References: <1241790769-3843-1-git-send-email-galak@kernel.crashing.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-27028-1242993197-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-27028-1242993197-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri,  8 May 2009 08:52:49 -0500
Kumar Gala <galak@kernel.crashing.org> wrote:

> We plan to use fsl,esdhc going forward as the base compatible so update
> the driver to bind against it.
>=20
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> ---

Applied.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-27028-1242993197-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkoWkisACgkQ7b8eESbyJLhE+QCgx/oYiz4LFnd/vFcKWiR4+DDI
jr4An3yUIoLOURJm4SpcgdQlWbZeRSZB
=J8Hr
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-27028-1242993197-0001-2--
