Return-Path: <linux-kernel-owner+w=401wt.eu-S1753366Ab0ATNZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab0ATNZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 08:25:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025Ab0ATNZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 08:25:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591Ab0ATNZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 08:25:48 -0500
Date: Wed, 20 Jan 2010 08:24:48 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100120132448.GI16096@redhat.com>
References: <20100119211646.GF16096@redhat.com> <20100120111220.e7fb4e2c.sfr@canb.auug.org.au> <20100120054950.GB27108@elte.hu> <20100120061551.GB6588@in.ibm.com> <20100120062834.GB12165@elte.hu> <20100120175959.59daa481.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <20100120175959.59daa481.sfr@canb.auug.org.au>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi -

On Wed, Jan 20, 2010 at 05:59:59PM +1100, Stephen Rothwell wrote:
> [...]
> > Including experimental code that is RFC and which is not certain to go=
=20
> > upstream is certainly not the purpose of linux-next though.
>=20
> Ingo is correct in what he says here.  See the boilerplate:
> [...]
> Basically, this should be just what you would send to Linus (or ask him
> to fetch)."
> I will remove this tree from linux-next tomorrow and wait until it is
> more ready for mainline inclusion.

Please reconsider.  Ingo mistook what was being proposed.  We request
merge/integration testing for just the set of patches posted
<http://lkml.org/lkml/2009/12/17/466>, which was in response to
peterz's earlier review comments, and none of which is labeled or
considered RFC or experimental.

Ananth was right that the utrace-ptrace git branch represents this
rather than master.

- FChE

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFLVwQgVZbdDOm/ZT0RAuoTAJ0QyGsZKMsihHsoB2C/0FYiWrBNEwCdEyV6
HwjZJu/Jc6bnhhnDU6AExac=
=lMTc
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
