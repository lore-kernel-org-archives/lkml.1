Return-Path: <linux-kernel-owner+w=401wt.eu-S1751341AbXH2Rhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341AbXH2Rhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 13:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbXH2Rho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 13:37:44 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:39850 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbXH2Rhn (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 13:37:43 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, jakub@redhat.com,
       Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3-mm1 - vdso and gettimeofday issues with glibc
In-Reply-To: Your message of "Wed, 29 Aug 2007 10:04:33 EDT."
             <23252.1188396273@turing-police.cc.vt.edu>
From: Valdis.Kletnieks@vt.edu
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
            <23252.1188396273@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1188409058_2981P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 29 Aug 2007 13:37:38 -0400
Message-ID: <3909.1188409058@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1188409058_2981P
Content-Type: text/plain; charset=us-ascii

On Wed, 29 Aug 2007 10:04:33 EDT, Valdis.Kletnieks@vt.edu said:

(Fixing the Subject: and updating the info)

> On Wed, 22 Aug 2007 02:06:48 PDT, Andrew Morton said:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/

> The issue:  vdso and gettimeofday seem to be having a quarrel.

This is also open as a Fedora bug:
https://bugzilla.redhat.com/show_bug.cgi?id=262481

--==_Exmh_1188409058_2981P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG1a7icC3lWbTT17ARAvxHAJ4+BZUAvLUA218Ij2z8MFq0Yc/6NQCeJA4N
EtQu4oQU34Mg1CWwDIx2toQ=
=a9kE
-----END PGP SIGNATURE-----

--==_Exmh_1188409058_2981P--
