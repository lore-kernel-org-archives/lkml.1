Return-Path: <linux-kernel-owner+w=401wt.eu-S1754555AbZHLROk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbZHLROk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 13:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbZHLROj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 13:14:39 -0400
Received: from gold.linx.net ([195.66.232.40]:39139 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069AbZHLROi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 13:14:38 -0400
Subject: Re: [PATCH 2.6.32 v3] Conditional MSI support for sata_nv
From: Tony Vroon <tony@linx.net>
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Philip Langdale <philipl@overt.org>,
       Robert Hancock <hancockrwd@gmail.com>
In-Reply-To: <c384c5ea0908121003x2f3eef3ejd8bc4a5aaa120793@mail.gmail.com>
References: <20090805235009.88C091007F@gold.linx.net>
	 <c384c5ea0908121003x2f3eef3ejd8bc4a5aaa120793@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-c6fiQCB8R9r/7pHbNPTd"
Organization: London Internet Exchange (LINX; AS5459)
Date: Wed, 12 Aug 2009 18:15:14 +0100
Message-Id: <1250097314.3879.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-c6fiQCB8R9r/7pHbNPTd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-08-12 at 19:03 +0200, Leon Woestenberg wrote:
> Shouldn't there be a matching "if (msi_enabled)
> pci_disabling_msi(pdev);" somewhere else?

Hello there Leon,

Actually that is taken care of through other means. Please see Tejun
Heo's confirmation of this in the "v2" thread for this patch.

> Regards,
> Leon.

Regards,
Tony V.

--=-c6fiQCB8R9r/7pHbNPTd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkqC+KIACgkQp5vW4rUFj5rAxgCgnwiK+47bbEl/MZST+AIlCrJy
ZK0An34Hve+abB8h57/Cl9DqDRIfhJx4
=hf5e
-----END PGP SIGNATURE-----

--=-c6fiQCB8R9r/7pHbNPTd--

