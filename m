Return-Path: <linux-kernel-owner+w=401wt.eu-S1758965AbZAMXOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758965AbZAMXOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758487AbZAMXNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:13:33 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:59149 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884AbZAMXNc (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:13:32 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: linux-kernel@vger.kernel.org
Cc: mm-commits@vger.kernel.org
Subject: Re: mmotm 2009-01-13-01-23 uploaded
In-Reply-To: Your message of "Tue, 13 Jan 2009 01:24:37 PST."
             <200901130924.n0D9Obvf006707@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <200901130924.n0D9Obvf006707@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1231888411_3146P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 13 Jan 2009 18:13:31 -0500
Message-ID: <14657.1231888411@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1231888411_3146P
Content-Type: text/plain; charset=us-ascii

On Tue, 13 Jan 2009 01:24:37 PST, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2009-01-13-01-23 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

'quilt push -a' fails with:

Applying patch synclink_gt-enable-ri-interrupt.patch
patching file drivers/char/synclink_gt.c
Hunk #1 FAILED at 1.
Hunk #2 FAILED at 89.
2 out of 7 hunks FAILED -- rejects in file drivers/char/synclink_gt.c
Patch synclink_gt-enable-ri-interrupt.patch does not apply (enforce with -f)

Handing that one line in the series file a '#' made quilt happy.


--==_Exmh_1231888411_3146P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJbSAbcC3lWbTT17ARAiWqAKCEQInvvjop9DVk0zXwNAz1B1FMQwCfeuv/
I0dYCsP/JacLBg+mXsWO8c0=
=rCZg
-----END PGP SIGNATURE-----

--==_Exmh_1231888411_3146P--
