Return-Path: <linux-kernel-owner+w=401wt.eu-S934666AbXFFS4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934666AbXFFS4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 14:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762361AbXFFS4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 14:56:45 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37132 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755973AbXFFS4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 14:56:44 -0400
Date: Wed, 6 Jun 2007 11:58:29 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
Message-ID: <20070606185829.GA26062@tree.beaverton.ibm.com>
References: <20070601004427.GI30788@tree.beaverton.ibm.com> <20070605172310.GD17143@linux-os.sc.intel.com> <20070605173647.GC12782@tree.beaverton.ibm.com> <20070605181342.GE17143@linux-os.sc.intel.com> <20070605183300.GD12782@tree.beaverton.ibm.com> <20070605184015.GF17143@linux-os.sc.intel.com> <20070605200954.GE12782@tree.beaverton.ibm.com> <20070605211451.GG17143@linux-os.sc.intel.com> <20070605235707.GB16074@tree.beaverton.ibm.com> <20070606013759.GI17143@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
In-Reply-To: <20070606013759.GI17143@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 05, 2007 at 06:37:59PM -0700, Siddha, Suresh B wrote:
> On Tue, Jun 05, 2007 at 04:57:07PM -0700, Darrick J. Wong wrote:
> > On Tue, Jun 05, 2007 at 02:14:51PM -0700, Siddha, Suresh B wrote:
> > =20
> > > Can you send us your system's dmesg aswell as output of /proc/interru=
pts?
> >=20
> > http://sweaglesw.net/~djwong/docs/dmesg
> > http://sweaglesw.net/~djwong/docs/interrupts
>=20
> Didn't find anything wrong in that information. Can you try this
> appended debug patch and see if you see this error msg in dmesg, when you
> hit the bug? Thanks.

I don't see that message.

--D

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGZwPVa6vRYYgWQuURAiLVAJ4mFrjO+tdkGrXzdyBItmc7jeYa4QCfRx7p
SbKiG4CKeQ4CnHbSaDZ0oLU=
=FDQk
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
