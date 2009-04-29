Return-Path: <linux-kernel-owner+w=401wt.eu-S1759993AbZD2SQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993AbZD2SQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 14:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbZD2SQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 14:16:25 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:24807 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbZD2SQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 14:16:24 -0400
X-Loopcount0: from 10.9.160.254
Message-ID: <49F89981.10806@dell.com>
Date: Wed, 29 Apr 2009 13:16:33 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Add support for more dell-wmi hotkeys
References: <49ECBAE2.2080308@dell.com> <49EE09D9.2060209@dell.com> <20090429165729.GB32619@srcf.ucam.org>
In-Reply-To: <20090429165729.GB32619@srcf.ucam.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8E48161565F76263BEC1E083"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8E48161565F76263BEC1E083
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Matthew:

Matthew Garrett wrote:
> Taking another look at this, you've got:
>
> -       {KE_KEY, 0xe045, KEY_PROG1},
> +    {KE_KEY, 0xe045, KEY_NUMLOCK},
>
> The hardware I have here uses 0xe045 for the power profile (or whatever=
=20
> it is) button above the keyboard. How do we differentiate these?
>  =20
What hardware is this?  I can look more to see why they are deviating
from the spec.  Also, are you on the latest BIOS for that box?  It's
possible it was a BIOS bug causing the wrong key to be sent.
--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com



--------------enig8E48161565F76263BEC1E083
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkn4mYEACgkQ2CrZjkA73YvfygCggX0L34j47WeUpeyQL58czP9C
860AoI8a/C8e6o8UKXpYm3CJtGSEfBa6
=URpJ
-----END PGP SIGNATURE-----

--------------enig8E48161565F76263BEC1E083--
