Return-Path: <linux-kernel-owner+w=401wt.eu-S1754295AbZEQOIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbZEQOIR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 10:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbZEQOHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 10:07:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34071 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbZEQOHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 10:07:42 -0400
Date: Mon, 18 May 2009 00:07:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Doug Thompson <dougthompson@xmission.com>
Subject: Re: linux-next: Tree for May 15
Message-Id: <20090518000734.6fd3d652.sfr@canb.auug.org.au>
In-Reply-To: <20090515130729.GA13026@aftab>
References: <20090515153733.4384db9f.sfr@canb.auug.org.au>
	<20090515130729.GA13026@aftab>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__18_May_2009_00_07_34_+1000_Y_=nuWfcbgfFv5Or"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_May_2009_00_07_34_+1000_Y_=nuWfcbgfFv5Or
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Boris,

On Fri, 15 May 2009 15:07:29 +0200 Borislav Petkov <borislav.petkov@amd.com=
> wrote:
>
> can you please add the tree at
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-next
>=20
> to linux-test for a wider testing. It is rebased ontop of
> 45d447406a19cbfd42720f066f156f4eb9d68801 (Linus's tree from yesterday).

A hint as to what the tree is about would be nice.  It looks like EDAC
stuff (mostly AMD64).  If so, you are not listed as a maintainer of that
code (Doug cc'd).

The boilerplate:

What I tell everyone: all patches/commits in the tree/series must
have been:

	posted to a relevant mailing list
	reviewed
	unit tested
	destined for the next merge window (or the current release)

*before* they are included.  The linux-next tree is for integration
testing and to lower the impact of conflicts between subsystems in the
next merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__18_May_2009_00_07_34_+1000_Y_=nuWfcbgfFv5Or
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoQGiYACgkQjjKRsyhoI8yqgQCdF9q2Eyt04XRr/WKZIrRm6lu/
rb0AnA3vdNnUKVS+VRe6CXuO9jGVLzVG
=Ib0+
-----END PGP SIGNATURE-----

--Signature=_Mon__18_May_2009_00_07_34_+1000_Y_=nuWfcbgfFv5Or--
