Return-Path: <linux-kernel-owner+w=401wt.eu-S1757856AbYAYRUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856AbYAYRUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 12:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755066AbYAYRUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 12:20:35 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:58245 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782AbYAYRUf (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 12:20:35 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Tobias Winter <tobias@linuxdingsda.de>, linux-kernel@vger.kernel.org
Subject: Re: [resolved] kernel bug report 2.6.24-rc8 on core2quad q6600 with debian unstable amd64
In-Reply-To: Your message of "Fri, 25 Jan 2008 09:25:59 EST."
             <20080125142559.GJ16171@csclub.uwaterloo.ca>
From: Valdis.Kletnieks@vt.edu
References: <4797D86B.3060202@linuxdingsda.de> <20080123170748.36068472@deepthought> <20080124144547.GB16173@csclub.uwaterloo.ca> <4799B732.2030907@linuxdingsda.de>
            <20080125142559.GJ16171@csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1201281630_2846P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 25 Jan 2008 12:20:30 -0500
Message-ID: <10703.1201281630@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1201281630_2846P
Content-Type: text/plain; charset=us-ascii

On Fri, 25 Jan 2008 09:25:59 EST, Lennart Sorensen said:

> Personally I just don't bother with memtest anymore.  The only thing it
> tells you is that you have errors or that you might have errors but it
> didn't find them.  It never tells you that you do not have errors and it
> often does miss that you have errors since marginal memory is more
> likely to fail under cpu load it seems which memtest doesn't do.

It's been quite some time since I've gone the "run memtest for 24 hours" route.

However, I still recommend that for odd cases, you let memtest make *one* cycle
through its tests - that's only an hour-ish, and if it hits something, then
you *know* you have some hardware issues to deal with.

--==_Exmh_1201281630_2846P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHmhpecC3lWbTT17ARAr1kAKC+8rLp5R79dYNySRpAMGuMyhowJwCcCDtX
9niV5cOQBcDhbfi3J+UIpVY=
=2ufD
-----END PGP SIGNATURE-----

--==_Exmh_1201281630_2846P--
