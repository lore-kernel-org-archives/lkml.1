Return-Path: <linux-kernel-owner+w=401wt.eu-S1760587AbXH1Soq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760587AbXH1Soq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 14:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbXH1Soh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 14:44:37 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:45346 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbXH1Soh (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 14:44:37 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Update sysctl_check to handle compiled out code.
In-Reply-To: Your message of "Sat, 25 Aug 2007 12:03:19 MDT."
             <m1sl67lcew.fsf_-_@ebiederm.dsl.xmission.com>
From: Valdis.Kletnieks@vt.edu
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <23568.1187876026@turing-police.cc.vt.edu> <20070823141652.d488a6e0.akpm@linux-foundation.org> <m1wsvlmvu6.fsf_-_@ebiederm.dsl.xmission.com> <6634.1188030574@turing-police.cc.vt.edu> <m16433n55e.fsf@ebiederm.dsl.xmission.com> <2371.1188050875@turing-police.cc.vt.edu>
            <m1sl67lcew.fsf_-_@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1188330469_3159P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Aug 2007 14:44:31 -0400
Message-ID: <6090.1188326671@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1188330469_3159P
Content-Type: text/plain; charset=us-ascii

On Sat, 25 Aug 2007 12:03:19 MDT, Eric W. Biederman said:

> So don't worry about missing strategy routines, or missing proc_handler
> routines when they will never be called.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

I'm not seeing the false-positive msgs after applying this patch...

Tested-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>

--==_Exmh_1188330469_3159P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG1G0PcC3lWbTT17ARAn6XAKD73+5zyHYQDEFOZ1xC/wxd1kYaaQCff62L
a+mQBEnWNaDP4W80fbQn640=
=z8nM
-----END PGP SIGNATURE-----

--==_Exmh_1188330469_3159P--
