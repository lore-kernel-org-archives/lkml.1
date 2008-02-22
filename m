Return-Path: <linux-kernel-owner+w=401wt.eu-S934479AbYBVE6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934479AbYBVE6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 23:58:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbYBVE5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 23:57:43 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39971 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762559AbYBVE50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 23:57:26 -0500
Date: Fri, 22 Feb 2008 15:57:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: ananth@in.ibm.com
Cc: linux-next@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, ak@suse.de,
       arjan@linux.intel.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, sam@ravnborg.org
Subject: Re: [GIT PULL?] Create and populate toplevel tests/ for kernel
 tests
Message-Id: <20080222155713.0304dd19.sfr@canb.auug.org.au>
In-Reply-To: <20080222034231.GA6716@in.ibm.com>
References: <20080211104452.GB7944@in.ibm.com>
	<20080212164452.GA31096@infradead.org>
	<20080212132246.aac67ed1.akpm@linux-foundation.org>
	<20080212223918.GA3927@uranus.ravnborg.org>
	<20080219192153.GA11948@uranus.ravnborg.org>
	<20080222034231.GA6716@in.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__22_Feb_2008_15_57_13_+1100_Gr1dM/5k2R6mL/39"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_Feb_2008_15_57_13_+1100_Gr1dM/5k2R6mL/39
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ananth,

On Fri, 22 Feb 2008 09:12:31 +0530 Ananth N Mavinakayanahalli <ananth@in.ib=
m.com> wrote:
>
> The patchset in question is just a major code movement - basically to
> move all in-kernel tests to live under a toplevel tests/ directory. As
> such, all the stakeholders have acked the patchset, but it does look
> like this is a big enough change to be deferred to the next merge
> window.
>=20
> Given that there is general agreement about the patchset, could you
> please pull in the changes into the linux-next tree?
>=20
> Sam has setup a git tree for this and you can pull from:
> ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/tests.git
> =20
> Link to the thread: http://lkml.org/lkml/2008/2/11/97

I will include this in the next linux-tree.  It looks like it should not
cause to many problems (it merges OK on top of the about to be announce
next-20080222), but if I get a hard to resolve merge problem with it, I
will drop it first, OK.

I have noted you as the contact.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__22_Feb_2008_15_57_13_+1100_Gr1dM/5k2R6mL/39
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHvlYuTgG2atn1QN8RAgKqAJ9I3GEGXFJMqEct7GR94YwZ1SFQEwCeOeSH
6K2LNL07QCC3Ap9NACMdv7g=
=Lemh
-----END PGP SIGNATURE-----

--Signature=_Fri__22_Feb_2008_15_57_13_+1100_Gr1dM/5k2R6mL/39--
