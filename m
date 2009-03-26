Return-Path: <linux-kernel-owner+w=401wt.eu-S1759210AbZCZWP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210AbZCZWP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 18:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbZCZWPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 18:15:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59637 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756937AbZCZWPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 18:15:19 -0400
Date: Fri, 27 Mar 2009 09:15:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/2] tracing: add average time in function to function
 profiler
Message-Id: <20090327091507.f133257e.sfr@canb.auug.org.au>
In-Reply-To: <20090326010811.510051401@goodmis.org>
References: <20090326010737.611522983@goodmis.org>
	<20090326010811.510051401@goodmis.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__27_Mar_2009_09_15_07_+1100_Bv6RNjwNy2juYE1r"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Mar_2009_09_15_07_+1100_Bv6RNjwNy2juYE1r
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steve,

On Wed, 25 Mar 2009 21:07:39 -0400 Steven Rostedt <rostedt@goodmis.org> wro=
te:
>
> From: Steven Rostedt <srostedt@redhat.com>
>=20
> Show the average time in the function (Time / Hit)

Just wondering why we need to do this in the kernel ... there is already
enough information for a user to figure these averages out.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__27_Mar_2009_09_15_07_+1100_Bv6RNjwNy2juYE1r
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknL/msACgkQjjKRsyhoI8z2awCfY+ASTQVDuTtxIWIsQpH+/31A
opoAmwX4eEgA7AsMGoRwTyMhbZE61jAH
=761y
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Mar_2009_09_15_07_+1100_Bv6RNjwNy2juYE1r--
