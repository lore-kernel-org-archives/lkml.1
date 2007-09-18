Return-Path: <linux-kernel-owner+w=401wt.eu-S1760140AbXIRVg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760140AbXIRVg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 17:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755538AbXIRVgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 17:36:09 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:59197 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbXIRVgH (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 17:36:07 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Miles Lane <miles.lane@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: What can be done to reduce the huge number of build fixes required to release an MM tree?
In-Reply-To: Your message of "Tue, 18 Sep 2007 08:23:38 EDT."
             <a44ae5cd0709180523p646024b1u43269816e5328c9f@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <a44ae5cd0709180523p646024b1u43269816e5328c9f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1190151354_4811P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 18 Sep 2007 17:35:54 -0400
Message-ID: <14112.1190151354@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1190151354_4811P
Content-Type: text/plain; charset=us-ascii

On Tue, 18 Sep 2007 08:23:38 EDT, Miles Lane said:

> and once in while causes trouble?  And 3) Who is causing the most
> cumulative trouble?

Umm... Andrew's Vaio and my Latitude? :)

Seriously though - one big chunk of the problem is almost certainly that Andrew
and I run with .config's and hardware that differ drastically from what the
various maintainers test against, and the rest is that Andrew pulls git trees
that may or may not be ready for prime time.  Not sure if there's any practical
way to "fix" that without adding so much administrivia overhead to render the
whole -mm tree useless as a a preview/early-warning system....


--==_Exmh_1190151354_4811P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG8ES6cC3lWbTT17ARAma3AKC/eO1JmWetYcIHFuPowg/+0qjtNQCeJECS
ijjb/RrXZz8fjiTRdODBOOQ=
=x5ZG
-----END PGP SIGNATURE-----

--==_Exmh_1190151354_4811P--
