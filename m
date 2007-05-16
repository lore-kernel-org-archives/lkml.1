Return-Path: <linux-kernel-owner+w=401wt.eu-S1760136AbXEPJLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136AbXEPJLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 05:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756866AbXEPJLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 05:11:41 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:60394 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756857AbXEPJLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 05:11:40 -0400
X-Sasl-enc: u5V80D/bogvMlmsQAcuPqP3VcwmYmfqFPqWIMLVYOyLV 1179306698
Message-ID: <464ACB7E.9040405@imap.cc>
Date: Wed, 16 May 2007 11:14:38 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Linux 2.6.22-rc1
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>	 <4647569D.7010709@imap.cc>	 <Pine.LNX.4.61.0705141918180.9570@yvahk01.tjqt.qr>	 <4648A3DF.7040004@imap.cc>	 <Pine.LNX.4.61.0705142227350.9570@yvahk01.tjqt.qr>	 <a781481a0705141934u6b369dd5ob1715f14890af914@mail.gmail.com>	 <46498EE3.8010907@imap.cc> <a781481a0705151839l65ea7ee0yb61bf7c911a0c2f8@mail.gmail.com>
In-Reply-To: <a781481a0705151839l65ea7ee0yb61bf7c911a0c2f8@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig23D7448D781512D1DF8519F6"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig23D7448D781512D1DF8519F6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 16.05.2007 03:39 schrieb Satyam Sharma:
["default n" for menuconfig]
> these problems would occur only the _first_ time someone
> transitions from the old .config's to the new scheme. But those
> "default y"s for all the various "configmenu"s (let's please call
> them that) that got introduced in the Kconfig files would cause
> unnecessary annoyance to users of make oldconfig _for ever_.

I'm not sure I'm following you. Where would that annoyance occur?
On subsequent uses of "make oldconfig" the default shouldn't even
matter, as the previous choice would just silently be kept.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig23D7448D781512D1DF8519F6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGSsuGMdB4Whm86/kRAqV4AJ9Tt+dwz6leCLuL2Ix9u26yQtE8/ACfRkwU
J+ReXeRlOLMSSgUo0HOhr7k=
=qnLn
-----END PGP SIGNATURE-----

--------------enig23D7448D781512D1DF8519F6--
