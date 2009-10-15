Return-Path: <linux-kernel-owner+w=401wt.eu-S1762225AbZJOAOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762225AbZJOAOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 20:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761715AbZJOAOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 20:14:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34731 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbZJOAOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 20:14:33 -0400
Date: Thu, 15 Oct 2009 11:13:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@linux.intel.com>
Subject: Re: linux-next: staging tree build failure
Message-Id: <20091015111351.8cea4030.sfr@canb.auug.org.au>
In-Reply-To: <20091014235449.GA9709@kroah.com>
References: <20091013150753.f738576e.sfr@canb.auug.org.au>
	<20091014235449.GA9709@kroah.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__15_Oct_2009_11_13_51_+1100_f4kP.1a1PUAtOmXX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Oct_2009_11_13_51_+1100_f4kP.1a1PUAtOmXX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Wed, 14 Oct 2009 16:54:49 -0700 Greg KH <greg@kroah.com> wrote:
>
> I've now fixed this up, it needed to be removed from
> include/linux/Kbuild file.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__15_Oct_2009_11_13_51_+1100_f4kP.1a1PUAtOmXX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrWaT8ACgkQjjKRsyhoI8wk4ACfd3JCbllP08mCKjdCOhY7ae25
He4An3lIV2feZh9zprSiUhHKwoS/cwJW
=zmHL
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Oct_2009_11_13_51_+1100_f4kP.1a1PUAtOmXX--
