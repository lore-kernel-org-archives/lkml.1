Return-Path: <linux-kernel-owner+w=401wt.eu-S1763289AbYBTOYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763289AbYBTOYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 09:24:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756891AbYBTOYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 09:24:24 -0500
Received: from mail.phnxsoft.com ([195.227.45.4]:3880 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbYBTOYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 09:24:23 -0500
Message-ID: <47BC3802.1070107@imap.cc>
Date: Wed, 20 Feb 2008 15:24:02 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: Andi Kleen <andi@firstfloor.org>, Sam Ravnborg <sam@ravnborg.org>,
       Greg KH <greg@kroah.com>, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: Plans for mISDN? Was: [PATCH 00/14] [ISDN] ...
References: <098123kjff90231nv098233rnvd908u234@garzik.org> <20080217195235.GN14588@uranus.ravnborg.org> <20080218045209.GA15141@kroah.com> <p73zltyxy9q.fsf@bingen.suse.de> <20080219085033.GA1775@uranus.ravnborg.org> <20080219094034.GD6485@one.firstfloor.org> <20080219095622.GC4164@uranus.ravnborg.org> <20080219095834.GB6940@one.firstfloor.org> <79536BD8-1BB6-451E-9047-EBAC37F2073E@holtmann.org>
In-Reply-To: <79536BD8-1BB6-451E-9047-EBAC37F2073E@holtmann.org>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig91D4A7C9422F8C7665839397"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig91D4A7C9422F8C7665839397
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Marcel Holtmann schrieb:
> My proposal is to merge mISDN and then see what falls out. My guess it =
=20
> won't be that bad as everybody thinks and then we go from there. Next  =

> step is to remove ISDN4Linux since that should not be used at all =20
> anymore.

No. Next step is to create the missing documentation.
The step after that is to convert the remaining isdn4linux
drivers to mISDN. Then you can remove isdn4linux.

HTH
T.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig91D4A7C9422F8C7665839397
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHvDgDQ3+did9BuFsRAgDJAKCKeM13pqelTK5Xy/VrFKMmGlV5LgCfRcR5
oiGVLSl24Wi8dBBENC+ycV8=
=Mx1p
-----END PGP SIGNATURE-----

--------------enig91D4A7C9422F8C7665839397--
