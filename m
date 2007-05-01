Return-Path: <linux-kernel-owner+w=401wt.eu-S1031697AbXEANKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031697AbXEANKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 09:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031698AbXEANKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 09:10:13 -0400
Received: from h80ad26a9.async.vt.edu ([128.173.38.169]:55228 "EHLO
	h80ad26a9.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031697AbXEANJo (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 09:09:44 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: Daniel Hazelton <dhazelton@enter.net>,
       Marat Buharov <marat.buharov@gmail.com>,
       Parav K Pandit <Parav_Pandit@mindtree.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: assembly code in the loadable kernel module
In-Reply-To: Your message of "Fri, 27 Apr 2007 17:06:48 EDT."
             <Pine.LNX.4.61.0704271658240.5071@chaos.analogic.com>
From: Valdis.Kletnieks@vt.edu
References: <2C15D00D262B7245B1D8D1799F04D88F052A6F42@mtw01ex01.mindtree.com> <Pine.LNX.4.61.0704270726080.3369@chaos.analogic.com> <698310e10704270457p7fce899ao16dee58b5e16869c@mail.gmail.com> <200704271212.07579.dhazelton@enter.net>
            <Pine.LNX.4.61.0704271658240.5071@chaos.analogic.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1178024914_28512P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 01 May 2007 09:08:34 -0400
Message-ID: <17221.1178024914@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1178024914_28512P
Content-Type: text/plain; charset=us-ascii

On Fri, 27 Apr 2007 17:06:48 EDT, "linux-os (Dick Johnson)" said:

>         if(strchr(buf, 'Z'-64) || strchr(buf, 'D'-64))

This probably isn't UTF-8 safe... :)

> Anything after ^D or ^Z doesn't get copied to the list. Something like
> this needs to be done because it's gonna get a whole lot worse because
> all the 'IT' people read the same rags -- so they think that "naked"
> email fails the "due diligence" test. Honest, I'm not making that up!

And here I thought blindly slapping that disclaimer on *everything*, whether
or not it actually called for it, failed "due diligence".  Ain't much diligence,
due or otherwise, in evidence when a "This contains confidential" sticker
gets posted to a worldwide public mailing list...

--==_Exmh_1178024914_28512P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGNzvScC3lWbTT17ARAvNDAJ4+B1KvsjPhV7NzCiP2ittzcsb/SwCfTQuz
u8IZUOGzpATh7hP3wUz6FMc=
=krbe
-----END PGP SIGNATURE-----

--==_Exmh_1178024914_28512P--
