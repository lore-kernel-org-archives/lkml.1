Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbZIPGDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbZIPGDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 02:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752963AbZIPGDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 02:03:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50048 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbZIPGDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 02:03:15 -0400
Date: Wed, 16 Sep 2009 16:03:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Bryan Wu <cooloney.lkml@gmail.com>
Subject: Re: 2.6.32 -mm Blackfin patches
Message-Id: <20090916160313.aeb61ef7.sfr@canb.auug.org.au>
In-Reply-To: <20090915211810.d1b83015.akpm@linux-foundation.org>
References: <8bd0f97a0909152056h61bfc487g6b8631966c6d72be@mail.gmail.com>
	<20090915211810.d1b83015.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__16_Sep_2009_16_03_13_+1000_pJOTdue2ivI16kT."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_Sep_2009_16_03_13_+1000_pJOTdue2ivI16kT.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew, Mike,

On Tue, 15 Sep 2009 21:18:10 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Tue, 15 Sep 2009 23:56:21 -0400 Mike Frysinger <vapier.adi@gmail.com> =
wrote:
>=20
> > On Tue, Sep 15, 2009 at 19:15, Andrew Morton wrote:
> > > blackfin-convert-to-use-arch_gettimeoffset.patch
> >=20
> > i thought John was merging this via some sort of patch series, but i
> > can pick it up in the Blackfin tree to make sure things are really
> > sane
>=20
> Sent.
>=20
> > > blackfin-fix-read-buffer-overflow.patch
> >=20
> > the latter patch i merged into my tree (and i thought that i followed
> > up in the original posting about this)
>=20
> Well, it isn't in linux-next so as far as I'm concerned I have the
> only copy.  Should you be getting your tree into linux-next?

There is a blackfin tree in linux-next managed by Bryan Wu:

git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git#for=
-linus

As far as I can tell, it hasn't bee updated since March 30.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__16_Sep_2009_16_03_13_+1000_pJOTdue2ivI16kT.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkqwf6EACgkQjjKRsyhoI8xV9wCeME8MJjeIf9UJeTaoGCC77VRR
4/IAn3sWPvY6DBs4xhIEMThx3dIQRRFy
=I6GP
-----END PGP SIGNATURE-----

--Signature=_Wed__16_Sep_2009_16_03_13_+1000_pJOTdue2ivI16kT.--
