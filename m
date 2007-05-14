Return-Path: <linux-kernel-owner+w=401wt.eu-S1760048AbXENUNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760048AbXENUNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758351AbXENUMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:12:51 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:34072 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757703AbXENUMu (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:12:50 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: tglx@linutronix.de
Cc: Alistair John Strachan <s0348365@sms.ed.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86-64 highres/dyntick support 2.6.22-rc1-v1
In-Reply-To: Your message of "Mon, 14 May 2007 12:26:08 +0200."
             <1179138368.22481.334.camel@localhost.localdomain>
From: Valdis.Kletnieks@vt.edu
References: <1178485128.31213.98.camel@localhost.localdomain> <200705140217.11515.s0348365@sms.ed.ac.uk>
            <1179138368.22481.334.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1179173440_4398P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 14 May 2007 16:10:40 -0400
Message-ID: <10373.1179173440@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1179173440_4398P
Content-Type: text/plain; charset=us-ascii

On Mon, 14 May 2007 12:26:08 +0200, Thomas Gleixner said:

> Broken out version is available here:
> http://www.tglx.de/projects/hrtimers/2.6.22-rc1/linux-2.6.22-rc1-x86_64-highres-v1.patches.tar.bz2

How unhappy am I likely to be if I try to apply this to a 21-mm2 kernel? It
doesn't *look* like any of the patches are in -mm2 (at least not under the
same name).

--==_Exmh_1179173440_4398P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGSMJAcC3lWbTT17ARAjieAJ48EyLHWSVG+MTVMNwooY59/IcDMwCcCa0y
EOROqDnDM8ss3IEs45vgmD8=
=LKhP
-----END PGP SIGNATURE-----

--==_Exmh_1179173440_4398P--
