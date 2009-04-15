Return-Path: <linux-kernel-owner+w=401wt.eu-S1758806AbZDOLtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806AbZDOLtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 07:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbZDOLtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 07:49:09 -0400
Received: from mail.phnxsoft.com ([195.227.45.4]:2235 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbZDOLtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 07:49:08 -0400
Message-ID: <49E5C997.3030804@imap.cc>
Date: Wed, 15 Apr 2009 13:48:39 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14 Mnenhy/0.7.6.0
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: Fast testing
References: <2d05c4580904140255t25414b2bpe99b2a150dbe132a@mail.gmail.com> <20090414080511.5f50a81a@infradead.org>
In-Reply-To: <20090414080511.5f50a81a@infradead.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig312DE371A2AD23AA4EEAE829"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig312DE371A2AD23AA4EEAE829
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Arjan van de Ven schrieb:
> On Tue, 14 Apr 2009 11:55:10 +0200
> Dragoslav Zaric <dragoslav.zaric.kd@gmail.com> wrote:
>=20
>> I have question regarding fast testing of some change in some kernel
>> source file. Since rebooting is a long process, there must be way to
>=20
> Rebooting is bloody fast for me (0.7 seconds for the kernel start,
> about 3 to 4 seconds for the whole boot)....

Wow. Nice machine. I wish I had one like that. And how long until
the GUI is usable again and you can actually continue working?

For comparison: my 3.4 GHz Pentium D takes 30 secs for kernel start
(ie. until it begins looking for the filesystems), 6 mins for fsck
if it happens to decide my filesystems have gone too long without
checking, 2 mins until the graphical login screen appears, and
5 mins from logging in to the GUI being completely present.

> not sure that doing weird magic to save that is worth it...

Not for systems like yours, that's for sure, but perhaps for
systems like mine.

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig312DE371A2AD23AA4EEAE829
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJ5cmhQ3+did9BuFsRAnSVAJ9UNFngIBUBOqglWb8GjZrnj/f/swCfUtv1
sZnPOhg/DzuSWZqON0JFUls=
=74AY
-----END PGP SIGNATURE-----

--------------enig312DE371A2AD23AA4EEAE829--
