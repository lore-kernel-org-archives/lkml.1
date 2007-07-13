Return-Path: <linux-kernel-owner+w=401wt.eu-S1763603AbXGMUNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763603AbXGMUNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 16:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757584AbXGMUNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 16:13:07 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:52439 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756765AbXGMUNG (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 16:13:06 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Mike Anderson <andmike@us.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>,
       Matt Mackall <mpm@selenic.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] Re: [2.6.23 PATCH 13/18] dm: netlink
In-Reply-To: Your message of "Thu, 12 Jul 2007 19:00:59 PDT."
             <20070713020059.GA5402@us.ibm.com>
From: Valdis.Kletnieks@vt.edu
References: <20070711210137.GE24114@agk.fab.redhat.com> <20070711142712.e646995b.akpm@linux-foundation.org> <20070712231920.GZ11166@waste.org> <20070712163115.ee686f8d.akpm@linux-foundation.org>
            <20070713020059.GA5402@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1184357578_3376P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 13 Jul 2007 16:12:58 -0400
Message-ID: <6408.1184357578@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1184357578_3376P
Content-Type: text/plain; charset=us-ascii

On Thu, 12 Jul 2007 19:00:59 PDT, Mike Anderson said:

> No, all admin tools and interfaces function as they do today. The
> dm-netlink patch series only contains 9 deletions (actual just one true
> deletion of existing kernel code the others are due to break up of the
> patch into compilable chunks). The intent was not to break users or force
> migration.

OK, I'll bite - if the admin tools function as before, who is *using* the
code?  Or do the admin tools have a preferred netlink component and a fallback
set of code if that fails?

--==_Exmh_1184357578_3376P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGl9zKcC3lWbTT17ARAn1TAJwK7uClY988U38VvooewVlui/+RpwCg3cJr
DTxUbQjXfXFwFebgArnL3KM=
=DJ4I
-----END PGP SIGNATURE-----

--==_Exmh_1184357578_3376P--
