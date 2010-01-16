Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab0APHey (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 02:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898Ab0APHex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 02:34:53 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:34046 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909Ab0APHew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 02:34:52 -0500
Date: Sat, 16 Jan 2010 18:34:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] kbuild: improve version string logic
Message-Id: <20100116183445.29fc5d50.sfr@canb.auug.org.au>
In-Reply-To: <20100116063754.GC20342@elte.hu>
References: <alpine.DEB.2.00.1001041330230.26148@chino.kir.corp.google.com>
	<4B4345AF.9040600@suse.cz>
	<alpine.DEB.2.00.1001131300360.26527@chino.kir.corp.google.com>
	<20100116063754.GC20342@elte.hu>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__16_Jan_2010_18_34_45_+1100_fgFhiyl91z43a5u/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__16_Jan_2010_18_34_45_+1100_fgFhiyl91z43a5u/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Sat, 16 Jan 2010 07:37:54 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>
> Given that Sam doesnt maintain the kbuild tree anymore, would this patch =
be a=20
> good fit for -mm perhaps?

There is a new kbuild tree maintainer: Michal Marek <mmarek@suse.cz>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__16_Jan_2010_18_34_45_+1100_fgFhiyl91z43a5u/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktRbBUACgkQjjKRsyhoI8wBKACZAQfb55hlh5UmsE+CRYCkC8Rr
aGQAn12Rr+2j0BkR2gU+qkHYHFQ6dP0Q
=4+47
-----END PGP SIGNATURE-----

--Signature=_Sat__16_Jan_2010_18_34_45_+1100_fgFhiyl91z43a5u/--
