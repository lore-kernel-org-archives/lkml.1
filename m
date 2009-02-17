Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbZBQVCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbZBQVCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 16:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbZBQVCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 16:02:11 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:54293 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbZBQVCK (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 16:02:10 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mm-commits@vger.kernel.org
Subject: Re: mmotm 2009-02-14-00-49 uploaded -epoll busted.
In-Reply-To: Your message of "Tue, 17 Feb 2009 10:31:07 PST."
             <alpine.DEB.1.10.0902171023400.21510@alien.or.mcafeemobile.com>
From: Valdis.Kletnieks@vt.edu
References: <200902140851.n1E8pfIN030501@imap1.linux-foundation.org> <7379.1234881458@turing-police.cc.vt.edu>
            <alpine.DEB.1.10.0902171023400.21510@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1234904495_3892P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 17 Feb 2009 16:01:36 -0500
Message-ID: <4138.1234904496@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1234904495_3892P
Content-Type: text/plain; charset=us-ascii

On Tue, 17 Feb 2009 10:31:07 PST, Davide Libenzi said:

> Andrew, the patch below replaced the one you have under the name:
> 
> epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups.patch

I built a new -rc5-mmotm0214 with that patch replaced, and things are
working as designed again.  Glad you were able to figure out what the
problem was.

--==_Exmh_1234904495_3892P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJmyWvcC3lWbTT17ARAtNXAKDdhXuuutowszwsGU8/asMphMFQPACghXt0
5XPAIMwpGC3onc5xmpOOuM0=
=40Af
-----END PGP SIGNATURE-----

--==_Exmh_1234904495_3892P--
