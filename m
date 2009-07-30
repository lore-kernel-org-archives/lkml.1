Return-Path: <linux-kernel-owner+w=401wt.eu-S1752812AbZG3XcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbZG3XcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 19:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbZG3XcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 19:32:06 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34526 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbZG3XcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 19:32:04 -0400
Date: Fri, 31 Jul 2009 09:31:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tom Peng <tom_peng@usish.com>, Jack Wang <jack_wang@usish.com>,
       Lindar Liu <lindar_liu@usish.com>, Kevin Ao <aoqingyun@usish.com>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: linux-next: scsi-rc-fixes tree build failure
Message-Id: <20090731093159.32960632.sfr@canb.auug.org.au>
In-Reply-To: <1248965603.3880.64.camel@mulgrave.site>
References: <20090730181345.cec774b2.sfr@canb.auug.org.au>
	<1248961882.3880.4.camel@mulgrave.site>
	<1248965603.3880.64.camel@mulgrave.site>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__31_Jul_2009_09_31_59_+1000_H8j8xJ+LiYKJEi6i"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__31_Jul_2009_09_31_59_+1000_H8j8xJ+LiYKJEi6i
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Thu, 30 Jul 2009 09:53:23 -0500 James Bottomley <James.Bottomley@HansenP=
artnership.com> wrote:
>
> This fixes it on my ppc64 box, so I'll fold it into the original patch
> and put it back into the tree.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__31_Jul_2009_09_31_59_+1000_H8j8xJ+LiYKJEi6i
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpyLW8ACgkQjjKRsyhoI8xWzgCbBjGLp82Pc9pCewU4D9aGvdSr
YlQAnitc616arNZFMsq7URJzYauOpTh5
=5VIW
-----END PGP SIGNATURE-----

--Signature=_Fri__31_Jul_2009_09_31_59_+1000_H8j8xJ+LiYKJEi6i--
