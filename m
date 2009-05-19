Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbZESQwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbZESQwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 12:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbZESQwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 12:52:44 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:35725 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbZESQwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 12:52:44 -0400
X-Loopcount0: from 10.9.160.254
Message-ID: <4A12E3DF.3070402@dell.com>
Date: Tue, 19 May 2009 11:52:47 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Oliver Neukum <oliver@neukum.org>, Marcel Holtmann <marcel@holtmann.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Explicitly disable BT radio using rfkill interface on
 suspend
References: <4A11C126.1000704@dell.com> <1242710064.3147.4.camel@localhost.localdomain> <20090519090610.GA29967@srcf.ucam.org> <200905191447.34000.oliver@neukum.org> <20090519125853.GA12483@srcf.ucam.org> <4A12DEA8.4060305@dell.com> <20090519163333.GA17189@srcf.ucam.org>
In-Reply-To: <20090519163333.GA17189@srcf.ucam.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig18BBED433BED8C599762CC20"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig18BBED433BED8C599762CC20
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Matthew:

Matthew Garrett wrote:
> On Tue, May 19, 2009 at 11:30:32AM -0500, Mario Limonciello wrote:
>  =20
>
> I thought all USB devices got reenumerated on resume?
>  =20
Leaving udevadm monitor running on a terminal during S3, I don't see any
events that would agree with this.
--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com


--------------enig18BBED433BED8C599762CC20
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoS498ACgkQ2CrZjkA73YstwQCfRs8dXw61gK+uYTD7PaF/lfDL
fsQAnRJVLm5mFtOSUUAmN6FHvoWlzGSU
=kbYZ
-----END PGP SIGNATURE-----

--------------enig18BBED433BED8C599762CC20--
