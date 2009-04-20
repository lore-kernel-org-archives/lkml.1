Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbZDTSqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbZDTSqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 14:46:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbZDTSpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 14:45:50 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:15169 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbZDTSpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 14:45:49 -0400
X-Loopcount0: from 10.9.160.254
Message-ID: <49ECC2E4.6070105@dell.com>
Date: Mon, 20 Apr 2009 13:45:56 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Add support for Eject hotkey in dell-wmi
References: <49ECBAE2.2080308@dell.com> <20090420182312.GA2910@srcf.ucam.org> <49ECBE35.9040003@dell.com> <20090420182848.GA3105@srcf.ucam.org>
In-Reply-To: <20090420182848.GA3105@srcf.ucam.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig534C8EFDB8E1454D946A0E4B"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig534C8EFDB8E1454D946A0E4B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Matthew

Matthew Garrett wrote:
> On Mon, Apr 20, 2009 at 01:25:57PM -0500, Mario Limonciello wrote:
>  =20
>
> Ok. How can we determine whether we're on a machine with this support? =

> Applying this patch right now will result in systems receiving the even=
t=20
> twice.
>  =20
I've checked with the BIOS teams further, and they indicated at the time
that this is enabled on those consumer systems, the hotkey should be
switched over to a mechanical key rather than a software key, so the
keyboard interface would not see this key.  The support in the BIOS to
turn on and off WMI would actually enable SMI hot key events instead
(which could then be serviced by dell-laptop).

--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com


--------------enig534C8EFDB8E1454D946A0E4B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAknswuQACgkQ2CrZjkA73YuG5ACfcs0gyOdSgN/7hxGpJmzat4I/
qtcAoINxvS8LYlFiyXqGPhvVZ91Y4Qo7
=Uzgv
-----END PGP SIGNATURE-----

--------------enig534C8EFDB8E1454D946A0E4B--
