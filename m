Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbYAZDUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbYAZDUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 22:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbYAZDUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 22:20:07 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:43357 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbYAZDUG (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 22:20:06 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "Giacomo A. Catenazzi" <cate@cateee.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 2.6.24
In-Reply-To: Your message of "Sat, 26 Jan 2008 00:50:44 +0100."
             <479A75D4.6070607@s5r6.in-berlin.de>
From: Valdis.Kletnieks@vt.edu
References: <alpine.LFD.1.00.0801241506500.15329@hp.linux-foundation.org> <4799A773.2030702@cateee.net> <22000.1201255093@turing-police.cc.vt.edu> <200801251258.08707.rjw@sisk.pl> <4799D770.2070203@cateee.net>
            <479A75D4.6070607@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1201317556_2846P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 25 Jan 2008 22:19:16 -0500
Message-ID: <7766.1201317556@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1201317556_2846P
Content-Type: text/plain; charset=us-ascii

On Sat, 26 Jan 2008 00:50:44 +0100, Stefan Richter said:
> How often is "bisectability" being broken already before merge in
> subsystem trees, and how often only in the context of the merge result?

I don't bisect git trees often - but I'd say that at least half the time
I have to bisect -mm, I'll hit a busticated bisection point and need to
move several one way or another.  Fortunately, Andrew does a good job
of keeping fixes near their parents, so it's usually not *that* hard to
clean up (at least for me - but I recently realized that I had passed the
3-decade mark of breaking and fixing software).  Newcomer kernel testers
are likely in for a rude awakening if they hit one of those points.


--==_Exmh_1201317556_2846P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHmqa0cC3lWbTT17ARAl0SAKCIwhQSmrj4a+4umT88W2tlCE+wEgCggpmT
P5FVqk2jBRTLC/jcVWoozYc=
=QEBU
-----END PGP SIGNATURE-----

--==_Exmh_1201317556_2846P--
