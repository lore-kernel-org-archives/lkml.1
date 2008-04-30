Return-Path: <linux-kernel-owner+w=401wt.eu-S1760512AbYD3GW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760512AbYD3GW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 02:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755610AbYD3GWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 02:22:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43432 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104AbYD3GWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 02:22:50 -0400
Date: Wed, 30 Apr 2008 16:22:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, greg@kroah.com, jbarnes@virtuousgeek.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: gregkh-02-pci tree is now gone
Message-Id: <20080430162239.c0af9846.sfr@canb.auug.org.au>
In-Reply-To: <20080429.223854.24800777.davem@davemloft.net>
References: <20080424225104.GA16529@kroah.com>
	<20080429223412.0e8f135d.akpm@linux-foundation.org>
	<20080429.223854.24800777.davem@davemloft.net>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__30_Apr_2008_16_22_39_+1000_QWrPGmHxiYkhkKNs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__30_Apr_2008_16_22_39_+1000_QWrPGmHxiYkhkKNs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 29 Apr 2008 22:38:54 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Tue, 29 Apr 2008 22:34:12 -0700
>=20
> > What is gregkh-03-ldp?
>=20
> That's the special tree that breaks the linux-next build every day
> in order to make sure Stephen is paying attention :-)

Today, that failed in its plan :-)

Actually is it is a tree for the Linux Driver Project that Greg is
running - I am in two minds about whether I should carry it.  Currently,
it is right at the end of the build and if something fails in there it
gets reverted - I make no attempt to diagnose problems.  Greg wanted
"exposure".

I will write up a general mail about what I want in linux-next from now
on and I suspect that I will exclude most (if not all) of that tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__30_Apr_2008_16_22_39_+1000_QWrPGmHxiYkhkKNs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIGBA1TgG2atn1QN8RAmqrAJ0QgFGqAHQYH2OQF6+14rywKL9HlQCeMy1X
aBCLqJJQ8q0u5oqz6fV6Dgs=
=eM1a
-----END PGP SIGNATURE-----

--Signature=_Wed__30_Apr_2008_16_22_39_+1000_QWrPGmHxiYkhkKNs--
