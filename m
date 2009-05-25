Return-Path: <linux-kernel-owner+w=401wt.eu-S1752983AbZEYHW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbZEYHW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 03:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbZEYHWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 03:22:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39170 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbZEYHWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 03:22:15 -0400
Date: Mon, 25 May 2009 17:22:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Chris Zankel <chris@zankel.net>
Subject: Re: Linux 2.6.30-rc7
Message-Id: <20090525172208.d3bc133e.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LFD.2.01.0905231453180.3555@localhost.localdomain>
References: <alpine.LFD.2.01.0905231453180.3555@localhost.localdomain>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__25_May_2009_17_22_08_+1000_/8lBITLaiYPYyD+="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_May_2009_17_22_08_+1000_/8lBITLaiYPYyD+=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, 23 May 2009 15:07:03 -0700 (PDT) Linus Torvalds <torvalds@linux-fou=
ndation.org> wrote:
>
> So go wild. I suspect I'll do an -rc8, but we're definitely getting close=
r=20
> to release-time - it would be good to get as much testing as possible, an=
d=20
> it should generally be pretty safe to try this all out.

Given that, it is nice to see lots of green at
http://kisskb.ellerman.id.au/kisskb/branch/3/ (that's -rc7) and also at
http://kisskb.ellerman.id.au/kisskb/branch/9/ (that's -next).  I also
assume that almost everything for 2.6.31 has been submitted to
linux-next, right?  :-)

[It would be nice if xtensa would build ...]
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__25_May_2009_17_22_08_+1000_/8lBITLaiYPYyD+=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoaRyAACgkQjjKRsyhoI8xwYACdFa4v26eZnZdnC4/1aF20bdsy
6RAAn0f0KCggo7pSn5XvQ0wwjVpEa4G5
=70Q4
-----END PGP SIGNATURE-----

--Signature=_Mon__25_May_2009_17_22_08_+1000_/8lBITLaiYPYyD+=--
