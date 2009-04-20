Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbZDTSut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbZDTSut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 14:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbZDTSuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 14:50:40 -0400
Received: from ausxippc101.us.dell.com ([143.166.85.207]:65263 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbZDTSuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 14:50:39 -0400
X-Loopcount0: from 10.9.160.254
Message-ID: <49ECC407.6030400@dell.com>
Date: Mon, 20 Apr 2009 13:50:47 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Add support for Eject hotkey in dell-wmi
References: <49ECBAE2.2080308@dell.com> <20090420182312.GA2910@srcf.ucam.org> <49ECBE35.9040003@dell.com> <20090420182848.GA3105@srcf.ucam.org> <49ECC279.2080607@dell.com> <20090420184807.GA3490@srcf.ucam.org>
In-Reply-To: <20090420184807.GA3490@srcf.ucam.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigAB2705C7E8DC4380D2F5C131"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAB2705C7E8DC4380D2F5C131
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Matthew:

Matthew Garrett wrote:
> On Mon, Apr 20, 2009 at 01:44:09PM -0500, Mario Limonciello wrote:
>  =20
> Ah, ok, that's fine. As long as the event will only be delivered either=
=20
> via WMI or the keyboard controller then we should be good.
>
>  =20
At least for consumer machines that I've heard, this will be the case.=20
I'd expect the same policy for business client (Latitude etc), but I
don't know for sure.

Regards
--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com


--------------enigAB2705C7E8DC4380D2F5C131
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAknsxAcACgkQ2CrZjkA73YvVWwCfVmQaFf8RONmS/PsSViJq+u5g
n+MAn2yjL497s+qCv/tPTT/oKf/j2h8u
=Jufn
-----END PGP SIGNATURE-----

--------------enigAB2705C7E8DC4380D2F5C131--
