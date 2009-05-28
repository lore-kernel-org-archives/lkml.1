Return-Path: <linux-kernel-owner+w=401wt.eu-S1761815AbZE1Gfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761815AbZE1Gfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 02:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757997AbZE1GfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 02:35:01 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43838 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759557AbZE1Ge7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 02:34:59 -0400
Date: Thu, 28 May 2009 16:34:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: Tony Lindgren <tony@atomide.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the omap tree with the arm tree
Message-Id: <20090528163453.641e5ea3.sfr@canb.auug.org.au>
In-Reply-To: <EAF47CD23C76F840A9E7FCE10091EFAB02B4BE3927@dbde02.ent.ti.com>
References: <20090528143138.2de9ad37.sfr@canb.auug.org.au>
	<EAF47CD23C76F840A9E7FCE10091EFAB02B4BE3927@dbde02.ent.ti.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__28_May_2009_16_34_53_+1000_RC6hePVUgMZWjbpL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__28_May_2009_16_34_53_+1000_RC6hePVUgMZWjbpL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 28 May 2009 11:55:09 +0530 "Shilimkar, Santosh" <santosh.shilimkar@=
ti.com> wrote:
>
> >  +machine-$(CONFIG_ARCH_OMAP2)		:=3D omap2
> >  +machine-$(CONFIG_ARCH_OMAP3)		:=3D omap2
> > ++machine-$(CONFIG_ARCH_OMAP4)		:=3D omap2
>=20
> ++ Is this really ok ?

Yeah, this is a diff of a git merge.  The ++ just means it was added on
neither side of the merge - I modified the change from the omap tree
slightly to fit in better with the cleanups from the arm tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__28_May_2009_16_34_53_+1000_RC6hePVUgMZWjbpL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoeMI0ACgkQjjKRsyhoI8xSlACgrTQSCJW+K1lcThuCVazKDxz/
XyEAoIplKSQcYjez+mHPy44/uM7Rwi9/
=h8Ui
-----END PGP SIGNATURE-----

--Signature=_Thu__28_May_2009_16_34_53_+1000_RC6hePVUgMZWjbpL--
