Return-Path: <linux-kernel-owner+w=401wt.eu-S1750999AbZLSFdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750999AbZLSFdc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 00:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbZLSFdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 00:33:31 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:55440 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbZLSFda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 00:33:30 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Sage Weil <sage@newdream.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Ceph distributed file system client for 2.6.33
In-Reply-To: Your message of "Fri, 18 Dec 2009 12:54:02 PST."
             <Pine.LNX.4.64.0912181140370.26094@cobra.newdream.net>
From: Valdis.Kletnieks@vt.edu
References: <Pine.LNX.4.64.0912071511470.32397@cobra.newdream.net>
            <Pine.LNX.4.64.0912181140370.26094@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1261200797_3855P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 19 Dec 2009 00:33:17 -0500
Message-ID: <14397.1261200797@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=zidane.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020204.4B2C659F.0079,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1261200797_3855P
Content-Type: text/plain; charset=us-ascii

On Fri, 18 Dec 2009 12:54:02 PST, Sage Weil said:
> I would still like to see ceph merged for 2.6.33.  It's certainly not 
> production ready, but it would be greatly beneficial to be in mainline for 
> the same reasons other file systems like btrfs and exofs were merged 
> early.

Is the on-the-wire protocol believed to be correct, complete, and stable? How
about any userspace APIs and on-disk formats? In other words..

> > The git tree includes the full patchset posted in October and incremental
> > changes since then.  I've tried to cram in all the anticipated protocol
> > changes, but the file system is still strictly EXPERIMENTAL and is marked

Anything left dangling on the changes?

--==_Exmh_1261200797_3855P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLLGWdcC3lWbTT17ARAgDgAKD92sdfp2Q4T6ucKJyVthh0gJ26fQCgvvMb
JSVxggXzOMQn42BaiIFX++U=
=wkjY
-----END PGP SIGNATURE-----

--==_Exmh_1261200797_3855P--

