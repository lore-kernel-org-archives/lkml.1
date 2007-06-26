Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbXFZDOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbXFZDOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 23:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbXFZDN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 23:13:58 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:42563 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbXFZDN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 23:13:56 -0400
Message-ID: <4680843B.5010503@freedesktop.org>
Date: Mon, 25 Jun 2007 20:12:59 -0700
From: Josh Triplett <josh@freedesktop.org>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070618)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Segher Boessenkool <segher@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
References: <E1I2N6V-0003g9-8H@ZenIV.linux.org.uk> <20070624174732.GZ21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241102160.3593@woody.linux-foundation.org> <20070624183547.GA21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241203530.3593@woody.linux-foundation.org> <1a25667a20e43a072f733a3ec2b8e79d@kernel.crashing.org> <20070624203837.GE21478@ftp.linux.org.uk> <467F531A.3030702@freedesktop.org> <20070625195511.GG21478@ftp.linux.org.uk>
In-Reply-To: <20070625195511.GG21478@ftp.linux.org.uk>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1B5BA729A899237316EB4FF1"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1B5BA729A899237316EB4FF1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Al Viro wrote:
> On Sun, Jun 24, 2007 at 10:31:06PM -0700, Josh Triplett wrote:
>> Al Viro wrote:
>>> Joy.  OK, folks, disregard 16/16 in the current form; everything prio=
r
>>> to it stands on its own.
>> Acknowledged.  The rest of the patches look good to me, so I'll merge =
1-15
>> soon, and ignore 16.
>>
>> Do you have those patches in public git somewhere, or would you like m=
e to
>> just apply the patches from mail?
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/sparse.git/ misc

No changes to validation output at any point in the series.  Merged.  Tha=
nks!

- Josh Triplett



--------------enig1B5BA729A899237316EB4FF1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGgIQ7GJuZRtD+evsRAuCTAKCm8+NDg5I9ZI9CLnwA3CRHKc5U5wCeLCcF
E9GtVfce5Evvt3YPmXYH2II=
=jLNt
-----END PGP SIGNATURE-----

--------------enig1B5BA729A899237316EB4FF1--
