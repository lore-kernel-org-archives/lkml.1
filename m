Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbXGIVma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbXGIVma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 17:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbXGIVmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 17:42:23 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:33471 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265AbXGIVmW (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 17:42:22 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Dave Jones <davej@redhat.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Liunx power consumption on laptops -- Enormous progress in the last few months
In-Reply-To: Your message of "Fri, 06 Jul 2007 13:02:10 EDT."
             <20070706170210.GA11214@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <468D4D82.8030009@linux.intel.com> <468E6F0C.1090601@redhat.com> <468E6F4C.8000601@linux.intel.com>
            <20070706170210.GA11214@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1184017334_3383P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 09 Jul 2007 17:42:14 -0400
Message-ID: <9264.1184017334@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1184017334_3383P
Content-Type: text/plain; charset=us-ascii

On Fri, 06 Jul 2007 13:02:10 EDT, Dave Jones said:
> On Fri, Jul 06, 2007 at 09:35:24AM -0700, Arjan van de Ven wrote:
> 
>  > > Where is the ondemand-fix.patch? I can't find any link to it.
>  > 
>  > just click on it in the graph ;_
>  > 
>  > it's also http://www.linuxpowertop.org/patches/ondemand-fix.patch 
>  > (which is submitted already to the maintainers)
> 
> Should be in cpufreq.git (and thus, -mm) too, waiting for .23 to open up.

Somebody should fix http://ww.linuxpowertop.org/known.php then, it says:

"The kernels ondemand CPU frequency management function currently has a
high-frequency timer that samples to see if the CPU is idle. Intel fixed this
and the patches to the kernel to effectively remove this timer are included in
Linus' tree as of 2.6.22-rc1."

which confused me no end when I was looking at this stuff and wondering why
it was in the -mm tree if Linus already picked it up. :)

--==_Exmh_1184017334_3383P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGkqu2cC3lWbTT17ARAjcKAKC1Opn/Y8foWsNq/s+Zl1uX1L5JvwCeLdAx
Awip8PB74mAQPjwIMmgwKwU=
=8Bqz
-----END PGP SIGNATURE-----

--==_Exmh_1184017334_3383P--
