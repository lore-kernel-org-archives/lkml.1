Return-Path: <linux-kernel-owner+w=401wt.eu-S1761955AbYBTDpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761955AbYBTDpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 22:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096AbYBTDpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 22:45:38 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:41687 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbYBTDph (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 22:45:37 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Karl Dahlke <eklhad@comcast.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Where to put adapters, /proc is cool
In-Reply-To: Your message of "Tue, 19 Feb 2008 14:39:45 EST."
             <20080119143945.eklhad@comcast.net>
From: Valdis.Kletnieks@vt.edu
References: <20080119143945.eklhad@comcast.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1203479134_762P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 19 Feb 2008 22:45:34 -0500
Message-ID: <4951.1203479134@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1203479134_762P
Content-Type: text/plain; charset=us-ascii

On Tue, 19 Feb 2008 14:39:45 EST, Karl Dahlke said:

> Really, /proc is the only place for these virtual files that interact
> directly with the kernel and/or its modules;
> I just wanted a fixed place under /proc for adapters to live,
> like sys ttys scsi net, and so on.

There's an awful lot of stuff under /dev for virtual files and similar.
For starters, look at /dev/null, /dev/kmsg, all the dm/md stuff in /dev/mapper,
all the PTY stuff.... etc etc...

--==_Exmh_1203479134_762P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHu6JecC3lWbTT17ARAmgLAJ0bZ2wx6H05VyLRz2qu7KbHpDDaIQCfaZNy
q4fTC0ZrTb1BoM1kjifH0HM=
=9UFu
-----END PGP SIGNATURE-----

--==_Exmh_1203479134_762P--
