Return-Path: <linux-kernel-owner+w=401wt.eu-S965710AbXIGRLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965710AbXIGRLy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 13:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965431AbXIGRLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 13:11:46 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:58297 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965427AbXIGRLq (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 13:11:46 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Theodore Tso <tytso@mit.edu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/6] Linux Kernel Markers - Architecture Independent Code
In-Reply-To: Your message of "Fri, 07 Sep 2007 12:04:45 EDT."
             <20070907160445.GB8911@thunk.org>
From: Valdis.Kletnieks@vt.edu
References: <20070906200733.194442762@polymtl.ca> <20070906200825.893834634@polymtl.ca> <20070906160001.cfe48d78.randy.dunlap@oracle.com> <20070906160429.629c9497.akpm@linux-foundation.org> <20070906163737.9cc91307.randy.dunlap@oracle.com>
            <20070907160445.GB8911@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1189185054_6579P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 07 Sep 2007 13:10:54 -0400
Message-ID: <6791.1189185054@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1189185054_6579P
Content-Type: text/plain; charset=us-ascii

On Fri, 07 Sep 2007 12:04:45 EDT, Theodore Tso said:
> This was proposed by Andrew and discussed at the Kernel Summit; the
> basic idea is that it is a formal indication that the person has done
> a *full* review of the patch (a few random comments from the local
> whitespace police don't count),

Anybody got a proposed scheme for the case where somebody like myself
who is *not* a member of the Maintainer Cabal has looked at a patch, and
found a valid show-stopper that's bigger than just whitespace (breaks on
64-bit, locking issues, etc), or other commentary that *should* be addressed
before it gets merged?  I'd like *some* way to tag a patch with "I had an
issue with V1, but the author addressed it to my satisfaction in V2"....

(Note that includes "the author convinced me the patch was right and I was
wrong"...)

--==_Exmh_1189185054_6579P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG4YYecC3lWbTT17ARAvWIAJ4/rMZwAx+D+4eP7AzoO/3Sfli20QCZAWRw
+CweplZatvGS+L1u/R10tuQ=
=ttFp
-----END PGP SIGNATURE-----

--==_Exmh_1189185054_6579P--
