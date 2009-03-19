Return-Path: <linux-kernel-owner+w=401wt.eu-S1761349AbZCSWIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761349AbZCSWIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 18:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760306AbZCSWHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 18:07:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33905 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361AbZCSWHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 18:07:48 -0400
Date: Fri, 20 Mar 2009 09:07:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Al Viro <viro@zeniv.linux.org.uk>,
       Christopher Li <sparse@chrisli.org>, linux-sparse@vger.kernel.org,
       Hannes Eder <hannes@hanneseder.net>, linux-kernel@vger.kernel.org
Subject: Re: Nasal demons in preprocessor use (Re: [PATCH] test-suite: new 
 preprocessor test case)
Message-Id: <20090320090708.b87580a4.sfr@canb.auug.org.au>
In-Reply-To: <19f34abd0903191320qdd73530ud85081d23e17b266@mail.gmail.com>
References: <20090319175544.13691.42362.stgit@f10box.hanneseder.net>
	<20090319182628.GB28946@ZenIV.linux.org.uk>
	<154e089b0903191151q37ab7b20o43838845af12966f@mail.gmail.com>
	<20090319190730.GC28946@ZenIV.linux.org.uk>
	<20090319192758.GB24318@elte.hu>
	<19f34abd0903191320qdd73530ud85081d23e17b266@mail.gmail.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__20_Mar_2009_09_07_08_+1100_.o=X60qHxJJ/lBOR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__20_Mar_2009_09_07_08_+1100_.o=X60qHxJJ/lBOR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vegard,

On Thu, 19 Mar 2009 21:20:51 +0100 Vegard Nossum <vegard.nossum@gmail.com> =
wrote:
>
> I guess this means that kmemcheck branch should be withdrawn from
> linux-next, at least temporarily, as I have no immediate
> workarounds/alternatives. Stephen, can you drop it?

OK, I will remove it starting today.  Let me know when you want it back
in.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__20_Mar_2009_09_07_08_+1100_.o=X60qHxJJ/lBOR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknCwgwACgkQjjKRsyhoI8wsJACfYe7sORkN/86nZ6dI7KEMomzI
bpIAoIn8aE8P/apZ+FdkGn13cn5ODkO2
=HWIO
-----END PGP SIGNATURE-----

--Signature=_Fri__20_Mar_2009_09_07_08_+1100_.o=X60qHxJJ/lBOR--
