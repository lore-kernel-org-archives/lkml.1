Return-Path: <linux-kernel-owner+w=401wt.eu-S1753019AbZHSSqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbZHSSqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 14:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbZHSSql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 14:46:41 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:49413 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbZHSSql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 14:46:41 -0400
X-Loopcount0: from 10.9.160.253
Message-ID: <4A8C48BA.1000009@dell.com>
Date: Wed, 19 Aug 2009 13:47:22 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090804)
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: cezary.jackiewicz@gmail.com, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/3] Add rfkill support to compal-laptop
References: <1250706969-10382-1-git-send-email-Mario_Limonciello@Dell.com> <1250707376.8073.4.camel@johannes.local>
In-Reply-To: <1250707376.8073.4.camel@johannes.local>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB6BB6021364367E83410BC28"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB6BB6021364367E83410BC28
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Johannes:

Johannes Berg wrote:
> On Wed, 2009-08-19 at 13:36 -0500, Mario Limonciello wrote:
>  =20
>
>  =20
>
> Isn't that missing sysfs_remove_group()?
>
> johannes
>  =20
The third patch in the (updated) series is dropping the sysfs bits, so
sysfs_remove_group is removed there.
--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com


--------------enigB6BB6021364367E83410BC28
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkqMSLoACgkQ2CrZjkA73YsU6QCgkOtaczvK4YUYRZ0wVPIDa3nu
Ph4An0md7zA/kWObwbWk6od0dTAn9cDJ
=yUa8
-----END PGP SIGNATURE-----

--------------enigB6BB6021364367E83410BC28--
