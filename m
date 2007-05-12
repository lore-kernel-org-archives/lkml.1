Return-Path: <linux-kernel-owner+w=401wt.eu-S1762042AbXELC0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762042AbXELC0y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 22:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755471AbXELC0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 22:26:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45935 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753682AbXELC0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 22:26:47 -0400
Date: Sat, 12 May 2007 12:26:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: kjhall@us.ibm.com, tpm@selhorst.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: remove invalid list address for TPM
Message-Id: <20070512122636.9d13f0ec.sfr@canb.auug.org.au>
In-Reply-To: <20070511091932.8a7aa843.randy.dunlap@oracle.com>
References: <20070511164207.24b1437e.sfr@canb.auug.org.au>
	<20070511091932.8a7aa843.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.0 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__12_May_2007_12_26_36_+1000_eXTST1Kp53rULx/l"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__12_May_2007_12_26_36_+1000_eXTST1Kp53rULx/l
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Fri, 11 May 2007 09:19:32 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
>
> On Fri, 11 May 2007 16:42:07 +1000 Stephen Rothwell wrote:
>
> > This address bounces with "550 Unknown user".
> >
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > ---
> >  MAINTAINERS |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
>
> Hm, I get:
>
> Your mail to 'tpmdd-devel' with the subject
>     test only
> Is being held until the list moderator can review it for approval.
> The reason it is being held:
>     Post by non-member to a members-only list

Hmm, interesting.  I did get the "550 Unknown user" bounce.  I guess some
glitch in sourceforge.net's mail system?

> so what MAINTAINERS usually says in that case is "(subscribers-only)":
>
> L:	linux-atm-general@lists.sourceforge.net (subscribers-only)

Fine, that seems sensible.

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__12_May_2007_12_26_36_+1000_eXTST1Kp53rULx/l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGRSXkFdBgD/zoJvwRAnjEAJ9tA6VFd//lZkJ1bMXAqf97ozoj0ACgi1ZP
j8mcHS2xa/5iUyxy0mPneMo=
=UcHB
-----END PGP SIGNATURE-----

--Signature=_Sat__12_May_2007_12_26_36_+1000_eXTST1Kp53rULx/l--
