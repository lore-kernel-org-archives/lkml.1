Return-Path: <linux-kernel-owner+w=401wt.eu-S1755476AbZAPQCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbZAPQCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 11:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757262AbZAPQCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 11:02:23 -0500
Received: from mail.klingt.org ([86.59.21.178]:56556 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756291AbZAPQCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 11:02:21 -0500
Subject: Re: 2.6.28-rc9: oprofile regression
From: Tim Blechmann <tim@klingt.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@linux.intel.com>, oprofile-list@lists.sf.net,
       linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
       venkatesh.pallipadi@intel.com
In-Reply-To: <alpine.LFD.2.00.0901161651590.3400@localhost.localdomain>
References: <1229869416.6911.1.camel@thinkpad>
	 <1229894585.6898.6.camel@thinkpad>  <49544497.9020900@linux.intel.com>
	 <1230894257.6072.10.camel@thinkpad>
	 <alpine.LFD.2.00.0901141739580.3598@localhost.localdomain>
	 <1231957184.13033.70.camel@thinkpad>
	 <alpine.LFD.2.00.0901150940250.3598@localhost.localdomain>
	 <1232010853.6541.4.camel@thinkpad>
	 <alpine.LFD.2.00.0901152135110.3400@localhost.localdomain>
	 <1232067181.6134.74.camel@thinkpad>
	 <alpine.LFD.2.00.0901160956170.3400@localhost.localdomain>
	 <1232105393.6378.16.camel@thinkpad>
	 <alpine.LFD.2.00.0901161651590.3400@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-XYlzHcHe9fwh6t9kKqrj"
Date: Fri, 16 Jan 2009 17:02:02 +0100
Message-Id: <1232121722.6680.2.camel@thinkpad>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (klingt.org [127.0.0.1]); Fri, 16 Jan 2009 17:02:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-XYlzHcHe9fwh6t9kKqrj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-16 at 16:52 +0100, Thomas Gleixner wrote:
> On Fri, 16 Jan 2009, Tim Blechmann wrote:
> > nothing fancy, just the ubuntu default:
> > root=3DUUID=3D7b58a11b-972a-4a67-909a-b8e48cb29da5 ro quiet splash=20
>=20
> Hmm, ubuntu. question: which gcc version ?

~$ gcc -v
Using built-in specs.
Target: x86_64-linux-gnu
Configured with: ../src/configure -v --with-pkgversion=3D'Ubuntu
4.3.2-1ubuntu11' --with-bugurl=3Dfile:///usr/share/doc/gcc-4.3/README.Bugs
--enable-languages=3Dc,c++,fortran,objc,obj-c++ --prefix=3D/usr
--enable-shared --with-system-zlib --libexecdir=3D/usr/lib
--without-included-gettext --enable-threads=3Dposix --enable-nls
--with-gxx-include-dir=3D/usr/include/c++/4.3 --program-suffix=3D-4.3
--enable-clocale=3Dgnu --enable-libstdcxx-debug --enable-objc-gc
--enable-mpfr --enable-checking=3Drelease --build=3Dx86_64-linux-gnu
--host=3Dx86_64-linux-gnu --target=3Dx86_64-linux-gnu
Thread model: posix
gcc version 4.3.2 (Ubuntu 4.3.2-1ubuntu11)


--
tim@klingt.org
http://tim.klingt.org

The aim of education is the knowledge, not of facts, but of values
  William S. Burroughs

--=-XYlzHcHe9fwh6t9kKqrj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklwr3cACgkQdL+4qsZfVstT5QCeNz/gWEI9bTgW1Upyx6ZBCCjY
MSoAnRI92KysMYsIvRgh6j94SxUBKNDE
=nm6D
-----END PGP SIGNATURE-----

--=-XYlzHcHe9fwh6t9kKqrj--

