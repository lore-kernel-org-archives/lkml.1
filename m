Return-Path: <linux-kernel-owner+w=401wt.eu-S1423072AbXBBCTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423072AbXBBCTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 21:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030211AbXBBCTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 21:19:53 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:57893 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030196AbXBBCTw (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 21:19:52 -0500
Message-Id: <200702020219.l122J6aE005791@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Trent Waddington <trent.waddington@gmail.com>
Cc: Tomas Carnecky <tom@dbservice.com>, Jon Masters <jonathan@jonmasters.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] Ban module license tag string termination trick
In-Reply-To: Your message of "Fri, 02 Feb 2007 10:51:23 +1000."
             <3d57814d0702011651s5d5f9dafuc26369fab99ad5cf@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <Pine.LNX.4.61.0611011204140.23977@yvahk01.tjqt.qr> <Pine.LNX.4.61.0702012147470.1862@yvahk01.tjqt.qr> <45C2670F.5000003@jonmasters.org> <45C2832F.10603@dbservice.com>
            <3d57814d0702011651s5d5f9dafuc26369fab99ad5cf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1170382746_5349P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 01 Feb 2007 21:19:06 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1170382746_5349P
Content-Type: text/plain; charset=us-ascii

On Fri, 02 Feb 2007 10:51:23 +1000, Trent Waddington said:
> On 2/2/07, Tomas Carnecky <tom@dbservice.com> wrote:
> > Can't you put this somewhere into the documentation: it's our kernel,
> > play by our rules, and our rules are, the license is what is visible in
> > 'printf(license)'?
> 
> Here I was thinking the rules were: all modules must be GPL and the
> jerks who make proprietary modules are just blatantly breaking the
> law.  But you're right, the MODULE_LICENSE tag really does imply that
> licenses other than the GPL are ok.

Given that the definition of "derived work" in the software world is still
quite squishy and not firmed up, it's not at all clear that proprietary
modules are "blatantly" breaking the law.  In particular, feel free to
cite actual statute or case law that proves unequivocally that modules that
have a GPL shim that interface between the kernel and a binary blob are
breaking the law.

Hint: first you have to prove that the kernel API doesn't qualify as 'scenes
a faire' - a tough job when calling a function in any way but the one approved
one will cause an oops. ;)

--==_Exmh_1170382746_5349P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFFwp+acC3lWbTT17ARApkTAKD0uADAZdZpPRFftJK31uX9U3LgfQCg5dkj
CvX6j4e9ONDna0Z4op1CcX4=
=cnJK
-----END PGP SIGNATURE-----

--==_Exmh_1170382746_5349P--
