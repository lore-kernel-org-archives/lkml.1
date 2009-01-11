Return-Path: <linux-kernel-owner+w=401wt.eu-S1752587AbZAKGgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbZAKGgo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 01:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbZAKGgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 01:36:33 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:47294 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbZAKGgd (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 01:36:33 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>,
       Ingo Molnar <mingo@elte.hu>, David Brown <lkml@davidb.org>,
       Phil Oester <kernel@linuxace.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
In-Reply-To: Your message of "Sat, 10 Jan 2009 10:30:23 PST."
             <alpine.LFD.2.00.0901101015290.6528@localhost.localdomain>
From: Valdis.Kletnieks@vt.edu
References: <E1LKy3v-0003KO-Nx@dylan.lougher.demon.co.uk> <20090108165029.GA10951@infradead.org> <20090108175338.2abbee16.akpm@linux-foundation.org> <4966B24E.1050700@lougher.demon.co.uk> <ac3eb2510901081824g38abc47g4619e80ffaf8f1c5@mail.gmail.com> <20090109023629.GA29520@linuxace.com> <20090109165422.GF24884@logfs.org> <20090109193738.GA9827@linode.davidb.org> <20090109211937.GA14342@logfs.org> <20090110124335.GB30744@elte.hu> <20090110165033.GA23943@logfs.org> <20090110101235.7ca24c44.akpm@linux-foundation.org>
            <alpine.LFD.2.00.0901101015290.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1231655763_4078P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 11 Jan 2009 01:36:03 -0500
Message-ID: <20704.1231655763@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1231655763_4078P
Content-Type: text/plain; charset=us-ascii

On Sat, 10 Jan 2009 10:30:23 PST, Linus Torvalds said:

> I think squashfs usage would be similar - you'd not have squashfs as a 
> standalone media, it would be a "installation medium" thing.

Actually, for some of us, squashfs would *usually* be a standalone - my biggest
application for it is when I end up having to can-opener some wonky install
medium that one of my users is having a problem with.  And of course, I
have to use some *other* kernel/system to do the can-opener trick with, because
if the one on the medium worked, the user wouldn't be standing in my office :)

Fortunately, that usually means I'm using a recent -mm kernel on my laptop,
and the kernel/medium I'm trying to debug is almost always older, so I don't
have to worry much about a too-new medium.  Anybody comes in my office with
something even more bleeding edge than what I have, I damn well expect them
to be able to debug the issue themselves. ;)

--==_Exmh_1231655763_4078P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJaZNTcC3lWbTT17ARAq09AKCHuh2sh9/8iZPSlSvPL+3GXnsgTQCg+N3y
5kfkpcV53uHkCl/tL/BS+jI=
=ghPN
-----END PGP SIGNATURE-----

--==_Exmh_1231655763_4078P--
