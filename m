Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbZDTSfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbZDTSfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 14:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbZDTSf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 14:35:26 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:25743 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769AbZDTSfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 14:35:25 -0400
X-Greylist: delayed 576 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Apr 2009 14:35:25 EDT
X-Loopcount0: from 10.9.160.254
Message-ID: <49ECBE35.9040003@dell.com>
Date: Mon, 20 Apr 2009 13:25:57 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Add support for Eject hotkey in dell-wmi
References: <49ECBAE2.2080308@dell.com> <20090420182312.GA2910@srcf.ucam.org>
In-Reply-To: <20090420182312.GA2910@srcf.ucam.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB5DDA09E2861DC2C03BDF855"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB5DDA09E2861DC2C03BDF855
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Matthew:

Matthew Garrett wrote:
> On Mon, Apr 20, 2009 at 01:11:46PM -0500, Mario Limonciello wrote:
>  =20
>
> Looks good - can you confirm that it'll be removed from the normal=20
> keyboard interface at the same time?
>  =20
No it won't be removed at the same time on all machines during the
transition period.  I've however requested to add a BIOS option for the
machines that support this to try to enable or disable WMI support in
the interim.

Regards
--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com


--------------enigB5DDA09E2861DC2C03BDF855
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAknsvjUACgkQ2CrZjkA73YsKVwCfb6DQjjzXamCCbweVbWEQMOPb
mIIAoJvKx1TipzEPgyvb01MI3IZYAJ84
=4uUp
-----END PGP SIGNATURE-----

--------------enigB5DDA09E2861DC2C03BDF855--
