Return-Path: <linux-kernel-owner+w=401wt.eu-S1753741AbYIZM2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbYIZM2D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 08:28:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbYIZM1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 08:27:53 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:59782 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbYIZM1x (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 08:27:53 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Zachary Amsden <zach@vmware.com>, Alok Kataria <akataria@vmware.com>,
       Alok kataria <alokkataria1@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Yan Li <elliot.li.tech@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
       "rjmaomao@gmail.com" <rjmaomao@gmail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH 1/2] VMware detection support for x86 and x86-64
In-Reply-To: Your message of "Thu, 25 Sep 2008 15:27:41 PDT."
             <48DC105D.9050803@zytor.com>
From: Valdis.Kletnieks@vt.edu
References: <20080221115452.GB13948@elte.hu> <20080907234510.GA24133@yantp.cn.ibm.com> <20080908140423.GG11993@elte.hu> <35f686220809241928k3669e30bi8a98b440443c4bff@mail.gmail.com> <48DB15DB.8040501@zytor.com> <1222317978.23524.117.camel@alok-dev1> <48DB1984.8020704@zytor.com> <1222318928.23524.121.camel@alok-dev1> <48DB1BCE.2070106@zytor.com> <1222320201.23524.135.camel@alok-dev1> <1222375694.27056.179.camel@bodhitayantram.eng.vmware.com> <48DC09D9.7040204@zytor.com> <1222381254.27056.194.camel@bodhitayantram.eng.vmware.com>
            <48DC105D.9050803@zytor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1222432051_7097P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 26 Sep 2008 08:27:31 -0400
Message-ID: <34947.1222432051@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1222432051_7097P
Content-Type: text/plain; charset=us-ascii

On Thu, 25 Sep 2008 15:27:41 PDT, "H. Peter Anvin" said:
> Zachary Amsden wrote:
> > On Thu, 2008-09-25 at 14:59 -0700, H. Peter Anvin wrote:

> >> should have disappeared in the early 1990's, and it's really disturbing
> >> that virtualization vendors -- not just VMWare -- are, in effect,
> >> re-making all the mistakes hardware vendors did in the 1980's.
...
> This, of course, is what CPUID is for.

I remember from my old mainframe days that IBM actually got this right all the
way back in 1967 for the *first* product called VM - the 'Store CPUID'
instruction would give a specified result when executed on bare iron, but if
you did it inside a virtual machine running under CP-67 it would give a
documented different value that couldn't happen on bare iron.

So this mistake goes back a lot further than the 80s... :)



--==_Exmh_1222432051_7097P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFI3NUzcC3lWbTT17ARAiEmAJ40gQgzjEDUxbEjh0gvjQM2id0DFwCgtAyt
c2BFxmVEVWAzOQYKyI5+1wU=
=/9jf
-----END PGP SIGNATURE-----

--==_Exmh_1222432051_7097P--
