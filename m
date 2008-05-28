Return-Path: <linux-kernel-owner+w=401wt.eu-S1759640AbYE1Blt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759640AbYE1Blt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 21:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYE1Blm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 21:41:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42870 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbYE1Bll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 21:41:41 -0400
Date: Wed, 28 May 2008 11:41:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem.Bityutskiy@nokia.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: can UBIFS be taken to linux-next?
Message-Id: <20080528114112.b8600074.sfr@canb.auug.org.au>
In-Reply-To: <483BA79F.9030100@nokia.com>
References: <483BA79F.9030100@nokia.com>
X-Mailer: Sylpheed 2.5.0rc (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__28_May_2008_11_41_12_+1000_twnOC9_sZSYdB+WW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_May_2008_11_41_12_+1000_twnOC9_sZSYdB+WW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

On Tue, 27 May 2008 09:18:07 +0300 Artem Bityutskiy <Artem.Bityutskiy@nokia=
.com> wrote:
>
> we would like to ask for UBIFS mainline inclusion the next merge window.
> Of course we cannot say for sure whether Linus will merge it or not,
> but it would be helpful to have it in your tree for some time anyway.
> UBIFS is already in -mm tree so I assume it should not have too many
> build issues.

OK, my requirements are that you intend for it to be integrated in the
next merge window, that it be reviewed and that it be unit tested (i.e.
tested as well as you can in isolation).  You seem to have done all that,
so I will add it.

I will put it at the end of the merge today.

Andrew, does that make sense to you?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_May_2008_11_41_12_+1000_twnOC9_sZSYdB+WW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIPLg+TgG2atn1QN8RAjeoAJ44eSVHjzYEe0hS3UnflxdZPxnluwCdGSRa
CqZeoCnaSNodCMFgTRNY02k=
=mrlE
-----END PGP SIGNATURE-----

--Signature=_Wed__28_May_2008_11_41_12_+1000_twnOC9_sZSYdB+WW--
