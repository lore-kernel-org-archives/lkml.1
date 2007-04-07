Return-Path: <linux-kernel-owner+w=401wt.eu-S966083AbXDGQnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966083AbXDGQnG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 12:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966100AbXDGQnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 12:43:06 -0400
Received: from h80ad275a.async.vt.edu ([128.173.39.90]:56108 "EHLO
	h80ad275a.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966083AbXDGQnF (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 12:43:05 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: johnrobertbanks@fastmail.fm
Cc: Ignatich <ignatich@gmail.com>, reiserfs-list@namesys.com,
       linux-kernel@vger.kernel.org
Subject: Re: COMPILING AND CONFIGURING A NEW KERNEL.
In-Reply-To: Your message of "Fri, 06 Apr 2007 18:26:45 PDT."
             <1175909205.905.1183425104@webmail.messagingengine.com>
From: Valdis.Kletnieks@vt.edu
References: <46157B5B.5000602@gmail.com> <1175817921.18400.1183285196@webmail.messagingengine.com>
            <1175909205.905.1183425104@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1175964174_4736P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 07 Apr 2007 12:42:54 -0400
Message-ID: <12252.1175964174@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1175964174_4736P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, 06 Apr 2007 18:26:45 PDT, johnrobertbanks=40fastmail.fm said:
>
> YOU SHOULD compile all the drivers necessary to boot your system, into
> the kernel (ie, such drivers should not be built as modules).
>=20
> This way you will NOT need an initrd file.

It is quite possible to build a kernel that has all the drivers built-in,=

but still require an initrd file.  For instance, if you have a recent
RedHat or Fedora system, '/' may very well be on an LVM partition, which
means you need an initrd to do a 'lvm varyonvg' before mounting your real=

root filesystem will work....

--==_Exmh_1175964174_4736P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGF8oOcC3lWbTT17ARAkHXAKC27KCQjHJkkA8CUR6e1r5Hi6f5mwCgwUSo
VegXdIBZlaLBC2Bnxp+1z4Y=
=F1Jj
-----END PGP SIGNATURE-----

--==_Exmh_1175964174_4736P--
