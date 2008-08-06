Return-Path: <linux-kernel-owner+w=401wt.eu-S1422902AbYHFVdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422902AbYHFVdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763364AbYHFVXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:23:10 -0400
Received: from home.keithp.com ([63.227.221.253]:1418 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756845AbYHFVXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:23:08 -0400
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
From: Keith Packard <keithp@keithp.com>
To: Stephane Marchesin <marchesin@icps.u-strasbg.fr>
Cc: keithp@keithp.com, Arjan van de Ven <arjan@infradead.org>,
       John Stoffel <john@stoffel.org>, Hugh Dickins <hugh@veritas.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Hellwig <hch@infradead.org>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <6a89f9d50808061109y3e68f0a0lc9b4bf289fd308cf@mail.gmail.com>
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	 <Pine.LNX.4.64.0808041855050.5717@blonde.site>
	 <1217877645.24714.87.camel@koto.keithp.com>
	 <Pine.LNX.4.64.0808042055240.17041@blonde.site>
	 <18583.47633.987143.236236@stoffel.org>
	 <1217910505.24714.152.camel@koto.keithp.com>
	 <6a89f9d50808060920t168d533g5d440b444e7c09fc@mail.gmail.com>
	 <20080806102437.2d5e5d11@infradead.org>
	 <6a89f9d50808061032k6c30887cg6bed0259f9620b1b@mail.gmail.com>
	 <1218045409.24714.257.camel@koto.keithp.com>
	 <6a89f9d50808061109y3e68f0a0lc9b4bf289fd308cf@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bkDrNMDw2BFqqAPMili3"
Date: Wed, 06 Aug 2008 14:22:57 -0700
Message-Id: <1218057777.24714.264.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bkDrNMDw2BFqqAPMili3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-08-06 at 20:09 +0200, Stephane Marchesin wrote:

> Well, this "abstract hardware" is in stores, it's called G80 and R600.
> If intel can't do something on its hardware shouldn't prevent others
> from using it. And I seriously doubt even the current interfaces would
> be fit for this.

Write a driver and we'll talk. Until then, I don't think your argument
is well supported.

If the result is that your driver requires a completely separate
interface than the Intel driver, that's OK too  -- we can talk about
merging them together in some unified mechanism at that point.

I'm trying to get from zero to one kernel driver for Intel graphics at
this point; that seems a valuable goal in itself. I hope it leads to
other people building kernel drivers for other graphics hardware. Don't
let me stop you from building a better mousetrap if you think the code
I've written is wrong somewhere.

--=20
keith.packard@intel.com

--=-bkDrNMDw2BFqqAPMili3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBImhYxQp8BWwlsTdMRAmKNAJ9bXJwSDgdgcMsf+eqhKd9DoSDa3QCfe5r9
ps9hD4UY+QJ63rRHl/lLDlA=
=LYAc
-----END PGP SIGNATURE-----

--=-bkDrNMDw2BFqqAPMili3--

