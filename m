Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbZHUD4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbZHUD4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 23:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754666AbZHUD4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 23:56:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40620 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754646AbZHUD4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 23:56:23 -0400
Date: Fri, 21 Aug 2009 13:56:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org
Subject: Re: linux-next: noot failure for next-20090820
Message-Id: <20090821135617.8b255a5a.sfr@canb.auug.org.au>
In-Reply-To: <20090821024454.GA8786@fieldses.org>
References: <20090821094226.286faa67.sfr@canb.auug.org.au>
	<1250821846.6514.23.camel@heimdal.trondhjem.org>
	<20090821024454.GA8786@fieldses.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__21_Aug_2009_13_56_17_+1000_TXjY0E_7zM=w3BX_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Aug_2009_13_56_17_+1000_TXjY0E_7zM=w3BX_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Trond,

On Thu, 20 Aug 2009 22:44:54 -0400 "J. Bruce Fields" <bfields@fieldses.org>=
 wrote:
>
> > Could both you and Bruce check if the following patch fixes the problem?
>=20
> Yep, that boots for me, thanks.

Works for me as well.  I will add it at the end of linux-next today and
hope to see it in your tree tomorrow.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__21_Aug_2009_13_56_17_+1000_TXjY0E_7zM=w3BX_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqOGuEACgkQjjKRsyhoI8z9QQCggljGTLwlUXVQgQAssCT2SagA
z0EAn2VjOXwf01T60c7RVKwy9KKRHIeV
=vcjD
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Aug_2009_13_56_17_+1000_TXjY0E_7zM=w3BX_--
