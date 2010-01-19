Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015Ab0ASXnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab0ASXnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 18:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755383Ab0ASXnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 18:43:19 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:40696 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab0ASXnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 18:43:16 -0500
Date: Wed, 20 Jan 2010 10:43:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: manual merge of the driver-core tree with Linus'
 tree
Message-Id: <20100120104308.0c28615e.sfr@canb.auug.org.au>
In-Reply-To: <20100119205912.GA10928@kroah.com>
References: <20100118184956.ea783994.sfr@canb.auug.org.au>
	<20100119205912.GA10928@kroah.com>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__20_Jan_2010_10_43_08_+1100_E2g/RI9nSbesUoLq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Jan_2010_10_43_08_+1100_E2g/RI9nSbesUoLq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Tue, 19 Jan 2010 12:59:12 -0800 Greg KH <greg@kroah.com> wrote:
>
> On Mon, Jan 18, 2010 at 06:49:56PM +1100, Stephen Rothwell wrote:
> >=20
> > Today's linux-next merge of the driver-core tree got a conflict in
> > drivers/base/memory.c between commit
> > 8ff410daa009c4b44be445ded5b0cec00abc0426 ("sysdev: fix prototype for
> > memory_sysdev_class show/store functions") from Linus' tree and commits
> > 95f4918fb2826dd7fc7be8a375ee0b71e8276a62 ("sysdev: Fix type of sysdev
> > class attribute in memory driver") and
> > 18a994bc1df640e77b853af5b6a175d6871b449f ("driver-core: Add attribute
> > argument to class_attribute show/store") from the driver-core tree.
> >=20
> > Not a big suprise.  I fixed it up by using the driver-core tree version
> > (effectively reverting the version in Linus' tree).
>=20
> I've fixed this up in my tree now.

Excellent, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__20_Jan_2010_10_43_08_+1100_E2g/RI9nSbesUoLq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktWQ4wACgkQjjKRsyhoI8yoigCaAxQqo2GLt2edVQM184fk/3kc
wXEAoIXYhxCIORQ8m0fItJZoxkxyjFyV
=CjQe
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Jan_2010_10_43_08_+1100_E2g/RI9nSbesUoLq--
