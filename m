Return-Path: <linux-kernel-owner+w=401wt.eu-S1762554AbYHFGuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762554AbYHFGuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 02:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbYHFGua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 02:50:30 -0400
Received: from molly.corsac.net ([81.57.48.219]:57191 "EHLO molly.corsac.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285AbYHFGua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 02:50:30 -0400
Subject: Re: [PATCH] Add Intel ACPI IGD OpRegion support
From: Yves-Alexis Perez <corsac@debian.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, airlied@linux.ie,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <20080806063441.GA14455@srcf.ucam.org>
References: <20080805183725.GA4468@srcf.ucam.org>
	 <1217965470.5449.4.camel@hidalgo> <1217972874.4540.3.camel@hidalgo>
	 <20080806001301.GA10630@srcf.ucam.org>
	 <20080806023247.GA4665@khazad-dum.debian.net>
	 <20080806063441.GA14455@srcf.ucam.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VnCQ2UpxEX+ECEq25VHf"
Date: Wed, 06 Aug 2008 08:50:31 +0200
Message-Id: <1218005431.4540.26.camel@hidalgo>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VnCQ2UpxEX+ECEq25VHf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On mer, 2008-08-06 at 07:34 +0100, Matthew Garrett wrote:
> It doesn't seem to, no. I should have been clearer - the delay is in
> the=20
> DSDT (not thinkpad-acpi itself), but there's a Thinkpad-specific ACPI=20
> call that seems to be needed in order to delay it. Here's the patch=20
> again.

Woah, it works perfectly fine here. Thanks :)

Cheers,
--=20
Yves-Alexis

--=-VnCQ2UpxEX+ECEq25VHf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkiZSbIACgkQTUTAIMXAW64k8gCgoKHCCdzcQf5877CSzk2NUnrk
TFgAn2Uey78rpwR795SBux2T72g+g4Kj
=7e83
-----END PGP SIGNATURE-----

--=-VnCQ2UpxEX+ECEq25VHf--
