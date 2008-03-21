Return-Path: <linux-kernel-owner+w=401wt.eu-S1761390AbYCUUGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761390AbYCUUGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 16:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbYCUUGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 16:06:11 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:55392 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbYCUUGK (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 16:06:10 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc3-mm1 - BUG at system shutdown time
In-Reply-To: Your message of "Fri, 21 Mar 2008 20:58:13 BST."
             <20080321195813.GC16179@elte.hu>
From: Valdis.Kletnieks@vt.edu
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org> <10815.1204862325@turing-police.cc.vt.edu> <20080312003227.a94580e8.akpm@linux-foundation.org> <4351.1205374751@turing-police.cc.vt.edu> <20080321134128.GO27245@elte.hu> <3343.1206128318@turing-police.cc.vt.edu>
            <20080321195813.GC16179@elte.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1206129958_3948P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 21 Mar 2008 16:05:58 -0400
Message-ID: <4945.1206129958@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1206129958_3948P
Content-Type: text/plain; charset=us-ascii

On Fri, 21 Mar 2008 20:58:13 BST, Ingo Molnar said:

> no, we frequently regenerate the x86.git tree so the dates have little 
> relevance. If for any particular pull, x86/base is good and x86/latest 
> is bad, then the bug is somewhere in those 200-300 patches inbetween. 
> They are lined up linearly so should be perfectly bisectable.

OK, off to go try the last few bisects then...



--==_Exmh_1206129958_3948P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFH5BUmcC3lWbTT17ARAmBkAKDCa2gMC1Rr2E0HLsSFMekr2pSfWgCgwGod
XhbWreCoOVboaa5mW1phwwM=
=SCow
-----END PGP SIGNATURE-----

--==_Exmh_1206129958_3948P--
