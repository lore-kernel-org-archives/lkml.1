Return-Path: <linux-kernel-owner+w=401wt.eu-S1763325AbZD2Wo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763325AbZD2Wo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762323AbZD2WbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:31:00 -0400
Received: from ausxipps301.us.dell.com ([143.166.148.223]:41507 "EHLO
	ausxipps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762300AbZD2Wa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:30:58 -0400
Message-ID: <49F8D52C.6000200@dell.com>
Date: Wed, 29 Apr 2009 17:31:08 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Add support for more dell-wmi hotkeys
References: <49ECBAE2.2080308@dell.com> <49EE09D9.2060209@dell.com> <20090429165729.GB32619@srcf.ucam.org> <49F89981.10806@dell.com> <20090429183154.GC2325@srcf.ucam.org> <49F8C59F.2010603@dell.com> <20090429212924.GA7900@srcf.ucam.org>
In-Reply-To: <20090429212924.GA7900@srcf.ucam.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2696E8A015B9414078ACA2D2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2696E8A015B9414078ACA2D2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Matthew:

Matthew Garrett wrote:
> On Wed, Apr 29, 2009 at 04:24:47PM -0500, Mario Limonciello wrote:
>
> Ok. Is there any programmatic way to determine whether a given Dell=20
> complies with your WMI spec or not? I'd prefer not to use DMI tables=20
> unless it's the only way to identify the machines - the risk is that=20
> there'll be something else that also uses its own codes and will just=20
> behave oddly until someone figures out why it's broken.
>  =20
Not that I can easily discern.  The only relevant bit that i'm finding
is whether a key is reported as "programmable", which might be the case
for the M6300.  I'll try to look further into it to see if that's the
case here, and if that information can be flagged upon.
--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com


--------------enig2696E8A015B9414078ACA2D2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkn41SwACgkQ2CrZjkA73Yv7NQCfZbCoWoRTf/9xBZ2sG16yAM5+
RH8An2TPA8YAeYEh8oLRGlO8SM0bHonb
=BNj2
-----END PGP SIGNATURE-----

--------------enig2696E8A015B9414078ACA2D2--
