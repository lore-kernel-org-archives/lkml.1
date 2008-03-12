Return-Path: <linux-kernel-owner+w=401wt.eu-S1754361AbYCLXnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbYCLXnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 19:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbYCLXnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 19:43:47 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:57279 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751584AbYCLXnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 19:43:46 -0400
X-Sasl-enc: GZwr1ZphzqxrPsHso/WFFaN11kXKO+JaI7L08jlB7SNA 1205365424
Message-ID: <47D86AA5.2080306@imap.cc>
Date: Thu, 13 Mar 2008 00:43:33 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Laurent Riffard <laurent.riffard@free.fr>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc5-mm1: NO_HZ=Y && PREEMPT_RCU=Y fails to build
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org> <47D78485.3030104@free.fr>
In-Reply-To: <47D78485.3030104@free.fr>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1468B0FFCEA01BC5A7D09287"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1468B0FFCEA01BC5A7D09287
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 12.03.2008 08:21 schrieb Laurent Riffard:
> Le 11.03.2008 09:14, Andrew Morton a =E9crit :
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-r=
c5/2.6.25-rc5-mm1/
>=20
> The kernel won't build if CONFIG_NO_HZ=3Dy and CONFIG_PREEMPT_RCU=3Dy:

Works fine here with those very same settings, except for a BUG message
and a warning I'll report separately and which don't seem to have any
serious consequences. This is a 32 bit build on a rather ordinary
Pentium D/Intel motherboard/openSUSE 10.3 workstation.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig1468B0FFCEA01BC5A7D09287
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFH2GquMdB4Whm86/kRAknkAJ9bdQRg0jIRbCP/aaSjvkzjhgTsVwCfZrKx
TosOBUT0TYJke5NOd9pYXSQ=
=SgED
-----END PGP SIGNATURE-----

--------------enig1468B0FFCEA01BC5A7D09287--
