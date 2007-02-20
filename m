Return-Path: <linux-kernel-owner+w=401wt.eu-S1030469AbXBTVyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030469AbXBTVyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 16:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030470AbXBTVyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 16:54:21 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:38863 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030469AbXBTVyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 16:54:20 -0500
X-Sasl-enc: /ROpF5c3HQ7Onf/zlxgml4hN2VrhM4CQ0Gg+kp/8Kh0B 1172008525
Message-ID: <45DB6E45.5040408@imap.cc>
Date: Tue, 20 Feb 2007 22:55:17 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Kai Germaschewski <kai.germaschewski@unh.edu>,
       Hansjoerg Lipp <hjlipp@web.de>, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org
Subject: Re: Kbuild problem
References: <45D74B46.3090602@imap.cc> <Pine.LNX.4.44.0702180017170.1150-100000@localhost.localdomain> <20070218104028.GU13958@stusta.de> <45DAFE0B.1070305@imap.cc> <20070220145943.GU13958@stusta.de>
In-Reply-To: <20070220145943.GU13958@stusta.de>
X-Enigmail-Version: 0.94.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0FC94AE81919513260171CBF"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0FC94AE81919513260171CBF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 20.02.2007 15:59 schrieb Adrian Bunk:
> I'm usually someone who likes to avoid including unneeded code in the=20
> kernel, but in this case I'd say KISS - and build it always into the=20
> gigaset module.

There seems to be a clear majority for this solution. So KISS it
will be. Thanks for all the advice. I'll do a new patch.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig0FC94AE81919513260171CBF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF225RMdB4Whm86/kRAvcTAJ9pi8/Mk4aE/I6MVbEZaafQs2JgVgCeLhtS
E8ETdHh1LpQhfTiYAWF47ak=
=/+Ki
-----END PGP SIGNATURE-----

--------------enig0FC94AE81919513260171CBF--
