Return-Path: <linux-kernel-owner+w=401wt.eu-S1762758AbXFGO3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762758AbXFGO3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 10:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762610AbXFGO3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 10:29:20 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:39136 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762593AbXFGO3T (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 10:29:19 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm2
In-Reply-To: Your message of "Wed, 06 Jun 2007 22:03:13 PDT."
             <20070606220313.8f7c1fab.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1181226554_4816P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 07 Jun 2007 10:29:15 -0400
Message-ID: <6775.1181226555@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1181226554_4816P
Content-Type: text/plain; charset=us-ascii

On Wed, 06 Jun 2007 22:03:13 PDT, Andrew Morton said:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm2/
> 
> - Basically a bugfixed version of 2.6.22-rc4-mm1.  None of the subsystem
>   trees were repulled, several bad patches were dropped, a few were fixed.

Ahh.. much better.  'lvm vgscan' worked, it booted, been up for an hour-ish
without any oops, bug, or warning.  Dell Latitude D820 laptop, T7200 dual-core,
x86_64 kernel....

--==_Exmh_1181226554_4816P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGaBY6cC3lWbTT17ARAoDPAJwLysOBo1Bp674o4ZzFuUQq8qD6WQCdHTxj
ARPxkO7CxK9omvo7IAeO3Iw=
=RBCU
-----END PGP SIGNATURE-----

--==_Exmh_1181226554_4816P--
