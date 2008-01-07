Return-Path: <linux-kernel-owner+w=401wt.eu-S1759532AbYAGUv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532AbYAGUv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 15:51:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758172AbYAGUvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 15:51:19 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:55067 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757963AbYAGUvS (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 15:51:18 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Willy Tarreau <w@1wt.eu>
Cc: Adrian Bunk <bunk@kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
       Peter Osterlund <petero2@telia.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
In-Reply-To: Your message of "Sun, 06 Jan 2008 22:08:13 +0100."
             <20080106210813.GA10136@1wt.eu>
From: Valdis.Kletnieks@vt.edu
References: <m3ir27oe7f.fsf@telia.com> <1199627875.5205.1.camel@localhost.localdomain> <20080106144706.GA25419@elte.hu> <1199632845.5205.31.camel@localhost.localdomain> <20080106171158.GM20473@parisc-linux.org> <1199640983.5205.65.camel@localhost.localdomain> <20080106183402.GA7906@1wt.eu> <20080106185625.GM2082@does.not.exist> <20080106191044.GA1105@1wt.eu> <20080106195802.GN2082@does.not.exist>
            <20080106210813.GA10136@1wt.eu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1199739038_2703P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 07 Jan 2008 15:50:38 -0500
Message-ID: <19438.1199739038@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1199739038_2703P
Content-Type: text/plain; charset=us-ascii

On Sun, 06 Jan 2008 22:08:13 +0100, Willy Tarreau said:

> even slightly annoying, we never get it. Have you noticed the number of
> "me too" on the list ? Users find any sort of excuse for not having filed
> a report in the first time, but are still willing to confirm another
> one's bug. That's normal, they're just humans after all.

Personally, I've lost count of the number of times I've *not* reported a
bug/oops just because of the "NVidia users this means you" statement, only
to have the exact same issue reported several weeks/months later by somebody
who's able to replicate it with an untainted kernel.

>  'lsmod|more' in a shell window. If you do not know how to run without
>   those drivers, please still file the report, it may still be considered
>  valuable, but you may be recontacted and guided to unload them."

Exactly.

--==_Exmh_1199739038_2703P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHgpCdcC3lWbTT17ARAnThAJ99dlhd43snk2gZGgQ0VCGr7lFqmgCcDIUA
sDHDhQAMOJ0UEE2hFnJs0Ic=
=UWlN
-----END PGP SIGNATURE-----

--==_Exmh_1199739038_2703P--
