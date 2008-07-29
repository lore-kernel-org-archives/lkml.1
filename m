Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbYG2KPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbYG2KPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 06:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbYG2KP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 06:15:27 -0400
Received: from mail.phnxsoft.com ([195.227.45.4]:3192 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847AbYG2KP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 06:15:26 -0400
Message-ID: <488EEDBA.9050604@imap.cc>
Date: Tue, 29 Jul 2008 12:15:22 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Karsten Keil <kkeil@suse.de>
Subject: Re: [PATCH 1/7] Add mISDN driver
References: <20080727010837.GA3415@pingi.kke.suse.de>
In-Reply-To: <20080727010837.GA3415@pingi.kke.suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigAE3A4D22E8722E1E5645A33A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAE3A4D22E8722E1E5645A33A
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

On Sun, 27 Jul 2008 03:08:37 +0200, Karsten Keil wrote:
> Please pull this and the following patches from=20
> git://git.kernel.org/pub/scm/linux/kernel/git/kkeil/ISDN-2.6.git master=

>=20
> mISDN is a new modular ISDN driver, in the long term it should replace
> the old I4L driver architecture for passiv ISDN cards.

At last. Thanks a lot for that effort!

>  Documentation/isdn/README.mISDN |    6 ++++++
>  drivers/isdn/Kconfig            |    4 +++-
>  drivers/isdn/Makefile           |    1 +
>  drivers/isdn/hardware/Makefile  |    1 +
>  4 files changed, 11 insertions(+), 1 deletions(-)

As the maintainer of an old I4L driver which I would like to convert
to mISDN as soon as possible, I would be very grateful if you could,
in time, also add a file Documentation/isdn/INTERFACE.mISDN describing
the in-kernel interface between the mISDN core and hardware specific
modules. (Like Documentation/isdn/INTERFACE does for I4L.)

Thanks again,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigAE3A4D22E8722E1E5645A33A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFIju26Q3+did9BuFsRAgpsAJ9Yr9OLuif1F6/pQto67ep2yYbL5wCeIgmW
rRHt1czX7o0vUDOHClU72LI=
=k9tr
-----END PGP SIGNATURE-----

--------------enigAE3A4D22E8722E1E5645A33A--
