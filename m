Return-Path: <linux-kernel-owner+w=401wt.eu-S938048AbXGMXEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938048AbXGMXEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 19:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760506AbXGMXEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 19:04:39 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:54723 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759346AbXGMXEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 19:04:38 -0400
X-Sasl-enc: gFmfOBJcwbZa8om3gH8Shvv68OjdAiltXMJkMPs2FGk6 1184367877
Message-ID: <46980610.9080705@imap.cc>
Date: Sat, 14 Jul 2007 01:09:04 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: -mm merge plans for 2.6.23
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <Pine.LNX.4.64.0707101107340.11053@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0707101107340.11053@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig25ACA098E83F99DFBFF6FE48"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig25ACA098E83F99DFBFF6FE48
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 13.07.2007 11:46 schrieb Jan Engelhardt:
> On Jul 10 2007 01:31, Andrew Morton wrote:
>=20
>> use-menuconfig-objects-isdn-config_isdn_i4l.patch
>>
>> tilman didn't like it - might drop
>=20
> Or replace by his suggestion patch ( http://lkml.org/lkml/2007/5/31/222=
 )

That posting was just a change proposal for the drivers/isdn/Kconfig
part, not a complete replacement for the entire patch. If you'd care to
reissue that patch with the modification I proposed, I'll gladly ack it.
Alternatively I can also send a full replacement patch if you prefer.

Regards,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig25ACA098E83F99DFBFF6FE48
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGmAYZMdB4Whm86/kRAlJOAJoCRFoLB//tNEs8E8fJIBbmLPZa2QCfQmL7
4CUOiSf3JXSyiJxbsUCbmrs=
=1lOS
-----END PGP SIGNATURE-----

--------------enig25ACA098E83F99DFBFF6FE48--
