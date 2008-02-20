Return-Path: <linux-kernel-owner+w=401wt.eu-S1758855AbYBTAdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855AbYBTAdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:33:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbYBTAdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:33:16 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:34530 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680AbYBTAdP (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:33:15 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Gunter Ohrner <G.Ohrner@post.rwth-aachen.de>, linux-kernel@vger.kernel.org
Subject: Re: vfat32 Free Cluster Count Update
In-Reply-To: Your message of "Tue, 19 Feb 2008 19:23:12 +0900."
             <877ih1w8hb.fsf@duaron.myhome.or.jp>
From: Valdis.Kletnieks@vt.edu
References: <fp77bc$akv$1@ger.gmane.org>
            <877ih1w8hb.fsf@duaron.myhome.or.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1203467589_762P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 19 Feb 2008 19:33:09 -0500
Message-ID: <27400.1203467589@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1203467589_762P
Content-Type: text/plain; charset=us-ascii

On Tue, 19 Feb 2008 19:23:12 +0900, OGAWA Hirofumi said:

> I'll dig it more, later. And for right now, please run "df" command, it
> will fix free cluster count.

Wow, that's a real kick in the head for all of us who have a mental concept
of 'df' being basically a read-only program, and "fixing counts" to be more
the job of 'fsck'.... :)

(Or is 'df' simply a known way to force execution of a code path that ends up
fixing the counts as a side-effect?)


--==_Exmh_1203467589_762P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHu3VFcC3lWbTT17ARAsf5AKDl6nO/sDDOoJ2OEQ6v7SSsfvHtwACgnRbH
C3NHcnLKhtRUv05CWx/Q7d4=
=Sgyx
-----END PGP SIGNATURE-----

--==_Exmh_1203467589_762P--
