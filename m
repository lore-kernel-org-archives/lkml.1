Return-Path: <linux-kernel-owner+w=401wt.eu-S1764462AbXGJXky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764462AbXGJXky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 19:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764746AbXGJXki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 19:40:38 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:40732 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764677AbXGJXkh (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 19:40:37 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: ric@emc.com
Cc: Tejun Heo <htejun@gmail.com>, david@lang.hm,
       Stefan Bader <Stefan.Bader@de.ibm.com>, Phillip Susi <psusi@cfl.rr.com>,
       device-mapper development <dm-devel@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
In-Reply-To: Your message of "Tue, 10 Jul 2007 14:39:41 EDT."
             <4693D26D.2060004@emc.com>
From: Valdis.Kletnieks@vt.edu
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528094358.GM25091@agk.fab.redhat.com> <5201e28f0705290225v14fdac44hb0382a4137a84d01@mail.gmail.com> <20070529220500.GA6513@agk.fab.redhat.com> <5201e28f0705300212g3be16464u5ee1a4c80db27a11@mail.gmail.com> <465DAC72.1010201@cfl.rr.com> <5201e28f0705310414u1a9aebc4je135748274543946@mail.gmail.com> <465F9197.7060002@gmail.com> <Pine.LNX.4.64.0705312144400.6705@asgard.lang.hm> <465FC7B1.3060309@gmail.com>
            <4693D26D.2060004@emc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1184110800_3928P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 10 Jul 2007 19:40:00 -0400
Message-ID: <4758.1184110800@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1184110800_3928P
Content-Type: text/plain; charset=us-ascii

On Tue, 10 Jul 2007 14:39:41 EDT, Ric Wheeler said:

> All of the high end arrays have non-volatile cache (read, on power loss, it is a 
> promise that it will get all of your data out to permanent storage). You don't 
> need to ask this kind of array to drain the cache. In fact, it might just ignore 
> you if you send it that kind of request ;-)

OK, I'll bite - how does the kernel know whether the other end of that
fiberchannel cable is attached to a DMX-3 or to some no-name product that
may not have the same assurances?  Is there a "I'm a high-end array" bit
in the sense data that I'm unaware of?


--==_Exmh_1184110800_3928P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGlBjQcC3lWbTT17ARAtJEAJ95DJJCwua1aoiSFNbABZZW6QetWgCdHr4P
qLscDCXsML8C1ETMv0Rt91s=
=jSB6
-----END PGP SIGNATURE-----

--==_Exmh_1184110800_3928P--
