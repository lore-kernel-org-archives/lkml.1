Return-Path: <linux-kernel-owner+w=401wt.eu-S1753022AbYKKXlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbYKKXlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 18:41:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYKKXlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 18:41:24 -0500
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:53771 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbYKKXlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 18:41:23 -0500
Message-ID: <491A1821.3070103@dell.com>
Date: Tue, 11 Nov 2008 17:41:21 -0600
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tim Gardner <timg@tpi.com>, marcel@holtmann.org,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Dell Wireless 365 requires reset quirk
References: <20081104162448.A338EF8A65@sepang.rtg.net> <20081111145706.9bfb4627.akpm@linux-foundation.org>
In-Reply-To: <20081111145706.9bfb4627.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9A7281E4917ED5A67E8ADC39"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9A7281E4917ED5A67E8ADC39
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Andrew Morton wrote:
> On Tue,  4 Nov 2008 09:24:48 -0700 (MST)
> timg@tpi.com (Tim Gardner) wrote:
>
>  =20
>
> I shall assume that this patch was authored by Mario.  This should have=

> been communicated by adding his From: line right at the top of the
> changelog.  Mario's signed-off-by: is absent, but that is tolerable
> because we have yours.
>
> The (absent) changelog fails to explain what effect this patch has.=20
> _why_ does this driver need this quirk?
>
> As it stands, there is insufficient information here for making
> 2.6.28-vs-2.6.29 decisions, let alone 2.6.27.x, 2.6.26.x, etc.
>  =20
Hi Andrew:

This patch causes the BT365 to be reset when the driver is loaded.=20
Without it, you won't be able to connect to other devices or scan for
devices.

Regards

--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com


--------------enig9A7281E4917ED5A67E8ADC39
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkkaGCIACgkQ2CrZjkA73Yvo0QCgn1Y4ykNNHkJCSKLAAPqQFrvi
lToAoIJIYRnNL+43IaNF8hDkQ2q6v+rl
=26pn
-----END PGP SIGNATURE-----

--------------enig9A7281E4917ED5A67E8ADC39--
