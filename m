Return-Path: <linux-kernel-owner+w=401wt.eu-S934209AbXEESEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934209AbXEESEd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 14:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934210AbXEESEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 14:04:33 -0400
Received: from h80ad2754.async.vt.edu ([128.173.39.84]:55455 "EHLO
	h80ad2754.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934209AbXEESEc (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 14:04:32 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm2 breaks 'lvm vgscan'.
In-Reply-To: Your message of "Thu, 26 Apr 2007 22:31:15 EDT."
             <8526.1177641075@turing-police.cc.vt.edu>
From: Valdis.Kletnieks@vt.edu
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
            <8526.1177641075@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1178388263_3690P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 05 May 2007 14:04:23 -0400
Message-ID: <3986.1178388263@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1178388263_3690P
Content-Type: text/plain; charset=us-ascii

On Thu, 26 Apr 2007 22:31:15 EDT, Valdis.Kletnieks@vt.edu said:
> On Wed, 25 Apr 2007 22:57:16 PDT, Andrew Morton said:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc7/2.6.21-rc7-mm2/
> 
> This addition in -rc7-mm1 breaks my laptop (Dell Latitude D820, x86_64 kernel)
> 
> gregkh-driver-sysfs-fix-i_ino-handling-in-sysfs.patch
> 
> The initrd on my system does an 'lvm vgscan' to get the root filesystem
> accessible.

This is confirmed fixed in 2.6.21-mm1.


--==_Exmh_1178388263_3690P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGPMcncC3lWbTT17ARAi+XAKCmZJRIQg8jNbRblUnU8+Qp/UfSjQCeNk/l
vwaAOSSILWPt6wOFCTwlLkw=
=AVnF
-----END PGP SIGNATURE-----

--==_Exmh_1178388263_3690P--
