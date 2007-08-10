Return-Path: <linux-kernel-owner+w=401wt.eu-S1763747AbXHJRVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763747AbXHJRVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 13:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbXHJRVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 13:21:42 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:46807 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393AbXHJRVl (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 13:21:41 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Adrian Bunk <bunk@kernel.org>
Cc: Aurelien Jarno <aurelien@aurel32.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm2
In-Reply-To: Your message of "Fri, 10 Aug 2007 18:59:06 +0200."
             <20070810165906.GI18938@stusta.de>
From: Valdis.Kletnieks@vt.edu
References: <20070809224254.11f42716.akpm@linux-foundation.org> <20070810092334.GA15285@hall.aurel32.net> <26090.1186764049@turing-police.cc.vt.edu>
            <20070810165906.GI18938@stusta.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1186766481_6376P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 10 Aug 2007 13:21:21 -0400
Message-ID: <28698.1186766481@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1186766481_6376P
Content-Type: text/plain; charset=us-ascii

On Fri, 10 Aug 2007 18:59:06 +0200, Adrian Bunk said:

> It must be included on *all* architectures, and the architectures where 
> asm/page.h wasn't by chance already included indirectly included by some 
> other header don't compile.

Wow. So it happened to work by chance on *most* architectures (or at
least enough so Andrew shipped it)?  I wasn't expecting "MIPS was the
first one to correctly barf because the header wasn't included"... :)



--==_Exmh_1186766481_6376P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD4DBQFGvJ6RcC3lWbTT17ARAjkjAKCy6tnewkhzEu1Py/fbrzgeUY7TgQCY3yLo
d6pBp4ELT5dFB5i05/Bdng==
=HCRl
-----END PGP SIGNATURE-----

--==_Exmh_1186766481_6376P--
