Return-Path: <linux-kernel-owner+w=401wt.eu-S1764345AbYEAQku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764345AbYEAQku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 12:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763951AbYEAQkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 12:40:36 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:40310 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763777AbYEAQkf (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 12:40:35 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
In-Reply-To: Your message of "Wed, 30 Apr 2008 14:52:44 PDT."
             <4818EA2C.2040507@zytor.com>
From: Valdis.Kletnieks@vt.edu
References: <20080429.190352.137408408.davem@davemloft.net> <200804302136.58005.rjw@sisk.pl> <20080430131537.1f7a0914.akpm@linux-foundation.org> <alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>
            <4818EA2C.2040507@zytor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1209659981_3191P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 01 May 2008 12:39:41 -0400
Message-ID: <4190.1209659981@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1209659981_3191P
Content-Type: text/plain; charset=us-ascii

On Wed, 30 Apr 2008 14:52:44 PDT, "H. Peter Anvin" said:

> This fragmentation is largely intentional, of course -- everyone can 
> pick a risk level appropriate for them -- but it does mean:
> 
> a) The lag for a patch to ride through the pipeline is pretty long.
> b) The section of people who are going to use the more aggressive trees 
> for "real work" testing is going to be small.

And another problem is that often, it's hard to get good "real work" coverage
over the whole tree.  I just discovered an apparent borkage somewhere in
the networking/wireless area that seems to have gotten into Linus's tree
somewhere between 24-rc8 and 24-final, just because I haven't beaten on
my wireless card in the last few weeks, so I didn't notice a regression in
'ip link show' related to the rfkill switch...


--==_Exmh_1209659981_3191P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIGfJNcC3lWbTT17ARAowXAKCjNkuAAtOT0qXfXZr0WFo3Dkh0zQCdHH/a
5mATrAX2tHU/vyuzdkRcUW4=
=VqiI
-----END PGP SIGNATURE-----

--==_Exmh_1209659981_3191P--
