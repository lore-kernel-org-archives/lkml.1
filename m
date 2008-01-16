Return-Path: <linux-kernel-owner+w=401wt.eu-S1752669AbYAPLbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbYAPLbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 06:31:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbYAPLbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 06:31:44 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:34644 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbYAPLbn (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 06:31:43 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: balbir@linux.vnet.ibm.com
Cc: Andrea Righi <righiandr@users.sourceforge.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] per-uid/gid I/O throttling (was Re: [RFC][PATCH] per-task I/O throttling)
In-Reply-To: Your message of "Wed, 16 Jan 2008 16:15:41 +0530."
             <20080116104541.GB25724@balbir.in.ibm.com>
From: Valdis.Kletnieks@vt.edu
References: <47869FFE.1050000@users.sourceforge.net> <661de9470801110759h318347acw5f08c91b48ca742d@mail.gmail.com> <47879A32.8060508@users.sourceforge.net> <3777.1200113861@turing-police.cc.vt.edu> <1200131197.7999.14.camel@lappy> <20080112105702.GC25388@balbir.in.ibm.com> <1200136245.7999.20.camel@lappy> <4789006C.2030804@users.sourceforge.net> <20080113044607.GA13633@balbir.in.ibm.com> <478CE41F.5010401@users.sourceforge.net>
            <20080116104541.GB25724@balbir.in.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1200483031_2966P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 16 Jan 2008 06:30:31 -0500
Message-ID: <13594.1200483031@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1200483031_2966P
Content-Type: text/plain; charset=us-ascii

On Wed, 16 Jan 2008 16:15:41 +0530, Balbir Singh said:

> Thanks for doing this. I am going to review the patches in greater
> detail and also test them. Why do you use configfs when we have a
> control group filesystem available for grouping tasks and providing a
> file system based interface for control and accounting?

And here I thought "There's more than one way to do it" was the Perl slogan. :)

An equally valid question would be: "Why are we carrying around a control
group filesystem when we have configfs?"  (Honestly, I didn't know we *were*
carrying around such a filesystem - and quite likely Andrea Righi didn't
either...)

--==_Exmh_1200483031_2966P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHjerXcC3lWbTT17ARAntkAKCPu9b8VlzBWuLyPrvf9y/FdbZLBwCeIa+X
sivo2BAT8rQke6HaxmQQW7I=
=Ul4v
-----END PGP SIGNATURE-----

--==_Exmh_1200483031_2966P--
