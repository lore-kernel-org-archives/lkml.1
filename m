Return-Path: <linux-kernel-owner+w=401wt.eu-S1752617AbZDORLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbZDORLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 13:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbZDORLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 13:11:38 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:56019 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbZDORLh (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 13:11:37 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mm-commits@vger.kernel.org
Subject: Re: mmotm 2009-04-14-17-24 uploaded
In-Reply-To: Your message of "Wed, 15 Apr 2009 08:27:19 PDT."
             <49E5FCD7.8060902@linux.intel.com>
From: Valdis.Kletnieks@vt.edu
References: <200904150024.n3F0Ovdo019569@imap1.linux-foundation.org> <22518.1239773374@turing-police.cc.vt.edu>
            <49E5FCD7.8060902@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1239815458_5930P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 15 Apr 2009 13:10:58 -0400
Message-ID: <24159.1239815458@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1239815458_5930P
Content-Type: text/plain; charset=us-ascii

On Wed, 15 Apr 2009 08:27:19 PDT, Arjan van de Ven said:

> it depends on a patch that now has gone mainline....

OK, I just reverted it locally, and will assume we just hit a race condition
with the timing of pull requests and when Andrew created the origin.patch
and linux-next.patch.  If it's still wrecked in the next mmotm tarball that
Andrew posts, I'll follow up then.


--==_Exmh_1239815458_5930P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJ5hUicC3lWbTT17ARAmPsAKC93Swl/Ynko800Jdv2wuvwOGC9nwCglICc
5NHOjvn+Oo317bBTdj8WtEA=
=qA5G
-----END PGP SIGNATURE-----

--==_Exmh_1239815458_5930P--
