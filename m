Return-Path: <linux-kernel-owner+w=401wt.eu-S946214AbXHMVEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S946214AbXHMVEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 17:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbXHMVDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 17:03:44 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:42030 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbXHMVDm (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 17:03:42 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Zan Lynx <zlynx@acm.org>
Cc: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org
Subject: Re: How to make -mm a more viable testbed (was: [PATCH] [1/12] x86: Work around mmio config space quirk on AMD)
In-Reply-To: Your message of "Mon, 13 Aug 2007 14:40:06 MDT."
             <1187037607.7855.21.camel@localhost>
From: Valdis.Kletnieks@vt.edu
References: <200708130808.46989.a1426z@gawab.com>
            <1187037607.7855.21.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1187039018_3175P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 13 Aug 2007 17:03:38 -0400
Message-ID: <29912.1187039018@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1187039018_3175P
Content-Type: text/plain; charset=us-ascii

On Mon, 13 Aug 2007 14:40:06 MDT, Zan Lynx said:

> I thought most people running -mm were running klive, which shou
> ld tell kernel versions, uptime and other things.  I run it, anyway.
> 
> http://klive.cpushare.com/

That page says there's a whole whopping 587 people reporting back, of which
1 is on 23-rc1-mm1, and 3 are on 23-rc2-mm2.

I know I'm on 23-rc2-mm1 at the moment (backed off from 23-rc2-mm2 due to
the sysctl breakage in iptables).  I certainly *hope* there's more than
5 people trying the -mm kernels, and I'm guessing that in fact, most -mm users
are *not* running klive.

--==_Exmh_1187039018_3175P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGwMcqcC3lWbTT17ARArvfAKDK1n8/zokA+XnyFZ33GxNOb9zYHACfZt7z
DWEGZ7cV/oPxZ5NceYesARY=
=+SBC
-----END PGP SIGNATURE-----

--==_Exmh_1187039018_3175P--
