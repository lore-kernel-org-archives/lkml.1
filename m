Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbYKGEqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbYKGEqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 23:46:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbYKGEqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 23:46:14 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45431 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbYKGEqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 23:46:13 -0500
Date: Fri, 7 Nov 2008 15:46:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: lachlan@sgi.com
Cc: David Chinner <david@fromorbit.com>, linux-next@vger.kernel.org,
       linuxf-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: linux-next: unable to fetch the xfs tree
Message-Id: <20081107154602.8621ea3d.sfr@canb.auug.org.au>
In-Reply-To: <4913BEC6.6080901@sgi.com>
References: <20081107111125.ef33b1dc.sfr@canb.auug.org.au>
	<20081107145332.52d49390.sfr@canb.auug.org.au>
	<4913BEC6.6080901@sgi.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__7_Nov_2008_15_46_02_+1100_k6+7yxsx/SEkz9MF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Nov_2008_15_46_02_+1100_k6+7yxsx/SEkz9MF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Lachlan,

On Fri, 07 Nov 2008 15:06:30 +1100 Lachlan McIlroy <lachlan@sgi.com> wrote:
>
> Stephen Rothwell wrote:
> > Hi all,
> >=20
> > On Fri, 7 Nov 2008 11:11:25 +1100 Stephen Rothwell <sfr@canb.auug.org.a=
u> wrote:
> >> I am getting:
> >>
> >> oss.sgi.com[0: 192.48.170.157]: errno=3DConnection refused
> >>
> >> so I will use what I fetched yesterday.
> >=20
> > And now I have received:
> >=20
> > <xfs-masters@oss.sgi.com>: host cuda-allmx.sgi.com[192.48.176.16] said:=
 550
> >     cuda_nsu 5.1.1 <xfs-masters@oss.sgi.com>... User unknown (in reply =
to RCPT
> >     TO command)
> >=20
> > So, is this a permanent state of affairs, or just a temporary glitch?
>=20
> Should be temporary.  We have known DNS and email issues that we are work=
ing
> on.  We're also moving oss.sgi.com but I have no idea what the schedule i=
s.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__7_Nov_2008_15_46_02_+1100_k6+7yxsx/SEkz9MF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkTyAoACgkQjjKRsyhoI8zIbwCfcig917DLvcVm1rIGnco5/Wzx
QmgAoL2fwdEutzseIPCE57Ylg3q3oo63
=N1lx
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Nov_2008_15_46_02_+1100_k6+7yxsx/SEkz9MF--
