Return-Path: <linux-kernel-owner+w=401wt.eu-S1760737AbXGMVLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760737AbXGMVLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 17:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754422AbXGMVLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 17:11:35 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:43740 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbXGMVLd (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 17:11:33 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Rob Landley <rob@landley.net>, leoli@freescale.com,
       Gerrit Huizenga <gh@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Kunai, Takashi" <kunai@linux-foundation.jp>,
       holzheu@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       mtk-manpages@gmx.net, jack@suse.cz, randy.dunlap@oracle.com,
       gregkh@suse.de, pavel@ucw.cz, tim.bird@am.sony.com, arjan@infradead.org,
       sam@ravnborg.org, jengelh@computergmbh.de, joe@perches.com,
       auke-jan.h.kok@intel.com, hansendc@us.ibm.com, davem@davemloft.net,
       kenistoj@us.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       linux-doc@vger.kernel.org
Subject: Re: Documentation of kernel messages (Summary)
In-Reply-To: Your message of "Fri, 13 Jul 2007 15:25:49 +0200."
             <46977D5D.6050002@s5r6.in-berlin.de>
From: Valdis.Kletnieks@vt.edu
References: <E1I7wsz-0007oJ-DE@w-gerrit.beaverton.ibm.com> <200707101212.38981.rob@landley.net> <1184163990.23373.46.camel@Gundam> <200707111413.03513.rob@landley.net> <20070711213234.GE19456@thunk.org> <20070713115321.23e3544f@the-village.bc.nu>
            <46977D5D.6050002@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1184361017_3376P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 13 Jul 2007 17:10:17 -0400
Message-ID: <9290.1184361017@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1184361017_3376P
Content-Type: text/plain; charset=us-ascii

On Fri, 13 Jul 2007 15:25:49 +0200, Stefan Richter said:
> Alan Cox wrote:
> > The English versions need a last updated too, that way we would know when
> > they are past their best before date (as most of them are)
> 
> I've got the impression that whenever I saw a "last updated:" note in a
> documentation, this note was out of date.

RCS and SCCS let you stick stuff like $DATE and $VERSION into the source, so
it would be automagically replaced at checkin/checkout time.  Not sure how
well that would work across a mesh of 'git pull' and 'git push' across trees. :)

--==_Exmh_1184361017_3376P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGl+o5cC3lWbTT17ARArLUAJ9ONHKL7sDN3pZBqZ+Z54YzAUBFkQCfUJS+
8yXBIWrwMqMJyjsqjkJDDUA=
=BKKS
-----END PGP SIGNATURE-----

--==_Exmh_1184361017_3376P--
