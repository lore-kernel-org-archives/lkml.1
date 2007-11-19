Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499AbXKSQEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbXKSQEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 11:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbXKSQEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 11:04:42 -0500
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:2986 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbXKSQEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 11:04:41 -0500
Date: Mon, 19 Nov 2007 17:04:27 +0100
From: Erik Mouw <mouw@nl.linux.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.24-rc3
Message-ID: <20071119160427.GD19359@gateway.home>
References: <alpine.LFD.0.9999.0711162123260.4260@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DiL7RhKs8rK9YGuF"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0711162123260.4260@woody.linux-foundation.org>
Organization: Eric Conspiracy Secret Labs
X-Eric-Conspiracy: There is no conspiracy!
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--DiL7RhKs8rK9YGuF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 16, 2007 at 09:33:22PM -0800, Linus Torvalds wrote:
> Go get it, and test it.

I gav 2.6.24 a first try and "make targz-pkg" fails on i386:

/bin/sh /home/erik/git/linux-2.6/scripts/package/buildtar targz-pkg
Makefile:119: *** Output directory (O=3D...) specifies kernel src dir.  Sto=
p.
make[1]: *** [targz-pkg] Error 2
make: *** [targz-pkg] Error 2


Erik

--=20
They're all fools. Don't worry. Darwin may be slow, but he'll
eventually get them. -- Matthew Lammers in alt.sysadmin.recovery

--DiL7RhKs8rK9YGuF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHQbQL/PlVHJtIto0RAijZAJ9eE+L6K1ZPcYtp9OdvsDKtNhxduwCfX8o7
M0FuhrTImpk+TNKxkxZzCgA=
=bLVt
-----END PGP SIGNATURE-----

--DiL7RhKs8rK9YGuF--
