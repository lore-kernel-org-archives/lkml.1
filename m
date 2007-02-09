Return-Path: <linux-kernel-owner+w=401wt.eu-S1946026AbXBIC3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946026AbXBIC3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 21:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946027AbXBIC3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 21:29:19 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:33825 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946026AbXBIC3S (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 21:29:18 -0500
Message-Id: <200702090229.l192T1O4008508@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Oleg Verych <olecom@flower.upol.cz>
Subject: Re: The who needs reviews anyways [PATCH]
In-Reply-To: Your message of "Fri, 09 Feb 2007 00:20:49 +0100."
             <Pine.LNX.4.64.0702090014020.14457@scrub.home>
From: Valdis.Kletnieks@vt.edu
References: <Pine.LNX.4.64.0702082227020.14457@scrub.home> <Pine.LNX.4.64.0702081414150.8424@woody.linux-foundation.org> <Pine.LNX.4.64.0702082335150.14457@scrub.home> <Pine.LNX.4.64.0702081500190.8424@woody.linux-foundation.org>
            <Pine.LNX.4.64.0702090014020.14457@scrub.home>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1170988141_5832P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 08 Feb 2007 21:29:01 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1170988141_5832P
Content-Type: text/plain; charset=us-ascii

On Fri, 09 Feb 2007 00:20:49 +0100, Roman Zippel said:
> > The point is, neither $BASH nor /bin/bash may be set.
> 
> Is that really a problem? I think any system that has bash without 
> /bin/bash is simply broken.

If you're trying to bootstrap a Linux box onto a new platform from some
non-Linux Unixoid, it's possible that bash lives in $TOOLCHAIN/bin/bash.

But I see that even Solaris 9 has a bash 2.05 in /bin/bash, so I might be
talking out some odd orifice here.



--==_Exmh_1170988141_5832P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFFy9xtcC3lWbTT17ARArawAJ4wwYZdnK3ODsXcjRHBsbax1lwCTwCdF5DJ
f++XbMyO0pG3VAxQE0ctPKc=
=AuAy
-----END PGP SIGNATURE-----

--==_Exmh_1170988141_5832P--
