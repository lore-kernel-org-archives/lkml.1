Return-Path: <linux-kernel-owner+w=401wt.eu-S1758571AbXENSBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571AbXENSBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 14:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756922AbXENSBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 14:01:10 -0400
Received: from mail.phnxsoft.com ([195.227.45.4]:2194 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717AbXENSBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 14:01:08 -0400
Message-ID: <4648A3DF.7040004@imap.cc>
Date: Mon, 14 May 2007 20:01:03 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc1
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org> <4647569D.7010709@imap.cc> <Pine.LNX.4.61.0705141918180.9570@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705141918180.9570@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2FB4F99B9288C88FDA839720"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2FB4F99B9288C88FDA839720
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Jan Engelhardt schrieb:
> On May 13 2007 20:19, Tilman Schmidt wrote:
>>
>>Would it be asking too much to have help texts on the following
>>new (wrt 2.6.21) configuration options?
>>
>>ESP Scsi Driver Core (SCSI_ESP_CORE) [N/m] (NEW)
>>Macintosh device drivers (MACINTOSH_DRIVERS) [Y/n] (NEW)
>>Ethernet (1000 Mbit) (NETDEV_1000) [Y/n] (NEW)
>>Ethernet (10000 Mbit) (NETDEV_10000) [Y/n] (NEW)
>>
>>Those for the latter three could/should say something like the
>>one for the WLAN_80211 option.
>=20
> "Patches welcome" ;-)

Sure. Just tell me exactly what those options are intended to do
and I'll happily write up a patch adding help texts trying to
express that in bad English. :-)

Seriously, it might be a tad more efficient if the help texts were
written by those who invented the options in the first place.

> As for NETDEV_1000 and _10000, I really wonder if we need anymore
> help text than the option. I do not know what the minimum level
> of user knowledge is that kconfig help texts need to support,
> but maybe you can tell?

For a start, it shouldn't require users to grep through Kconfigs
and Makefiles in order to find out what effects an option has.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig2FB4F99B9288C88FDA839720
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGSKPfMdB4Whm86/kRAniHAJ9+2ooXtauZEd3kw9ZT6yL4mP8h+wCcC+PT
ob4vtFUgk43jzEc+5E/7bUc=
=bAQ6
-----END PGP SIGNATURE-----

--------------enig2FB4F99B9288C88FDA839720--
