Return-Path: <linux-kernel-owner+w=401wt.eu-S937046AbXGLAJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937046AbXGLAJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936632AbXGKX4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:56:36 -0400
Received: from tamriel.snowman.net ([72.66.115.51]:43490 "EHLO
	tamriel.snowman.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936625AbXGKX4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:56:35 -0400
Date: Wed, 11 Jul 2007 19:56:34 -0400
From: Stephen Frost <sfrost@snowman.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Martin Orr <martin@martinorr.name>,
       Stefano Rivoir <s.rivoir@gts.it>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22 released
Message-ID: <20070711235634.GK4887@tamriel.snowman.net>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>,
	Martin Orr <martin@martinorr.name>,
	Stefano Rivoir <s.rivoir@gts.it>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4693327E.6000006@gts.it> <alpine.LFD.0.999.0707100824170.3412@woody.linux-foundation.org> <46947ADF.4080605@gts.it> <p73vecrxf0t.fsf@bingen.suse.de> <46951892.20406@martinorr.name> <alpine.LFD.0.999.0707111059200.3412@woody.linux-foundation.org> <469544D3.90004@martinorr.name> <alpine.LFD.0.999.0707111410430.20061@woody.linux-foundation.org> <20070711221626.GA25510@one.firstfloor.org> <alpine.LFD.0.999.0707111534340.20061@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rEhM+w5krfX9Wpv9"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707111534340.20061@woody.linux-foundation.org>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snowman.net
X-Operating-System: Linux/2.6.21-2-amd64 (x86_64)
X-Uptime: 19:51:54 up 10 days,  9:16, 21 users,  load average: 0.11, 0.09,
	0.09
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--rEhM+w5krfX9Wpv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> But yeah, if Debian/sid is just using random compiler snapshots of the=20
> day, I htink we can just bury this as "pointless".

Err, debian/sid *isn't* defaulting to gcc-4.2 yet, but it is made
available to people who want to install it and play with it.

Additionally, the kernel build is actually tied to a specific compiler
(doesn't default to just using whatever the default compiler is) so even
when gcc-4.2 is eventually made the default compiler the linux images
built for Debian won't use it immediately.  That change will be made
seperately and after additional testing to make sure it doesn't break
the built kernel which is distributed.

	Thanks,

		Stephen

--rEhM+w5krfX9Wpv9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGlW4yrzgMPqB3kigRAgwCAJ92CnYyGcuwkDXPWwHtxJhg8ylIlgCffNx1
KPj5MLSQVQPrmblLoBLALlA=
=zo8g
-----END PGP SIGNATURE-----

--rEhM+w5krfX9Wpv9--
