Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440AbZICRTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbZICRTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 13:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752272AbZICRTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 13:19:19 -0400
Received: from ausxipps301.us.dell.com ([143.166.148.223]:29187 "EHLO
	ausxipps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbZICRTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 13:19:19 -0400
Message-ID: <4A9FFAC4.1060808@dell.com>
Date: Thu, 03 Sep 2009 12:20:04 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Dell-laptop is not working without wireless
References: <20090818060340.E1C7A526EA5@mailhub.coreip.homeip.net> <20090903153215.E51F8526EA5@mailhub.coreip.homeip.net> <4A9FF1FB.5090507@dell.com> <20090903174839.948A4526EA5@mailhub.coreip.homeip.net>
In-Reply-To: <20090903174839.948A4526EA5@mailhub.coreip.homeip.net>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBF60709AA77D5EA782B4CB80"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBF60709AA77D5EA782B4CB80
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi Dmitry:

Dmitry Torokhov wrote:
> On Thursday 03 September 2009 09:42:35 am Mario Limonciello wrote:
>  =20
>
> Hmm, what is the BIOS version in your box? Also, mine used to have
> broadcom-based wifi and I replaced it with iwl3945, would that make
> any difference?
I'm on BIOS A06, but I wouldn't /expect/ any of the stable (A**) BIOS
releases to change any behaviors like this.

What card the machine shipped with won't have a bearing on the behaviors
with the current card.  There aren't any factory processes that change
the BIOS based on the card, just processes that would add newer firmware
directly to cards that support it.
--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com


--------------enigBF60709AA77D5EA782B4CB80
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkqf+sUACgkQ2CrZjkA73YvjJQCdED77s0DvZOpCUsa5lPx81MIT
agMAn15qJS0RMQFDn8ByZ6CvTfUny5SU
=llt0
-----END PGP SIGNATURE-----

--------------enigBF60709AA77D5EA782B4CB80--
