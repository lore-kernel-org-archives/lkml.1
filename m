Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbXISF6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbXISF6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 01:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbXISF6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 01:58:39 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:33102 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbXISF6i (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 01:58:38 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Combine instrumentation menus in kernel/Kconfig.instrumentation
In-Reply-To: Your message of "Tue, 18 Sep 2007 21:06:28 EDT."
             <20070919010627.GA24174@Krystal>
From: Valdis.Kletnieks@vt.edu
References: <20070918211259.GA14927@Krystal> <14754.1190151939@turing-police.cc.vt.edu>
            <20070919010627.GA24174@Krystal>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1190181478_4811P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 19 Sep 2007 01:57:58 -0400
Message-ID: <3956.1190181478@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1190181478_4811P
Content-Type: text/plain; charset=us-ascii

On Tue, 18 Sep 2007 21:06:28 EDT, Mathieu Desnoyers said:
 
> * Valdis.Kletnieks@vt.edu (Valdis.Kletnieks@vt.edu) wrote:
> > OK, I'll bite - given the mention of 'debugging' there, do we want to go for
> > broke and *also* suck in the 'Kernel Hacking' menu as well?
> 
> Instrumentation primarity aims at debugging user-space applications by
> giving the ability to extract information across execution layers, hence
> being a feature useful to users, not only kernel hackers.

Ahh.. Where I come from, "Instrumentation" includes *all* the code that doesn't
actually *do* the work, but exists solely so you can tell what the code is
doing - so almost everything on the i386/x86_64 "Kernel Hacking" menu counts
as "instrumentation" in my book.

Now if we're talking about the features provided by one specific *instance*
of instrumentation code, I can buy that too - but I think that help text
needs to be clear on what is included under "debugging"

(I'd settle for "If you're trying to debug the kernel itself, go see the
Kernel Hacking menu" or similar.. ;)

> to many, not only kernel developers. Please have a look at the
> papers (especially the OLS2007 paper) linked on http://ltt.polymtl.ca as a
> starting point if you are intereted in the question.

Ahh, LTT. *that* I recognize.  Yeah, I count that as *one flavor* of
instrumentation. :)


--==_Exmh_1190181478_4811P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG8LpmcC3lWbTT17ARAlGZAJ9I703zzUtT2NTnZZ26FWPwugi9SACg8Q39
Bvg58hI+TXWqKDO4+BebrbI=
=u3GT
-----END PGP SIGNATURE-----

--==_Exmh_1190181478_4811P--
