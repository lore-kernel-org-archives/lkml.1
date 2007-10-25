Return-Path: <linux-kernel-owner+w=401wt.eu-S1760645AbXJYXJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760645AbXJYXJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 19:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863AbXJYXJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 19:09:10 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:36986 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753835AbXJYXJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 19:09:07 -0400
X-Sasl-enc: nmFyylxyynrXfNeV3hfwXoaL01yPYWMMeUrF1GbswOJg 1193353743
Message-ID: <4721221A.1020309@imap.cc>
Date: Fri, 26 Oct 2007 01:09:14 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Simon Arlott <simon@fire.lp0.eu>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to	static
 interface)
References: <alpine.LFD.0.999.0710191336250.26902@woody.linux-foundation.org> <Pine.LNX.4.64.0710201255170.1997@fbirervta.pbzchgretzou.qr> <Xine.LNX.4.64.0710210842540.551@us.intercode.com.au> <20071022210956.31f7bbcf@laptopd505.fenrus.org> <20071023051642.GA3908@sequoia.sous-sol.org> <471E9260.6000704@goop.org> <20071023220649.5a76af82@laptopd505.fenrus.org> <55615.simon.1193226629@5ec7c279.invalid> <20071024125533.GE30533@stusta.de> <471F8AC5.9080300@simon.arlott.org.uk> <20071024223124.GI30533@stusta.de>
In-Reply-To: <20071024223124.GI30533@stusta.de>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig122860BE44C441408EB4410D"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig122860BE44C441408EB4410D
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 25.10.2007 00:31 schrieb Adrian Bunk:
> Generally, the goal is to get external modules included into the kernel=
=2E
> [...] even though it might sound harsh breaking
> external modules and thereby making people aware that their code should=
=20
> get into the kernel is IMHO a positive point.

This argument seems to start from the assumption that any externally
maintained kernel code *can* get into the kernel, which doesn't stand
up to  reality. Once you admit that there is code which, for very good
reasons, won't ever be accepted into the mainline kernel tree, what you
are saying amounts to: "Code that isn't fit to be included in the
mainline kernel isn't fit to exist at all."

I'm not sure I can agree with that.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=C3=B6ffnet mindestens haltbar bis: (siehe R=C3=BCckseite)


--------------enig122860BE44C441408EB4410D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHISIiMdB4Whm86/kRAgiNAJ9pxXfWVFs5dMpolPf4Gy/IcV+VHQCffpVI
9ambRYUhZJBxGDIhYHjvYNA=
=PK4d
-----END PGP SIGNATURE-----

--------------enig122860BE44C441408EB4410D--
