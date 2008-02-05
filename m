Return-Path: <linux-kernel-owner+w=401wt.eu-S1761376AbYBEV0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761376AbYBEV0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:26:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758922AbYBEV0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:26:42 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:41035 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758806AbYBEV0l (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:26:41 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-mm1
In-Reply-To: Your message of "Tue, 05 Feb 2008 11:50:11 PST."
             <47A8BDF3.6080609@linux.intel.com>
From: Valdis.Kletnieks@vt.edu
References: <20080203171634.58ab668b.akpm@linux-foundation.org> <10779.1202230436@turing-police.cc.vt.edu> <47A89664.8020407@linux.intel.com> <3289.1202240894@turing-police.cc.vt.edu>
            <47A8BDF3.6080609@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1202246727_3253P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 05 Feb 2008 16:25:27 -0500
Message-ID: <9255.1202246727@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1202246727_3253P
Content-Type: text/plain; charset=us-ascii

On Tue, 05 Feb 2008 11:50:11 PST, Arjan van de Ven said:
> > A bugfix?
> 
> yes it was a really painful bugfix, but still.

I'm not saying that it wasn't needed, it *was* a busticated API.

> I'll repeat the question. What would waiting for an -mm release have bought for this bugfix?
> Answer: nothing more than what was done on Linus git.

Just wondering what happened to the "large changes should percolate in -mm
for a bit beforehand" concept.  We've seen a lot of patchsets that totalled
up to a *lot* less intrusiveness get pushed off with "This needs to cook in
-mm for a while".  


--==_Exmh_1202246727_3253P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD4DBQFHqNRHcC3lWbTT17ARAgA6AKCvBbnhHjMoc0JVGyBwviY6ubQgrACY9D0Z
7gJ5KwQNLB6ZYo8BqNkBWw==
=abiS
-----END PGP SIGNATURE-----

--==_Exmh_1202246727_3253P--
