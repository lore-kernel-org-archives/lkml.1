Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbYAOXEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbYAOXEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 18:04:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbYAOXD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 18:03:58 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:58763 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754034AbYAOXD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 18:03:57 -0500
X-Sasl-enc: W9dvq4LNd/n0o2sqbDezy4cxOFO0GPF1GhHqOxuDQcaI 1200438234
Message-ID: <478D3BCF.9020904@imap.cc>
Date: Wed, 16 Jan 2008 00:03:43 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: where to maintain userspace daemon for line discipline
References: <45AE507E.3040601@imap.cc> <20070122115644.b538908f.akpm@osdl.org> <45CA4D32.6010302@zytor.com>
In-Reply-To: <45CA4D32.6010302@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig01B0A4F5EAFFD64299723C0E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig01B0A4F5EAFFD64299723C0E
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 07 Feb 2007 14:05:38 -0800, H. Peter Anvin wrote:
> util-linux-ng is already going, so it's a good place.

Not even a year later, I'd like to take up this proposal. I have:
- gigasetm101d.c (the source program)
- gigasetm101d.8 (a manpage)
- Makefile (trivial)
How should I proceed in order to get this included in util-linux-ng?

Thanks,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig01B0A4F5EAFFD64299723C0E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHjTvYMdB4Whm86/kRAif+AJ4vmpR5as/quo8Eheyz2ShMUxlEMQCeNHIV
GJEgfiWeji9/y+Gotri4h+Y=
=8L8L
-----END PGP SIGNATURE-----

--------------enig01B0A4F5EAFFD64299723C0E--
