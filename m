Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbXL2CLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbXL2CLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 21:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbXL2CLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 21:11:10 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:40984 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbXL2CLJ (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 21:11:09 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: sarcarsh@gmail.com
Cc: Marek Kierdelewicz <marek@piasta.pl>,
       =?ISO-8859-1?Q?Gustavo_Guillermo_P=E9rez?= <gustavo@compunauta.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Corrupted Hard Drive after activating intel I/oat dma
In-Reply-To: Your message of "Sat, 29 Dec 2007 04:21:44 +0530."
             <47757E00.1040905@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <200712271949.02116.gustavo@compunauta.com> <20071228040345.67db1361@catlap>
            <47757E00.1040905@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1198894256_2814P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 28 Dec 2007 21:10:56 -0500
Message-ID: <24730.1198894256@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1198894256_2814P
Content-Type: text/plain; charset=us-ascii

On Sat, 29 Dec 2007 04:21:44 +0530, Shourya Sarcar said:
> Marek Kierdelewicz wrote:
> 
> > 
> > I'm a gentoo@laptop user myself. This distro is very disk-demanding
> > because of the frequent compilations. In my opinion it's not the best
> > distro for a mobile system. No wonder your disk gave out :(.
> 
> Can you substantiate "distro is very disk-demanding
> because of the frequent compilations" ?

As I understand it, the gentoo philosophy is 'update by patching the source,
then compiling it'.  So basically, the way the kernel is updated with a
"patch/make/make install", you apply *all* updates that way.  This can suck
if you have things like OpenOffice and Firefox on your machine, and you get
to recompile them to update. And even if you don't, all it takes is one update
to the wrong /usr/include file, and you end up recompiling 3/4 of the binaries
in /usr.

--==_Exmh_1198894256_2814P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHdaywcC3lWbTT17ARAhuWAJ9zJ0IBlgCibe2qLFj3MfkHDtoMXQCgmJpT
RY0XJ62j8t6EjKW5g7wfBu8=
=MvDO
-----END PGP SIGNATURE-----

--==_Exmh_1198894256_2814P--
