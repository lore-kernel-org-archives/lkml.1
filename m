Return-Path: <linux-kernel-owner+w=401wt.eu-S1752936AbZIXX6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbZIXX6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 19:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbZIXX6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 19:58:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53015 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962AbZIXX6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 19:58:45 -0400
Date: Fri, 25 Sep 2009 09:58:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: michael@ellerman.id.au, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] perf_event, powerpc: Fix compilation after big
 perf_counter rename
Message-Id: <20090925095841.8578073a.sfr@canb.auug.org.au>
In-Reply-To: <1253798755.16237.4.camel@concordia>
References: <19128.4280.813369.589704@cargo.ozlabs.ibm.com>
	<1253584591.7103.197.camel@pasglop>
	<20090922072834.GA25470@elte.hu>
	<1253606415.7103.216.camel@pasglop>
	<1253620332.10476.4.camel@concordia>
	<20090923124420.GA5525@elte.hu>
	<1253747995.6110.5.camel@concordia>
	<20090924121423.GB12262@elte.hu>
	<1253798755.16237.4.camel@concordia>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__25_Sep_2009_09_58_41_+1000_ErTXIdWapXzp+cCt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__25_Sep_2009_09_58_41_+1000_ErTXIdWapXzp+cCt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Thu, 24 Sep 2009 23:25:55 +1000 Michael Ellerman <michael@ellerman.id.au=
> wrote:
>
> Give me a day or two, I should be able to add a per-branch setting for
> who to send mails to without too much trouble.

In the mean time I don't now if someone has pointed you at these today:

http://kisskb.ellerman.id.au/kisskb/branch/12/

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__25_Sep_2009_09_58_41_+1000_ErTXIdWapXzp+cCt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkq8B7EACgkQjjKRsyhoI8xzEQCfeNo85zq0AujzMPSceQjsIj8b
jPkAoLHR5ldo3FeTnJycBOTVmbKKzSlh
=xDI+
-----END PGP SIGNATURE-----

--Signature=_Fri__25_Sep_2009_09_58_41_+1000_ErTXIdWapXzp+cCt--
