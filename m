Return-Path: <linux-kernel-owner+w=401wt.eu-S933144AbXA2FqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933144AbXA2FqF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 00:46:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933138AbXA2FqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 00:46:05 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:34048 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933144AbXA2FqE (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 00:46:04 -0500
Message-Id: <200701290546.l0T5k08I016171@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
In-Reply-To: Your message of "Sun, 28 Jan 2007 21:58:26 EST."
             <200701290258.l0T2wQjU003810@turing-police.cc.vt.edu>
From: Valdis.Kletnieks@vt.edu
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net> <6bffcb0e0701270837i1ec40560l6e61e8876177e9da@mail.gmail.com> <45BBC444.8090109@imap.cc> <20070127134116.06bdadd8.akpm@osdl.org> <200701280241.l0S2f2ga015847@turing-police.cc.vt.edu>
            <200701290258.l0T2wQjU003810@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1170049560_8444P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 29 Jan 2007 00:46:00 -0500
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1170049560_8444P
Content-Type: text/plain; charset=us-ascii

On Sun, 28 Jan 2007 21:58:26 EST, Valdis.Kletnieks@vt.edu said:
> --==_Exmh_1170039506_3335P
> Content-Type: text/plain; charset=us-ascii
> 
> On 26/01/07, akpm@osdl.org <akpm@osdl.org> wrote:
> > The mm snapshot broken-out-2007-01-26-00-36.tar.gz has been uploaded to
> >    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-01-26-00-36.tar.gz
> 
> Aliens ate my brain, part 2:
> 
> My IPv6 configuration evaporated, totally, out of my .config.  I tracked it
> down to wierdness with net/Kconfig:

Trying again with the official -rc6-mm1 tarball...

The aliens regurgitated my brain - after I did a 'make oldconfig' against my
-rc4-mm1 config, I did a 'make menuconfig' and all the IPv6 stuff showed up
as 'NEW'.  Not sure why it didn't carry over the the -rc4-mm1 values, but
at least I was able to re-set them.

--==_Exmh_1170049560_8444P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFFvYoYcC3lWbTT17ARAuCnAJ9JnB95wzmzYSn8F76iytuA1TZmVACg92UF
npt0NJvr6/FsMLKkY0UNkzY=
=bdCe
-----END PGP SIGNATURE-----

--==_Exmh_1170049560_8444P--
