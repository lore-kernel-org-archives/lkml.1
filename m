Return-Path: <linux-kernel-owner+w=401wt.eu-S1760109AbXEMSQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760109AbXEMSQZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 14:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757612AbXEMSQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 14:16:10 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52383 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757573AbXEMSQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 14:16:09 -0400
X-Sasl-enc: /TkxA9IrodWkyZ37RIcgW+/vWF1x1Wgu+/Cn84cr9rzt 1179080169
Message-ID: <4647569D.7010709@imap.cc>
Date: Sun, 13 May 2007 20:19:09 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc1
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBAD41789B613FF1C527958B0"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBAD41789B613FF1C527958B0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 13.05.2007 05:20 schrieb Linus Torvalds:
> Ok, the merge window has closed, and 2.6.22-rc1 is out there.
[...]
> So give it a good testing.

Would it be asking too much to have help texts on the following
new (wrt 2.6.21) configuration options?

ESP Scsi Driver Core (SCSI_ESP_CORE) [N/m] (NEW)
Macintosh device drivers (MACINTOSH_DRIVERS) [Y/n] (NEW)
Ethernet (1000 Mbit) (NETDEV_1000) [Y/n] (NEW)
Ethernet (10000 Mbit) (NETDEV_10000) [Y/n] (NEW)

Those for the latter three could/should say something like the
one for the WLAN_80211 option.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigBAD41789B613FF1C527958B0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGR1alMdB4Whm86/kRAv2aAJ4yEVvZHhlmxzTOvZ12v8JPgXfZ9wCfRyLw
cryn3KdE7XqnQeyBx1H7d5M=
=GbIi
-----END PGP SIGNATURE-----

--------------enigBAD41789B613FF1C527958B0--
