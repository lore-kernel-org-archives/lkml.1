Return-Path: <linux-kernel-owner+w=401wt.eu-S1754992AbZEEU5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbZEEU5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 16:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753772AbZEEU5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 16:57:35 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:39918 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbZEEU5e (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 16:57:34 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: David Newall <davidn@davidnewall.com>
Cc: Theodore Tso <tytso@mit.edu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Chris Friesen <cfriesen@nortel.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Matthew Wilcox <matthew@wil.cx>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, tridge@samba.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Christoph Hellwig <hch@infradead.org>,
       Steve French <smfrench@gmail.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, LKML <linux-kernel@vger.kernel.org>,
       Olivier Galibert <galibert@pobox.com>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
In-Reply-To: Your message of "Tue, 05 May 2009 20:39:05 +0930."
             <4A001E51.4070903@davidnewall.com>
From: Valdis.Kletnieks@vt.edu
References: <20090504124129.GL7141@linux.vnet.ibm.com> <20090504124433.GW8822@parisc-linux.org> <20090504130638.GN7141@linux.vnet.ibm.com> <20090504132119.GX8822@parisc-linux.org> <20090504143919.GA6740@linux.vnet.ibm.com> <20090504150834.GZ8822@parisc-linux.org> <1241451391.20170.12.camel@norville.austin.ibm.com> <m14ow0hnal.fsf@fess.ebiederm.org> <1241453259.20170.17.camel@norville.austin.ibm.com> <m1k54wal0j.fsf@fess.ebiederm.org> <20090504230357.GI6766@mit.edu>
            <4A001E51.4070903@davidnewall.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1241556990_96868P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 05 May 2009 16:56:30 -0400
Message-ID: <109151.1241556990@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1241556990_96868P
Content-Type: text/plain; charset=us-ascii

On Tue, 05 May 2009 20:39:05 +0930, David Newall said:

> Whether your patch goes in; whether it doesn't; it now seems there's
> something fishy about long filenames, and to be safe, perhaps it would
> be better to just turn off anything to do with FAT filesystems.  Who
> would care, right?  Unless i turns out that Linux no longer has the
> essential features.
> 
> Unless disrupting Linux was the point, and of course it isn't, it seems
> that full disclosure is required.  And that's before any patch should
> even be looked at.

Well, VFAT was in Windows for Workgroups 3.11 or so, back in 1982, and a patent
only runs 17 years.  So that clock's been ticking for quite some time.  Heck,
one could probably make a case that if Microsoft hasn't officially squawked
*yet* about code that infringes on anything that was released in '82, that
they've basically estoppell'd themselves.

Of course, some spoil-sport is going to come along and say that submarine
patents don't work that way. ;)



--==_Exmh_1241556990_96868P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKAKf+cC3lWbTT17ARAnb3AJ9xfeShW5wJGMuG8BMIEeqEmaqChACeIr0G
PT55JFxpP0DzBhf1RsBuohQ=
=ldZ2
-----END PGP SIGNATURE-----

--==_Exmh_1241556990_96868P--
