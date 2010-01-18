Return-Path: <linux-kernel-owner+w=401wt.eu-S1753110Ab0ARO1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab0ARO1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 09:27:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039Ab0ARO1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 09:27:16 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:57316 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab0ARO1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 09:27:15 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Greg Kroah-Hartman <greg@kroah.com>,
       Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HOWTO: Updates on subsystem trees, patchwork, -next (vs. -mm)
In-Reply-To: Your message of "Thu, 14 Jan 2010 23:39:46 +0100."
             <tkrat.e8ba67441fb65247@s5r6.in-berlin.de>
From: Valdis.Kletnieks@vt.edu
References: <4B4F7304.5050401@s5r6.in-berlin.de> <Pine.LNX.4.30.1001141303230.3979-100000@mail.perches.com>
            <tkrat.e8ba67441fb65247@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1263824779_6729P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 18 Jan 2010 09:26:19 -0500
Message-ID: <25759.1263824779@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=steiner.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020206.4B546F8C.011E,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1263824779_6729P
Content-Type: text/plain; charset=us-ascii

On Thu, 14 Jan 2010 23:39:46 +0100, Stefan Richter said:
> One of the roles which -mm fulfilled some time ago (to offer an
> integration testing ground) has been taken over by -next.  This is still
> news to Documentation/HOWTO, so mention it there.

> -2.6.x -mm kernel patches
> -------------------------
> -These are experimental kernel patches released by Andrew Morton.  Andrew
> -takes all of the different subsystem kernel trees and patches and mushes
> -them together, along with a lot of patches that have been plucked from
> -the linux-kernel mailing list.  This tree serves as a proving ground for
> -new features and patches.

Note that -mm serves other purposes than just integration testing. I'm not
sure that nuking *all* reference to it is appropriate.

On the other hand, I think there's like 3 other guys besides myself that
actually test -mm kernels, so maybe the best bet is to see if it makes it
upstream via the -mm route. ;)

--==_Exmh_1263824779_6729P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLVG+LcC3lWbTT17ARAtzsAKDYM0Ir+3cPeCCcYjJt90njvLk+mwCeM1D5
hj7UcMBhN9iNO9bsHu6GYSY=
=K6PO
-----END PGP SIGNATURE-----

--==_Exmh_1263824779_6729P--

