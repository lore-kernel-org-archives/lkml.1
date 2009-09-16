Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbZIPGG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbZIPGG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 02:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbZIPGGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 02:06:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50173 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbZIPGGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 02:06:54 -0400
Date: Wed, 16 Sep 2009 16:06:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.32 -mm Blackfin patches
Message-Id: <20090916160651.88b10377.sfr@canb.auug.org.au>
In-Reply-To: <8bd0f97a0909152124n186278feja97a7257548b3eb7@mail.gmail.com>
References: <8bd0f97a0909152056h61bfc487g6b8631966c6d72be@mail.gmail.com>
	<20090915211810.d1b83015.akpm@linux-foundation.org>
	<8bd0f97a0909152124n186278feja97a7257548b3eb7@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__16_Sep_2009_16_06_51_+1000_1=K.bXQQyL..JnBs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_Sep_2009_16_06_51_+1000_1=K.bXQQyL..JnBs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

On Wed, 16 Sep 2009 00:24:37 -0400 Mike Frysinger <vapier.adi@gmail.com> wr=
ote:
>
> not sure how the next process works.  what do i need to do Stephen ?

You send me a request for inclusion with a git tree (and branch)  (or
quilt series on a web site) and contact address(es) and understand the
following:

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Wed__16_Sep_2009_16_06_51_+1000_1=K.bXQQyL..JnBs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkqwgHsACgkQjjKRsyhoI8zBUACglz37aqTcrkJeAwE4hNoWxUqJ
7kAAn3UOr8XF7Lnly7sMvSuzS9RuZQD4
=zeFd
-----END PGP SIGNATURE-----

--Signature=_Wed__16_Sep_2009_16_06_51_+1000_1=K.bXQQyL..JnBs--
