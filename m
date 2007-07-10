Return-Path: <linux-kernel-owner+w=401wt.eu-S1760531AbXGJTkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760531AbXGJTkE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 15:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbXGJTjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 15:39:55 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:56867 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbXGJTjy (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 15:39:54 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22 released
In-Reply-To: Your message of "Sun, 08 Jul 2007 16:52:52 PDT."
             <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1184096391_3928P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 10 Jul 2007 15:39:51 -0400
Message-ID: <25865.1184096391@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1184096391_3928P
Content-Type: text/plain; charset=us-ascii

On Sun, 08 Jul 2007 16:52:52 PDT, Linus Torvalds said:

> The full changelog since 2.6.21 also got uploaded, but quite frankly, I 
> wonder if anybody uses those things? I've been uploading them for non-git 
> users, but I have a suspicion that any people who want that kind of 
> detail have long since learnt to use git, or are following the commit 
> mailing lists or equivalent. 

What the Rest Of The World could probably use is if some kind soul were to go
through and build a .21->.22 document that lists all the *userspace visible*
changes (new drivers, new filesystems/features, new/changed stuff in /sys and
/proc, new ioctls, new and changed Kconfig, etc).  Unfortunately, it's quite
probably not automagically creatable, so we'd need to find another Adrian Bunk
to do it (BTW, between cleanups and keeping track of regressions and so on,
Adrian is definitely a resource we're lucky to have - let's have a round of
applause and appreciation for all of Adrian's work.. :)

> Or do people really want the full logs, and don't use git?

I'm not really a git user (I have enough trouble keeping a -mm tree around in
an unbusticated state) - but the few times I've needed info from git, I've
gotten it from the git-web interface.  I think I've only looked at the
Changelogs once in the last 5 years, and it was because I was researching a
"When did feature XYZ go into the kernel?" for something that happened before
the bitkeeper and git days.

--==_Exmh_1184096391_3928P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGk+CHcC3lWbTT17ARAlxhAJ9un7tKa/a4skUHv3Qos8zT351RpwCgouT8
+AsDHlb+OXnFY6iXJ16vDJg=
=wwKU
-----END PGP SIGNATURE-----

--==_Exmh_1184096391_3928P--
