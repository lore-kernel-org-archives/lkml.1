Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbXHSUOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbXHSUOX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 16:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbXHSUOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 16:14:15 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:55166 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386AbXHSUOP (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 16:14:15 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Marc Perkel <mperkel@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: The vi editor causes brain damage
In-Reply-To: Your message of "Sat, 18 Aug 2007 22:20:34 PDT."
             <964583.28477.qm@web52504.mail.re2.yahoo.com>
From: Valdis.Kletnieks@vt.edu
References: <964583.28477.qm@web52504.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1187554454_3025P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 19 Aug 2007 16:14:14 -0400
Message-ID: <15512.1187554454@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1187554454_3025P
Content-Type: text/plain; charset=us-ascii

On Sat, 18 Aug 2007 22:20:34 PDT, Marc Perkel said:
> Let me give you and example of the difference between
> Linux open source world brain damaged thinking and
> what it's like out here in the real world.
> 
> Go to a directory with 10k files and type:
> 
> rm *
> 
> What do you get?
> 
> /bin/rm: Argument list too long

Given that you don't even understand that this message is issued by the
*shell* and not /bin/rm, and *why* it issues that sort of error message
when an argument string expands to be bigger than MAX_ARGV, and the fact
that there are extant patches to increase that to essentially any reasonable
size, why should we listen to you when you proclaim that you have any sort
of enlightenment about systems design?


--==_Exmh_1187554454_3025P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGyKSWcC3lWbTT17ARAnITAKCXc8p4SxeM3cEAwd/BXb25/LAF1wCgt5Wo
vnHx42B6sfvE7U6diFSNM84=
=6vmy
-----END PGP SIGNATURE-----

--==_Exmh_1187554454_3025P--
