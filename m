Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbYKGDxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbYKGDxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 22:53:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbYKGDxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 22:53:42 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39989 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbYKGDxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 22:53:41 -0500
Date: Fri, 7 Nov 2008 14:53:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Chinner <david@fromorbit.com>
Cc: linux-next@vger.kernel.org, linuxfs-devel@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Lachlan McIlroy <lachlan@sgi.com>
Subject: Re: linux-next: unable to fetch the xfs tree
Message-Id: <20081107145332.52d49390.sfr@canb.auug.org.au>
In-Reply-To: <20081107111125.ef33b1dc.sfr@canb.auug.org.au>
References: <20081107111125.ef33b1dc.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__7_Nov_2008_14_53_32_+1100_YSMbXh7D3Ukc/9wO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Nov_2008_14_53_32_+1100_YSMbXh7D3Ukc/9wO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 7 Nov 2008 11:11:25 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> I am getting:
>=20
> oss.sgi.com[0: 192.48.170.157]: errno=3DConnection refused
>=20
> so I will use what I fetched yesterday.

And now I have received:

<xfs-masters@oss.sgi.com>: host cuda-allmx.sgi.com[192.48.176.16] said: 550
    cuda_nsu 5.1.1 <xfs-masters@oss.sgi.com>... User unknown (in reply to R=
CPT
    TO command)

So, is this a permanent state of affairs, or just a temporary glitch?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__7_Nov_2008_14_53_32_+1100_YSMbXh7D3Ukc/9wO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkTu7wACgkQjjKRsyhoI8wDiACfWwL3hdavMYaKszlr05qJEnZZ
GzMAn1JkHBRsDngtNt7ipWSUzu1jfMBq
=LYZT
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Nov_2008_14_53_32_+1100_YSMbXh7D3Ukc/9wO--
