Return-Path: <linux-kernel-owner+w=401wt.eu-S1754439AbYKGJMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439AbYKGJMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 04:12:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbYKGJLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 04:11:55 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:34499 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823AbYKGJLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 04:11:54 -0500
Date: Fri, 7 Nov 2008 20:11:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpumask: introduce new API, without changing anything
Message-Id: <20081107201139.196fa52b.sfr@canb.auug.org.au>
In-Reply-To: <20081107084016.GF4435@elte.hu>
References: <20081029152849.3883d072.sfr@canb.auug.org.au>
	<200811021229.16061.rusty@rustcorp.com.au>
	<alpine.LFD.2.00.0811011834360.3483@nehalem.linux-foundation.org>
	<200811070949.02914.rusty@rustcorp.com.au>
	<20081107084016.GF4435@elte.hu>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__7_Nov_2008_20_11_39_+1100_A7_iuZrQk8fio2_L"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Nov_2008_20_11_39_+1100_A7_iuZrQk8fio2_L
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Fri, 7 Nov 2008 09:40:16 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>
> if this is equal to the patch that you sent me (see the git=20
> coordinates below), it was also stess-tested and build-coverage tested=20
> by me on a healthy range of x86 systems, in a range of build=20
> environments.

It isn't identical.  See my message about a small merge conflict between
the cpus4096 tree and the rr tree in linux-next today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__7_Nov_2008_20_11_39_+1100_A7_iuZrQk8fio2_L
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkUBksACgkQjjKRsyhoI8zV+gCcCA/i5dKxihbIM6qBQoah1scG
LqwAn0drbMwbriLTMW7CQmGqWMSndUiq
=iG5a
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Nov_2008_20_11_39_+1100_A7_iuZrQk8fio2_L--
