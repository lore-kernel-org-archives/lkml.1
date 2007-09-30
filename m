Return-Path: <linux-kernel-owner+w=401wt.eu-S1756308AbXI3C0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308AbXI3C0b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 22:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbXI3C0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 22:26:24 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:38655 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbXI3C0Y (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 22:26:24 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc8-mm2
In-Reply-To: Your message of "Thu, 27 Sep 2007 02:22:20 PDT."
             <20070927022220.c76a7a6e.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1191119181_2993P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 29 Sep 2007 22:26:21 -0400
Message-ID: <18268.1191119181@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1191119181_2993P
Content-Type: text/plain; charset=us-ascii

On Thu, 27 Sep 2007 02:22:20 PDT, Andrew Morton said:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm2/

Locks up hard at very early boot on my Dell Latitude - grub says loading
kernel, the screen clears, and we lock up before we get penguins.

-rc8-mm1 was OK. I'm off to go bisect, figured I'd drop a heads-up.

--==_Exmh_1191119181_2993P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG/wlNcC3lWbTT17ARAhM5AKCo00FkSSbqn3DH9v5Xe9cZOin4lQCfbCYQ
fHuwfzxtTYdgpWi+YZFdAf8=
=kSWQ
-----END PGP SIGNATURE-----

--==_Exmh_1191119181_2993P--
