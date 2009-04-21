Return-Path: <linux-kernel-owner+w=401wt.eu-S1758359AbZDUTQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359AbZDUTQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 15:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbZDUTQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 15:16:41 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:35575 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbZDUTQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 15:16:41 -0400
X-Loopcount0: from 10.9.160.254
Message-ID: <49EE1B9F.2030504@dell.com>
Date: Tue, 21 Apr 2009 14:16:47 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Add support for more dell-wmi hotkeys
References: <49ECBAE2.2080308@dell.com> <49EE09D9.2060209@dell.com> <20090421183100.GA8120@srcf.ucam.org> <49EE1945.2080808@dell.com> <20090421191242.GA8445@srcf.ucam.org>
In-Reply-To: <20090421191242.GA8445@srcf.ucam.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDA0B7533C0DA4EA34B3303D9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDA0B7533C0DA4EA34B3303D9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Matthew:

Matthew Garrett wrote:
> Hm. But if we get the scancode, presumably we can do this anyway?
>  =20
Yes, this information might not be as useful on Linux as it is for the
Windows situation.  On Windows, the WMI event doesn't translate directly
into a key, but rather a userspace application makes the changes.  As it
stands right now, the keys still don't do anything with my patch(s).=20
They're at least documented however in case someone would like to change
this behavior at some point.

Regards
--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com


--------------enigDA0B7533C0DA4EA34B3303D9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAknuG6AACgkQ2CrZjkA73YuvDwCfaZ7z1cqYaOKNGwNnEbAYB8hd
RkIAnj8/hK/K0cth7aebPS6FB+1846ME
=03jE
-----END PGP SIGNATURE-----

--------------enigDA0B7533C0DA4EA34B3303D9--
