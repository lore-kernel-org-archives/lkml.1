Return-Path: <linux-kernel-owner+w=401wt.eu-S964834AbXDQPEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964834AbXDQPEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 11:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965044AbXDQPEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 11:04:35 -0400
Received: from mail.phnxsoft.com ([195.227.45.4]:1110 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964834AbXDQPEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 11:04:34 -0400
Message-ID: <4624E1DE.2040300@imap.cc>
Date: Tue, 17 Apr 2007 17:03:58 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Tilman Schmidt <tilman@imap.cc>, Randy Dunlap <randy.dunlap@oracle.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       i4ldeveloper@listserv.isdn4linux.de, Karsten Keil <kkeil@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: so what *is* obsolete and removable?
References: <Pine.LNX.4.64.0704151647200.29357@localhost.localdomain>	<4623FB0E.4080602@imap.cc>	<20070416161337.d59f2ea3.randy.dunlap@oracle.com>	<4624C320.3050206@imap.cc> <20070417144054.24c104bf@the-village.bc.nu>
In-Reply-To: <20070417144054.24c104bf@the-village.bc.nu>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig46ABE4EFD9668E9A1E089CD9"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig46ABE4EFD9668E9A1E089CD9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Apr 2007 14:40:54 +0100, Alan Cox wrote:
> If the obsolete tag is to be removed then it needs a formal maintainer,=

> all the obsolete interface usage cleaning up and the like otherwise at
> some point in a clean up it is going to end up breaking and migrating t=
o
> && BROKEN as well.

I'm not sure I understand. What do you mean by "obsolete interface
usage"? What sort of cleaning up needs to be done? What sort of
breakage do you anticipate in the event of a clean up?

Thanks
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig46ABE4EFD9668E9A1E089CD9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGJOHlMdB4Whm86/kRAgDMAJ0dXzqPtP7DujTwCpTb416QLcnXFgCfe5J0
MJHDDLG4d8Ldm3dTVCGcT58=
=rK7d
-----END PGP SIGNATURE-----

--------------enig46ABE4EFD9668E9A1E089CD9--
