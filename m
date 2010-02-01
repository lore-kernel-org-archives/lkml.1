Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab0BAXW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 18:22:58 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48639 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889Ab0BAXW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 18:22:56 -0500
Date: Tue, 2 Feb 2010 10:22:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: Remove unused update_shares_locked()
Message-Id: <20100202102249.aa87c7e1.sfr@canb.auug.org.au>
In-Reply-To: <1265019219.24455.128.camel@laptop>
References: <20100201182204.cc53b339.sfr@canb.auug.org.au>
	<1265019219.24455.128.camel@laptop>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__2_Feb_2010_10_22_49_+1100_su7gj6QsEz9OzLg3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Feb_2010_10_22_49_+1100_su7gj6QsEz9OzLg3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Peter,

On Mon, 01 Feb 2010 11:13:39 +0100 Peter Zijlstra <peterz@infradead.org> wr=
ote:
>
> Subject: sched: Remove unused update_shares_locked()

Thanks for that.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__2_Feb_2010_10_22_49_+1100_su7gj6QsEz9OzLg3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktnYkkACgkQjjKRsyhoI8yU9QCeMemTGi3/MtgUxVR4PxSk2pkT
eiQAnAoRDsMtuBM/dSXXPWCIZpuFpeQS
=htHq
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Feb_2010_10_22_49_+1100_su7gj6QsEz9OzLg3--
