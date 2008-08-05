Return-Path: <linux-kernel-owner+w=401wt.eu-S1761825AbYHETxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761825AbYHETxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 15:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbYHETqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 15:46:03 -0400
Received: from smtp1-g19.free.fr ([212.27.42.27]:53379 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515AbYHETqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 15:46:01 -0400
Subject: Re: [PATCH] Add Intel ACPI IGD OpRegion support
From: Yves-Alexis Perez <corsac@debian.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: airlied@linux.ie, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <20080805183725.GA4468@srcf.ucam.org>
References: <20080805183725.GA4468@srcf.ucam.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-50w8MfyFDKCJmaizKbYl"
Date: Tue, 05 Aug 2008 21:44:30 +0200
Message-Id: <1217965470.5449.4.camel@hidalgo>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-50w8MfyFDKCJmaizKbYl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On mar, 2008-08-05 at 19:37 +0100, Matthew Garrett wrote:
> This adds the support necessary for allowing ACPI backlight control
> to=20
> work on some newer Intel-based graphics systems. Tested on Thinkpad
> T61=20
> and HP 2510p hardware.

Ok, I managed to apply it against drm-2.6/drm-next but it won't apply
against linux-acpi-2.6/test and I'm not sure how hard it is to cherry
pick the needed stuff from drm to acpi.

I'll try to build the drm-2.6/drm-next + patch but I guess it won't be
enough to test brightness keys?

Cheersm
--=20
Yves-Alexis

--=-50w8MfyFDKCJmaizKbYl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkiYrZ4ACgkQTUTAIMXAW66mSACdFAzSLp5uy+ocFVrogi0vGzpm
vG8An1MXpXt2eofme9WT/fizR95iJut6
=Som+
-----END PGP SIGNATURE-----

--=-50w8MfyFDKCJmaizKbYl--
