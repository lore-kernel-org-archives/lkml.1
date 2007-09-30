Return-Path: <linux-kernel-owner+w=401wt.eu-S1755800AbXI3CYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbXI3CYR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 22:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbXI3CYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 22:24:11 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:38649 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbXI3CYK (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 22:24:10 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 0/3 coding standards documentation/code updates
In-Reply-To: Your message of "Sat, 29 Sep 2007 11:18:05 PDT."
             <alpine.LFD.0.999.0709291116180.3579@woody.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <11910151223214-git-send-email-ezk@cs.sunysb.edu>
            <alpine.LFD.0.999.0709291116180.3579@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1191119041_2993P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 29 Sep 2007 22:24:01 -0400
Message-ID: <18163.1191119041@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1191119041_2993P
Content-Type: text/plain; charset=us-ascii

On Sat, 29 Sep 2007 11:18:05 PDT, Linus Torvalds said:

> "CodingStyle" should be about the big issues, not about details. Yes, 
> we've messed that up over the years, but let's not continue that.
> 
> In other words, I'd suggest *removing* lines from CodingStyle, not adding 
> them. The file has already gone from a "good general principles" to "lots 
> of stupid details". Let's not make it worse.

I think there needs to be a "sense of fairness" attached here - CodingStyle
should cover all the stuff maintainers/reviewers are allowed to whinge about.
Otherwise, we get maintainers whinging about undocumented style rules, and
we get code submitters who are unhappy because they have no real way to tell
if their code really *is* stylistically lacking, or if they just have a
jerk maintainer who wants to keep their code out-of-tree for political
reasons.


--==_Exmh_1191119041_2993P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG/wjBcC3lWbTT17ARAuvPAKDPvwDe1tJnQQXK9D8RLZZ7YGuMdACg7A4E
8E6JdKgaHfq1V1kRmOFzDto=
=wSqA
-----END PGP SIGNATURE-----

--==_Exmh_1191119041_2993P--
