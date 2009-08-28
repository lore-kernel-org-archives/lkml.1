Return-Path: <linux-kernel-owner+w=401wt.eu-S1752334AbZH1TNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbZH1TNB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 15:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbZH1TNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 15:13:00 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:59079 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbZH1TNA (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 15:13:00 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: joe Shmoe <jsmoe3@yahoo.com>
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org
Subject: Re: kernel page table mapping for >1GB <3 GB for x86 arch without PAE
In-Reply-To: Your message of "Fri, 28 Aug 2009 11:40:56 PDT."
             <812804.57438.qm@web45209.mail.sp1.yahoo.com>
From: Valdis.Kletnieks@vt.edu
References: <812804.57438.qm@web45209.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1251486780_3654P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 28 Aug 2009 15:13:00 -0400
Message-ID: <24089.1251486780@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1251486780_3654P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, 28 Aug 2009 11:40:56 PDT, joe Shmoe said:

> For the sake of discussion, let us say I have 3.5 GB of RAM of x86 with=
 PAE
> disabled and I have only one process running other than kernel.

Oh, so an embedded environment. Sure, you could play games with that.

But most Linux systems have more processes running than just 'init'. And
in that case, what do you do with your memory map?  It gets a bit more
complicated then....


--==_Exmh_1251486780_3654P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKmCw8cC3lWbTT17ARAvCCAJ9PwAcP3pYSDeBWyKPBUR1UTNGSxwCg1/vc
hv8eYV3IVYkzFQ5gPI8Wz9Q=
=N7/y
-----END PGP SIGNATURE-----

--==_Exmh_1251486780_3654P--
