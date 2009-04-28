Return-Path: <linux-kernel-owner+w=401wt.eu-S1757606AbZD1FQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606AbZD1FQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 01:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbZD1FQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 01:16:21 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34782 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbZD1FQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 01:16:21 -0400
Date: Tue, 28 Apr 2009 15:16:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, john@johnmccutchan.com, rlove@rlove.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 05/12] dnotify: reimplement dnotify using fsnotify
Message-Id: <20090428151610.fbc75279.sfr@canb.auug.org.au>
In-Reply-To: <20090427215328.14161.85505.stgit@paris.rdu.redhat.com>
References: <20090427215305.14161.33354.stgit@paris.rdu.redhat.com>
	<20090427215328.14161.85505.stgit@paris.rdu.redhat.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__28_Apr_2009_15_16_10_+1000_rhH9eXV=lt7_Y_Pd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__28_Apr_2009_15_16_10_+1000_rhH9eXV=lt7_Y_Pd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Mon, 27 Apr 2009 17:53:28 -0400 Eric Paris <eparis@redhat.com> wrote:
>
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1792,6 +1792,8 @@ F:	drivers/char/digi*
>  DIRECTORY NOTIFICATION (DNOTIFY)
>  P:	Stephen Rothwell
>  M:	sfr@canb.auug.org.au
> +P:	Eric Paris
> +M:	eparis@parisplace.org

At this point, you might as well remove me as a maintainer of dnotify.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__28_Apr_2009_15_16_10_+1000_rhH9eXV=lt7_Y_Pd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkn2kRoACgkQjjKRsyhoI8yZ9ACfXzKU6xc1sgzY/X527IR7cs3/
9CgAnRcWOSgsoirtYWjVtV2DFLuXc3A6
=hWhj
-----END PGP SIGNATURE-----

--Signature=_Tue__28_Apr_2009_15_16_10_+1000_rhH9eXV=lt7_Y_Pd--
