Return-Path: <linux-kernel-owner+w=401wt.eu-S935768AbYBUXnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935768AbYBUXnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759746AbYBUXnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:43:05 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57229 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647AbYBUXnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:43:03 -0500
Date: Fri, 22 Feb 2008 10:42:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: no next-20080221 tree
Message-Id: <20080222104257.cab90fd4.sfr@canb.auug.org.au>
In-Reply-To: <20080222003429.802eac76.sfr@canb.auug.org.au>
References: <20080222003429.802eac76.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__22_Feb_2008_10_42_57_+1100_rmUUG3KYe_iVtnix"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_Feb_2008_10_42_57_+1100_rmUUG3KYe_iVtnix
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 22 Feb 2008 00:34:29 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> turns out to be inadequate.  So we have a new tag NEXT_BASE which may
> name another git tree/quilt series that is also included in the
> linux-next tree.

Just to be clear, the "name" of a tree comes from the Name field in the
Next/Trees file.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__22_Feb_2008_10_42_57_+1100_rmUUG3KYe_iVtnix
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHvgyFTgG2atn1QN8RAsREAJ4gkJCnCu9DBi2PEasezvrugx+eBACdF48m
BNQj5QxXgLg+jWLl/kh9Qnw=
=9gpN
-----END PGP SIGNATURE-----

--Signature=_Fri__22_Feb_2008_10_42_57_+1100_rmUUG3KYe_iVtnix--
