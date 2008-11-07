Return-Path: <linux-kernel-owner+w=401wt.eu-S1752670AbYKGFOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbYKGFOP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 00:14:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbYKGFN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 00:13:57 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36454 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbYKGFN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 00:13:56 -0500
Date: Fri, 7 Nov 2008 16:13:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: lachlan@sgi.com
Cc: David Chinner <david@fromorbit.com>, linux-next@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: linux-next: unable to fetch the xfs tree
Message-Id: <20081107161340.268ee812.sfr@canb.auug.org.au>
In-Reply-To: <4913C967.30309@sgi.com>
References: <20081107111125.ef33b1dc.sfr@canb.auug.org.au>
	<20081107145332.52d49390.sfr@canb.auug.org.au>
	<4913BEC6.6080901@sgi.com>
	<20081107154602.8621ea3d.sfr@canb.auug.org.au>
	<4913C967.30309@sgi.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__7_Nov_2008_16_13_40_+1100_//=X1SKeU.yVpAZe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Nov_2008_16_13_40_+1100_//=X1SKeU.yVpAZe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Lachlan,

On Fri, 07 Nov 2008 15:51:51 +1100 Lachlan McIlroy <lachlan@sgi.com> wrote:
>
> Stephen Rothwell wrote:
> >=20
> > On Fri, 07 Nov 2008 15:06:30 +1100 Lachlan McIlroy <lachlan@sgi.com> wr=
ote:
> >> Stephen Rothwell wrote:
> >>>
> >>> On Fri, 7 Nov 2008 11:11:25 +1100 Stephen Rothwell <sfr@canb.auug.org=
.au> wrote:
> >>>> I am getting:
> >>>>
> >>>> oss.sgi.com[0: 192.48.170.157]: errno=3DConnection refused
> >>>>
> >>>> so I will use what I fetched yesterday.
> >>> And now I have received:
> >>>
> >>> <xfs-masters@oss.sgi.com>: host cuda-allmx.sgi.com[192.48.176.16] sai=
d: 550
> >>>     cuda_nsu 5.1.1 <xfs-masters@oss.sgi.com>... User unknown (in repl=
y to RCPT
> >>>     TO command)
> >>>
> >>> So, is this a permanent state of affairs, or just a temporary glitch?
> >> Should be temporary.  We have known DNS and email issues that we are w=
orking
> >> on.  We're also moving oss.sgi.com but I have no idea what the schedul=
e is.
> >=20
> > Thanks.
>=20
> I actually got a bounce message when I sent that reply.  Gotta love the i=
rony.

That is probably because I spelt linux-fsdevel wrong twice :-(

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__7_Nov_2008_16_13_40_+1100_//=X1SKeU.yVpAZe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkTzoQACgkQjjKRsyhoI8xDAQCcDXfsShHmuder29mSHvBm9nzW
PAQAn0xJtKrEQUHGoiNab/IBRPGWFwF7
=F7QU
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Nov_2008_16_13_40_+1100_//=X1SKeU.yVpAZe--
