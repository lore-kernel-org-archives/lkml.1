Return-Path: <linux-kernel-owner+w=401wt.eu-S1764941AbXGXOmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764941AbXGXOmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 10:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbXGXOmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 10:42:24 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:50716 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbXGXOmY (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 10:42:24 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Oliver Pinter <oliver.pntr@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: [ANNOUNCE][GIT PATCH] Kconfig.cpu cosmetics
In-Reply-To: Your message of "Sun, 22 Jul 2007 22:16:14 +0200."
             <6101e8c40707221316t744c7c15pc7ed8f179e0bab25@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <6101e8c40707221311l19a7e39r36b99bcb2dcaaae1@mail.gmail.com>
            <6101e8c40707221316t744c7c15pc7ed8f179e0bab25@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1185238590_3463P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 23 Jul 2007 20:56:30 -0400
Message-ID: <5263.1185238590@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1185238590_3463P
Content-Type: text/plain; charset=us-ascii

On Sun, 22 Jul 2007 22:16:14 +0200, Oliver Pinter said:

> Here is one patch, Kconfig.cpu, this patch add the Pentium D processor
> for help, because number of person has the question: I have Pentium D,
> and which CPU chose  I.

Would it make sense to extend the help sections in arch/i386/Kconfig.cpu to
list the family/model numbers reported by /proc/cpuinfo?  There's a few cookie
crumbs in there about new/old Xeons, and that Via Nehemiah chips are 'model 9'.
Should that be extended to be more complete?

--==_Exmh_1185238590_3463P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGpU4+cC3lWbTT17ARArqIAJ9DONdb4+B+mhs0HtAno5FJQ6yflACgvRo/
E/PtUITST7ZIiCGavX3f1Yg=
=glxL
-----END PGP SIGNATURE-----

--==_Exmh_1185238590_3463P--
