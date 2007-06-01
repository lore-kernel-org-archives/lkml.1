Return-Path: <linux-kernel-owner+w=401wt.eu-S1762105AbXFARou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762105AbXFARou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 13:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760951AbXFARom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 13:44:42 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:53362 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760351AbXFARom (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 13:44:42 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Pavel Machek <pavel@ucw.cz>
Cc: David Wagner <daw-usenet@taverner.cs.berkeley.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
In-Reply-To: Your message of "Thu, 24 May 2007 14:47:27 -0000."
             <20070524144726.GB3920@ucw.cz>
From: Valdis.Kletnieks@vt.edu
References: <653438.15244.qm@web36612.mail.mud.yahoo.com> <20070529144518.GD5840@ucw.cz> <Pine.LNX.4.64.0705291622430.31474@asgard.lang.hm> <20070529233041.GC24200@elf.ucw.cz> <f3il25$pcp$1@taverner.cs.berkeley.edu>
            <20070524144726.GB3920@ucw.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1180719875_9513P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 01 Jun 2007 13:44:35 -0400
Message-ID: <12508.1180719875@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1180719875_9513P
Content-Type: text/plain; charset=us-ascii

On Thu, 24 May 2007 14:47:27 -0000, Pavel Machek said:
> Yes, if there's significantly more remote bad guys than local bad
> guys, and if remote bad guys can't just get some local user first, AA
> still has some value.

Experience over on the Windows side of the fence indicates that "remote bad
guys get some local user first" is a *MAJOR* part of the current real-world
threat model - the vast majority of successful attacks on end-user boxes these
days start off with either "Get user to (click on link|open attachment)" or
"Subvert the path to a website (either by hacking the real site or hijacking
the DNS) and deliver a drive-by fruiting when the user visits the page".



--==_Exmh_1180719875_9513P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGYFsDcC3lWbTT17ARAm35AJ40EWmi/u2D+fHvxgEYS2gYTEE71ACgqRHJ
A/v1dKXCJ8P1KQq0CoZ3T2k=
=exTf
-----END PGP SIGNATURE-----

--==_Exmh_1180719875_9513P--
