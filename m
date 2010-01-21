Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531Ab0AUXUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab0AUXUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 18:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755515Ab0AUXUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 18:20:39 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48661 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513Ab0AUXUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 18:20:38 -0500
Date: Fri, 22 Jan 2010 10:20:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: linux-next: driver-core tree build warning
Message-Id: <20100122102031.df650449.sfr@canb.auug.org.au>
In-Reply-To: <20100121231010.GB29796@kroah.com>
References: <20100119172741.2dd81553.sfr@canb.auug.org.au>
	<20100119210417.GC10928@kroah.com>
	<20100120104525.752a790f.sfr@canb.auug.org.au>
	<20100120172543.e884a8af.sfr@canb.auug.org.au>
	<20100120174441.e1b12fd7.sfr@canb.auug.org.au>
	<20100121231010.GB29796@kroah.com>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__22_Jan_2010_10_20_31_+1100_Lr=WAoUDj_y6IfzK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_Jan_2010_10_20_31_+1100_Lr=WAoUDj_y6IfzK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Thu, 21 Jan 2010 15:10:10 -0800 Greg KH <greg@kroah.com> wrote:
>
> Ah, you are right, I was focusing on the lines after this.
>=20
> Here's a patch that I just applied to my tree to hopefully resolve this
> issue.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__22_Jan_2010_10_20_31_+1100_Lr=WAoUDj_y6IfzK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktY4T8ACgkQjjKRsyhoI8xo7gCfeV7JItSx8kRyIJp559zfMfm1
J1wAoIb7hvvdmq1Xhg2gMSPB+OPqKkGE
=jP/8
-----END PGP SIGNATURE-----

--Signature=_Fri__22_Jan_2010_10_20_31_+1100_Lr=WAoUDj_y6IfzK--
