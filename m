Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbXJTEry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbXJTEry (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 00:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbXJTErk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 00:47:40 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:34077 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbXJTErj (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 00:47:39 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Al Boldi <a1426z@gawab.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Patrick McHardy <kaber@trash.net>,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFD] iptables: mangle table obsoletes filter table
In-Reply-To: Your message of "Sat, 20 Oct 2007 06:40:02 +0300."
             <200710200640.02012.a1426z@gawab.com>
From: Valdis.Kletnieks@vt.edu
References: <200710120031.42805.a1426z@gawab.com> <47168EA1.1080300@tmr.com> <471699A0.3060303@tmr.com>
            <200710200640.02012.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1192855654_10241P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 20 Oct 2007 00:47:34 -0400
Message-ID: <26556.1192855654@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1192855654_10241P
Content-Type: text/plain; charset=us-ascii

On Sat, 20 Oct 2007 06:40:02 +0300, Al Boldi said:

> Sure, the idea was to mark the filter table obsolete as to make people start 
> using the mangle table to do their filtering for new setups.  The filter 
> table would then still be available for legacy/special setups.  But this 
> would only be possible if we at least ported the REJECT target to mangle.

That's *half* the battle.  The other half is explaining why I should move
from a perfectly functional setup that uses the filter table.  What gains
do I get from doing so?  What isn't working that I don't know about? etc?

In other words - why do I want to move from filter to mangle?

--==_Exmh_1192855654_10241P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHGYhmcC3lWbTT17ARAlHPAJ9Y5sobdaOgDr3R6HkxXlgQwUXjXwCg5alK
uWct6eF1gvoGsHBzKTOGrU0=
=kaN6
-----END PGP SIGNATURE-----

--==_Exmh_1192855654_10241P--
