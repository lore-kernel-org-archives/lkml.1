Return-Path: <linux-kernel-owner+w=401wt.eu-S1945902AbXBBIS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945902AbXBBIS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 03:18:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423197AbXBBIS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 03:18:29 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:43839 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423198AbXBBIS2 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 03:18:28 -0500
Message-Id: <200702020817.l128Hios030270@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jon Masters <jonathan@jonmasters.org>
Cc: Chris Rankin <rankincj@yahoo.com>, Mark Rustad <mrustad@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.18-stable release plans?
In-Reply-To: Your message of "Fri, 02 Feb 2007 01:47:38 EST."
             <45C2DE8A.7040201@jonmasters.org>
From: Valdis.Kletnieks@vt.edu
References: <999038.34946.qm@web52908.mail.yahoo.com> <200702020402.l12427em008810@turing-police.cc.vt.edu>
            <45C2DE8A.7040201@jonmasters.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1170404264_8768P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 02 Feb 2007 03:17:44 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1170404264_8768P
Content-Type: text/plain; charset=us-ascii

On Fri, 02 Feb 2007 01:47:38 EST, Jon Masters said:

> I must be weird or something, but I often think about this and the sheer 
> number of clock cycles executing at any one time around the world. Have 
> you ever stopped to think how many copies of schedule() (or whatever) 
> are currently running somewhere in the world? It's just nuts :-)

That's why we count single cycles in fast-path sections of code. :)

--==_Exmh_1170404264_8768P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFFwvOocC3lWbTT17ARAli8AKCehF1cTrsrTeDivVpfuaCSLxh5uQCfeDNA
QM2vk7HzDiVwpftMfMPBTCo=
=fud2
-----END PGP SIGNATURE-----

--==_Exmh_1170404264_8768P--
