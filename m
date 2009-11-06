Return-Path: <linux-kernel-owner+w=401wt.eu-S1759407AbZKFQFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759407AbZKFQFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 11:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758546AbZKFQFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 11:05:45 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:52550 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758189AbZKFQFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 11:05:44 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: nir.tzachar@gmail.com
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, zippel@linux-m68k.org, andi@firstfloor.org
Subject: Re: [PATCH] nconfig v5
In-Reply-To: Your message of "Fri, 06 Nov 2009 10:36:54 +0200."
             <1257496614-12052-1-git-send-email-nir.tzachar@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1257496614-12052-1-git-send-email-nir.tzachar@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1257523499_2875P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 06 Nov 2009 11:04:59 -0500
Message-ID: <4185.1257523499@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.14.107 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020202.4AF4492D.012B,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1257523499_2875P
Content-Type: text/plain; charset=us-ascii

On Fri, 06 Nov 2009 10:36:54 +0200, nir.tzachar@gmail.com said:
> Building on menuconfig, this patch implements a more modern look interface using
> ncurses and ncurses' satellite libraries (menu, panel, form).

What is the minimum release of ncurses needed?  Some of us silverbacks have
bad memories of twisty little mazes of ncurses releases, all incompatible. ;)

(Much less of an issue if we're only trying to build on Linux - but at least
in the semi-recent past we've supported doing a kernel build on non-Linux
boxes.  Did that get lopped out at some point, or do we need to worry about
what ncurses Solaris ships with?)

--==_Exmh_1257523499_2875P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK9EkrcC3lWbTT17ARAu8TAKDp+W2/NJzWADBeAjmqQEm65bOfYgCg330W
0NV+D86LCWRfAZba0FgYQfU=
=XBfP
-----END PGP SIGNATURE-----

--==_Exmh_1257523499_2875P--

