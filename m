Return-Path: <linux-kernel-owner+w=401wt.eu-S1756658AbZD0QPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbZD0QPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 12:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755073AbZD0QOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 12:14:54 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:38976 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbZD0QOy (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 12:14:54 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@linux.intel.com>,
       Huang Ying <ying.huang@intel.com>,
       Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: Re-implement MCE log ring buffer as per-CPU ring buffer
In-Reply-To: Your message of "Mon, 27 Apr 2009 07:44:13 PDT."
             <alpine.DEB.1.10.0904270738470.9296@makko.or.mcafeemobile.com>
From: Valdis.Kletnieks@vt.edu
References: <1240391484.6842.474.camel@yhuang-dev.sh.intel.com> <20090422092259.GC18226@elte.hu> <20090422101600.GL3226@erda.amd.com> <1240553210.6842.871.camel@yhuang-dev.sh.intel.com> <20090424100943.GJ27264@erda.amd.com> <alpine.DEB.2.00.0904240935140.24293@gandalf.stny.rr.com> <1240818596.6842.1001.camel@yhuang-dev.sh.intel.com> <49F5646F.4000305@linux.intel.com> <alpine.DEB.2.00.0904271027580.24293@gandalf.stny.rr.com>
            <alpine.DEB.1.10.0904270738470.9296@makko.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1240848874_4302P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Apr 2009 12:14:34 -0400
Message-ID: <49036.1240848874@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1240848874_4302P
Content-Type: text/plain; charset=us-ascii

On Mon, 27 Apr 2009 07:44:13 PDT, Davide Libenzi said:

> IANAL, but what is the point of it? If that's for OSS IP protection 
> against Evil Corporate claims, isn't the only fact that you posted the 
> code and algorirthm, constitutes Prior Art, that would automatically 
> protect your contribution from future claims?

The general idea is that if some Big-Linux-Hating-Company comes to you and says
"You're infringing our patent #XXZZZY in this module", you want to be able pull
out a sheet of paper and say "Yes, and you've shipped 45,348,917 copies of
FooBar Release 7, that infringes on *our* patent #YYXXZ.  You probably owe
us more money than we owe you.  But we'll let you walk out the door and
never mention it again."

If you're old enough to remember the Cold War, it was called Mutually
Assured Destruction back then. ;)


--==_Exmh_1240848874_4302P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJ9dnqcC3lWbTT17ARApvaAKCw9H5ae7b79AKZzt41SntmqclAzACaA0yA
GO7jh8AjMyr/B+iWVtu34UM=
=I5fH
-----END PGP SIGNATURE-----

--==_Exmh_1240848874_4302P--
