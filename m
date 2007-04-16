Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbXDPWgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbXDPWgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 18:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbXDPWgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 18:36:55 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:57050 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753958AbXDPWgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 18:36:54 -0400
X-Sasl-enc: McEWkkYA1F7BEMSMJpWHBvgbJQBkXKa0Iz/XEeWaDEVu 1176763014
Message-ID: <4623FB0E.4080602@imap.cc>
Date: Tue, 17 Apr 2007 00:39:10 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: i4ldeveloper@listserv.isdn4linux.de, Karsten Keil <kkeil@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: so what *is* obsolete and removable?
References: <Pine.LNX.4.64.0704151647200.29357@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0704151647200.29357@localhost.localdomain>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCDC12AD418B320CFCEDFF0A2"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCDC12AD418B320CFCEDFF0A2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 15.04.2007 22:55 schrieb Robert P. J. Day:
>   as i recall, the isdn4linux was *un*obsoleted, wasn't it?

Actually, it wasn't.

We *did* reach a consensus that isdn4linux is not obsolete in the
accepted sense of the word, because there is no replacement for it
so far.

OTOH I have since submitted (twice, in fact) a patch that would remove
the "(obsolete)" label from the Kconfig entry, but somehow nothing
ever became of it. My submissions just linger in LKML, uncommented and
unmerged.

To sum it up, we agree that the "(obsolete)" label is wrong, but we
won't remove it. I have no idea how to resolve that situation.

What I do know is that it would be very wrong to remove isdn4linux,
because it has an existing userbase with nowhere else to go.

--=20
Tilman Schmidt                                  E-Mail: tilman@imap.cc
Wehrhausweg 66                                  Fax: +49 228 4299019
53227 Bonn
Germany


--------------enigCDC12AD418B320CFCEDFF0A2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGI/sWMdB4Whm86/kRAtt3AJ9JxxGz/H4LFKXDwIc9gD/k1re/SQCdHU0R
FL5Vf5BrUWItWDfd0RfqZ6c=
=S6cd
-----END PGP SIGNATURE-----

--------------enigCDC12AD418B320CFCEDFF0A2--
