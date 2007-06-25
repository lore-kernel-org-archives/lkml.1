Return-Path: <linux-kernel-owner+w=401wt.eu-S1755853AbXFYFix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbXFYFix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 01:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbXFYFip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 01:38:45 -0400
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:44912 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbXFYFip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 01:38:45 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jun 2007 01:38:45 EDT
Message-ID: <467F531A.3030702@freedesktop.org>
Date: Sun, 24 Jun 2007 22:31:06 -0700
From: Josh Triplett <josh@freedesktop.org>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070618)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Segher Boessenkool <segher@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
References: <E1I2N6V-0003g9-8H@ZenIV.linux.org.uk> <20070624174732.GZ21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241102160.3593@woody.linux-foundation.org> <20070624183547.GA21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241203530.3593@woody.linux-foundation.org> <1a25667a20e43a072f733a3ec2b8e79d@kernel.crashing.org> <20070624203837.GE21478@ftp.linux.org.uk>
In-Reply-To: <20070624203837.GE21478@ftp.linux.org.uk>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB902522D1392C2A17E885A2B"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB902522D1392C2A17E885A2B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Al Viro wrote:
> Joy.  OK, folks, disregard 16/16 in the current form; everything prior
> to it stands on its own.

Acknowledged.  The rest of the patches look good to me, so I'll merge 1-1=
5
soon, and ignore 16.

Do you have those patches in public git somewhere, or would you like me t=
o
just apply the patches from mail?

- Josh Triplett



--------------enigB902522D1392C2A17E885A2B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGf1MsGJuZRtD+evsRAiazAJ95iY7OzpYrn/tAkSpTyj0tK3OJjgCeIum9
5U10pncQSc6kSLKjLuQDjv0=
=F/A5
-----END PGP SIGNATURE-----

--------------enigB902522D1392C2A17E885A2B--
