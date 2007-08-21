Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbXHUXEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbXHUXEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 19:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbXHUXE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 19:04:26 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:54507 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbXHUXEZ (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 19:04:25 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: John Stoffel <john@stoffel.org>
Cc: Peter Staubach <staubach@redhat.com>,
       Robin Lee Powell <rlpowell@digitalkingdom.org>,
       linux-kernel@vger.kernel.org
Subject: Re: NFS hang + umount -f: better behaviour requested.
In-Reply-To: Your message of "Tue, 21 Aug 2007 14:50:42 EDT."
             <18123.13314.43009.263383@stoffel.org>
From: Valdis.Kletnieks@vt.edu
References: <20070820225415.GL3956@digitalkingdom.org> <18123.5699.405125.137517@stoffel.org> <46CB1A78.7040102@redhat.com>
            <18123.13314.43009.263383@stoffel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1187737456_2990P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 21 Aug 2007 19:04:16 -0400
Message-ID: <29735.1187737456@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1187737456_2990P
Content-Type: text/plain; charset=us-ascii

On Tue, 21 Aug 2007 14:50:42 EDT, John Stoffel said:

> Now maybe those issues are raised when you have a Linux NFS server
> with Solaris clients.  But in my book, reliable NFS servers are key,
> and if they are reliable, 'soft,intr' works just fine.

And you don't need all that ext3 journal overhead if your disk drives
are reliable too.  Gotcha. :)

--==_Exmh_1187737456_2990P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGy29wcC3lWbTT17ARAhFOAKCCJj/nxKB3NUKFJfrhllOu09U0jwCdHrep
06s5Rz0QmZwPMVH7kCTMfSE=
=GGCg
-----END PGP SIGNATURE-----

--==_Exmh_1187737456_2990P--
