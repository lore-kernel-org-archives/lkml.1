Return-Path: <linux-kernel-owner+w=401wt.eu-S1759974AbXJLUcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974AbXJLUcX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 16:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759613AbXJLUcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 16:32:00 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:60937 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759546AbXJLUb7 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 16:31:59 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: 7eggert@gmx.de, Kok@imap.glb.intel.com, prasad@linux.vnet.ibm.com,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Pavel Machek <pavel@ucw.cz>, Arjan van de Ven <arjan@infradead.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: gigabit ethernet power consumption
In-Reply-To: Your message of "Fri, 12 Oct 2007 09:35:15 PDT."
             <470FA243.6030908@intel.com>
From: Valdis.Kletnieks@vt.edu
References: <9c8XH-7gs-13@gated-at.bofh.it> <9c9qN-7Rn-19@gated-at.bofh.it> <9cs0n-3Dc-9@gated-at.bofh.it> <9csjH-43E-33@gated-at.bofh.it> <9d4yC-5hT-7@gated-at.bofh.it> <9d7ZJ-2mI-11@gated-at.bofh.it> <E1Ig9wz-0000sg-Ep@be1.lrz>
            <470FA243.6030908@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1192221016_3255P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 12 Oct 2007 16:30:16 -0400
Message-ID: <12419.1192221016@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1192221016_3255P
Content-Type: text/plain; charset=us-ascii

On Fri, 12 Oct 2007 09:35:15 PDT, "Kok, Auke" said:

> > How much power does a non-connected NIC consume, and can you save power
> > by forcing 10 MBit until a link is detected (doubling negotiation time)?
> 
> no, the PHY consumes a minimal amount of energy when not connected, regardless of
> whether it is advertising 10, 100 or 1000mbit.

Is that true for essentially all the chipsets we support (or at least "the vast
majority of the ones currently found in common machines")?

--==_Exmh_1192221016_3255P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHD9lYcC3lWbTT17ARAir0AJ9QgMh17zxgAOlw6CEEIIo85khbagCgz5RK
bj8BhEwtu7964WSHpKq1qv4=
=lQmN
-----END PGP SIGNATURE-----

--==_Exmh_1192221016_3255P--
