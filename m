Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbYEWRTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbYEWRTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 13:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbYEWRTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 13:19:24 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:56936 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbYEWRTY (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 13:19:24 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: cpw@sgi.com (Cliff Wickman)
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] use of /sys versus /proc
In-Reply-To: Your message of "Fri, 23 May 2008 08:12:55 CDT."
             <20080523131255.C19831F0380@attica.americas.sgi.com>
From: Valdis.Kletnieks@vt.edu
References: <20080523131255.C19831F0380@attica.americas.sgi.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1211563160_2938P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 23 May 2008 13:19:20 -0400
Message-ID: <23175.1211563160@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1211563160_2938P
Content-Type: text/plain; charset=us-ascii

On Fri, 23 May 2008 08:12:55 CDT, Cliff Wickman said:
> 
> I have a need to display TLB shootdown statistics.  (I'm working
> on a patch to implement this on a new machine at SGI.)
> 
> I had planned to display these statistics through /proc
> as in arch/ia64/sn/kernel/sn2/sn2_smp.c (/proc/sgi_sn/ptc_statistics).
> 
> However, considering the general move to reserve /proc for
> process-related things, I thought the community might prefer the
> interface to be in /sys.

Is debugfs an option?

--==_Exmh_1211563160_2938P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFINvyYcC3lWbTT17ARAu+lAKCHFr585F7QOeadwBIanq+R37RwRwCdEaJy
tRlRbpVZCpG1qDwB1Xizvx0=
=M1u5
-----END PGP SIGNATURE-----

--==_Exmh_1211563160_2938P--
