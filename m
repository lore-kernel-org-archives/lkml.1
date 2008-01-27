Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbYA0Hil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbYA0Hil (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 02:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbYA0Hib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 02:38:31 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:57518 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbYA0Hia (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 02:38:30 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Ingo Molnar <mingo@elte.hu>, "Giacomo A. Catenazzi" <cate@cateee.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: using LKML for subsystem development
In-Reply-To: Your message of "Sat, 26 Jan 2008 14:31:01 +0100."
             <479B3615.9000903@s5r6.in-berlin.de>
From: Valdis.Kletnieks@vt.edu
References: <alpine.LFD.1.00.0801241506500.15329@hp.linux-foundation.org> <4799A773.2030702@cateee.net> <22000.1201255093@turing-police.cc.vt.edu> <200801251258.08707.rjw@sisk.pl> <4799D770.2070203@cateee.net> <479A75D4.6070607@s5r6.in-berlin.de> <479A8203.40804@s5r6.in-berlin.de> <8125.1201318113@turing-police.cc.vt.edu>
            <479B3615.9000903@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1201419454_2859P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 27 Jan 2008 02:37:34 -0500
Message-ID: <15602.1201419454@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1201419454_2859P
Content-Type: text/plain; charset=us-ascii

On Sat, 26 Jan 2008 14:31:01 +0100, Stefan Richter said:
> Does your laptop have for example chained sg lists?  :-)

Beats me - I don't see it on an 'lspci' ;)  But I'm pretty sure it doesn't
have a 'powerpc' in it, so those threads get *totally* skipped...

My point was "personal interest in the domain" may not be a great way to
tell if a given thread has a stability risk - but I suspect that for the vast
majority of testers like myself who aren't paid to be kernel hackers, if it
isn't something they can trip over on the one or two machines they can easily
test on, it isn't code they're going to review....

(Note that it extends past just hardware too - my config has selinux in it,
so those threads at least *might* get looked at.  cpusets or ocfs2?  If I
read those threads, it's probably by accident... :)




--==_Exmh_1201419454_2859P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHnDS+cC3lWbTT17ARAiHPAJ9gcqJ3n5lT/DKc0MgaVJ1bjQ06GACgkpSX
5cgnhXIr84Y49NxlHNUeYWY=
=0s+n
-----END PGP SIGNATURE-----

--==_Exmh_1201419454_2859P--
