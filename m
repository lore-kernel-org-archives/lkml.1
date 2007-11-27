Return-Path: <linux-kernel-owner+w=401wt.eu-S1757918AbXK0FZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918AbXK0FZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 00:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751066AbXK0FZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 00:25:27 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:32904 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbXK0FZ1 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 00:25:27 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Patrick McHardy <kaber@trash.net>
Cc: kloczek@rudy.mif.pg.gda.pl, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.23.9
In-Reply-To: Your message of "Tue, 27 Nov 2007 02:39:08 +0100."
             <474B753C.7060303@trash.net>
From: Valdis.Kletnieks@vt.edu
References: <20071126180132.GA25230@kroah.com> <Pine.BSO.4.63.0711270211090.18832@rudy.mif.pg.gda.pl>
            <474B753C.7060303@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1196141091_2838P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 27 Nov 2007 00:24:51 -0500
Message-ID: <26193.1196141091@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1196141091_2838P
Content-Type: text/plain; charset=us-ascii

On Tue, 27 Nov 2007 02:39:08 +0100, Patrick McHardy said:
> Tomasz K wrote:
> > On Mon, 26 Nov 2007, Greg Kroah-Hartman wrote:
> > [..]
> >
> > Still there is no aroud officialy released iptables tarball with 
> > support for rules for new xt_{connlimit,time,u32} modules.
> > Anyone know where are patches for manage connlimit, time, u32 rules 
> > which will be included in next release ?
> 
> A well chosen thread to ask this question. xt_time is not even
> included in 2.6.23.
> 
> http://netfilter.org/news.html#2007-10-15

And I don't see any mention of connlimit, time, or u32 in the Changelog for that...

I admit I haven't peeked inside the actual tarball to see if they added stuff
and didn't Changelog it...

--==_Exmh_1196141091_2838P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHS6ojcC3lWbTT17ARAt8eAKCtK9OahAS8X80r0w8wLITDmGWX3wCgzSOb
GcWhxwsrf81+UC3nwkJlNbk=
=yM26
-----END PGP SIGNATURE-----

--==_Exmh_1196141091_2838P--
