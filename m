Return-Path: <linux-kernel-owner+w=401wt.eu-S1757831AbZDUTWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831AbZDUTWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 15:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756188AbZDUTWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 15:22:09 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:25753 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbZDUTWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 15:22:08 -0400
X-Loopcount0: from 10.9.160.254
Message-ID: <49EE1CE7.5020503@dell.com>
Date: Tue, 21 Apr 2009 14:22:15 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Add support for more dell-wmi hotkeys
References: <49ECBAE2.2080308@dell.com> <49EE09D9.2060209@dell.com> <20090421183100.GA8120@srcf.ucam.org> <49EE1945.2080808@dell.com> <20090421191242.GA8445@srcf.ucam.org> <49EE1B9F.2030504@dell.com> <20090421191817.GA9419@srcf.ucam.org>
In-Reply-To: <20090421191817.GA9419@srcf.ucam.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigAEC2AC6B32E84F8AE5D35A35"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAEC2AC6B32E84F8AE5D35A35
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Matthew:

Matthew Garrett wrote:
> On Tue, Apr 21, 2009 at 02:16:47PM -0500, Mario Limonciello wrote:
>  =20
>
> Ok. As long as there's a way of determining when a platform no longer=20
> sends scancodes (and so we can switch to WMI delivery), then that seems=
=20
> fine.
>  =20
Looking at the specs for this next year, there is no plan to drop
sending the scancodes for the volume keys.  These were written with Win7
in mind, so at a minimum, this behavior wouldn't be changed until Win7+1.=


A lot of the other keys I've hooked up through this however, platforms
will see these changes within the year.  I've tried to document which
keys will still send scan code events per that spec.

Regards
--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com


--------------enigAEC2AC6B32E84F8AE5D35A35
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAknuHOcACgkQ2CrZjkA73Yu5xACffixsN7LZgKpu8X3hTrK2TdIu
IKkAnAtgcyJ356Fk1WNtZm7Tdd2BuaNs
=ZCUP
-----END PGP SIGNATURE-----

--------------enigAEC2AC6B32E84F8AE5D35A35--
